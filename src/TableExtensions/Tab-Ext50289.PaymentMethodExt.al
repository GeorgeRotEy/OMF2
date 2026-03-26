tableextension 50289 "Payment Method Ext" extends "Payment Method"
{
    fields
    {
        field(50000; Transfer; Boolean)
        {
            Caption = 'Transfer', Comment = 'ESP="Transferencia"';
        }
    }
}
