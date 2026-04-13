codeunit 50006 "EDUCAMOS API Management"
{
    trigger OnRun()
    begin
        Code();
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
        vStatusCode: Integer;
        vMovimientoId: Integer;
        vOutStr: OutStream;
        vStartDate: Date;
        vEndDate: Date;
        vAccessToken: Text;
        vResult: Text;
        vCalendarioId: Text;
        vJsonBody: Text;
        vFullJsonBody: Text;
        vBaseUrl: Text;
        vPersonaId: Text[50];
        vPagadorMedioPagoId: Text[50];
        vDependientePersonaId: Text[50];
        vRemesaId: Text[50];
        vReciboId: Text[50];
        vReciboConceptoId: Text[50];
        vDescuentoId: Text[50];
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
        if not GetAccessToken() then begin
            cuInterface.fSetLogWithResponse(3, StrSubstNo('%1: %2', Error004, vResult), CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if not CallGET() then begin
            cuInterface.fSetLogWithResponse(3, vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if vJsonBody = '' then begin
            cuInterface.fSetLogWithResponse(2, Error003, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        //

        if not CallGETWithContinuationToken(BuildPagadoresUrl()) then begin
            cuInterface.fSetLogWithResponse(3, 'Error obteniendo pagadores: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if not TryGetPagadores() then begin
            cuInterface.fSetLogWithResponse(3, 'No se pudieron traer los pagadores: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if not TryGetActiveCalendar() then begin
            cuInterface.fSetLogWithResponse(3, 'No se pudo determinar calendario activo: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if not CallGETWithContinuationToken(BuildRemesasUrl()) then begin
            cuInterface.fSetLogWithResponse(3, 'Error obteniendo remesas: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if vFullJsonBody = '' then begin
            cuInterface.fSetLogWithResponse(2, Error003, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if not TryGetRemesas() then begin
            cuInterface.fSetLogWithResponse(3, 'No se pudieron traer las remesas: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if not CallGETWithContinuationToken(BuildMovsReciboUrl()) then begin
            cuInterface.fSetLogWithResponse(3, 'Error obteniendo movimientos de recibo: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if not TryGetMovsRecibo() then begin
            cuInterface.fSetLogWithResponse(3, 'No se pudieron traer los movimientos de recibo: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

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

    local procedure BuildPagadoresUrl(): Text
    var
        Url: Label 'https://developer-api-neu.educamos.com/apismeducamos/api/colegio/pagadores', Locked = true;
    begin
        exit(Url);
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

    local procedure BuildRecibosRemesaUrl(): Text
    var
        Url: Text;
    begin
        Url := vBaseUrl + '/' + Format(vCalendarioId) + '/remesas/' +
        vRemesaId + '/recibos';

        exit(Url);
    end;

    local procedure BuildMovsReciboUrl(): Text
    var
        Url: Text;
    begin
        Url := vBaseUrl + '/' + Format(vCalendarioId) + '/remesas/' +
        vRemesaId + '/recibos/' + vReciboId + '/historicoRecibo';

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

            rlPagador.Insert();
        end else begin
            fFillPagadorData(PagadorObj, rlPagador);

            rlPagador.Modify();
        end;

        if PagadorObj.Get('direccion', DireccionTok) then
            if DireccionTok.IsObject() then begin
                DirObj := DireccionTok.AsObject();

                fFillDireccionData(DirObj, rlPagador);

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

            rlMedioPago.Insert();
        end else begin
            fFillMedioPagoData(MediosPagoObj, rlMedioPago);

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

                    rlDependienteEconomico.Insert();
                end else begin
                    fFillDependienteData(DepEconObj, rlDependienteEconomico);

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

        pPagadores."Importation DateTime" := CurrentDateTime;
        pPagadores.Processed := true;
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

        pPagadores."Importation DateTime" := CurrentDateTime;
        pPagadores.Processed := true;
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

        pMedioPago."Importation DateTime" := CurrentDateTime;
        pMedioPago.Processed := true;
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

        pMedioPago."Importation DateTime" := CurrentDateTime;
        pMedioPago.Processed := true;
    end;

    local procedure fFillDependienteData(DepEconObj: JsonObject; var pDepEconomico: Record "EDUCAMOS Dep. Economico")
    var
        vlToken: JsonToken;
    begin
        if DepEconObj.Get('porDefecto', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pDepEconomico.porDefecto := vlToken.AsValue().AsBoolean();

        pDepEconomico."Importation DateTime" := CurrentDateTime;
        pDepEconomico.Processed := true;
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
        end;

        vResult := 'Remesas importadas correctamente';
        exit(true);
    end;

    local procedure fFillRemesas(ItemObj: JsonObject): Boolean
    var
        rlRemesa: Record "EDUCAMOS Remesa";
        rlRemesaAux: Record "EDUCAMOS Remesa";
        vlToken: JsonToken;
    begin
        if ItemObj.Get('remesaId', vlToken) then begin
            rlRemesa.Reset();
            rlRemesa.SetRange(remesaId, vlToken.AsValue().AsText());
            if not rlRemesa.FindFirst() then begin
                vRemesaId := vlToken.AsValue().AsText();

                rlRemesa.Init();
                rlRemesa.calendarioEscolarId := vCalendarioId;
                rlRemesaAux.Reset();
                if rlRemesaAux.FindLast() then
                    rlRemesa."ID Remesa BC" := rlRemesaAux."ID Remesa BC" + 1
                else
                    rlRemesa."ID Remesa BC" := 1;
                rlRemesa.remesaId := vlToken.AsValue().AsText();
                fFillRemesasData(ItemObj, rlRemesa);
                rlRemesa.Insert();
                Commit();

                if not fTratarRecibosRemesa() then begin
                    vResult := 'No se han podido tratar los recibos de las remesas.';
                    exit(false);
                end;
            end else begin
                vRemesaId := vlToken.AsValue().AsText();

                fFillRemesasData(ItemObj, rlRemesa);
                rlRemesa.Modify();
                Commit();

                if not fTratarRecibosRemesa() then begin
                    vResult := 'No se han podido tratar los recibos de las remesas.';
                    exit(false);
                end;
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

    local procedure fTratarRecibosRemesa(): Boolean
    begin
        if not CallGETWithContinuationToken(BuildRecibosRemesaUrl()) then begin
            cuInterface.fSetLogWithResponse(3, 'Error obteniendo recibos: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if not TryGetRecibosRemesa() then begin
            cuInterface.fSetLogWithResponse(3, 'No se pudieron traer los recibos de remesas: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        exit(true);
    end;

    local procedure TryGetRecibosRemesa(): Boolean
    var
        Root: JsonObject;
        RecibosTok: JsonToken;
        RecibosArr: JsonArray;
        ConceptosTok: JsonToken;
        ConceptosArr: JsonArray;
        DescuentosTok: JsonToken;
        DescuentosArr: JsonArray;
        RecTok: JsonToken;
        RecObj: JsonObject;
        ConTok: JsonToken;
        ConObj: JsonObject;
        DescTok: JsonToken;
        DescObj: JsonObject;
        i: Integer;
        j: Integer;
        k: Integer;
        OpenPos: Integer;
        ClosePos: Integer;
        RemainingText: Text;
        OneJsonText: Text;
    begin
        vResult := '';
        RemainingText := vFullJsonBody;

        while StrLen(RemainingText) > 0 do begin
            OpenPos := StrPos(RemainingText, '{');
            if OpenPos = 0 then
                break;

            ClosePos := fFindMatchingBrace(RemainingText, OpenPos);
            if ClosePos = 0 then begin
                vResult := 'JSON de recibos incompleto.';
                exit(false);
            end;

            OneJsonText := CopyStr(RemainingText, OpenPos, ClosePos - OpenPos + 1);
            Clear(Root);

            if not Root.ReadFrom(OneJsonText) then begin
                vResult := NonJsonResponseErr;
                exit(false);
            end;

            if not Root.Get('recibos', RecibosTok) then begin
                vResult := 'La respuesta no contiene el nodo "recibos".';
                exit(false);
            end;

            if RecibosTok.IsValue() then
                if (RecibosTok.AsValue().IsNull()) then
                    exit(true);

            RecibosArr := RecibosTok.AsArray();

            for i := 0 to RecibosArr.Count() - 1 do begin
                RecibosArr.Get(i, RecTok);
                RecObj := RecTok.AsObject();

                if not fFillRecibosRemesa(RecObj) then begin
                    vResult := 'No se han podido tratar los recibos.';
                    exit(false);
                end;

                if RecObj.Get('conceptos', ConceptosTok) and ConceptosTok.IsArray() then begin
                    ConceptosArr := ConceptosTok.AsArray();

                    for j := 0 to ConceptosArr.Count() - 1 do begin
                        ConceptosArr.Get(j, ConTok);
                        ConObj := ConTok.AsObject();

                        if not fFillConceptosRecibo(ConObj) then begin
                            vResult := 'No se han podido tratar los conceptos.';
                            exit(false);
                        end;

                        if ConObj.Get('descuentos', DescuentosTok) and DescuentosTok.IsArray() then begin
                            DescuentosArr := DescuentosTok.AsArray();

                            for k := 0 to DescuentosArr.Count() - 1 do begin
                                DescuentosArr.Get(k, DescTok);
                                DescObj := DescTok.AsObject();

                                if not fFillDescuentosConcepto(DescObj) then begin
                                    vResult := 'No se han podido tratar los descuentos.';
                                    exit(false);
                                end;
                            end;
                        end;
                    end;
                end;
            end;

            RemainingText := CopyStr(RemainingText, ClosePos + 1);
        end;

        vResult := 'Recibos importados correctamente.';
        exit(true);
    end;

    local procedure fFillRecibosRemesa(RecObj: JsonObject): Boolean
    var
        rlRecibo: Record "EDUCAMOS ReciboRemesa";
        vlToken: JsonToken;
    begin
        if not RecObj.Get('reciboId', vlToken) then begin
            vResult := 'El recibo no tiene reciboId.';
            exit(false);
        end;

        vReciboId := vlToken.AsValue().AsText();

        if not rlRecibo.Get(vCalendarioId, vRemesaId, vReciboId) then begin
            rlRecibo.Init();
            rlRecibo.calendarioEscolarId := vCalendarioId;
            rlRecibo.remesaId := vRemesaId;
            rlRecibo.reciboId := vReciboId;

            fFillReciboRemesaData(RecObj, rlRecibo);

            rlRecibo.Insert();
        end else begin
            fFillReciboRemesaData(RecObj, rlRecibo);

            rlRecibo.Modify();
        end;

        exit(true);
    end;

    local procedure fFillReciboRemesaData(RecObj: JsonObject; var pRecibo: Record "EDUCAMOS ReciboRemesa")
    var
        vlToken: JsonToken;
        rlReciboRemesa: Record "EDUCAMOS ReciboRemesa";
        rlRemesa: Record "EDUCAMOS Remesa";
    begin
        rlRemesa.Reset();
        rlRemesa.SetRange(remesaId, vRemesaId);
        if rlRemesa.FindFirst() then
            pRecibo."ID Remesa BC" := rlRemesa."ID Remesa BC";

        if rlReciboRemesa.Get(vCalendarioId, vRemesaId, vReciboId) then
            pRecibo."ID Recibo BC" += 1;

        if RecObj.Get('estado', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibo.estado := vlToken.AsValue().AsText();

        if RecObj.Get('reciboOrigenId', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibo.reciboOrigenId := vlToken.AsValue().AsText();

        if RecObj.Get('medioPago', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibo.medioPago := vlToken.AsValue().AsText();

        if RecObj.Get('pagadorMedioPagoId', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibo.pagadorMedioPagoId := vlToken.AsValue().AsText();

        if RecObj.Get('prefijo', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibo.prefijo := vlToken.AsValue().AsText();

        if RecObj.Get('numero', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibo.numero := vlToken.AsValue().AsInteger();

        if RecObj.Get('sufijoAnulacion', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pRecibo.sufijoAnulacion := vlToken.AsValue().AsText();

        pRecibo."Importation DateTime" := CurrentDateTime;
        pRecibo.Processed := true;
    end;

    local procedure fFillConceptosRecibo(ConObj: JsonObject): Boolean
    var
        rlConcepto: Record "EDUCAMOS ConceptoRecibo";
        vlToken: JsonToken;
    begin
        if not ConObj.Get('reciboConceptoId', vlToken) then
            exit(false);

        vReciboConceptoId := vlToken.AsValue().AsText();

        if not rlConcepto.Get(vCalendarioId, vRemesaId, vReciboId, vReciboConceptoId) then begin
            rlConcepto.Init();
            rlConcepto.calendarioEscolarId := vCalendarioId;
            rlConcepto.remesaId := vRemesaId;
            rlConcepto.reciboId := vReciboId;
            rlConcepto.reciboConceptoId := vReciboConceptoId;

            fFillConceptoData(ConObj, rlConcepto);

            rlConcepto.Insert();
        end else begin
            fFillConceptoData(ConObj, rlConcepto);

            rlConcepto.Modify();
        end;

        exit(true);
    end;

    local procedure fFillConceptoData(ConObj: JsonObject; var pConcepto: Record "EDUCAMOS ConceptoRecibo")
    var
        vlToken: JsonToken;
    begin
        if ConObj.Get('importe', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pConcepto.importe := vlToken.AsValue().AsDecimal();

        if ConObj.Get('importePagado', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pConcepto.importePagado := vlToken.AsValue().AsDecimal();

        if ConObj.Get('fechaPago', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pConcepto.fechaPago, vlToken.AsValue().AsText());

        if ConObj.Get('conceptoId', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pConcepto.conceptoId := vlToken.AsValue().AsText();

        if ConObj.Get('texto', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pConcepto.texto := vlToken.AsValue().AsText();

        if ConObj.Get('personaId', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pConcepto.personaId := vlToken.AsValue().AsText();

        if ConObj.Get('estado', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pConcepto.estado := vlToken.AsValue().AsText();

        pConcepto."Importation DateTime" := CurrentDateTime;
        pConcepto.Processed := true;
    end;

    local procedure fFillDescuentosConcepto(DescObj: JsonObject): Boolean
    var
        rlDescuento: Record "EDUCAMOS DescuentoConcepto";
        vlToken: JsonToken;
    begin
        if not DescObj.Get('descuentoId', vlToken) then
            exit(false);

        vDescuentoId := vlToken.AsValue().AsText();

        if not rlDescuento.Get(vCalendarioId, vRemesaId, vReciboConceptoId, vDescuentoId) then begin
            rlDescuento.Init();
            rlDescuento.calendarioEscolarId := vCalendarioId;
            rlDescuento.remesaId := vRemesaId;
            rlDescuento.reciboConceptoId := vReciboConceptoId;
            rlDescuento.descuentoId := vDescuentoId;

            fFillDescuentosConceptoData(DescObj, rlDescuento);

            rlDescuento.Insert();
        end else begin
            fFillDescuentosConceptoData(DescObj, rlDescuento);

            rlDescuento.Modify();
        end;

        exit(true);
    end;

    local procedure fFillDescuentosConceptoData(DescObj: JsonObject; var pDescuento: Record "EDUCAMOS DescuentoConcepto"): Boolean
    var
        vlToken: JsonToken;
    begin
        if DescObj.Get('nombreDescuento', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pDescuento.nombreDescuento := vlToken.AsValue().AsText();

        if DescObj.Get('importe', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pDescuento.importe := vlToken.AsValue().AsDecimal();

        if DescObj.Get('porcentaje', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pDescuento.porcentaje := vlToken.AsValue().AsDecimal();

        pDescuento."Importation DateTime" := CurrentDateTime;
        pDescuento.Processed := true;
    end;

    local procedure fFillConceptoPagadoData(ConPagObj: JsonObject): Boolean
    var
        rlConceptoPagado: Record "EDUCAMOS ConceptoPagado";
        vlToken: JsonToken;
    begin
        if not ConPagObj.Get('reciboConceptoId', vlToken) then
            exit(false);

        vReciboConceptoId := vlToken.AsValue().AsText();

        if not rlConceptoPagado.Get(vReciboConceptoId) then begin
            rlConceptoPagado.Init();
            rlConceptoPagado.reciboConceptoId := vReciboConceptoId;

            if ConPagObj.Get('importePagado', vlToken) then
                if not vlToken.AsValue().IsNull() then
                    rlConceptoPagado.importePagado := vlToken.AsValue().AsDecimal();

            rlConceptoPagado."Importation DateTime" := CurrentDateTime;
            rlConceptoPagado.Processed := true;

            rlConceptoPagado.Insert();
        end;

        exit(true);
    end;

    local procedure TryGetMovsRecibo(): Boolean
    var
        Root: JsonObject;
        MovimientosTok: JsonToken;
        MovimientosArr: JsonArray;

        MovTok: JsonToken;
        MovObj: JsonObject;

        i: Integer;

        OpenPos: Integer;
        ClosePos: Integer;
        RemainingText: Text;
        OneJsonText: Text;
    begin
        vResult := '';
        RemainingText := vFullJsonBody;

        while StrLen(RemainingText) > 0 do begin
            OpenPos := StrPos(RemainingText, '{');
            if OpenPos = 0 then
                break;

            ClosePos := fFindMatchingBrace(RemainingText, OpenPos);
            if ClosePos = 0 then begin
                vResult := 'JSON de movimientos incompleto.';
                exit(false);
            end;

            OneJsonText := CopyStr(RemainingText, OpenPos, ClosePos - OpenPos + 1);
            Clear(Root);

            if not Root.ReadFrom(OneJsonText) then begin
                vResult := NonJsonResponseErr;
                exit(false);
            end;

            if not Root.Get('movimientos', MovimientosTok) then begin
                vResult := 'La respuesta no contiene el nodo "calendarios".';
                exit(false);
            end;

            if MovimientosTok.IsArray() then begin
                MovimientosArr := MovimientosTok.AsArray();

                if MovimientosArr.Count() <> 0 then
                    for i := 0 to MovimientosArr.Count() - 1 do begin
                        MovimientosArr.Get(i, MovTok);
                        MovObj := MovTok.AsObject();

                        if not fFillMovsRecibo(MovObj) then begin
                            vResult := 'No se han podido tratar los movimientos del recibo.';
                            exit(false);
                        end;
                    end;
            end;

            RemainingText := CopyStr(RemainingText, ClosePos + 1);
        end;

        exit(true);
    end;

    local procedure fFillMovsRecibo(MovObj: JsonObject): Boolean
    var
        rlReciboRemesa: Record "EDUCAMOS ReciboRemesa";
        rlMovRecibo: Record "EDUCAMOS MovRecibo";
        rlMovReciboAux: Record "EDUCAMOS MovRecibo";
        vlMovimientoId: Integer;
    begin
        rlReciboRemesa.Reset();
        if rlReciboRemesa.FindSet() then
            repeat
                rlMovReciboAux.Reset();
                rlMovReciboAux.SetRange(calendarioEscolarId, rlReciboRemesa.calendarioEscolarId);
                rlMovReciboAux.SetRange(remesaId, rlReciboRemesa.remesaId);
                rlMovReciboAux.SetRange(reciboId, rlReciboRemesa.reciboId);
                if rlMovReciboAux.FindLast() then
                    vlMovimientoId := rlMovReciboAux.movimientoId + 1
                else
                    vlMovimientoId := 1;

                if not rlMovRecibo.Get(rlReciboRemesa.calendarioEscolarId, rlReciboRemesa.remesaId, rlReciboRemesa.reciboId, vlMovimientoId) then begin
                    rlMovRecibo.Init();
                    rlMovRecibo.calendarioEscolarId := rlReciboRemesa.calendarioEscolarId;
                    rlMovRecibo.remesaId := rlReciboRemesa.remesaId;
                    rlMovRecibo.reciboId := rlReciboRemesa.reciboId;
                    rlMovRecibo.movimientoId := vlMovimientoId;

                    fFillMovimientoData(MovObj, rlMovRecibo);

                    rlMovRecibo.Insert();
                end else begin
                    fFillMovimientoData(MovObj, rlMovRecibo);

                    rlMovRecibo.Modify();
                end;
            until rlReciboRemesa.Next() = 0;

        exit(true);
    end;

    local procedure fFillMovimientoData(MovObj: JsonObject; var pMov: Record "EDUCAMOS MovRecibo")
    var
        vlToken: JsonToken;
        PagoTok: JsonToken;
        PagoObj: JsonObject;
        ConceptosPagadosTok: JsonToken;
        ConceptosPagadosArr: JsonArray;
        j: integer;
        ConTok: JsonToken;
        ConObj: JsonObject;
    begin
        if MovObj.Get('nombreResponsable', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMov.nombreResponsable := vlToken.AsValue().AsText();

        if MovObj.Get('apellido1Responsable', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMov.apellido1Responsable := vlToken.AsValue().AsText();

        if MovObj.Get('apellido2Responsable', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMov.apellido2Responsable := vlToken.AsValue().AsText();

        if MovObj.Get('fechaMovimiento', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pMov.fechaMovimiento, vlToken.AsValue().AsText());

        if MovObj.Get('fechaValor', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pMov.fechaValor, vlToken.AsValue().AsText());

        if MovObj.Get('estadoRecibo', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMov.estadoRecibo := vlToken.AsValue().AsText();

        if MovObj.Get('motivoDevolucion', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMov.motivoDevolucion := vlToken.AsValue().AsText();

        if MovObj.Get('comentario', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMov.comentario := vlToken.AsValue().AsText();

        if MovObj.Get('domiciliado', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMov.domiciliado := vlToken.AsValue().AsBoolean();

        if MovObj.Get('pago', PagoTok) then
            if PagoTok.IsObject then begin
                PagoObj := PagoTok.AsObject();

                fFillPagoData(PagoObj, pMov);

                if PagoObj.Get('conceptosPagados', ConceptosPagadosTok) then
                    if ConceptosPagadosTok.IsArray() then begin
                        ConceptosPagadosArr := ConceptosPagadosTok.AsArray();

                        for j := 0 to ConceptosPagadosArr.Count() - 1 do begin
                            ConceptosPagadosArr.Get(j, ConTok);
                            ConObj := ConTok.AsObject();

                            fFillConceptosPagados(ConObj);
                        end;
                    end;
            end;

        pMov."Importation DateTime" := CurrentDateTime;
        pMov.Processed := true;
    end;

    local procedure fFillPagoData(PagoObj: JsonObject; var pMov: Record "EDUCAMOS MovRecibo")
    var
        vlToken: JsonToken;
    begin
        if PagoObj.Get('fechaPago', vlToken) then
            if not vlToken.AsValue().IsNull() then
                Evaluate(pMov.fechaPago, vlToken.AsValue().AsText());

        if PagoObj.Get('importePago', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pMov.importePago := vlToken.AsValue().AsDecimal();
    end;

    local procedure fFillConceptosPagados(ConPagObj: JsonObject): Boolean
    var
        rlConceptoPagado: Record "EDUCAMOS ConceptoPagado";
    begin
        if not rlConceptoPagado.Get(vCalendarioId, vRemesaId, vReciboId, vMovimientoId) then begin
            rlConceptoPagado.Init();
            rlConceptoPagado.calendarioEscolarId := vCalendarioId;
            rlConceptoPagado.remesaId := vRemesaId;
            rlConceptoPagado.reciboId := vReciboId;
            rlConceptoPagado.movimientoId := vMovimientoId;

            fFillConceptosPagadosData(ConPagObj, rlConceptoPagado);

            rlConceptoPagado.Insert();
        end else begin
            fFillConceptosPagadosData(ConPagObj, rlConceptoPagado);

            rlConceptoPagado.Modify();
        end;

        exit(true);
    end;

    local procedure fFillConceptosPagadosData(pConPagObj: JsonObject; var pConceptoPagado: Record "EDUCAMOS ConceptoPagado")
    var
        vlToken: JsonToken;
    begin
        if pConPagObj.Get('importePagado', vlToken) then
            if not vlToken.AsValue().IsNull() then
                pConceptoPagado.importePagado := vlToken.AsValue().AsDecimal();

        pConceptoPagado."Importation DateTime" := CurrentDateTime;
        pConceptoPagado.Processed := true;
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
        vFullJsonBody := '';
        vStatusCode := 0;
        vBaseUrl := rEDUSetup."API URL";

        exit(true);
    end;
}