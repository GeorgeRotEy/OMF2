page 50163 InformeBalanceCuentas
{
    PageType = List;
    Caption = 'Balance Report Accounts', Comment = 'ESP="Informe balance cuentas"';
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
}
