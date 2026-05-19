codeunit 50028 InformesBalance
{
    trigger OnRun()
    begin
        IF GUIALLOWED() THEN
            IF NOT CONFIRM('¿Estás seguro que quieres recargar la tabla Informe Balance?') THEN
                EXIT;
        IF GUIALLOWED() THEN
            WindowsCompany.OPEN('Processing Company......@1@@@@@@@@@@');
        //DELETEALL();
        Companies.RESET();
        Companies.SETFILTER(Name, 'COM*|TIE*|HOS*|UNI*|EDI*|COL*|FRA*|PRO*|ZC*');
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
                GLEntry.SETFILTER("G/L Account No.", '1*|2*|3*|4*|5*|6*|7*');
                //GLEntry.SETFILTER("Source Code", 'ASTOREGUL');

                //Buscamos en la empresa el último mov introducido
                LastInformeBalance.RESET();
                LastInformeBalance.SETRANGE(Empresa, Companies.Name);
                LastInformeBalance.SETCURRENTKEY("Nº mov");
                LastInformeBalance.SETASCENDING("Nº mov", TRUE);
                IF LastInformeBalance.FINDLAST() THEN
                    GLEntry.SETFILTER("Entry No.", '>%1', LastInformeBalance."Nº mov");

                IF GUIALLOWED() THEN
                    WindowsGLEntry.OPEN('Processing GL Entry......@1@@@@@@@@@@');
                GLEntryCount := GLEntry.COUNT;
                IF GLEntry.FINDSET() THEN
                    REPEAT
                        CurrGLEntry += 1;
                        IF GUIALLOWED() THEN
                            WindowsGLEntry.UPDATE(1, (CurrGLEntry / GLEntryCount) DIV 1);

                        //Comprobamos que no es asiento de regularización

                        //IF (GLEntry."Posting Date" <= DMY2DATE(31,12,DATE2DMY(GLEntry."Posting Date",3))) THEN BEGIN
                        InformeBalance.INIT();
                        InformeBalance.id := 0;
                        InformeBalance.Empresa := Companies.Name;
                        InformeBalance."Business Unit Code" := GLEntry."Business Unit Code";
                        InformeBalance."Nº mov" := GLEntry."Entry No.";
                        InformeBalance."Nº Cuenta" := GLEntry."G/L Account No.";
                        IF COPYSTR(FORMAT(GLEntry."Posting Date"), 1, 1) = 'U' THEN
                            InformeBalance.Astoregul := 'Astoregul';
                        InformeBalance."Fecha registro" := GLEntry."Posting Date";
                        InformeBalance.Descripcion := GLEntry.Description;
                        InformeBalance."Debe Amount" := GLEntry."Debit Amount";
                        InformeBalance."Haber Amount" := GLEntry."Credit Amount";
                        InformeBalance."Account Name" := GLEntry."G/L Account Name";

                        IF InformeBalance.Empresa = 'PRO-PROVINCIA INMACULADA' THEN BEGIN
                            InformeBalance."Actividad Codigo" := GLEntry."Global Dimension 2 Code";
                            InformeBalance."Entidad Codigo" := GLEntry."Global Dimension 1 Code";
                            DimensionValue.RESET();
                            DimensionValue.SETRANGE("Dimension Code", 'ENTIDAD');
                            DimensionValue.SETRANGE(Code, GLEntry."Global Dimension 1 Code");
                            IF DimensionValue.FINDFIRST() THEN
                                InformeBalance."Entidad Nombre" := DimensionValue.Name;
                            DimensionValue.RESET();
                            DimensionValue.SETRANGE("Dimension Code", 'ACTIVIDADES');
                            DimensionValue.SETRANGE(Code, GLEntry."Global Dimension 2 Code");
                            IF DimensionValue.FINDFIRST() THEN
                                InformeBalance."Actividad Nombre" := DimensionValue.Name;
                        END;

                        IF InformeBalance.Empresa = 'PRO-EXPLOTACIONES VARIAS' THEN BEGIN
                            InformeBalance."Actividad Codigo" := GLEntry."Global Dimension 1 Code";
                            InformeBalance."Entidad Codigo" := GLEntry."Global Dimension 2 Code";
                            DimensionValue.RESET();
                            DimensionValue.SETRANGE("Dimension Code", 'ENTIDAD');
                            DimensionValue.SETRANGE(Code, GLEntry."Global Dimension 2 Code");
                            IF DimensionValue.FINDFIRST() THEN
                                InformeBalance."Entidad Nombre" := DimensionValue.Name;
                            DimensionValue.RESET();
                            DimensionValue.SETRANGE("Dimension Code", 'ACTIVIDADES');
                            DimensionValue.SETRANGE(Code, GLEntry."Global Dimension 1 Code");
                            IF DimensionValue.FINDFIRST() THEN
                                InformeBalance."Actividad Nombre" := DimensionValue.Name;
                        END;
                        IF COPYSTR(InformeBalance.Empresa, 1, 4) = 'COL-' THEN BEGIN
                            InformeBalance."Servicio Codigo" := GLEntry."Global Dimension 2 Code";
                            DimensionValue.RESET();
                            DimensionValue.SETRANGE("Dimension Code", 'ACTIVIDAD');
                            DimensionValue.SETRANGE(Code, GLEntry."Global Dimension 2 Code");
                            IF DimensionValue.FINDFIRST() THEN
                                InformeBalance."Servicio Nombre" := DimensionValue.Name;
                        END;

                        InformeBalance.INSERT();

                    //END;
                    UNTIL GLEntry.NEXT() = 0;
                IF GUIALLOWED() THEN
                    WindowsGLEntry.CLOSE();
            UNTIL Companies.NEXT() = 0;
        IF GUIALLOWED() THEN
            WindowsCompany.CLOSE();
    end;

    var
        InformeBalance: Record InformeBalances;
        Companies: Record Company;
        GLEntry: Record "G/L Entry";
        WindowsCompany: Dialog;
        WindowsGLEntry: Dialog;
        companiesCount: Integer;
        CurrCompany: Integer;
        GLEntryCount: Integer;
        CurrGLEntry: Integer;
        LastInformeBalance: Record InformeBalances;
        DimensionValue: Record "Dimension Value";
}
