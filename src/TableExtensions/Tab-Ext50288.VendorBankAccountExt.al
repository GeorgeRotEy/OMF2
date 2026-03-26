tableextension 50288 "Vendor Bank Account Ext" extends "Vendor Bank Account"
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
