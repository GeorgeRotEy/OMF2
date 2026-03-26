pageextension 50084 "FA Posting Groups Ext" extends "FA Posting Groups"
{
    layout
    {
        addafter("Allocated Maintenance %")
        {
            field("Related Straight-Line %"; Rec."Related Straight-Line %")
            {
                ApplicationArea = All;
            }
        }
    }
}
