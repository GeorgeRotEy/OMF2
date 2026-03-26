pageextension 50034 "Customer Ledger Entries Ext" extends "Customer Ledger Entries"
{
    layout
    {
        moveafter("Reversed Entry No."; "Sales (LCY)")
        moveafter("Direct Debit Mandate ID"; "Customer Name")
        moveafter("Customer Name"; "External Document No.")

        addafter(Description)
        {
            field("Posting concept"; Rec."Posting concept")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
}
