codeunit 50025 InformeVentas
{
    trigger OnRun()
    begin
        IF GUIALLOWED() THEN
            IF NOT CONFIRM('¿Estás seguro que quieres recargar la tabla Informe Ventas?') THEN
                EXIT;
        IF GUIALLOWED() THEN
            WindowsCompany.OPEN('Processing Company......@1@@@@@@@@@@');
        InformeVentas.DELETEALL();
        Companies.RESET();
        Companies.SETFILTER(Name, 'COM*|TIE*|HOS*|UNI*|EDI*|COL*|FRA*|PRO*');
        companiesCount := Companies.COUNT;
        IF Companies.FINDSET() THEN
            REPEAT
                CurrCompany += 1;
                IF GUIALLOWED() THEN
                    WindowsCompany.UPDATE(1, (CurrCompany / companiesCount) DIV 1);
                GLEntry.CHANGECOMPANY(Companies.Name);
                GLEntry.RESET();
                GLEntry.SETCURRENTKEY("Entry No.");
                GLEntry.SETFILTER("G/L Account No.", '6*|7*');
                GLEntry.SETFILTER("Source Code", '<>ASTOREGUL');
                IF GUIALLOWED() THEN
                    WindowsGLEntry.OPEN('Processing GL Entry......@1@@@@@@@@@@');
                GLEntryCount := GLEntry.COUNT;
                IF GLEntry.FINDSET() THEN
                    REPEAT
                        //LastInformeVentas.RESET();
                        //LastInformeVentas.SETCURRENTKEY(Empresa,"Nº mov");
                        //LastInformeVentas.SETRANGE(Empresa,Companies.Name);
                        //LastInformeVentas.SETRANGE("Nº mov",GLEntry."Entry No.");
                        //IF NOT LastInformeVentas.FINDFIRST() THEN BEGIN
                        CurrGLEntry += 1;
                        IF GUIALLOWED() THEN
                            WindowsGLEntry.UPDATE(1, (CurrGLEntry / GLEntryCount) DIV 1);
                        InformeVentas.INIT();
                        InformeVentas.id := 0;
                        InformeVentas.Empresa := Companies.Name;
                        InformeVentas."Nº mov" := GLEntry."Entry No.";
                        InformeVentas."Nº Cuenta" := GLEntry."G/L Account No.";
                        InformeVentas."Fecha registro" := GLEntry."Posting Date";
                        InformeVentas.Descripcion := GLEntry.Description;
                        //IF GLEntry."G/L Account Name"= '' THEN BEGIN
                        InformeVentas."Account Name" := GLEntry."G/L Account Name";
                        //END;
                        IF (COPYSTR(GLEntry."G/L Account No.", 1, 1) = '7') OR
                        (COPYSTR(GLEntry."G/L Account No.", 1, 7) = '5505007') THEN
                            InformeVentas.Importe := -(GLEntry.Amount)
                        ELSE
                            InformeVentas.Importe := GLEntry.Amount;
                        InformeVentas.INSERT();
                    //END;
                    UNTIL GLEntry.NEXT() = 0;
                IF GUIALLOWED() THEN
                    WindowsGLEntry.CLOSE();
            UNTIL Companies.NEXT() = 0;
        IF GUIALLOWED() THEN
            WindowsCompany.CLOSE();
    end;

    var
        InformeVentas: Record InformeVentas;
        Companies: Record Company;
        GLEntry: Record "G/L Entry";
        WindowsCompany: Dialog;
        WindowsGLEntry: Dialog;
        companiesCount: Integer;
        CurrCompany: Integer;
        GLEntryCount: Integer;
        CurrGLEntry: Integer;
}
