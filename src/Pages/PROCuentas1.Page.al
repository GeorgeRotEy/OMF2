page 50137 "PRO-Cuentas1"
{
    PageType = List;
    Caption = 'Accounts 1', Comment = 'ESP="Cuentas 1"';
    SourceTable = TablaCuentas;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.id)
                {
                }
                field("Nº Cuenta"; Rec."Nº Cuenta")
                {
                }
                field(Descripcion; Rec.Descripcion)
                {
                }
                field(Empresa; Rec.Empresa)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SETFILTER(Empresa, 'PRO*|COL*');
        Rec.SETFILTER("Nº Cuenta", '20*|21*|23*|6*|7*|5505007|5530001');

        /*DELETEALL();
        id := 0; // Inicializar el contador de ID
        Companies.RESET();
        Companies.SETFILTER(Name, 'PRO*|COL*');
        IF Companies.FINDSET() THEN
          REPEAT
          rGLBudgetName.CHANGECOMPANY(Companies.Name);
          rGLBudgetName.RESET();
          rGLBudgetName.SETRANGE("Power BI", TRUE);
           IF rGLBudgetName.FINDSET() THEN
            REPEAT
              GLAccount.CHANGECOMPANY(Companies.Name);
              GLAccount.RESET();
              GLAccount.SETFILTER("No.", '20*|21*|23*|6*|7*|5505007|5530001');
              GLAccount.SETRANGE("Budget Filter", rGLBudgetName.Name);
              IF GLAccount.FINDSET() THEN
                REPEAT
                    INIT;
                    id := id + 1;
                    "Nº Cuenta" := GLAccount."No.";
                    Descripcion := GLAccount.Name;
                    Empresa := Companies.Name;
                    INSERT();
                UNTIL GLAccount.NEXT() = 0
             UNTIL rGLBudgetName.NEXT=0;
          UNTIL Companies.NEXT() = 0;
          */
    end;
}
