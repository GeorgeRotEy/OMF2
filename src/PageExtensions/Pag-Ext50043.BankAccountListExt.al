pageextension 50043 "Bank Account List Ext" extends "Bank Account List"
{
    layout
    {
        addafter("Search Name")
        {
            field("CCC Bank No."; Rec."CCC Bank No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the four-digit bank account code.', Comment = 'ESP="Especifica el código de cuenta bancaria de cuatro dígitos."';
            }
            field("Main Bank"; Rec."Main Bank")
            {
                ApplicationArea = All;
            }
        }
    }
}
