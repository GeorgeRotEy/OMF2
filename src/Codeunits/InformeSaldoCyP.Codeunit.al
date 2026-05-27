codeunit 50026 InformeSaldoCyP
{
    trigger OnRun()
    begin
        IF GUIALLOWED() THEN
            IF NOT CONFIRM('¿Estás seguro que quieres recargar la tabla TablaInformeSaldoCyP?') THEN
                EXIT;
        IF GUIALLOWED() THEN
            WindowsCompany.OPEN('Processing Company......@1@@@@@@@@@@');
        TablaInformeSaldoCyP.DELETEALL();
        TablaInformeSaldoCyP.RESET();
        Companies.RESET();
        Companies.SETFILTER(Name, 'COM*|TIE*|HOS*|UNI*|EDI*|COL*|FRA*|PRO*');
        companiesCount := Companies.COUNT;
        IF Companies.FINDSET() THEN
            REPEAT
                CurrCompany += 1;
                IF GUIALLOWED() THEN
                    WindowsCompany.UPDATE(1, (CurrCompany / companiesCount) DIV 1);
                GLEntry.CHANGECOMPANY(Companies.Name);
                vCustLedgerEntry.CHANGECOMPANY(Companies.Name);
                GLEntry.RESET();
                GLEntry.SETCURRENTKEY("Entry No.");
                GLEntry.SETFILTER("G/L Account No.", '4100001|4300001|4000001');
                GLEntry.SETFILTER("Source Code", '<>ASTOREGUL');
                IF GUIALLOWED() THEN
                    WindowsGLEntry.OPEN('Processing GL Entry......@1@@@@@@@@@@');
                GLEntryCount := GLEntry.COUNT;
                IF GLEntry.FINDSET() THEN
                    REPEAT
                        CurrGLEntry += 1;
                        IF GUIALLOWED() THEN
                            WindowsGLEntry.UPDATE(1, (CurrGLEntry / GLEntryCount) DIV 1);
                        vCustLedgerEntry.RESET();
                        IF (GLEntry."Source Type" = GLEntry."Source Type"::Customer) AND (NOT vCustLedgerEntry.GET(GLEntry."Entry No.")) THEN BEGIN
                        END
                        ELSE BEGIN
                            TablaInformeSaldoCyP.INIT();
                            TablaInformeSaldoCyP.id := 0;
                            TablaInformeSaldoCyP.Empresa := Companies.Name;
                            TablaInformeSaldoCyP."Nombre Cuenta" := GLEntry.Description;
                            TablaInformeSaldoCyP."Nº Cuenta" := GLEntry."G/L Account No.";
                            TablaInformeSaldoCyP."Fecha registro" := GLEntry."Posting Date";
                            TablaInformeSaldoCyP.Importe := GLEntry.Amount;
                            TablaInformeSaldoCyP."Source Type" := GLEntry."Source Type";
                            TablaInformeSaldoCyP."Source Description" := GLEntry."Source Description";
                            TablaInformeSaldoCyP."Source No." := GLEntry."Source No.";
                            TablaInformeSaldoCyP."Document Type" := FORMAT(GLEntry."Document Type");
                            TablaInformeSaldoCyP.INSERT();
                        END;
                    UNTIL GLEntry.NEXT() = 0;
                IF GUIALLOWED() THEN
                    WindowsGLEntry.CLOSE();
            UNTIL Companies.NEXT() = 0;
        IF GUIALLOWED() THEN
            WindowsCompany.CLOSE();
    end;

    var
        TablaInformeSaldoCyP: Record InformeSaldoCyP;
        Companies: Record Company;
        GLEntry: Record "G/L Entry";
        WindowsCompany: Dialog;
        WindowsGLEntry: Dialog;
        companiesCount: Integer;
        CurrCompany: Integer;
        GLEntryCount: Integer;
        CurrGLEntry: Integer;
        vCustLedgerEntry: Record "Cust. Ledger Entry";
}
