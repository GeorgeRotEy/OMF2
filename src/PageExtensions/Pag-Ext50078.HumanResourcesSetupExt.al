pageextension 50078 "Human Resources Setup Ext" extends "Human Resources Setup"
{
    layout
    {
        addafter("Employee Nos.")
        {
            field("No serie Friar"; Rec."No serie Friar")
            {
                ApplicationArea = All;
            }
        }
    }
}
