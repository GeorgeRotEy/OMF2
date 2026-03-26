pageextension 50015 "Posted Purchase Invoice Ext" extends "Posted Purchase Invoice"
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
