page 50157 CuentasInformeVentas
{
    PageType = List;
    Caption = 'Sales Report Accounts', Comment = 'ESP="Cuentas informe ventas"';
    SourceTable = "Plan Corporativo";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Nivel1; Nivel1)
                {
                }
                field(DescNivel1; DescNivel1)
                {
                }
                field(Nivel2; Nivel2)
                {
                }
                field(DescNivel2; DescNivel2)
                {
                }
                field(Nivel3; Nivel3)
                {
                }
                field(DescNivel3; DescNivel3)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Nivel1 := COPYSTR(Rec."No.", 1, 1);
        PlanCorporativo.RESET();
        IF PlanCorporativo.GET(Nivel1) THEN
            DescNivel1 := PlanCorporativo.Name;

        Nivel2 := COPYSTR(Rec."No.", 1, 2);
        PlanCorporativo.RESET();
        IF PlanCorporativo.GET(Nivel2) THEN
            DescNivel2 := PlanCorporativo.Name;

        Nivel3 := COPYSTR(Rec."No.", 1, 3);
        PlanCorporativo.RESET();
        IF PlanCorporativo.GET(Nivel3) THEN
            DescNivel3 := PlanCorporativo.Name;
    end;

    trigger OnOpenPage()
    begin
        Rec.SETFILTER("No.", '6* | 7*');
        Rec.SETRANGE("Account Type", Rec."Account Type"::Posting);
    end;

    var
        Nivel1: Code[20];
        DescNivel1: Text[50];
        PlanCorporativo: Record "Plan Corporativo";
        Nivel2: Code[20];
        Nivel3: Code[20];
        DescNivel2: Text[50];
        DescNivel3: Text[50];
}
