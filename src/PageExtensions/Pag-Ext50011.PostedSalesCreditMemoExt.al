pageextension 50011 "Posted Sales Credit Memo Ext" extends "Posted Sales Credit Memo"
{
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
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
