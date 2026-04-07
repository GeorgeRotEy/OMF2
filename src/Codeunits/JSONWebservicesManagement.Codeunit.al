codeunit 50006 "JSON Webservices Management"
{
    trigger OnRun()
    begin
        Code();
        Message('Proceso completado. Por favor, revise el LOG para más detalles.');
    end;

    var
        cuInterface: Codeunit "EDUCAMOS Interface";
        rEDUSetup: Record "EDUCAMOS Setup";
        cTempBlob: Codeunit "Temp Blob";
        vClient: HttpClient;
        vResponse: HttpResponseMessage;
        vRequest: HttpRequestMessage;
        vHeaders: HttpHeaders;
        vContent: HttpContent;
        vAccessToken: Text;
        vResult: Text;
        vCalendarioId: Text;
        vStartDate: Date;
        vEndDate: Date;
        vJsonBody: Text;
        Ok: Boolean;
        vFullJsonBody: Text;
        vStatusCode: Integer;
        vOutStr: OutStream;
        vBaseUrl: Text;
        vPersonaId: Text[50];
        vPagadorMedioPagoId: Text[50];
        vDependientePersonaId: Text[50];
        Error001: Label 'Fail to access API. Code %1 - %2', Comment = 'ESP="Error al acceder a la API. Código %1 - %2"';
        Error002: Label 'No response from api', Comment = 'ESP="Sin respuesta de la API"';
        Error003: Label 'No se obtuvieron datos para importar';
        Error004: Label 'No se pudo obtener token para hacer login';
        InvalidResponseErr: Label 'The response was not valid', Comment = 'ESP="La respuesta no era válida"';
        NonJsonResponseErr: Label 'Respuesta no JSON (revisa "Open" en el LOG)';

    procedure Code(): Boolean
    var
    begin
        if not fInitializeGlobals() then
            exit(false);

        // 1) Token
        Ok := GetAccessToken();
        if not Ok then begin
            cuInterface.fSetLogWithResponse(3, StrSubstNo('%1: %2', Error004, vResult), CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        // 2) GET Calendarios
        Ok := CallGET();
        if not Ok then begin
            cuInterface.fSetLogWithResponse(3, vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if vJsonBody = '' then begin
            cuInterface.fSetLogWithResponse(2, Error003, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        //Traer pagadores - BEGIN.
        Ok := CallGETWithContinuationToken(BuildPagadoresUrl());
        if not Ok then begin
            cuInterface.fSetLogWithResponse(3, 'Error obteniendo pagadores: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if not TryGetPagadores() then begin
            cuInterface.fSetLogWithResponse(3, 'No se pudieron traer los pagadores: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;
        //Traer pagadores - END.

        //Descomentar
        // if not TryGetActiveCalendar() then begin
        //     cuInterface.fSetLogWithResponse(3, 'No se pudo determinar calendario activo: ' + vResult, CompanyName, 0, cTempBlob);
        //     Commit();
        //     exit(false);
        // end;

        // Ok := CallGETWithContinuationToken(BuildRemesasUrl());
        // if not Ok then begin
        //     cuInterface.fSetLogWithResponse(3, 'Error obteniendo remesas: ' + vResult, CompanyName, 0, cTempBlob);
        //     Commit();
        //     exit(false);
        // end;

        // if vFullJsonBody = '' then begin
        //     cuInterface.fSetLogWithResponse(2, Error003, CompanyName, 0, cTempBlob);
        //     Commit();
        //     exit(false);
        // end;

        // if not TryGetRemesas() then begin
        //     cuInterface.fSetLogWithResponse(3, 'No se pudieron traer las remesas: ' + vResult, CompanyName, 0, cTempBlob);
        //     Commit();
        //     exit(false);
        // end;

        //Descomentar
        // if not FillInputData(vFullJsonBody) then begin
        //     cuInterface.fSetLog(3, Error006 + ' - ' + GetLastErrorText(), CompanyName, 0);
        //     Commit();
        //     exit(false);
        // end;

        // cuInterface.fSetLogWithResponse(
        //     1,
        //     StrSubstNo(
        //         'Datos importadas correctamente. Calendario=%1 | Desde=%2 | Hasta=%3',
        //         Format(vCalendarioId),
        //         Format(vStartDate, 0, '<Year4>-<Month,2>-<Day,2>'),
        //         Format(vEndDate, 0, '<Year4>-<Month,2>-<Day,2>')),
        //     CompanyName, 0, TempBlob);

        // Commit();
        // exit(true);
    end;

    local procedure GetAccessToken(): Boolean
    var
        Body: Text;
        RespTxt: Text;
        JsonObject: JsonObject;
        Token: JsonToken;
        ContentHeaders: HttpHeaders;
        ReqHeaders: HttpHeaders;
        Base64: Codeunit "Base64 Convert";
        BasicValue: Text;
    begin
        if rEDUSetup."Token URL" = '' then begin
            vResult := 'Token URL vacío en Setup';
            exit(false);
        end;

        if (rEDUSetup."Client Id" = '') or (rEDUSetup.GetPassword() = '') then begin
            vResult := 'Faltan Client Id / Client Secret en Setup';
            exit(false);
        end;

        if rEDUSetup."Redirect URI" = '' then begin
            vResult := 'Redirect URI vacío en Setup';
            exit(false);
        end;

        Clear(vRequest);
        Clear(vResponse);
        Clear(vContent);

        vRequest.SetRequestUri(rEDUSetup."Token URL");
        vRequest.Method := 'POST';

        vRequest.GetHeaders(ReqHeaders);
        ReqHeaders.Clear();

        BasicValue := Base64.ToBase64(StrSubstNo('%1:%2', rEDUSetup."Client Id", rEDUSetup.GetPassword()));
        ReqHeaders.Add('Authorization', StrSubstNo('Basic %1', BasicValue));
        ReqHeaders.Add('Accept', 'application/json');

        Body := 'grant_type=authorization_code' +
                '&content-type=application/x-www-form-urlencoded' +
                '&code=' + UrlEncode(rEDUSetup."Auth Grant") +
                '&redirect_uri=' + UrlEncode(rEDUSetup."Redirect URI") +
                '&client_id=' + UrlEncode(rEDUSetup."Client Id") +
                '&client_secret=' + UrlEncode(rEDUSetup.GetPassword());

        vContent.WriteFrom(Body);
        vContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();

        vRequest.Content := vContent;

        if not vClient.Send(vRequest, vResponse) then begin
            vResult := Error002;
            exit(false);
        end;

        vStatusCode := vResponse.HttpStatusCode();
        vResponse.Content.ReadAs(RespTxt);

        Clear(cTempBlob);
        cTempBlob.CreateOutStream(vOutStr);
        vOutStr.WriteText(RespTxt);

        if (vStatusCode < 200) or (vStatusCode > 299) then begin
            vResult := StrSubstNo('Fail to access API. Code %1 - %2. Body: %3',
                vStatusCode, vResponse.ReasonPhrase(), RespTxt);
            exit(false);
        end;

        if not JsonObject.ReadFrom(RespTxt) then begin
            vResult := NonJsonResponseErr;
            exit(false);
        end;

        if not JsonObject.Get('access_token', Token) then begin
            vResult := InvalidResponseErr;
            exit(false);
        end;

        vAccessToken := Token.AsValue().AsText();
        if vAccessToken = '' then begin
            vResult := InvalidResponseErr;
            exit(false);
        end;

        exit(true);
    end;

    local procedure CallGET(): Boolean
    var
        vlStatusCode: Integer;
        vlOutS: OutStream;
    begin
        vJsonBody := '';
        vResult := '';

        if rEDUSetup."API URL" = '' then begin
            vResult := StrSubstNo('URL API vacío en %1', rEDUSetup.TableCaption);
            exit(false);
        end;

        Clear(vRequest);
        Clear(vResponse);
        Clear(vContent);

        vRequest.SetRequestUri(rEDUSetup."API URL");
        vRequest.Method := 'GET';

        vRequest.GetHeaders(vHeaders);
        vHeaders.Clear();

        vHeaders.Add('Authorization', StrSubstNo('Bearer %1', vAccessToken));

        if rEDUSetup.GetSubscriptionKey() <> '' then
            vHeaders.Add('Ocp-Apim-Subscription-Key', rEDUSetup.GetSubscriptionKey());

        if rEDUSetup."API Version" <> '' then
            vHeaders.Add('api-version', rEDUSetup."API Version");

        if not vClient.Send(vRequest, vResponse) then begin
            vResult := Error002;
            exit(false);
        end;

        vlStatusCode := vResponse.HttpStatusCode();
        vResponse.Content.ReadAs(vJsonBody);

        cTempBlob.CreateOutStream(vlOutS);
        VLOutS.WriteText(vJsonBody);

        if (vlStatusCode < 200) or (vlStatusCode > 299) then begin
            vResult := StrSubstNo(Error001, vlStatusCode, vResponse.ReasonPhrase());
            vResult += StrSubstNo('. Body: %1', vJsonBody);
            exit(false);
        end;

        exit(true);
    end;

    local procedure CallGETWithContinuationToken(pUrl: Text): Boolean
    var
        vlContinuationTkn: Text;
        vlPageTxt: Text;
        Aggregated: BigText;
    begin
        vFullJsonBody := '';
        vResult := '';
        Clear(Aggregated);
        vlContinuationTkn := '';

        repeat
            if not CallContinuationToken(pUrl, vlContinuationTkn, vlPageTxt) then
                exit(false);

            if vlPageTxt = '' then begin
                vResult := Error003;
                Clear(cTempBlob);
                cTempBlob.CreateOutStream(vOutStr);
                vOutStr.WriteText(vResult);
                exit(false);
            end;

            Aggregated.AddText(vlPageTxt);

            vlContinuationTkn := ExtractContinuationToken(vlPageTxt);
        until vlContinuationTkn = '';

        vFullJsonBody := BigTextToText(Aggregated);

        Clear(cTempBlob);
        cTempBlob.CreateOutStream(vOutStr);
        vOutStr.WriteText(vFullJsonBody);

        exit(true);
    end;

    local procedure CallContinuationToken(pUrl: Text; pContinuationToken: Text; var pResponseText: Text): Boolean
    var
    begin
        pResponseText := '';
        vResult := '';

        if pUrl = '' then begin
            vResult := 'API URL vacío';
            exit(false);
        end;

        Clear(vRequest);
        Clear(vResponse);
        Clear(vContent);

        vRequest.SetRequestUri(pUrl);
        vRequest.Method := 'GET';

        vRequest.GetHeaders(vHeaders);
        vHeaders.Clear();

        vHeaders.Add('Authorization', StrSubstNo('Bearer %1', vAccessToken));

        if rEDUSetup.GetSubscriptionKey() <> '' then
            vHeaders.Add('Ocp-Apim-Subscription-Key', rEDUSetup.GetSubscriptionKey());

        if rEDUSetup."API Version" <> '' then
            vHeaders.Add('api-version', rEDUSetup."API Version");

        if pContinuationToken <> '' then
            vHeaders.Add('continuationToken', pContinuationToken);

        if not vClient.Send(vRequest, vResponse) then begin
            vResult := Error002;
            exit(false);
        end;

        vStatusCode := vResponse.HttpStatusCode();
        vResponse.Content.ReadAs(pResponseText);

        Clear(cTempBlob);
        cTempBlob.CreateOutStream(vOutStr);
        vOutStr.WriteText(pResponseText);

        if (vStatusCode < 200) or (vStatusCode > 299) then begin
            vResult := StrSubstNo(Error001, vStatusCode, vResponse.ReasonPhrase());
            vResult += StrSubstNo('. Body: %1', pResponseText);
            exit(false);
        end;

        exit(true);
    end;

    local procedure ExtractContinuationToken(pJsonText: Text): Text
    var
        JsonObject: JsonObject;
        Token: JsonToken;
    begin
        if not JsonObject.ReadFrom(pJsonText) then
            exit('');

        if JsonObject.Get('continuationToken', Token) then
            exit(Token.AsValue().AsText());

        exit('');
    end;

    local procedure BigTextToText(var pBigText: BigText): Text
    var
        vlInStr: InStream;
        vlResult: Text;
    begin
        Clear(cTempBlob);
        cTempBlob.CreateOutStream(vOutStr);
        pBigText.Write(vOutStr);

        cTempBlob.CreateInStream(vlInStr);
        vlInStr.ReadText(vlResult);

        exit(vlResult);
    end;

    local procedure TryGetActiveCalendar(): Boolean
    var
        Root: JsonObject;
        CalendariosTok: JsonToken;
        CalendariosArr: JsonArray;
        ItemTok: JsonToken;
        ItemObj: JsonObject;
        Token: JsonToken;
        Activo: Boolean;
        vlStartDate: Text;
        vlEndDate: Text;
        i: Integer;
    begin
        vResult := '';
        Clear(vCalendarioId);
        vStartDate := 0D;
        vEndDate := 0D;
        vlStartDate := '';
        vlEndDate := '';

        if not Root.ReadFrom(vJsonBody) then begin
            vResult := NonJsonResponseErr;
            exit(false);
        end;

        if not Root.Get('calendarios', CalendariosTok) then begin
            vResult := 'La respuesta no contiene el nodo "calendarios".';
            exit(false);
        end;

        CalendariosArr := CalendariosTok.AsArray();

        for i := 0 to CalendariosArr.Count() - 1 do begin
            CalendariosArr.Get(i, ItemTok);
            ItemObj := ItemTok.AsObject();

            Activo := false;
            if ItemObj.Get('activo', Token) then
                if not Token.AsValue().IsNull() then
                    Activo := Token.AsValue().AsBoolean();

            if Activo then begin
                if not ItemObj.Get('calendarioEscolarId', Token) then begin
                    vResult := 'Calendario activo sin "calendarioEscolarId".';
                    exit(false);
                end;

                vCalendarioId := Token.AsValue().AsText();
                if vCalendarioId = '' then begin
                    vResult := 'El ID del calendario está vacío';
                    exit(false);
                end;

                if ItemObj.Get('fechaInicio', Token) then
                    if not Token.AsValue().IsNull() then
                        vlStartDate := Token.AsValue().AsText();

                if ItemObj.Get('fechaFin', Token) then
                    if not Token.AsValue().IsNull() then
                        vlEndDate := Token.AsValue().AsText();

                if not Evaluate(vStartDate, vlStartDate) then begin
                    vResult := StrSubstNo('FechaInicio inválida: %1', vlStartDate);
                    exit(false);
                end;

                if not Evaluate(vEndDate, vlEndDate) then begin
                    vResult := StrSubstNo('FechaFin inválida: %1', vlEndDate);
                    exit(false);
                end;

                if (vStartDate = 0D) or (vEndDate = 0D) then begin
                    vResult := 'El calendario activo no trae fechaInicio/fechaFin válidas.';
                    exit(false);
                end;

                exit(true);
            end;
        end;

        vResult := 'No existe ningún calendario con "activo"=true.';
        exit(false);
    end;

    local procedure BuildRemesasUrl(): Text
    var
        Url: Text;
        HasQuery: Boolean;
    begin
        Url := vBaseUrl + '/' + Format(vCalendarioId) + '/remesas';

        HasQuery := false;

        if vStartDate <> 0D then begin
            Url += '?fechaEmisionDesde=' + Format(vStartDate, 0, '<Year4>-<Month,2>-<Day,2>');
            HasQuery := true;
        end;

        if vEndDate <> 0D then begin
            if HasQuery then
                Url += '&'
            else
                Url += '?';
            Url += 'fechaEmisionHasta=' + Format(vEndDate, 0, '<Year4>-<Month,2>-<Day,2>');
        end;

        exit(Url);
    end;

    local procedure BuildRecibosRemesaUrl(pRemesaID: Text): Text
    var
        Url: Text;
    begin
        Url := vBaseUrl + '/' + Format(vCalendarioId) + '/remesas/' +
        pRemesaID + '/recibos';

        exit(Url);
    end;

    local procedure BuildPagadoresUrl(): Text
    var
        Url: Label 'https://developer-api-neu.educamos.com/apismeducamos/api/colegio/pagadores', Locked = true;
    begin
        exit(Url);
    end;

    local procedure TryGetPagadores(): Boolean
    var
        Root: JsonObject;
        PagadoresTok: JsonToken;
        PagadoresArr: JsonArray;
        MediosPagoTok: JsonToken;
        MediosPagoArr: JsonArray;
        DepEconTok: JsonToken;
        DepEconArr: JsonArray;
        PagTok: JsonToken;
        PagObj: JsonObject;
        vlToken: JsonToken;
        i: Integer;
        j: Integer;
        k: Integer;
        OpenPos: Integer;
        ClosePos: Integer;
        RemainingText: Text;
        OneJsonText: Text;
        MedPagTok: JsonToken;
        MedPagObj: JsonObject;
        DepTok: JsonToken;
        DepObj: JsonObject;
    begin
        vResult := '';

        RemainingText := vFullJsonBody;

        while StrLen(RemainingText) > 0 do begin
            OpenPos := StrPos(RemainingText, '{');
            if OpenPos = 0 then
                break;

            ClosePos := fFindMatchingBrace(RemainingText, OpenPos);
            if ClosePos = 0 then begin
                vResult := 'JSON de pagadores incompleto.';
                exit(false);
            end;

            OneJsonText := CopyStr(RemainingText, OpenPos, ClosePos - OpenPos + 1);

            Clear(Root);

            if not Root.ReadFrom(OneJsonText) then begin
                vResult := NonJsonResponseErr;
                exit(false);
            end;

            if not Root.Get('pagadores', PagadoresTok) then begin
                vResult := 'La respuesta no contiene el nodo "Pagadores".';
                exit(false);
            end;

            PagadoresArr := PagadoresTok.AsArray();

            for i := 0 to PagadoresArr.Count() - 1 do begin
                PagadoresArr.Get(i, PagTok);
                PagObj := PagTok.AsObject();

                vPersonaId := '';
                if PagObj.Get('personaId', vlToken) then
                    if vlToken.IsValue() and (not vlToken.AsValue.IsNull) then begin

                        vPersonaId := vlToken.AsValue().AsText();

                        if not fFillPagadores(PagObj) then begin
                            vResult := 'No se han podido tratar los pagadores.';
                            exit(false);
                        end
                    end;

                if PagObj.Get('mediosPago', MediosPagoTok) and MediosPagoTok.IsArray() then begin
                    MediosPagoArr := MediosPagoTok.AsArray();

                    for j := 0 to MediosPagoArr.Count() - 1 do begin
                        MediosPagoArr.Get(j, MedPagTok);
                        MedPagObj := MedPagTok.AsObject();

                        vPagadorMedioPagoId := '';
                        if MedPagObj.Get('pagadorMedioPagoId', vlToken) then
                            if vlToken.IsValue() and (not vlToken.AsValue.IsNull) then begin

                                vPagadorMedioPagoId := vlToken.AsValue().AsText();

                                if not fFillMediosPago(MedPagObj) then begin
                                    vResult := 'No se han podido tratar los medios de pago.';
                                    exit(false);
                                end;
                            end;
                    end;
                end;

                if PagObj.Get('dependientesEconomicos', DepEconTok) and DepEconTok.IsArray() then begin
                    DepEconArr := DepEconTok.AsArray();

                    for k := 0 to DepEconArr.Count() - 1 do begin
                        DepEconArr.Get(k, DepTok);
                        DepObj := DepTok.AsObject();

                        vDependientePersonaId := '';
                        if DepObj.Get('personaId', vlToken) then
                            if vlToken.IsValue() and (not vlToken.AsValue.IsNull) then begin

                                vDependientePersonaId := vlToken.AsValue().AsText();
                                if vDependientePersonaId = '' then
                                    vDependientePersonaId := 'null';

                                if not fFillDepEconomicos(PagObj) then begin
                                    vResult := 'No se han podido tratar los dependientes económicos.';
                                    exit(false);
                                end;
                            end
                    end;
                end;
            end;

            RemainingText := CopyStr(RemainingText, ClosePos + 1);
        end;

        vResult := 'Pagadores importados correctamente.';
        exit(true);
    end;

    local procedure fFillPagadores(PagadorObj: JsonObject): Boolean
    var
        rlPagador: Record "EDUCAMOS Pagador";
        DireccionTok: JsonToken;
        DirObj: JsonObject;
    begin
        if vPersonaId = '' then begin
            vResult := 'El pagador no tiene identificadores suficientes.';
            exit(false);
        end;

        if not rlPagador.Get(vPersonaId) then begin
            rlPagador.Init();
            rlPagador.personaId := vPersonaId;

            fFillPagadorData(PagadorObj, rlPagador);

            rlPagador."Importation DateTime" := CurrentDateTime;
            rlPagador.Processed := true;
            rlPagador.Insert();
        end else begin
            fFillPagadorData(PagadorObj, rlPagador);

            rlPagador."Importation DateTime" := CurrentDateTime;
            rlPagador.Processed := true;
            rlPagador.Modify();
        end;

        if PagadorObj.Get('direccion', DireccionTok) then
            if DireccionTok.IsObject() then begin
                DirObj := DireccionTok.AsObject();

                fFillDireccionData(DirObj, rlPagador);

                rlPagador."Importation DateTime" := CurrentDateTime;
                rlPagador.Processed := true;
                rlPagador.Modify();
            end;

        exit(true);
    end;

    local procedure fFillMediosPago(MediosPagoObj: JsonObject): Boolean
    var
        rlMedioPago: Record "EDUCAMOS MedioPago";
        CuentaBancariaTok: JsonToken;
        CuenBancObj: JsonObject;
    begin
        if vPagadorMedioPagoId = '' then begin
            vResult := 'El pagador no tiene identificadores suficientes.';
            exit(false);
        end;

        if not rlMedioPago.Get(vPersonaId, vPagadorMedioPagoId) then begin
            rlMedioPago.Init();
            rlMedioPago.personaId := vPersonaId;
            rlMedioPago.pagadorMedioPagoId := vPagadorMedioPagoId;

            fFillMedioPagoData(MediosPagoObj, rlMedioPago);

            rlMedioPago."Importation DateTime" := CurrentDateTime;
            rlMedioPago.Processed := true;
            rlMedioPago.Insert();
        end else begin
            fFillMedioPagoData(MediosPagoObj, rlMedioPago);

            rlMedioPago."Importation DateTime" := CurrentDateTime;
            rlMedioPago.Processed := true;
            rlMedioPago.Modify();
        end;

        if MediosPagoObj.Get('cuentaBancaria', CuentaBancariaTok) then
            if CuentaBancariaTok.IsObject() then begin
                CuenBancObj := CuentaBancariaTok.AsObject();

                fFillCuentaBancariaData(CuenBancObj, rlMedioPago);

                rlMedioPago."Importation DateTime" := CurrentDateTime;
                rlMedioPago.Processed := true;
                rlMedioPago.Modify();
            end;

        exit(true);
    end;

    local procedure fFillDepEconomicos(PagadorObj: JsonObject): Boolean
    var
        rlDependienteEconomico: Record "EDUCAMOS Dep. Economico";
        DependientesEconomicosArr: JsonArray;
        DependientesEconomicosTok: JsonToken;
        DepEconTok: JsonToken;
        DepEconObj: JsonObject;
        i: Integer;
    begin
        if vDependientePersonaId = '' then begin
            vResult := 'El pagador no tiene identificadores suficientes.';
            exit(false);
        end;

        if PagadorObj.Get('dependientesEconomicos', DependientesEconomicosTok) then begin
            if DependientesEconomicosTok.IsArray() then begin
                DependientesEconomicosArr := DependientesEconomicosTok.AsArray();

                DependientesEconomicosArr.Get(i, DepEconTok);
                DepEconObj := DepEconTok.AsObject();

                if not rlDependienteEconomico.Get(vPersonaId, vDependientePersonaId) then begin
                    rlDependienteEconomico.Init();
                    rlDependienteEconomico.personaId := vPersonaId;
                    rlDependienteEconomico.dependientePersonaId := vDependientePersonaId;

                    fFillDependienteData(DepEconObj, rlDependienteEconomico);

                    rlDependienteEconomico."Importation DateTime" := CurrentDateTime;
                    rlDependienteEconomico.Processed := true;
                    rlDependienteEconomico.Insert();
                end else begin
                    fFillDependienteData(DepEconObj, rlDependienteEconomico);

                    rlDependienteEconomico."Importation DateTime" := CurrentDateTime;
                    rlDependienteEconomico.Processed := true;
                    rlDependienteEconomico.Modify();
                end;
            end;
        end;

        exit(true);
    end;

    local procedure fFillPagadorData(PagadorObj: JsonObject; var pPagadores: Record "EDUCAMOS Pagador")
    var
        vlToken: JsonToken;
    begin
        if PagadorObj.Get('nombre', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.nombre := vlToken.AsValue().AsText();

        if PagadorObj.Get('apellido1', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.apellido1 := vlToken.AsValue().AsText();

        if PagadorObj.Get('apellido2', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.apellido2 := vlToken.AsValue().AsText();

        if PagadorObj.Get('sexo', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.sexo := vlToken.AsValue().AsText();

        if PagadorObj.Get('tipoDocumento', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.tipoDocumento := vlToken.AsValue().AsText();

        if PagadorObj.Get('numeroDocumento', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.numeroDocumento := vlToken.AsValue().AsText();

        if PagadorObj.Get('telefonoCasa', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.telefonoCasa := vlToken.AsValue().AsText();

        if PagadorObj.Get('telefonoMovil1', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.telefonoMovil1 := vlToken.AsValue().AsText();

        if PagadorObj.Get('correoElectronico', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.correoElectronico := vlToken.AsValue().AsText();

        if PagadorObj.Get('codigoSAGE', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.codigoSAGE := vlToken.AsValue().AsText();
    end;

    local procedure fFillDireccionData(DirObj: JsonObject; var pPagadores: Record "EDUCAMOS Pagador")
    var
        vlToken: JsonToken;
    begin
        if DirObj.Get('calle', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.calle := vlToken.AsValue().AsText();

        if DirObj.Get('codigoPostal', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.codigoPostal := vlToken.AsValue().AsText();

        if DirObj.Get('region', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.region := vlToken.AsValue().AsText();

        if DirObj.Get('pais', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.pais := vlToken.AsValue().AsText();

        if DirObj.Get('tipoVia', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.tipoVia := vlToken.AsValue().AsText();

        if DirObj.Get('numero', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.numero := vlToken.AsValue().AsText();

        if DirObj.Get('bloque', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.bloque := vlToken.AsValue().AsText();

        if DirObj.Get('escalera', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.escalera := vlToken.AsValue().AsText();

        if DirObj.Get('piso', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.piso := vlToken.AsValue().AsText();

        if DirObj.Get('puerta', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.puerta := vlToken.AsValue().AsText();

        if DirObj.Get('localidad', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.localidad := vlToken.AsValue().AsText();

        if DirObj.Get('codigoMunicipio', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.codigoMunicipio := vlToken.AsValue().AsText();

        if DirObj.Get('concejo', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.concejo := vlToken.AsValue().AsText();

        if DirObj.Get('provincia', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pPagadores.provincia := vlToken.AsValue().AsText();
    end;

    local procedure fFillMedioPagoData(MedPagObj: JsonObject; var pMedioPago: Record "EDUCAMOS MedioPago")
    var
        vlToken: JsonToken;
    begin
        if MedPagObj.Get('medioPago', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMedioPago.medioPago := vlToken.AsValue().AsText();

        if MedPagObj.Get('porDefecto', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMedioPago.porDefecto := vlToken.AsValue().AsBoolean();
    end;

    local procedure fFillCuentaBancariaData(CuenBancObj: JsonObject; var pMedioPago: Record "EDUCAMOS MedioPago")
    var
        vlToken: JsonToken;
    begin
        if CuenBancObj.Get('bic', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMedioPago.bic := vlToken.AsValue().AsText();

        if CuenBancObj.Get('codigoPais', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMedioPago.codigoPais := vlToken.AsValue().AsText();

        if CuenBancObj.Get('digitoControlIban', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMedioPago.digitoControlIban := vlToken.AsValue().AsText();

        if CuenBancObj.Get('entidad', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMedioPago.entidad := vlToken.AsValue().AsText();

        if CuenBancObj.Get('sucursal', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMedioPago.sucursal := vlToken.AsValue().AsText();

        if CuenBancObj.Get('digitoControl', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMedioPago.digitoControl := vlToken.AsValue().AsText();

        if CuenBancObj.Get('numeroCuenta', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMedioPago.numeroCuenta := vlToken.AsValue().AsText();
    end;

    local procedure fFillDependienteData(DepEconObj: JsonObject; var pDepEconomico: Record "EDUCAMOS Dep. Economico")
    var
        vlToken: JsonToken;
    begin
        if DepEconObj.Get('porDefecto', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pDepEconomico.porDefecto := vlToken.AsValue().AsBoolean();
    end;

    local procedure fFindMatchingBrace(TextToScan: Text; StartPos: Integer): Integer
    var
        i: Integer;
        Level: Integer;
        c: Char;
    begin
        Level := 0;

        for i := StartPos to StrLen(TextToScan) do begin
            c := TextToScan[i];

            if c = '{' then
                Level += 1;

            if c = '}' then begin
                Level -= 1;

                if Level = 0 then
                    exit(i);
            end;
        end;

        exit(0);
    end;

    local procedure TryGetRemesas(): Boolean
    var
        Root: JsonObject;
        RemesasTok: JsonToken;
        RemesasArr: JsonArray;
        ItemTok: JsonToken;
        ItemObj: JsonObject;
        i: Integer;
    begin
        vResult := '';

        if not Root.ReadFrom(vFullJsonBody) then begin
            vResult := NonJsonResponseErr;
            exit(false);
        end;

        if not Root.Get('remesas', RemesasTok) then begin
            vResult := 'La respuesta no contiene el nodo "Remesas".';
            exit(false);
        end;

        RemesasArr := RemesasTok.AsArray();

        for i := 0 to RemesasArr.Count() - 1 do begin
            RemesasArr.Get(i, ItemTok);
            ItemObj := ItemTok.AsObject();

            if not fFillRemesas(ItemObj) then begin
                vResult := 'No se han podido tratar los recibos de las remesas.';
                exit(false);
            end;

            exit(true);
        end;

        vResult := 'Remesas importadas correctamente';
        exit(false);
    end;

    local procedure fFillRemesas(ItemObj: JsonObject): Boolean
    var
        rlRemesa: Record "EDUCAMOS Remesa";
        vlToken: JsonToken;
    begin
        if ItemObj.Get('remesaId', vlToken) then begin
            if not rlRemesa.Get(vlToken.AsValue().AsText()) then begin
                rlRemesa.Init();
                rlRemesa.remesaId := vlToken.AsValue().AsText();
                fFillRemesasData(ItemObj, rlRemesa);
                rlRemesa.Insert();

                if not fTratarRecibosRemesa(rlRemesa.remesaId) then begin
                    vResult := 'No se han podido tratar los recibos de las remesas.';
                    exit(false);
                end;
            end else begin
                fFillRemesasData(ItemObj, rlRemesa);
                rlRemesa.Modify();
            end;

            exit(true);
        end;
    end;

    local procedure fFillRemesasData(ItemObj: JsonObject; var pRemesa: Record "EDUCAMOS Remesa")
    var
        vlToken: JsonToken;
    begin
        if ItemObj.Get('descripcion', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.descripcion := vlToken.AsValue().AsText();

        if ItemObj.Get('reducido', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.reducido := vlToken.AsValue().AsText();

        if ItemObj.Get('periodoFacturacionId', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.periodoFacturacionId := vlToken.AsValue().AsText();

        if ItemObj.Get('nombrePeriodo', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.nombrePeriodo := vlToken.AsValue().AsText();

        if ItemObj.Get('pagadorComun', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.pagadorComun := vlToken.AsValue().AsBoolean();

        if ItemObj.Get('fechaCreacion', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRemesa.fechaCreacion, vlToken.AsValue().AsText());

        if ItemObj.Get('fechaEmision', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRemesa.fechaEmision, vlToken.AsValue().AsText());

        if ItemObj.Get('importe', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRemesa.importe, vlToken.AsValue().AsText());

        if ItemObj.Get('ordenanteCuentaBancariaId', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.ordenanteCuentaBancariaId := vlToken.AsValue().AsText();

        if ItemObj.Get('ordenante', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.ordenante := vlToken.AsValue().AsText();

        if ItemObj.Get('presentador', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.presentador := vlToken.AsValue().AsText();

        if ItemObj.Get('datosBancarios', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.datosBancarios := vlToken.AsValue().AsText();

        if ItemObj.Get('fechaCargo', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRemesa.fechaCargo, vlToken.AsValue().AsText());

        if ItemObj.Get('cuadernoBancario', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.cuadernoBancario := vlToken.AsValue().AsText();

        if ItemObj.Get('esquemaSEPA', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.esquemaSEPA := vlToken.AsValue().AsText();

        if ItemObj.Get('textoReciboRecargo', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.textoReciboRecargo := vlToken.AsValue().AsText();

        if ItemObj.Get('importeRecargo', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRemesa.importeRecargo, vlToken.AsValue().AsText());

        if ItemObj.Get('numeroRecibosBanco', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.numeroRecibosBanco := vlToken.AsValue().AsInteger();

        if ItemObj.Get('importeTotalBanco', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRemesa.importeTotalBanco, vlToken.AsValue().AsText());

        if ItemObj.Get('numeroRecibosVentanilla', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.numeroRecibosVentanilla := vlToken.AsValue().AsInteger();

        if ItemObj.Get('importeTotalVentanilla', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRemesa.importeTotalVentanilla, vlToken.AsValue().AsText());

        if ItemObj.Get('esRemitida', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRemesa.esRemitida := vlToken.AsValue().AsBoolean();

        pRemesa."Importation DateTime" := CurrentDateTime;
        pRemesa.Processed := true;
    end;

    local procedure fTratarRecibosRemesa(pRemesaID: Text): Boolean
    begin
        Ok := CallGETWithContinuationToken(BuildRecibosRemesaUrl(pRemesaID));
        if not Ok then begin
            cuInterface.fSetLogWithResponse(3, 'Error obteniendo recibos: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if not TryGetRecibosRemesa(pRemesaID) then begin
            cuInterface.fSetLogWithResponse(3, 'No se pudieron traer los recibos de remesas: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;
    end;

    local procedure TryGetRecibosRemesa(pRemesaID: Text): Boolean
    var
        Root: JsonObject;
        recibosTok: JsonToken;
        recibosArr: JsonArray;
        conceptosTok: JsonToken;
        conceptosArr: JsonArray;
        descuentosTok: JsonToken;
        descuentosArr: JsonArray;
        movimientosTok: JsonToken;
        movimientosArr: JsonArray;
        pagoTok: JsonToken;
        pagoArr: JsonArray;
        conceptosPagadosTok: JsonToken;
        conceptosPagadosArr: JsonArray;
        ItemTok: JsonToken;
        ItemObj: JsonObject;
        i: Integer;
    begin
        vResult := '';

        if not Root.ReadFrom(vFullJsonBody) then begin
            vResult := NonJsonResponseErr;
            exit(false);
        end;

        if not Root.Get('recibos', recibosTok) then begin
            vResult := 'La respuesta no contiene el nodo "Recibos".';
            exit(false);
        end;

        recibosArr := recibosTok.AsArray();

        for i := 0 to recibosArr.Count() - 1 do begin
            RecibosArr.Get(i, ItemTok);
            ItemObj := ItemTok.AsObject();

            if not fFillRecibosRemesa(ItemObj, pRemesaID) then begin
                vResult := 'No se han podido tratar los recibos de las remesas.';
                exit(false);
            end;
        end;

        if not Root.Get('conceptos', conceptosTok) then begin
            vResult := 'La respuesta no contiene el nodo "Conceptos".';
            exit(false);
        end;

        conceptosArr := conceptosTok.AsArray();

        for i := 0 to conceptosArr.Count() - 1 do begin
            conceptosArr.Get(i, ItemTok);
            ItemObj := ItemTok.AsObject();

            if not fFillRecibosRemesa(ItemObj, pRemesaID) then begin
                vResult := 'No se han podido tratar los recibos de las remesas.';
                exit(false);
            end;
        end;

        if not Root.Get('descuentos', descuentosTok) then begin
            vResult := 'La respuesta no contiene el nodo "descuentos".';
            exit(false);
        end;

        descuentosArr := descuentosTok.AsArray();

        for i := 0 to descuentosArr.Count() - 1 do begin
            descuentosArr.Get(i, ItemTok);
            ItemObj := ItemTok.AsObject();

            if not fFillRecibosRemesa(ItemObj, pRemesaID) then begin
                vResult := 'No se han podido tratar los descuentos.';
                exit(false);
            end;
        end;

        if not Root.Get('movimientos', movimientosTok) then begin
            vResult := 'La respuesta no contiene el nodo "movimientos".';
            exit(false);
        end;

        movimientosArr := movimientosTok.AsArray();

        for i := 0 to movimientosArr.Count() - 1 do begin
            movimientosArr.Get(i, ItemTok);
            ItemObj := ItemTok.AsObject();

            if not fFillRecibosRemesa(ItemObj, pRemesaID) then begin
                vResult := 'No se han podido tratar los movimientos.';
                exit(false);
            end;
        end;

        if not Root.Get('pago', pagoTok) then begin
            vResult := 'La respuesta no contiene el nodo "pago".';
            exit(false);
        end;

        pagoArr := pagoTok.AsArray();

        for i := 0 to pagoArr.Count() - 1 do begin
            pagoArr.Get(i, ItemTok);
            ItemObj := ItemTok.AsObject();

            if not fFillRecibosRemesa(ItemObj, pRemesaID) then begin
                vResult := 'No se han podido tratar los pagos.';
                exit(false);
            end;
        end;

        if not Root.Get('conceptosPagados', conceptosPagadosTok) then begin
            vResult := 'La respuesta no contiene el nodo "conceptosPagados".';
            exit(false);
        end;

        conceptosPagadosArr := conceptosPagadosTok.AsArray();

        for i := 0 to conceptosPagadosArr.Count() - 1 do begin
            conceptosPagadosArr.Get(i, ItemTok);
            ItemObj := ItemTok.AsObject();

            if not fFillRecibosRemesa(ItemObj, pRemesaID) then begin
                vResult := 'No se han podido tratar los conceptos pagados.';
                exit(false);
            end;
        end;

        vResult := 'Recibos importados correctamente.';
        exit(false);
    end;

    local procedure fFillRecibosRemesa(ItemObj: JsonObject; pRemesaID: Text): Boolean
    var
        rlRecibosRemesa: Record "EDUCAMOS RecibosRemesa";
        vlToken: JsonToken;
    begin
        if ItemObj.Get('reciboId', vlToken) then begin
            if not rlRecibosRemesa.Get(pRemesaID, vlToken.AsValue().AsText()) then begin
                rlRecibosRemesa.Init();
                rlRecibosRemesa.remesaid := pRemesaID;
                rlRecibosRemesa.reciboId := vlToken.AsValue().AsText();
                fFillRecibosRemesaData(ItemObj, rlRecibosRemesa);
                rlRecibosRemesa.Insert();
            end else begin
                fFillRecibosRemesaData(ItemObj, rlRecibosRemesa);
                rlRecibosRemesa.Modify();
            end;

            exit(true);
        end;
    end;

    local procedure fFillRecibosRemesaData(ItemObj: JsonObject; var pRecibosRemesa: Record "EDUCAMOS RecibosRemesa")
    var
        vlToken: JsonToken;
    begin
        if ItemObj.Get('medioPago', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.medioPago := vlToken.AsValue().AsText();

        if ItemObj.Get('pagadorMedioPagoId', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.pagadorMedioPagoId, vlToken.AsValue().AsText());

        if ItemObj.Get('prefijo', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.prefijo := vlToken.AsValue().AsText();

        if ItemObj.Get('numero', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.numero := vlToken.AsValue().AsInteger();

        if ItemObj.Get('sufijoAnulacion', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.sufijoAnulacion := vlToken.AsValue().AsText();

        if ItemObj.Get('reciboConceptoId', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.reciboConceptoId, vlToken.AsValue().AsText());

        if ItemObj.Get('importeConcepto', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.importeConcepto, vlToken.AsValue().AsText());

        if ItemObj.Get('importePagado', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.importePagado, vlToken.AsValue().AsText());

        if ItemObj.Get('fechaPago', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.fechaPago, vlToken.AsValue().AsText());

        if ItemObj.Get('conceptoId', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.conceptoId, vlToken.AsValue().AsText());

        if ItemObj.Get('texto', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.texto := vlToken.AsValue().AsText();

        if ItemObj.Get('personaId', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.personaId, vlToken.AsValue().AsText());

        if ItemObj.Get('estado', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.estado := vlToken.AsValue().AsText();

        if ItemObj.Get('descuentoId', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.descuentoId, vlToken.AsValue().AsText());

        if ItemObj.Get('nombreDescuento', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.nombreDescuento := vlToken.AsValue().AsText();

        if ItemObj.Get('importe', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.importe, vlToken.AsValue().AsText());

        if ItemObj.Get('porcentaje', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.porcentaje, vlToken.AsValue().AsText());

        if ItemObj.Get('nombreResponsable', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.nombreResponsable := vlToken.AsValue().AsText();

        if ItemObj.Get('apellido1Responsable', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.apellido1Responsable := vlToken.AsValue().AsText();

        if ItemObj.Get('apellido2Responsable', vlToken) then
            pRecibosRemesa.apellido2Responsable := vlToken.AsValue().AsText();

        if ItemObj.Get('fechaMovimiento', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.fechaMovimiento, vlToken.AsValue().AsText());

        if ItemObj.Get('fechaValor', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.fechaValor, vlToken.AsValue().AsText());

        if ItemObj.Get('estadoRecibo', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.estadoRecibo := vlToken.AsValue().AsText();

        if ItemObj.Get('motivoDevolucion', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.motivoDevolucion := vlToken.AsValue().AsText();

        if ItemObj.Get('comentario', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.comentario := vlToken.AsValue().AsText();

        if ItemObj.Get('domiciliado', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibosRemesa.domiciliado := vlToken.AsValue().AsBoolean();

        if ItemObj.Get('importePago', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.pago_importePago, vlToken.AsValue().AsText());

        if ItemObj.Get('reciboConceptoId', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.pago_reciboConceptoId, vlToken.AsValue().AsText());

        if ItemObj.Get('importePagado', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pRecibosRemesa.pago_importePagado, vlToken.AsValue().AsText());

        pRecibosRemesa."Importation DateTime" := CurrentDateTime;
        pRecibosRemesa.Processed := true;
    end;

    local procedure FillInputData(pWSResult: Text): Boolean
    var
        rlInputData: Record "EDUCAMOS Input Data";
        rlInputDataAux: Record "EDUCAMOS Input Data";
        vlFileContent: BigText;
        vlNextEntryNo: Integer;
    begin
        vlNextEntryNo := 1;
        rlInputDataAux.Reset();
        if rlInputDataAux.FindLast() then
            vlNextEntryNo := rlInputDataAux."Entry No." + 1;

        Clear(vlFileContent);
        vlFileContent.AddText(pWSResult);

        rlInputData.Init();
        rlInputData."Entry No." := vlNextEntryNo;
        rlInputData."Importation DateTime" := CurrentDateTime();

        rlInputData.Content.CreateOutStream(vOutStr);
        vlFileContent.Write(vOutStr);

        exit(rlInputData.Insert());
    end;

    local procedure UrlEncode(Value: Text): Text
    begin
        Value := Value.Replace('%', '%25');
        Value := Value.Replace('&', '%26');
        Value := Value.Replace('=', '%3D');
        Value := Value.Replace('+', '%2B');
        Value := Value.Replace(' ', '%20');
        Value := Value.Replace('#', '%23');
        Value := Value.Replace('?', '%3F');
        Value := Value.Replace('/', '%2F');
        Value := Value.Replace(':', '%3A');
        exit(Value);
    end;

    local procedure fInitializeGlobals(): Boolean
    begin
        Clear(cuInterface);

        if not rEDUSetup.Get() then begin
            cuInterface.fSetLog(3, StrSubstNo('No existe %1', rEDUSetup.TableCaption), CompanyName, 0);
            Commit();
            exit(false);
        end;

        Clear(cTempBlob);
        vAccessToken := '';
        vResult := '';
        vCalendarioId := '';
        vStartDate := 0D;
        vEndDate := 0D;
        vJsonBody := '';
        Ok := false;
        vFullJsonBody := '';
        vStatusCode := 0;
        vBaseUrl := rEDUSetup."API URL";

        exit(true);
    end;
}