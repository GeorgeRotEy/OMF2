pageextension 50038 "Vendor List Ext" extends "Vendor List"
{
    // Mod. S2G 18/12/2017 (JGS) : TER001 � Terceros.
    //   Modified triggers
    //      OnfindRecord
    //      OnNextRecord
    //Mod. S2G 25-04-2019 (YLA) Se muestra el campo CIF/NIF
    layout
    {
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Fax No.")
        {
            Visible = false;
        }
        //Intercompany
        // modify("IC Partner Code")
        // {
        //     Visible = false;
        // }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Language Code")
        {
            Visible = false;
        }
        modify("Application Method")
        {
            Visible = false;
        }
        modify("Location Code2")
        {
            Visible = false;
        }
        modify("Shipment Method Code")
        {
            Visible = false;
        }
        modify("Lead Time Calculation")
        {
            Visible = false;
        }
        modify("Base Calendar Code")
        {
            Visible = false;
        }
        addafter("Search Name")
        {
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = All;
            }
            field("Purchases (LCY)"; Rec."Purchases (LCY)")
            {
                ApplicationArea = All;
            }
        }
        addafter("Balance Due (LCY)")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(DimensionsMultiple)
        {
            action("<Page Third Party>")
            {
                Caption = 'Third Party', Comment = 'ESP="Tercero"';
                Image = Customer;
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
        addlast(Promoted)
        {
            group(New)
            {
                Caption = 'New', Comment = 'ESP="Nuevo"';

                actionref(ThirdParty_Promoted; "<Page Third Party>")
                {
                }
            }
        }
    }

    //TODO-MIG
    // trigger OnFindRecord(Which: Text): Boolean
    // begin
    //     // TER001 - Maestro de terceros.begin
    //     EXIT(FindFirstAllowedRec(Which));
    //     // TER001 - Maestro de terceros.end
    // end;

    // trigger OnNextRecord(Steps: Integer): Integer
    // begin
    //     // TER001 - Terceros.begin
    //     EXIT(FindNextAllowedRec(Steps));
    //     // TER001 - Terceros.end
    // end;
}