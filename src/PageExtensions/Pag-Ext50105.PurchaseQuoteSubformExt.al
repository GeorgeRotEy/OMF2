pageextension 50105 "Purchase Quote Subform Ext" extends "Purchase Quote Subform"
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
