page 50022 "Chart of schedule List"
{
    Caption = 'Chart of schedule List', Comment = 'ESP="Lista plan de distribución"';
    CardPageID = "Distribution Account Card";
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Schedule of Distrib. Accounts";
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
                field(Type; Rec.Type)
                {
                }
                field(Totaling; Rec.Totaling)
                {
                }
                field("Interval of GC accounts"; Rec."Interval of GC accounts")
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
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'Functions', Comment = 'ESP="Funciones"';
                Image = "Action";

                action(IndentCostType)
                {
                    Caption = 'Indent Distribution Accounts', Comment = 'ESP="Sangrar cuentas de distribución"';
                    Image = IndentChartOfAccounts;

                    trigger OnAction()
                    var
                        cDistributionMng: Codeunit "Distribution Mngt";
                    begin
                        cDistributionMng.fConfirmIndentCostTypes;
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Process)
            {
                Caption = 'Process', Comment = 'ESP="Procesar"';

                actionref(IndentCostType_Promoted; IndentCostType)
                {
                }
            }
        }
    }

    procedure SetSelection(var DistributionSched: Record "Schedule of Distrib. Accounts")
    begin
        CurrPage.SETSELECTIONFILTER(DistributionSched);
    end;

    procedure GetSelectionFilter(): Text
    var
        DistriSched: Record "Schedule of Distrib. Accounts";
        EYFunctions: Codeunit "EY Functions";
    begin
        CurrPage.SETSELECTIONFILTER(DistriSched);
        EXIT(EYFunctions.GetSelectionFilterForDistribution(DistriSched));
    end;
}