pageextension 50068 "Sales Order Archive Ext" extends "Sales Order Archive"
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
