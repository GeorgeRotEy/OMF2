pageextension 50017 "Posted Purch. Credit Memo Ext" extends "Posted Purchase Credit Memo"
{
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        addafter("Pay-to Contact")
        {
            group(Retenciones)
            {
                Caption = 'Retenciones';

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
}
