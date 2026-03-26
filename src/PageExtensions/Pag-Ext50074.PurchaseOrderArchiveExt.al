pageextension 50074 "Purchase Order Archive Ext" extends "Purchase Order Archive"
{
    layout
    {
        addafter("Prices Including VAT")
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
