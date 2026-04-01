namespace DataSchema.DataSchema;

using Microsoft.Finance.ReceivablesPayables;

tableextension 50050 "Invoice Posting Parameters Ext" extends "Invoice Posting Parameters"
{
    fields
    {
        field(50000; "Retention Entry No."; Integer)
        {
            Caption = 'Retention Entry No.', Comment = 'ESP="Nº mov. retención"';
        }
    }
}
