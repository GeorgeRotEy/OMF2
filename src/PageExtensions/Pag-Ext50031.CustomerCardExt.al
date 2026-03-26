pageextension 50031 "Customer Card Ext" extends "Customer Card"
{
    // Mod. S2G 18/12/2017 (JGS) : TER001 � Terceros.
    // Modified triggers
    //      OnfindRecord
    //      OnNextRecord
    //      OnAction

    InsertAllowed = false;

    layout
    {
        addbefore(PostingDetails)
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
    actions
    {
        addafter("&Customer")
        {
            action("<Page Third Party>")
            {
                Caption = 'Third Party', Comment = 'ESP="Tercero"';
                ;
                Image = Customer;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Third Party List";
                ApplicationArea = All;

                trigger OnAction()
                var
                    lpThirdpartieslist: Page "Third Party List";
                    locThirdParty: Record "Third Party";
                begin
                    // Mod. S2G 27/12/2017 (JGS) : TER001 ã Terceros.
                    CLEAR(lpThirdpartieslist);
                    locThirdParty.RESET();
                    locThirdParty.SETRANGE("No.", Rec."Third Party No.");
                    lpThirdpartieslist.SETTABLEVIEW(locThirdParty);
                    lpThirdpartieslist.RUNMODAL();
                    // Mod. S2G 27/12/2017 (JGS) : TER001 ã Terceros.
                end;
            }
        }
    }
}
