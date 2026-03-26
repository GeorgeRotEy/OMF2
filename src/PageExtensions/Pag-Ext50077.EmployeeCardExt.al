pageextension 50077 "Employee Card Ext" extends "Employee Card"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field("User Web"; Rec."User Web")
            {
                ApplicationArea = All;
            }
            field("Password Web"; Rec."Password Web")
            {
                ApplicationArea = All;
            }
        }
    }
}
