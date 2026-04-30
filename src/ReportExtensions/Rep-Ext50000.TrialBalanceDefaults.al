reportextension 50000 "Trial Balance Defaults Ext" extends "Trial Balance"
{
    dataset
    {
        add("G/L Account")
        {
            column(BalanceatPeriodCaption; BalanceatPeriodCaptionLbl)
            {
            }
            column(AccinPeriodCaptionModf; AccinPeriodCaptionModfLbl)
            {
            }
            column(AccPeriodatDateCaptionModf; AccPeriodatDateCaptionModfLbl)
            {
            }
            column(BalanceatDateCaptionModf; BalanceatDateCaptionModf)
            {
            }

        }
    }
    requestpage
    {
        trigger OnOpenPage()
        begin
            SetDefaultRequestOptions;
        end;
    }

    trigger OnPreReport()
    begin
        if not GuiAllowed then
            SetDefaultRequestOptions;
    end;

    local procedure SetDefaultRequestOptions()
    begin
        PrintAllHavingBal := true;
        AcumBalance := true;
        if "G/L Account".GetFilter("Account Type") = '' then
            "G/L Account".SetRange("Account Type", "G/L Account"."Account Type"::Posting);
    end;

    var
        BalanceatPeriodCaptionLbl: Label 'Balance at Period', Comment = 'ESP="Saldo en periodo"';
        AccinPeriodCaptionModfLbl: Label 'Movs. en periodo';
        AccPeriodatDateCaptionModfLbl: Label 'Movs. acumulado a fecha';
        BalanceatDateCaptionModf: Label 'Saldo acum. a fecha';
}