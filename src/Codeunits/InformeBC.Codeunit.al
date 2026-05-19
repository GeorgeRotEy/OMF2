codeunit 50027 InformeBC
{
    trigger OnRun()
    begin
        IF GUIALLOWED() THEN
            IF NOT CONFIRM('¿Estás seguro que quieres recargar la tabla InformeBC?') THEN
                EXIT;
        IF GUIALLOWED() THEN
            WindowsCompany.OPEN('Processing Company......@1@@@@@@@@@@');
        InformeBC.DELETEALL();
        Companies.RESET();
        Companies.SETFILTER(Name, 'COM*|TIE*|HOS*|UNI*|EDI*|COL*|FRA*|PRO*');
        companiesCount := Companies.COUNT;
        IF Companies.FINDSET() THEN
            REPEAT
                CurrCompany += 1;
                IF GUIALLOWED() THEN
                    WindowsCompany.UPDATE(1, (CurrCompany / companiesCount) DIV 1);
                GLEntry.CHANGECOMPANY(Companies.Name);
                Bank.CHANGECOMPANY(Companies.Name);
                GLEntry.RESET();
                GLEntry.SETCURRENTKEY("Entry No.");
                //GLEntry.SETFILTER("Posting Date", '%1..%2', DMY2DATE(1, 1, 2023), DMY2DATE(30, 6, 2023));
                //GLEntry.SETFILTER("Posting Date", '>%1', DMY2DATE(1, 1, 2023));
                GLEntry.SETFILTER("G/L Account No.", '5720001|5700001');
                GLEntry.SETFILTER("Source Code", '<>ASTOREGUL');
                IF GUIALLOWED() THEN
                    WindowsGLEntry.OPEN('Processing GL Entry......@1@@@@@@@@@@');
                GLEntryCount := GLEntry.COUNT;
                IF GLEntry.FINDSET() THEN
                    REPEAT
                        //LastInformeBC.RESET();
                        //LastInformeBC.SETCURRENTKEY(Empresa,"Nº mov");
                        //LastInformeBC.SETRANGE(Empresa,Companies.Name);
                        //LastInformeBC.SETRANGE("Nº mov",GLEntry."Entry No.");
                        //IF NOT LastInformeBC.FINDFIRST() THEN BEGIN
                        CurrGLEntry += 1;
                        IF GUIALLOWED() THEN
                            WindowsGLEntry.UPDATE(1, (CurrGLEntry / GLEntryCount) DIV 1);
                        Bank.RESET();
                        IF Bank.GET(GLEntry."Source No.") THEN
                            IF NOT Bank.Blocked THEN BEGIN
                                InformeBC.INIT();
                                InformeBC.id := 0;
                                InformeBC.Empresa := Companies.Name;
                                InformeBC."Nombre Cuenta" := GLEntry.Description;
                                InformeBC."Nº Cuenta" := GLEntry."G/L Account No.";
                                InformeBC."Fecha registro" := GLEntry."Posting Date";
                                InformeBC.Importe := GLEntry.Amount;
                                InformeBC."Source Type" := GLEntry."Source Type";
                                InformeBC."Source Description" := GLEntry."Source Description";
                                InformeBC."Source No." := GLEntry."Source No.";
                                InformeBC."Main Bank" := Bank."Main Bank";
                                InformeBC.INSERT();
                            END;
                    //END;
                    UNTIL GLEntry.NEXT() = 0;
                IF GUIALLOWED() THEN
                    WindowsGLEntry.CLOSE();
            UNTIL Companies.NEXT() = 0;
        IF GUIALLOWED() THEN
            WindowsCompany.CLOSE();
    end;

    var
        InformeBC: Record InformeBC;
        Companies: Record Company;
        GLEntry: Record "G/L Entry";
        Bank: Record "Bank Account";
        WindowsCompany: Dialog;
        WindowsGLEntry: Dialog;
        companiesCount: Integer;
        CurrCompany: Integer;
        GLEntryCount: Integer;
        CurrGLEntry: Integer;
}
