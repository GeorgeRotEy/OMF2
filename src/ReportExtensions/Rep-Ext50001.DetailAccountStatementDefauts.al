reportextension 50001 "Detail Acc. Statement Defaults" extends "Detail Account Statement"
{
    requestpage
    {
        trigger OnOpenPage()
        begin
            SetDefaultAccountFilters();
        end;
    }

    trigger OnPreReport()
    begin
        SetDefaultAccountFilters();
    end;

    local procedure SetDefaultAccountFilters()
    begin
        if "G/L Account".GetFilter("Account Type") = '' then
            "G/L Account".SetRange("Account Type", "G/L Account"."Account Type"::Posting);
        if "G/L Account".GetFilter("No.") = '' then
            "G/L Account".SetFilter("No.", '6*|7*|8*|9*');
    end;
}