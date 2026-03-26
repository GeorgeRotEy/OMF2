tableextension 50007 "Acc. Schedule Line Ext" extends "Acc. Schedule Line"
{
    fields
    {
        modify(Totaling)
        {
            TableRelation = IF ("Totaling Type" = CONST("Posting Accounts")) "G/L Account"
            ELSE IF ("Totaling Type" = CONST("Total Accounts")) "G/L Account"
            ELSE IF ("Totaling Type" = CONST("Cash Flow Entry Accounts")) "Cash Flow Account"
            ELSE IF ("Totaling Type" = CONST("Cash Flow Total Accounts")) "Cash Flow Account"
            ELSE IF ("Totaling Type" = CONST("Cost Type")) "Cost Type"
            ELSE IF ("Totaling Type" = CONST("Cost Type Total")) "Cost Type"
            ELSE IF ("Totaling Type" = CONST("Distribution Entry")) "Schedule of Distrib. Accounts";
        }
        field(50006; "Source Code Filter"; Code[20])
        {
            Caption = 'Source Code Filter', Comment = 'ESP="Filtro cód. origen"';
            FieldClass = FlowFilter;
            TableRelation = "Source Code";
        }
    }

    procedure LookupSourceCodeFilter(var Text: Text): Boolean
    var
        SourceCodes: Page "Source Codes";
    begin
        SourceCodes.LOOKUPMODE(TRUE);
        IF SourceCodes.RUNMODAL() = ACTION::LookupOK THEN BEGIN
            Text := SourceCodes.GetSelectionFilter;
            EXIT(TRUE);
        END;
        EXIT(FALSE)
    end;
}