codeunit 50018 "Process Load GL Entry PBI"
{
    trigger OnRun()
    begin
        IF GUIALLOWED() THEN
            IF NOT CONFIRM('¿Estás seguro que quieres recargar la tabla TablaMovContabilidad?') THEN
                EXIT;
        IF GUIALLOWED() THEN
            WindowsCompany.OPEN('Processing Company......@1@@@@@@@@@@');
        //id := 0;
        Companies.RESET();
        Companies.SETFILTER(Name, 'COM*|TIE*|HOS*|UNI*|EDI*|COL*|FRA*|PRO*');
        companiesCount := Companies.COUNT;
        IF Companies.FINDSET() THEN
            REPEAT
                CurrCompany += 1;
                IF GUIALLOWED() THEN
                    WindowsCompany.UPDATE(1, (CurrCompany / companiesCount) DIV 1);
                GLEntry.CHANGECOMPANY(Companies.Name);
                DimensionValue.CHANGECOMPANY(Companies.Name);
                GLEntry.RESET();
                GLEntry.SETCURRENTKEY("Entry No.");
                //GLEntry.SETFILTER("G/L Account No.", '20*|21*|23*|6*|7*|5505007|5530001');
                GLEntry.SETFILTER("G/L Account No.", '20*|21*|23*|6*|7*|5505007');
                GLEntry.SETFILTER("Source Code", '<>ASTOREGUL');

                LastTablaMovContabilidad.RESET();
                LastTablaMovContabilidad.SETRANGE(Empresa, Companies.Name);
                LastTablaMovContabilidad.SETCURRENTKEY("Nº mov");
                LastTablaMovContabilidad.SETASCENDING("Nº mov", TRUE);
                IF LastTablaMovContabilidad.FINDLAST() THEN
                    GLEntry.SETFILTER("Entry No.", '>%1', LastTablaMovContabilidad."Nº mov");

                IF GUIALLOWED() THEN
                    WindowsGLEntry.OPEN('Processing GL Entry......@1@@@@@@@@@@');
                GLEntryCount := GLEntry.COUNT;
                IF GLEntry.FINDSET() THEN
                    REPEAT
                        //LastTablaMovContabilidad.RESET();
                        //LastTablaMovContabilidad.SETCURRENTKEY(Empresa,"Nº mov");
                        //LastTablaMovContabilidad.SETRANGE(Empresa,Companies.Name);
                        //LastTablaMovContabilidad.SETRANGE("Nº mov",GLEntry."Entry No.");
                        //IF NOT LastTablaMovContabilidad.FINDFIRST() THEN BEGIN
                        CurrGLEntry += 1;
                        IF GUIALLOWED() THEN
                            WindowsGLEntry.UPDATE(1, (CurrGLEntry / GLEntryCount) DIV 1);
                        TablaMovContabilidad.INIT();
                        TablaMovContabilidad.id := 0;
                        TablaMovContabilidad.Empresa := Companies.Name;
                        TablaMovContabilidad."Nº mov" := GLEntry."Entry No.";
                        TablaMovContabilidad."Nº Cuenta" := GLEntry."G/L Account No.";
                        TablaMovContabilidad."Fecha registro" := GLEntry."Posting Date";

                        IF TablaMovContabilidad.Empresa = 'PRO-PROVINCIA INMACULADA' THEN BEGIN
                            TablaMovContabilidad."Actividad Codigo" := GLEntry."Global Dimension 2 Code";
                            TablaMovContabilidad."Entidad Codigo" := GLEntry."Global Dimension 1 Code";
                            DimensionValue.RESET();
                            DimensionValue.SETRANGE("Dimension Code", 'ENTIDAD');
                            DimensionValue.SETRANGE(Code, GLEntry."Global Dimension 1 Code");
                            IF DimensionValue.FINDFIRST() THEN
                                TablaMovContabilidad."Entidad Nombre" := DimensionValue.Name;
                        END
                        ELSE BEGIN
                            TablaMovContabilidad."Actividad Codigo" := GLEntry."Global Dimension 1 Code";
                            TablaMovContabilidad."Entidad Codigo" := GLEntry."Global Dimension 2 Code";
                            DimensionValue.RESET();
                            DimensionValue.SETRANGE("Dimension Code", 'ENTIDAD');
                            DimensionValue.SETRANGE(Code, GLEntry."Global Dimension 2 Code");
                            IF DimensionValue.FINDFIRST() THEN
                                TablaMovContabilidad."Entidad Nombre" := DimensionValue.Name;
                        END;

                        //"Actividad Codigo":= GLEntry."Global Dimension 1 Code";
                        //"Entidad Codigo":= GLEntry."Global Dimension 2 Code";

                        TablaMovContabilidad.Descripcion := GLEntry.Description;
                        TablaMovContabilidad."Source Type" := GLEntry."Source Type";
                        TablaMovContabilidad."Source Description" := GLEntry."Source Description";
                        TablaMovContabilidad."Source No." := GLEntry."Source No.";
                        //IF GLEntry."G/L Account Name"= '' THEN BEGIN
                        TablaMovContabilidad."Account Name" := GLEntry."G/L Account Name";
                        //END;
                        IF (COPYSTR(GLEntry."G/L Account No.", 1, 1) = '7') OR
                        (COPYSTR(GLEntry."G/L Account No.", 1, 7) = '5505007') THEN
                            TablaMovContabilidad.Importe := -(GLEntry.Amount)
                        ELSE
                            TablaMovContabilidad.Importe := GLEntry.Amount;
                        TablaMovContabilidad.INSERT();
                    //END;
                    UNTIL GLEntry.NEXT() = 0;
                IF GUIALLOWED() THEN
                    WindowsGLEntry.CLOSE();
            UNTIL Companies.NEXT() = 0;
        IF GUIALLOWED() THEN
            WindowsCompany.CLOSE();
    end;

    var
        TablaMovContabilidad: Record TablaMovContabilidad;
        Companies: Record Company;
        GLEntry: Record "G/L Entry";
        WindowsCompany: Dialog;
        WindowsGLEntry: Dialog;
        companiesCount: Integer;
        CurrCompany: Integer;
        GLEntryCount: Integer;
        CurrGLEntry: Integer;
        LastTablaMovContabilidad: Record TablaMovContabilidad;
        DimensionValue: Record "Dimension Value";
}
