codeunit 50020 "Process Load GL Entry PBI Cuen"
{
    trigger OnRun()
    begin
        IF GUIALLOWED() THEN
            IF NOT CONFIRM('¿Estás seguro que quieres recargar la tabla Calcular?') THEN
                EXIT;
        IF GUIALLOWED() THEN
            WindowsCompany.OPEN('Processing Company......@1@@@@@@@@@@');
        TablaCalcular.id := 0;
        TablaCalcular.DELETEALL();
        Companies.RESET();
        Companies.SETFILTER(Name, 'COM*|TIE*|HOS*|UNI*|EDI*|COL*|FRA*|PRO*');
        companiesCount := Companies.COUNT;
        IF Companies.FINDSET() THEN
            REPEAT
                CurrCompany += 1;
                IF GUIALLOWED() THEN
                    WindowsCompany.UPDATE(1, (CurrCompany / companiesCount) DIV 1);

                rGLBudgetName.CHANGECOMPANY(Companies.Name);
                rGLBudgetName.RESET();

                rGLBudgetName.SETCURRENTKEY(Name);
                rGLBudgetName.SETRANGE("Power BI", TRUE);
                IF rGLBudgetName.FINDSET() THEN
                    REPEAT
                        GLAccount.RESET();
                        //GLAccount.SETFILTER("No.", '20*|21*|23*|6*|7*|5505007|5530001');
                        GLAccount.SETFILTER("No.", '20*|21*|23*|6*|7*|5505007');
                        IF GUIALLOWED() THEN
                            WindowsGLEntry.OPEN('Processing GL Entry......@1@@@@@@@@@@');
                        GLEntryCount := GLAccount.COUNT;
                        IF GLAccount.FINDSET() THEN
                            REPEAT
                            BEGIN
                                CurrGLEntry += 1;
                                IF GUIALLOWED() THEN
                                    WindowsGLEntry.UPDATE(1, (CurrGLEntry / GLEntryCount) DIV 1);
                                TablaCalcular.INIT();
                                TablaCalcular.id += 1;
                                TablaCalcular.Empresa := Companies.Name;
                                TablaCalcular."Nº Cuenta" := GLAccount."No.";
                                TablaCalcular.Descripcion := GLAccount.Name;
                                TablaCalcular.Año := rGLBudgetName.Name;

                                TablaCalcular.INSERT();
                            END
                            UNTIL GLAccount.NEXT() = 0;
                        IF GUIALLOWED() THEN
                            WindowsGLEntry.CLOSE();
                    UNTIL rGLBudgetName.NEXT() = 0;
            UNTIL Companies.NEXT() = 0;
        IF GUIALLOWED() THEN
            WindowsCompany.CLOSE();
    end;

    var
        TablaCalcular: Record "Cuentas Empresa";
        Companies: Record Company;
        GLAccount: Record "G/L Account";
        rGLBudgetName: Record "G/L Budget Name";
        WindowsGLEntry: Dialog;
        companiesCount: Integer;
        CurrCompany: Integer;
        GLEntryCount: Integer;
        CurrGLEntry: Integer;
        WindowsCompany: Dialog;
}
