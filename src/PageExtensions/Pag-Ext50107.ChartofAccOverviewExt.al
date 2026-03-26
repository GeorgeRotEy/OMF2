namespace OFM.OFM;

using Microsoft.Finance.GeneralLedger.Account;

pageextension 50107 "Chart of Acc. Overview Ext" extends "Chart of Accounts Overview"
{
    layout
    {
        modify("Balance at Date")
        {
            Visible = false;
        }
        addafter("Balance at Date")
        {
            field("Balance at Date OFM"; Rec."Balance at Date OFM")
            {
                ApplicationArea = All;
            }
        }
    }
}
