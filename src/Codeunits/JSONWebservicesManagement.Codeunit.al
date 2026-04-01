codeunit 50006 "JSON Webservices Management"
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
        vBaseUrl: Text; //Inicializar con rEDUSetup."API URL"
        Text001: Label 'Datos importados correctamente. Por favor, revise el LOG';
        Error001: Label 'Fail to access API. Code %1 - %2', Comment = 'ESP="Error al acceder a la API. Código %1 - %2"';
        Error002: Label 'No response from api', Comment = 'ESP="Sin respuesta de la API"';
        Error003: Label 'No se obtuvieron datos para importar';
        Error004: Label 'No se pudo obtener token para hacer login';
        Error006: Label 'No se pudo rellenar la tabla Input Data';
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

        if not TryGetActiveCalendar() then begin
            cuInterface.fSetLogWithResponse(3, 'No se pudo determinar calendario activo: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        Ok := CallGETWithContinuationToken(BuildRemesasUrl());
        if not Ok then begin
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
            cuInterface.fSetLogWithResponse(3, 'No se pudo determinar calendario activo: ' + vResult, CompanyName, 0, cTempBlob);
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
        NewRefreshToken: Text;
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

        // HEADER Authorization: Basic base64(client_id:client_secret)
        vRequest.GetHeaders(ReqHeaders);
        ReqHeaders.Clear();

        BasicValue := Base64.ToBase64(StrSubstNo('%1:%2', rEDUSetup."Client Id", rEDUSetup.GetPassword()));
        ReqHeaders.Add('Authorization', StrSubstNo('Basic %1', BasicValue));
        ReqHeaders.Add('Accept', 'application/json');

        // BODY x-www-form-urlencoded: grant_type + refresh_token
        Body := 'grant_type=authorization_code' +
                '&content-type=application/x-www-form-urlencoded' +
                '&code=' + UrlEncode(rEDUSetup."Auth Grant") +
                '&redirect_uri=' + UrlEncode(rEDUSetup."Redirect URI") +
                '&client_id=' + UrlEncode(rEDUSetup."Client Id") +
                '&client_secret=' + UrlEncode(rEDUSetup.GetPassword());

        vContent.WriteFrom(Body);
        vContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        // ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        vRequest.Content := vContent;

        if not vClient.Send(vRequest, vResponse) then begin
            vResult := Error002;
            exit(false);
        end;

        vStatusCode := vResponse.HttpStatusCode();
        vResponse.Content.ReadAs(RespTxt);

        // Guardar respuesta token para LOG "Open"
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
            Aggregated.AddText('\');

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
                    vlStartDate := Token.AsValue().AsText();

                if ItemObj.Get('fechaFin', Token) then
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
        HasQuery: Boolean;
    begin
        Url := vBaseUrl + '/' + Format(vCalendarioId) + '/remesas/' +
        pRemesaID + '/recibos';

        exit(Url);
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
                rlRemesa.Insert();

                if not fTratarRecibosRemesa(rlRemesa.remesaId) then begin
                    vResult := 'No se han podido tratar los recibos de las remesas.';
                    exit(false);
                end;
            end else begin
                if ItemObj.Get('descripcion', vlToken) then
                    rlRemesa.descripcion := vlToken.AsValue().AsText();

                if ItemObj.Get('reducido', vlToken) then
                    rlRemesa.reducido := vlToken.AsValue().AsText();

                if ItemObj.Get('periodoFacturacionId', vlToken) then
                    rlRemesa.periodoFacturacionId := vlToken.AsValue().AsText();

                if ItemObj.Get('nombrePeriodo', vlToken) then
                    rlRemesa.nombrePeriodo := vlToken.AsValue().AsText();

                if ItemObj.Get('pagadorComun', vlToken) then
                    rlRemesa.pagadorComun := vlToken.AsValue().AsBoolean();

                if ItemObj.Get('fechaCreacion', vlToken) then
                    Evaluate(rlRemesa.fechaCreacion, vlToken.AsValue().AsText());

                if ItemObj.Get('fechaEmision', vlToken) then
                    Evaluate(rlRemesa.fechaEmision, vlToken.AsValue().AsText());

                if ItemObj.Get('importe', vlToken) then
                    Evaluate(rlRemesa.importe, vlToken.AsValue().AsText());

                if ItemObj.Get('ordenanteCuentaBancariaId', vlToken) then
                    rlRemesa.ordenanteCuentaBancariaId := vlToken.AsValue().AsText();

                if ItemObj.Get('ordenante', vlToken) then
                    rlRemesa.ordenante := vlToken.AsValue().AsText();

                if ItemObj.Get('presentador', vlToken) then
                    rlRemesa.presentador := vlToken.AsValue().AsText();

                if ItemObj.Get('datosBancarios', vlToken) then
                    rlRemesa.datosBancarios := vlToken.AsValue().AsText();

                if ItemObj.Get('fechaCargo', vlToken) then
                    Evaluate(rlRemesa.fechaCargo, vlToken.AsValue().AsText());

                if ItemObj.Get('cuadernoBancario', vlToken) then
                    rlRemesa.cuadernoBancario := vlToken.AsValue().AsText();

                if ItemObj.Get('esquemaSEPA', vlToken) then
                    rlRemesa.esquemaSEPA := vlToken.AsValue().AsText();

                if ItemObj.Get('textoReciboRecargo', vlToken) then
                    rlRemesa.textoReciboRecargo := vlToken.AsValue().AsText();

                if ItemObj.Get('importeRecargo', vlToken) then
                    Evaluate(rlRemesa.importeRecargo, vlToken.AsValue().AsText());

                if ItemObj.Get('numeroRecibosBanco', vlToken) then
                    rlRemesa.numeroRecibosBanco := vlToken.AsValue().AsInteger();

                if ItemObj.Get('importeTotalBanco', vlToken) then
                    Evaluate(rlRemesa.importeTotalBanco, vlToken.AsValue().AsText());

                if ItemObj.Get('numeroRecibosVentanilla', vlToken) then
                    rlRemesa.numeroRecibosVentanilla := vlToken.AsValue().AsInteger();

                if ItemObj.Get('importeTotalVentanilla', vlToken) then
                    Evaluate(rlRemesa.importeTotalVentanilla, vlToken.AsValue().AsText());

                if ItemObj.Get('esRemitida', vlToken) then
                    rlRemesa.esRemitida := vlToken.AsValue().AsBoolean();

                rlRemesa."Importation DateTime" := CurrentDateTime;
                rlRemesa.Processed := true;

                rlRemesa.Modify();
            end;
        end;
    end;

    local procedure fTratarRecibosRemesa(pRemesaID: Text): Boolean
    var
        rlRecibosRemesa: Record "EDUCAMOS RecibosRemesa";
        vlToken: JsonToken;
        vlItemObj: JsonObject;
    begin
        //Por cada remesa, insertar los recibos.
        //Llamar a CallGETWithContinuationToken
        Ok := CallGETWithContinuationToken(BuildRecibosRemesaUrl(pRemesaID));
        if not Ok then begin
            cuInterface.fSetLogWithResponse(3, 'Error obteniendo recibos: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        //Crear y llamar TryGetRecibosRemesa y fFillRecibosRemesas
        if not TryGetRecibosRemesa(pRemesaID) then begin
            cuInterface.fSetLogWithResponse(3, 'No se pudieron traer los recibos de remesas: ' + vResult, CompanyName, 0, cTempBlob);
            Commit();
            exit(false);
        end;

        if vlItemObj.Get('remesaId', vlToken) then begin
            rlRecibosRemesa.Reset();
            rlRecibosRemesa.SetRange(remesaId, vlToken.AsValue().AsText());
            if not rlRecibosRemesa.FindFirst() then begin
                rlRecibosRemesa.Init();
                rlRecibosRemesa.remesaId := vlToken.AsValue().AsText();
                rlRecibosRemesa.Insert();

            end else begin
                rlRecibosRemesa."Importation DateTime" := CurrentDateTime;
                rlRecibosRemesa.Processed := true;

                rlRecibosRemesa.Modify();
            end;
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
                rlRecibosRemesa.Insert();
            end else begin
                if ItemObj.Get('medioPago', vlToken) then
                    rlRecibosRemesa.medioPago := vlToken.AsValue().AsText();

                if ItemObj.Get('pagadorMedioPagoId', vlToken) then
                    Evaluate(rlRecibosRemesa.pagadorMedioPagoId, vlToken.AsValue().AsText());

                if ItemObj.Get('prefijo', vlToken) then
                    rlRecibosRemesa.prefijo := vlToken.AsValue().AsText();

                if ItemObj.Get('numero', vlToken) then
                    rlRecibosRemesa.numero := vlToken.AsValue().AsInteger();

                if ItemObj.Get('sufijoAnulacion', vlToken) then
                    rlRecibosRemesa.sufijoAnulacion := vlToken.AsValue().AsText();

                if ItemObj.Get('reciboConceptoId', vlToken) then
                    Evaluate(rlRecibosRemesa.reciboConceptoId, vlToken.AsValue().AsText());

                if ItemObj.Get('importeConcepto', vlToken) then
                    Evaluate(rlRecibosRemesa.importeConcepto, vlToken.AsValue().AsText());

                if ItemObj.Get('importePagado', vlToken) then
                    Evaluate(rlRecibosRemesa.importePagado, vlToken.AsValue().AsText());

                if ItemObj.Get('fechaPago', vlToken) then
                    Evaluate(rlRecibosRemesa.fechaPago, vlToken.AsValue().AsText());

                if ItemObj.Get('conceptoId', vlToken) then
                    Evaluate(rlRecibosRemesa.conceptoId, vlToken.AsValue().AsText());

                if ItemObj.Get('texto', vlToken) then
                    rlRecibosRemesa.texto := vlToken.AsValue().AsText();

                if ItemObj.Get('personaId', vlToken) then
                    Evaluate(rlRecibosRemesa.personaId, vlToken.AsValue().AsText());

                if ItemObj.Get('estado', vlToken) then
                    rlRecibosRemesa.estado := vlToken.AsValue().AsText();

                if ItemObj.Get('descuentoId', vlToken) then
                    Evaluate(rlRecibosRemesa.descuentoId, vlToken.AsValue().AsText());

                if ItemObj.Get('nombreDescuento', vlToken) then
                    rlRecibosRemesa.nombreDescuento := vlToken.AsValue().AsText();

                if ItemObj.Get('importe', vlToken) then
                    Evaluate(rlRecibosRemesa.importe, vlToken.AsValue().AsText());

                if ItemObj.Get('porcentaje', vlToken) then
                    Evaluate(rlRecibosRemesa.porcentaje, vlToken.AsValue().AsText());

                if ItemObj.Get('nombreResponsable', vlToken) then
                    rlRecibosRemesa.nombreResponsable := vlToken.AsValue().AsText();

                if ItemObj.Get('apellido1Responsable', vlToken) then
                    rlRecibosRemesa.apellido1Responsable := vlToken.AsValue().AsText();

                if ItemObj.Get('apellido2Responsable', vlToken) then
                    rlRecibosRemesa.apellido2Responsable := vlToken.AsValue().AsText();

                if ItemObj.Get('fechaMovimiento', vlToken) then
                    Evaluate(rlRecibosRemesa.fechaMovimiento, vlToken.AsValue().AsText());

                if ItemObj.Get('fechaValor', vlToken) then
                    Evaluate(rlRecibosRemesa.fechaValor, vlToken.AsValue().AsText());

                if ItemObj.Get('estadoRecibo', vlToken) then
                    rlRecibosRemesa.estadoRecibo := vlToken.AsValue().AsText();

                if ItemObj.Get('motivoDevolucion', vlToken) then
                    rlRecibosRemesa.motivoDevolucion := vlToken.AsValue().AsText();

                if ItemObj.Get('comentario', vlToken) then
                    rlRecibosRemesa.comentario := vlToken.AsValue().AsText();

                if ItemObj.Get('domiciliado', vlToken) then
                    rlRecibosRemesa.domiciliado := vlToken.AsValue().AsBoolean();

                if ItemObj.Get('importePago', vlToken) then
                    Evaluate(rlRecibosRemesa.pago_importePago, vlToken.AsValue().AsText());

                if ItemObj.Get('reciboConceptoId', vlToken) then
                    Evaluate(rlRecibosRemesa.pago_reciboConceptoId, vlToken.AsValue().AsText());

                if ItemObj.Get('importePagado', vlToken) then
                    Evaluate(rlRecibosRemesa.pago_importePagado, vlToken.AsValue().AsText());

                rlRecibosRemesa."Importation DateTime" := CurrentDateTime;
                rlRecibosRemesa.Processed := true;

                rlRecibosRemesa.Modify();
            end;
        end;
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

        exit(true);
    end;
}