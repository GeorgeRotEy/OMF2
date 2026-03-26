pageextension 50104 "Sales Quote Subform Ext" extends "Sales Quote Subform"
{
    layout
    {
        addafter("Blanket Order Line No.")
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
