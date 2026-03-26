tableextension 50006 "Human Resources Setup Ext" extends "Human Resources Setup"
{
    fields
    {
        field(50000; "No serie Friar"; Code[10])
        {
            Caption = 'Friar No. Series', Comment = 'ESP="Nº serie Friar"';
            TableRelation = "No. Series";
        }
    }
}