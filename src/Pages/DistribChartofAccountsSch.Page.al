page 50026 "Distrib. Chart of Accounts Sch"
{
    Caption = 'Distrib. Chart of Accounts Sch', Comment = 'ESP="Esquema plan de cuentas distribución"';
    SourceTable = "Schedule of Distrib. Accounts";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Totaling; Rec.Totaling)
                {
                }
                field("Interval of GC accounts"; Rec."Interval of GC accounts")
                {
                }
                field("Dimension filter 1"; Rec."Dimension filter 1")
                {
                }
                field("Dimension filter 2"; Rec."Dimension filter 2")
                {
                }
                field(Balance; Rec.Balance)
                {
                }
                field("Balance to assign"; Rec."Balance to assign")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
            }
            group("Estadísticas")
            {
                field("Last date modified"; Rec."Last date modified")
                {
                }
                field("Modified by"; Rec."Modified by")
                {
                }
            }
        }
    }

    actions
    {
    }

    procedure GetSelectionFilter(): Text
    var
        GLAcc: Record "G/L Account";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SETSELECTIONFILTER(GLAcc);
        EXIT(SelectionFilterManagement.GetSelectionFilterForGLAccount(GLAcc));
    end;
}
