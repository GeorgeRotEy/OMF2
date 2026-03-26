pageextension 50106 "Purch. Cr. Memo Subf Ext" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        addafter("Blanket Order Line No.")
        {
            field("Grupo registro IRPF"; Rec."Grupo registro IRPF")
            {
                ApplicationArea = All;
            }
            field("Línea IRPF"; Rec."Línea IRPF")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
}
