namespace OFM.OFM;

using Microsoft.Bank.BankAccount;

page 50047 "Banks Balance"
{
    ApplicationArea = All;
    Caption = 'Banks Balance';
    PageType = List;
    SourceTable = "Bank Account";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Net Change"; Rec."Net Change")
                {
                }
                field("Date Filter"; Rec."Date Filter")
                {
                }
                field(Blocked; Rec.Blocked)
                {

                }
            }
        }
    }
}
