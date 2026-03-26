namespace OFM.OFM;

using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Foundation.AuditCodes;

page 50048 "GL Posting WS"
{
    ApplicationArea = All;
    Caption = 'GL Posting WS';
    PageType = List;
    SourceTable = "G/L Entry";
    UsageCategory = none;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = All;
                }
                field("Posting concept"; Rec."Posting concept")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        vlFirstEntry: Integer;
        vlLastEntry: Integer;
    begin
        rSourceCodeSetup.GET();

        rGLRegister.Reset();
        rGLRegister.SETRANGE("Source Code", rSourceCodeSetup."Easy Register Journal");
        IF rGLRegister.FINDLAST() THEN BEGIN
            vlLastEntry := rGLRegister."No.";
            rGLRegister.Next(-9);
            vlFirstEntry := rGLRegister."No.";

            fSetTransactionFilter(rSourceCodeSetup."Easy Register Journal", vlLastEntry, vlFirstEntry);
        END;

        IF vTransactionFilter <> '' THEN BEGIN
            Rec.SETCURRENTKEY("Transaction No.");
            Rec.SETFILTER("Transaction No.", vTransactionFilter);
            Rec.SetRange("Source Code", vEasyRegJnl);
        END;
    end;

    // trigger OnAfterGetRecord()
    // begin
    //     IF NOT rGLAcc.GET(Rec."G/L Account No.") THEN
    //         CLEAR(rGLAcc);
    //     vNombreCuenta := rGLAcc.Name;
    // end;

    var
        rGLAcc: Record "G/L Account";
        rGLRegister: Record "G/L Register";
        rSourceCodeSetup: Record "Source Code Setup";
        vEasyRegJnl: Code[10];
        vTransactionFilter: Text;
    // vNombreCuenta: Text;

    procedure fSetTransactionFilter(pEasyRegJnl: Code[10]; pLastEntry: Integer; pFirstEntry: Integer)
    begin
        vEasyRegJnl := pEasyRegJnl;
        vTransactionFilter := Format(pFirstEntry) + '..' + Format(pLastEntry);
    end;
}
