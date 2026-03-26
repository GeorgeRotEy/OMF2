pageextension 50069 "Sales Order Archive Sub Ext" extends "Sales Order Archive Subform"
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
                ApplicationArea = All;
            }
        }
    }
}
