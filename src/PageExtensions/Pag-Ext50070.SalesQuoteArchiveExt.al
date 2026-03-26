pageextension 50070 "Sales Quote Archive Ext" extends "Sales Quote Archive"
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
