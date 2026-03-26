tableextension 50048 "Invoice Posting Buffer Ext" extends "Invoice Posting Buffer"
{
    fields
    {
        field(50000; "Retention Entry No."; Integer)
        {
            Caption = 'Retention Entry No.', Comment = 'ESP="Nº mov. retención"';
        }
    }
}
