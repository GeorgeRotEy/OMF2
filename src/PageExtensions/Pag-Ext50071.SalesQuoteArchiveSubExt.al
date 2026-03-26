pageextension 50071 "Sales Quote Archive Sub Ext" extends "Sales Quote Archive Subform"
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
