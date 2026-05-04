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
            SetDefaultAccountFilters();
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

    local procedure SetDefaultAccountFilters()
    begin
        if "G/L Account".GetFilter("Account Type") = '' then
            "G/L Account".SetRange("Account Type", "G/L Account"."Account Type"::Posting);
        if "G/L Account".GetFilter("No.") = '' then
            "G/L Account".SetFilter("No.", '6*|7*|8*|9*');
    end;

    var
        BalanceatPeriodCaptionLbl: Label 'Balance at Period', Comment = 'ESP="Saldo en periodo"';
        AccinPeriodCaptionModfLbl: Label 'Movs. en periodo';
        AccPeriodatDateCaptionModfLbl: Label 'Movs. acumulado a fecha';
        BalanceatDateCaptionModf: Label 'Saldo acum. a fecha';
}