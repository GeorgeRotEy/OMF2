pageextension 50059 "Sales Order Subform Ext" extends "Sales Order Subform"
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
