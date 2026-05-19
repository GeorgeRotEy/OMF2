codeunit 50022 "Process Load GL Entry PBI Calc"
{
    trigger OnRun()
    begin

        IF GUIALLOWED() THEN
            WindowsCompany.OPEN('Processing Company......@1@@@@@@@@@@');
        TablaCuentas.DELETEALL();
        TablaCuentas.id := 0;
        Companies.RESET();
        Companies.SETFILTER(Name, 'COM*|TIE*|HOS*|UNI*|EDI*|COL*|FRA*|PRO*');
        companiesCount := Companies.COUNT;
        IF Companies.FINDSET() THEN
            REPEAT
                CurrCompany += 1;
                IF GUIALLOWED() THEN
                    WindowsCompany.UPDATE(1, (CurrCompany / companiesCount) DIV 1);
                GLAccount.CHANGECOMPANY(Companies.Name);
                GLAccount.RESET();
                //GLAccount.SETFILTER("No.", '20*|21*|23*|6*|7*|5505007|5530001');
                GLAccount.SETFILTER("No.", '20*|21*|23*|6*|7*|5505007');
                IF GUIALLOWED() THEN
                    WindowsGLEntry.OPEN('Processing GL Entry......@1@@@@@@@@@@');
                GLEntryCount := GLAccount.COUNT;
                IF GLAccount.FINDSET() THEN
                    REPEAT
                        TablaCuentas.INIT();
                        TablaCuentas.id := TablaCuentas.id + 1;
                        TablaCuentas.Empresa := Companies.Name;
                        TablaCuentas."Nº Cuenta" := GLAccount."No.";
                        TablaCuentas.Descripcion := GLAccount.Name;
                        TablaCuentas.INSERT();
                    UNTIL GLAccount.NEXT() = 0;
                IF GUIALLOWED() THEN
                    WindowsGLEntry.CLOSE();
            UNTIL Companies.NEXT() = 0;
        IF GUIALLOWED() THEN
            WindowsCompany.CLOSE();
    end;

    var
        TablaCuentas: Record TablaCuentas;
        Companies: Record Company;
        GLAccount: Record "G/L Account";
        WindowsGLEntry: Dialog;
        companiesCount: Integer;
        CurrCompany: Integer;
        GLEntryCount: Integer;
        WindowsCompany: Dialog;
}
