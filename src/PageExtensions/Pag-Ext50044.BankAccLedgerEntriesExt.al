pageextension 50044 "Bank Acc. Ledger Entries Ext" extends "Bank Account Ledger Entries"
{
    // (SIDS-466) S2G (LAG) 26-02-20: Mod dimensiones acceso directo.
    //     New Fields:
    //       -Shortcut Dimension 3
    //       -Shortcut Dimension 4
    //       -Shortcut Dimension 5
    //       -Shortcut Dimension 6
    layout
    {
        addafter("Entry No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 4"; Rec."Shortcut Dimension 4")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 5"; Rec."Shortcut Dimension 5")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 6"; Rec."Shortcut Dimension 6")
            {
                ApplicationArea = All;
            }
            field("Posting concept"; Rec."Posting concept")
            {
                ApplicationArea = All;
            }
        }
    }
}
