page 50158 CuentasInformeSaldoCyP
{
    PageType = List;
    Caption = 'P&L Balance Report Accounts', Comment = 'ESP="Cuentas informe saldo CyP"';
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
        Rec.SETFILTER("No.", '4100001|4300001|4000001|5720001|5700001');
        Rec.SETRANGE("Account Type", Rec."Account Type"::Posting);
    end;
}
