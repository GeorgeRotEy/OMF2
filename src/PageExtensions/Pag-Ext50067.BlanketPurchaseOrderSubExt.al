pageextension 50067 "Blanket Purchase Order Sub Ext" extends "Blanket Purchase Order Subform"
{
    layout
    {
        addafter("Expected Receipt Date")
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
