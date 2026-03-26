page 50159 CuentasInformeBC
{
    PageType = List;
    Caption = 'BC Report Accounts', Comment = 'ESP="Cuentas informe BC"';
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
        Rec.SETFILTER("No.", '5720001|5700001');
    end;
}
