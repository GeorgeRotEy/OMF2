namespace OFM.OFM;

using Microsoft.Finance.Analysis;
//GR-add-020226
pageextension 50001 "Chart of Acc. (G/L) Ext" extends "Chart of Accounts (G/L)"
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
        modify("Net Change")
        {
            Visible = false;
        }
        addafter("Net Change")
        {
            field("Net Change OFM"; Rec."Net Change OFM")
            {
                ApplicationArea = All;
            }
        }
    }
}
