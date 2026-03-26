pageextension 50008 "Posted Sales Shpt. Subform Ext" extends "Posted Sales Shpt. Subform"
{
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

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
