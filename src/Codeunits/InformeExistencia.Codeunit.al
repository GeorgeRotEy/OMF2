codeunit 50024 InformeExistencia
{
    trigger OnRun()
    begin
        IF GUIALLOWED() THEN
            IF NOT CONFIRM('¿Estás seguro que quieres recargar la tabla TablaExistencias?') THEN
                EXIT;
        IF GUIALLOWED() THEN
            WindowsCompany.OPEN('Processing Company......@1@@@@@@@@@@');
        //DELETEALL();
        Companies.RESET();
        Companies.SETFILTER(Name, 'COM*|TIE*|HOS*|UNI*|EDI*|PRO-EXPLOTACIONES*');
        companiesCount := Companies.COUNT;
        IF Companies.FINDSET() THEN
            REPEAT
                CurrCompany += 1;
                IF GUIALLOWED() THEN
                    WindowsCompany.UPDATE(1, (CurrCompany / companiesCount) DIV 1);
                GLEntry.CHANGECOMPANY(Companies.Name);
                GLEntry.RESET();
                GLEntry.SETCURRENTKEY("Entry No.");
                GLEntry.SETFILTER("G/L Account No.", '3000001..3290001');
                GLEntry.SETFILTER("Source Code", '<>ASTOREGUL');
                IF GUIALLOWED() THEN
                    WindowsGLEntry.OPEN('Processing GL Entry......@1@@@@@@@@@@');
                GLEntryCount := GLEntry.COUNT;
                IF GLEntry.FINDSET() THEN
                    REPEAT
                        LastTablaMovContabilidad.RESET();
                        LastTablaMovContabilidad.SETCURRENTKEY(Empresa, "Nº mov");
                        LastTablaMovContabilidad.SETRANGE(Empresa, Companies.Name);
                        LastTablaMovContabilidad.SETRANGE("Nº mov", GLEntry."Entry No.");
                        IF NOT LastTablaMovContabilidad.FINDFIRST() THEN BEGIN
                            CurrGLEntry += 1;
                            IF GUIALLOWED() THEN
                                WindowsGLEntry.UPDATE(1, (CurrGLEntry / GLEntryCount) DIV 1);
                            TablaMovContabilidad.INIT();
                            TablaMovContabilidad.id := 0;
                            TablaMovContabilidad.Empresa := Companies.Name;
                            TablaMovContabilidad."Nº mov" := GLEntry."Entry No.";
                            TablaMovContabilidad."Nombre Cuenta" := GLEntry.Description;
                            TablaMovContabilidad."Nº Cuenta" := GLEntry."G/L Account No.";
                            TablaMovContabilidad."Fecha registro" := GLEntry."Posting Date";
                            TablaMovContabilidad.Importe := GLEntry.Amount;
                            TablaMovContabilidad.INSERT();
                        END;
                    UNTIL GLEntry.NEXT() = 0;
                IF GUIALLOWED() THEN
                    WindowsGLEntry.CLOSE();
            UNTIL Companies.NEXT() = 0;
        IF GUIALLOWED() THEN
            WindowsCompany.CLOSE();
    end;

    var
        TablaMovContabilidad: Record InformeExistencia;
        Companies: Record Company;
        GLEntry: Record "G/L Entry";
        WindowsCompany: Dialog;
        WindowsGLEntry: Dialog;
        companiesCount: Integer;
        CurrCompany: Integer;
        GLEntryCount: Integer;
        CurrGLEntry: Integer;
        LastTablaMovContabilidad: Record InformeExistencia;
}
