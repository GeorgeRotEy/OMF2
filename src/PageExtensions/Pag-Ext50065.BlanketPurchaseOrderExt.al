pageextension 50065 "Blanket Purchase Order Ext" extends "Blanket Purchase Order"
{
    layout
    {
        addafter("Expected Receipt Date")
        {
            field("Control IRPF"; Rec."Control IRPF")
            {
                ApplicationArea = All;
            }
            field("Grupo registro IRPF"; Rec."Grupo registro IRPF")
            {
                ApplicationArea = All;
            }
        }
    }
}
