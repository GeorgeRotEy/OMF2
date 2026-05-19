codeunit 50023 "Mov Presupuestario4"
{
    // En esta codeunit la he creado para pasar los datos de la Page 50149- Movcontabilidad4 al informe Aportación Fondo Comun.

    trigger OnRun()
    begin
        IF GUIALLOWED() THEN
            IF NOT CONFIRM('¿Estás seguro que quieres recargar la tabla TablaMovContabilidad?') THEN
                EXIT;
        IF GUIALLOWED() THEN
            WindowsCompany.OPEN('Processing Company......@1@@@@@@@@@@');
        TablaMovContabilidad.DELETEALL();
        Companies.RESET();
        Companies.SETFILTER(Name, 'PRO-PROVINCIA INMACULADA');
        companiesCount := Companies.COUNT;
        IF Companies.FINDSET() THEN
            REPEAT
                CurrCompany += 1;
                IF GUIALLOWED() THEN
                    WindowsCompany.UPDATE(1, (CurrCompany / companiesCount) DIV 1);
                GLEntry.CHANGECOMPANY(Companies.Name);
                GLEntry.RESET();
                GLEntry.SETCURRENTKEY("Entry No.");
                GLEntry.SETFILTER("G/L Account No.", '5500001');
                GLEntry.SETFILTER("Source Code", '<>ASTOREGUL');
                GLEntry.SETFILTER("Global Dimension 1 Code", '301..398|401..498');
                //GLEntry.SETFILTER("Global Dimension 2 Code", '6310|6320|6330');
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
                            TablaMovContabilidad."Nº Cuenta" := GLEntry."G/L Account No.";
                            TablaMovContabilidad."Fecha registro" := GLEntry."Posting Date";
                            TablaMovContabilidad."Actividad Codigo" := GLEntry."Global Dimension 2 Code";
                            TablaMovContabilidad."Entidad Codigo" := GLEntry."Global Dimension 1 Code";
                            TablaMovContabilidad.Descripcion := GLEntry.Description;
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
        TablaMovContabilidad: Record TablaMovContabilidad4;
        Companies: Record Company;
        GLEntry: Record "G/L Entry";
        WindowsCompany: Dialog;
        WindowsGLEntry: Dialog;
        companiesCount: Integer;
        CurrCompany: Integer;
        GLEntryCount: Integer;
        CurrGLEntry: Integer;
        LastTablaMovContabilidad: Record TablaMovContabilidad4;
}
