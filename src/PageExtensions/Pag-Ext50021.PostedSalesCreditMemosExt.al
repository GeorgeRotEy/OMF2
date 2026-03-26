pageextension 50021 "Posted Sales Credit Memos Ext" extends "Posted Sales Credit Memos"
{
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        addafter("Amount Including VAT")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
