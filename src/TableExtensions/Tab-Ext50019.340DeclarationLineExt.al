namespace DataSchema.DataSchema;

using Microsoft.Finance.VAT.Reporting;
using Microsoft.Finance.VAT.Ledger;

tableextension 50019 "340 Declaration Line Ext" extends "340 Declaration Line"
{
    procedure fRemoveDuplicateAmounts()
    var
        VATEntry: Record "VAT Entry";
    begin
        if not "VAT Cash Regime" then
            exit;

        if "Document Type" in
           [Format(VATEntry."Document Type"::Payment),
            Format(VATEntry."Document Type"::Refund),
            Format(VATEntry."Document Type"::Bill)]
        then begin
            "VAT Amount" := 0;
            "VAT Amount / EC Amount" := 0;
            "Amount Including VAT / EC" := 0;
            "VAT %" := 0;
            Base := 0;
            "EC %" := 0;
            "EC Amount" := 0;
        end;
    end;
}