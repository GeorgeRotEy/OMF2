pageextension 50010 "Posted Sales Invoice Sub Ext" extends "Posted Sales Invoice Subform"
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
