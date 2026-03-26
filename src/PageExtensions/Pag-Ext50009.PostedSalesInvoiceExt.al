pageextension 50009 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        moveafter("Sell-to Customer Name"; "VAT Registration No.")

        addafter("VAT Registration No.")
        {
            field(Email; Rec.Email)
            {
                ApplicationArea = All;
            }
        }
        addafter("Bill-to Contact")
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
