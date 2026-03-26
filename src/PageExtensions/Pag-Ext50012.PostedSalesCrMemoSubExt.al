pageextension 50012 "Posted Sales Cr. Memo Sub Ext" extends "Posted Sales Cr. Memo Subform"
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
