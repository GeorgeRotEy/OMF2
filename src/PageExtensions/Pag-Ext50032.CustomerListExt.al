pageextension 50032 "Customer List Ext" extends "Customer List"
{
    // Mod. S2G 18/12/2017 (JGS) : TER001 � Terceros.
    // Modified triggers
    //                  OnfindRecord
    //                  OnNextRecord

    //Mod. S2G 25/04/2019 (YLA) Se muestra el campo CIF/NIF
    layout
    {
        addafter("Sales (LCY)")
        {
            field("Third Party No."; Rec."Third Party No.")
            {
                ApplicationArea = All;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
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
                Image = Customer;
                RunObject = Page "Third Party List";
                ApplicationArea = All;
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
    //     // TER001 - Maestro de terceros.begin
    //     EXIT(FindNextAllowedRec(Steps));
    //     // TER001 - Maestro de terceros.end
    // end;
}