pageextension 50040 "Vendor Ledger Entries Ext" extends "Vendor Ledger Entries"
{
    layout
    {
        moveafter("Exported to Payment File"; "Vendor Name")
        addafter(Description)
        {
            field("Posting concept"; Rec."Posting concept")
            {
                ApplicationArea = All;
            }
        }
        addafter("Amount (LCY)")
        {
            field("Purchase (LCY)"; Rec."Purchase (LCY)")
            {
                ApplicationArea = All;
            }
        }
    }
}
