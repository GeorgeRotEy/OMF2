tableextension 50287 "Customer Bank Account Ext" extends "Customer Bank Account"
{
    fields
    {
        field(50001; "Third Party Reference"; Integer)
        {
            Caption = 'Third Party Reference', Comment = 'ESP="Referencia tercero"';
            Editable = false;
            TableRelation = Donation;
        }
    }
}
