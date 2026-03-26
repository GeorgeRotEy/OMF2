pageextension 50042 "Bank Account Card Ext" extends "Bank Account Card"
{
    layout
    {
        addafter("Bank Clearing Code")
        {
            field("Main Bank"; Rec."Main Bank")
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF Rec."Main Bank" = '' THEN
            Rec."Main Bank" := Rec."Search Name";
        // Asegura que el cambio se aplique al registro
    end;
}
