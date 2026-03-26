tableextension 50380 "Detailed Vendor Ledg. Entry" extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
        field(50001; "Third Party No."; Code[20])
        {
            Caption = 'Third Party No.', Comment = 'ESP="Nº tercero"';
            TableRelation = "Third Party";
        }
    }
}
