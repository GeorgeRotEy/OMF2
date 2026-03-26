pageextension 50087 "Sales Return Order Subform Ext" extends "Sales Return Order Subform"
{
    layout
    {
        addafter("Appl.-to Item Entry")
        {
            field("IRPF Posting Group"; Rec."IRPF Posting Group")
            {
                ApplicationArea = All;
            }
            field("IRPF Line"; Rec."IRPF Line")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
}
