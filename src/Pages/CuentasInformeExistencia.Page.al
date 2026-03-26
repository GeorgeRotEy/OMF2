page 50156 CuentasInformeExistencia
{
    PageType = List;
    Caption = 'Inventory Report Accounts', Comment = 'ESP="Cuentas informe existencia"';
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
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SETFILTER("No.", '3000001..3290001');
        Rec.SETRANGE("Account Type", Rec."Account Type"::Posting);
    end;
}
