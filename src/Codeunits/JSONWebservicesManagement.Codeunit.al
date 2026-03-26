codeunit 50006 "JSON Webservices Management"
{
    trigger OnRun()
    begin
        Code();
    end;

    var
        Text001: Label 'Datos importados correctamente. Por favor, revise el LOG';
        Error001: Label 'Fail to access API. Code %1 - %2', Comment = 'ESP="Error al acceder a la API. Código %1 - %2"';
        Error002: Label 'No response from api', Comment = 'ESP="Sin respuesta de la API"';
        Error003: Label 'No se obtuvieron datos para importar';
        Error004: Label 'No se pudo obtener token para hacer login';
        Error006: Label 'No se pudo rellenar la tabla Input Data';
        InvalidResponseErr: Label 'The response was not valid', Comment = 'ESP="La respuesta no era válida"';
        NonJsonResponseErr: Label 'Respuesta no JSON (revisa "Open" en el LOG)';

        cuInterface: Codeunit "EDUCAMOS Interface";
        rEDUSetup: Record "EDUCAMOS Setup";

        vClient: HttpClient;
        vResponse: HttpResponseMessage;
        vRequest: HttpRequestMessage;
        vHeaders: HttpHeaders;
        vContent: HttpContent;

        vAccessToken: Text;
        TextResult: Text;

    // =========================================================
    // PUBLIC API
    // =========================================================

    /// Importación "base": llama a la WS URL del Setup (por ejemplo /colegio/calendarios)
    procedure Code(): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        FullJson: Text;
        Ok: Boolean;
    begin
        Clear(cuInterface);
        Clear(TempBlob);
        TextResult := '';
        vAccessToken := '';

        if not rEDUSetup.Get() then begin
            cuInterface.fSetLog(3, StrSubstNo('No existe %1', rEDUSetup.TableCaption), CompanyName, 0);
            Commit();
            exit(false);
        end;

        // 1) TOKEN
        Ok := GetAccessToken(vAccessToken, TextResult, TempBlob);
        if not Ok then begin
            cuInterface.fSetLogWithResponse(3, StrSubstNo('%1: %2', Error004, TextResult), CompanyName, 0, TempBlob);
            Commit();
            exit(false);
        end;

        // 2) GET Datos (como en Postman)
        Ok := CallGET(rEDUSetup."API URL", vAccessToken, FullJson, TextResult, TempBlob);
        if not Ok then begin
            cuInterface.fSetLogWithResponse(3, TextResult, CompanyName, 0, TempBlob);
            Commit();
            exit(false);
        end;

        if FullJson = '' then begin
            cuInterface.fSetLogWithResponse(2, Error003, CompanyName, 0, TempBlob);
            Commit();
            exit(false);
        end;

        // 3) Guardar en Input Data
        if not FillInputData(FullJson) then begin
            cuInterface.fSetLog(3, Error006 + ' - ' + GetLastErrorText(), CompanyName, 0);
            Commit();
            exit(false);
        end;

        // 4) LOG OK
        cuInterface.fSetLogWithResponse(1, Text001, CompanyName, 0, TempBlob);
        Commit();

        exit(true);
    end;

    procedure GetAccessToken(var pAccessToken: Text; var pTextResult: Text; var pTempBlob: Codeunit "Temp Blob"): Boolean
    var
        Body: Text;
        RespTxt: Text;
        OutS: OutStream;
        JsonObject: JsonObject;
        Token: JsonToken;
        StatusCode: Integer;
        ContentHeaders: HttpHeaders;
        ReqHeaders: HttpHeaders;
        Base64: Codeunit "Base64 Convert";
        BasicValue: Text;
        NewRefreshToken: Text;
    begin
        if rEDUSetup."Token URL" = '' then begin
            pTextResult := 'Token URL vacío en Setup';
            exit(false);
        end;

        if (rEDUSetup."Client Id" = '') or (rEDUSetup.GetPassword() = '') then begin
            pTextResult := 'Faltan Client Id / Client Secret en Setup';
            exit(false);
        end;

        if rEDUSetup."Redirect URI" = '' then begin
            pTextResult := 'Redirect URI vacío en Setup';
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
            pTextResult := Error002;
            exit(false);
        end;

        StatusCode := vResponse.HttpStatusCode();
        vResponse.Content.ReadAs(RespTxt);

        // Guardar respuesta token para LOG "Open"
        pTempBlob.CreateOutStream(OutS);
        OutS.WriteText(RespTxt);

        if (StatusCode < 200) or (StatusCode > 299) then begin
            pTextResult := StrSubstNo('Fail to access API. Code %1 - %2. Body: %3',
                StatusCode, vResponse.ReasonPhrase(), RespTxt);
            exit(false);
        end;

        if not JsonObject.ReadFrom(RespTxt) then begin
            pTextResult := NonJsonResponseErr;
            exit(false);
        end;

        if not JsonObject.Get('access_token', Token) then begin
            pTextResult := InvalidResponseErr;
            exit(false);
        end;

        pAccessToken := Token.AsValue().AsText();
        if pAccessToken = '' then begin
            pTextResult := InvalidResponseErr;
            exit(false);
        end;

        exit(true);
    end;

    // GET
    local procedure CallGET(pUrl: Text; pAccessToken: Text; var pResponseText: Text; var pTextResult: Text; var pTempBlob: Codeunit "Temp Blob"): Boolean
    var
        StatusCode: Integer;
        TmpTxt: Text;
        OutS: OutStream;
    begin
        pResponseText := '';
        pTextResult := '';

        if pUrl = '' then begin
            pTextResult := 'API URL vacío en Setup';
            exit(false);
        end;

        Clear(vRequest);
        Clear(vResponse);
        Clear(vContent);

        vRequest.SetRequestUri(pUrl);
        vRequest.Method := 'GET';

        vRequest.GetHeaders(vHeaders);
        vHeaders.Clear();

        vHeaders.Add('Authorization', StrSubstNo('Bearer %1', pAccessToken));

        if rEDUSetup.GetSubscriptionKey() <> '' then
            vHeaders.Add('Ocp-Apim-Subscription-Key', rEDUSetup.GetSubscriptionKey());

        if rEDUSetup."API Version" <> '' then
            vHeaders.Add('api-version', rEDUSetup."API Version");

        if not vClient.Send(vRequest, vResponse) then begin
            pTextResult := Error002;
            exit(false);
        end;

        StatusCode := vResponse.HttpStatusCode();
        vResponse.Content.ReadAs(TmpTxt);

        pTempBlob.CreateOutStream(OutS);
        OutS.WriteText(TmpTxt);

        if (StatusCode < 200) or (StatusCode > 299) then begin
            pTextResult := StrSubstNo(Error001, StatusCode, vResponse.ReasonPhrase());
            pTextResult += StrSubstNo('. Body: %1', TmpTxt);
            exit(false);
        end;

        pResponseText := TmpTxt;
        exit(true);
    end;

    local procedure CallGET_WithContinuationToken(pUrl: Text; pAccessToken: Text; pContinuationToken: Text; var pResponseText: Text; var pTextResult: Text; var pTempBlob: Codeunit "Temp Blob"): Boolean
    var
        StatusCode: Integer;
        TmpTxt: Text;
        OutS: OutStream;
    begin
        pResponseText := '';
        pTextResult := '';

        if pUrl = '' then begin
            pTextResult := 'API URL vacío';
            exit(false);
        end;

        Clear(vRequest);
        Clear(vResponse);
        Clear(vContent);

        vRequest.SetRequestUri(pUrl);
        vRequest.Method := 'GET';

        vRequest.GetHeaders(vHeaders);
        vHeaders.Clear();

        vHeaders.Add('Authorization', StrSubstNo('Bearer %1', pAccessToken));

        if rEDUSetup.GetSubscriptionKey() <> '' then
            vHeaders.Add('Ocp-Apim-Subscription-Key', rEDUSetup.GetSubscriptionKey());

        if rEDUSetup."API Version" <> '' then
            vHeaders.Add('api-version', rEDUSetup."API Version");

        if pContinuationToken <> '' then
            vHeaders.Add('continuationToken', pContinuationToken);

        if not vClient.Send(vRequest, vResponse) then begin
            pTextResult := Error002;
            exit(false);
        end;

        StatusCode := vResponse.HttpStatusCode();
        vResponse.Content.ReadAs(TmpTxt);

        pTempBlob.CreateOutStream(OutS);
        OutS.WriteText(TmpTxt);

        if (StatusCode < 200) or (StatusCode > 299) then begin
            pTextResult := StrSubstNo(Error001, StatusCode, vResponse.ReasonPhrase());
            pTextResult += StrSubstNo('. Body: %1', TmpTxt);
            exit(false);
        end;

        pResponseText := TmpTxt;
        exit(true);
    end;

    local procedure CallGET_PagedByContinuationToken(pUrl: Text; pAccessToken: Text; var pFullResponseText: Text; var pTextResult: Text; var pTempBlob: Codeunit "Temp Blob"): Boolean
    var
        ContinuationToken: Text;
        PageTxt: Text;
        Aggregated: BigText;
        OutS: OutStream;
    begin
        pFullResponseText := '';
        pTextResult := '';

        Clear(Aggregated);
        ContinuationToken := '';

        repeat
            if not CallGET_WithContinuationToken(pUrl, pAccessToken, ContinuationToken, PageTxt, pTextResult, pTempBlob) then
                exit(false);

            if PageTxt = '' then begin
                pTextResult := Error003;
                pTempBlob.CreateOutStream(OutS);
                OutS.WriteText(pTextResult);
                exit(false);
            end;

            Aggregated.AddText(PageTxt);
            Aggregated.AddText('\');

            ContinuationToken := ExtractContinuationToken(PageTxt);
        until ContinuationToken = '';

        pFullResponseText := BigTextToText(Aggregated);

        pTempBlob.CreateOutStream(OutS);
        OutS.WriteText(pFullResponseText);

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
        TempBlob: Codeunit "Temp Blob";
        OutS: OutStream;
        InS: InStream;
        ResultTxt: Text;
    begin
        TempBlob.CreateOutStream(OutS);
        pBigText.Write(OutS);

        TempBlob.CreateInStream(InS);
        InS.ReadText(ResultTxt);

        exit(ResultTxt);
    end;

    // CALENDARIO ACTIVO (AUTO)
    local procedure TryGetCalendarioActivo(pCalendariosJson: Text; var pCalendarioId: Guid; var pFechaInicio: Date; var pFechaFin: Date; var pError: Text): Boolean
    var
        Root: JsonObject;
        CalendariosTok: JsonToken;
        CalendariosArr: JsonArray;
        ItemTok: JsonToken;
        ItemObj: JsonObject;
        Token: JsonToken;
        Activo: Boolean;
        IdTxt: Text;
        FechaInicioTxt: Text;
        FechaFinTxt: Text;
        i: Integer;
    begin
        pError := '';
        Clear(pCalendarioId); // <-- en vez de Guid::Empty
        pFechaInicio := 0D;
        pFechaFin := 0D;

        if not Root.ReadFrom(pCalendariosJson) then begin
            pError := NonJsonResponseErr;
            exit(false);
        end;

        if not Root.Get('calendarios', CalendariosTok) then begin
            pError := 'La respuesta no contiene el nodo "calendarios".';
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
                    pError := 'Calendario activo sin "calendarioEscolarId".';
                    exit(false);
                end;

                IdTxt := Token.AsValue().AsText();
                if not Evaluate(pCalendarioId, IdTxt) then begin
                    pError := StrSubstNo('GUID inválido en calendarioEscolarId: %1', IdTxt);
                    exit(false);
                end;

                FechaInicioTxt := '';
                FechaFinTxt := '';

                if ItemObj.Get('fechaInicio', Token) then
                    FechaInicioTxt := Token.AsValue().AsText();

                if ItemObj.Get('fechaFin', Token) then
                    FechaFinTxt := Token.AsValue().AsText();

                if (FechaInicioTxt <> '') and (not Evaluate(pFechaInicio, FechaInicioTxt)) then begin
                    pError := StrSubstNo('FechaInicio inválida: %1', FechaInicioTxt);
                    exit(false);
                end;

                if (FechaFinTxt <> '') and (not Evaluate(pFechaFin, FechaFinTxt)) then begin
                    pError := StrSubstNo('FechaFin inválida: %1', FechaFinTxt);
                    exit(false);
                end;

                if (pFechaInicio = 0D) or (pFechaFin = 0D) then begin
                    pError := 'El calendario activo no trae fechaInicio/fechaFin válidas.';
                    exit(false);
                end;

                exit(true);
            end;
        end;

        pError := 'No existe ningún calendario con "activo"=true.';
        exit(false);
    end;

    // URL BUILDERS
    local procedure BuildFacturasTPVUrl(pCalendarioEscolarId: Guid; pDesde: Date; pHasta: Date): Text
    var
        BaseUrl: Text;
        Url: Text;
        HasQuery: Boolean;
    begin
        BaseUrl := rEDUSetup."API URL"; // debe ser .../colegio/calendarios
        Url := BaseUrl + '/' + Format(pCalendarioEscolarId) + '/facturasTPV';

        HasQuery := false;

        if pDesde <> 0D then begin
            Url += '?fechaEmisionDesde=' + Format(pDesde, 0, '<Year4>-<Month,2>-<Day,2>');
            HasQuery := true;
        end;

        if pHasta <> 0D then begin
            if HasQuery then
                Url += '&'
            else
                Url += '?';
            Url += 'fechaEmisionHasta=' + Format(pHasta, 0, '<Year4>-<Month,2>-<Day,2>');
        end;

        exit(Url);
    end;

    local procedure FillInputData(pWSResult: Text): Boolean
    var
        MyOutStr: OutStream;
        rlInputData: Record "EDUCAMOS Input Data";
        rlInputDataAux: Record "EDUCAMOS Input Data";
        FileContent: BigText;
        NextEntryNo: Integer;
    begin
        NextEntryNo := 1;
        rlInputDataAux.Reset();
        if rlInputDataAux.FindLast() then
            NextEntryNo := rlInputDataAux."Entry No." + 1;

        Clear(FileContent);
        FileContent.AddText(pWSResult);

        rlInputData.Init();
        rlInputData."Entry No." := NextEntryNo;
        rlInputData."Importation DateTime" := CurrentDateTime();

        rlInputData.Content.CreateOutStream(MyOutStr);
        FileContent.Write(MyOutStr);

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

    procedure ImportFacturasTPV(): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        CalendariosJson: Text;
        FacturasJson: Text;
        Ok: Boolean;
        CalendarioId: Guid;
        FechaInicio: Date;
        FechaFin: Date;
        Url: Text;
    begin
        Clear(cuInterface);
        Clear(TempBlob);
        TextResult := '';
        vAccessToken := '';

        if not rEDUSetup.Get() then begin
            cuInterface.fSetLog(3, 'No existe registro en EDUCAMOS Setup', CompanyName, 0);
            Commit();
            exit(false);
        end;

        // 1) TOKEN
        Ok := GetAccessToken(vAccessToken, TextResult, TempBlob);
        if not Ok then begin
            cuInterface.fSetLogWithResponse(3, StrSubstNo('%1: %2', Error004, TextResult), CompanyName, 0, TempBlob);
            Commit();
            exit(false);
        end;

        // 2) GET calendarios (base)
        Ok := CallGET(rEDUSetup."API URL", vAccessToken, CalendariosJson, TextResult, TempBlob);
        if not Ok then begin
            cuInterface.fSetLogWithResponse(3, 'Error obteniendo calendarios: ' + TextResult, CompanyName, 0, TempBlob);
            Commit();
            exit(false);
        end;

        // 3) Parse calendario activo + fechas
        if not TryGetCalendarioActivo(CalendariosJson, CalendarioId, FechaInicio, FechaFin, TextResult) then begin
            cuInterface.fSetLogWithResponse(3, 'No se pudo determinar calendario activo: ' + TextResult, CompanyName, 0, TempBlob);
            Commit();
            exit(false);
        end;

        // 4) URL facturasTPV (fechas auto)
        Url := BuildFacturasTPVUrl(CalendarioId, FechaInicio, FechaFin);

        // 5) GET paginado
        Ok := CallGET_PagedByContinuationToken(Url, vAccessToken, FacturasJson, TextResult, TempBlob);
        if not Ok then begin
            cuInterface.fSetLogWithResponse(3, 'Error obteniendo facturasTPV: ' + TextResult, CompanyName, 0, TempBlob);
            Commit();
            exit(false);
        end;

        if FacturasJson = '' then begin
            cuInterface.fSetLogWithResponse(2, Error003, CompanyName, 0, TempBlob);
            Commit();
            exit(false);
        end;

        // 6) Guardar en Input Data
        if not FillInputData(FacturasJson) then begin
            cuInterface.fSetLog(3, Error006 + ' - ' + GetLastErrorText(), CompanyName, 0);
            Commit();
            exit(false);
        end;

        cuInterface.fSetLogWithResponse(
            1,
            StrSubstNo(
                'FacturasTPV importadas OK. Calendario=%1 | Desde=%2 | Hasta=%3',
                Format(CalendarioId),
                Format(FechaInicio, 0, '<Year4>-<Month,2>-<Day,2>'),
                Format(FechaFin, 0, '<Year4>-<Month,2>-<Day,2>')),
            CompanyName, 0, TempBlob);

        Commit();
        exit(true);
    end;
}