pageextension 50039 "Source Code Setup Ext" extends "Source Code Setup"
{
    layout
    {
        addafter(Reversal)
        {
            field("Retention Application"; Rec."Retention Application")
            {
                ApplicationArea = All;
            }
        }
        addafter("Payment Reconciliation Journal")
        {
            field("Easy Register Journal"; Rec."Easy Register Journal")
            {
                ApplicationArea = All;
            }
        }
        addafter("Transfer Budget to Actual")
        {
            field("Distribution Allocation"; Rec."Distribution Allocation")
            {
                ApplicationArea = All;
            }
            field("Analytic Distribution"; Rec."Analytic Distribution")
            {
                ApplicationArea = All;
            }
        }
    }
}
