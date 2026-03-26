tableextension 50009 "Analysis View Entry Ext" extends "Analysis View Entry"
{
    fields
    {
        modify("Account No.")
        {
            TableRelation = IF ("Account Source" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Account Source" = CONST("Cash Flow Account")) "Cash Flow Account"
            ELSE IF ("Account Source" = CONST("Distr. Account")) "Schedule of Distrib. Accounts";
        }
        field(50005; "Source Code"; Code[20])
        {
            Caption = 'Source Code', Comment = 'ESP="Cód. origen"';
            TableRelation = "Source Code";
        }
    }
}
