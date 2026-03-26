page 50023 "Analytical Distribution"
{
    Caption = 'Analytical Distribution', Comment = 'ESP="Distribución analítica"';
    PageType = Document;
    SourceTable = "Analytical Distribution Hdr.";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field(Level; Rec.Level)
                {
                }
                field("Valid from date"; Rec."Valid from date")
                {
                }
                field("Valid to date"; Rec."Valid to date")
                {
                }
                field("Source dimension code"; Rec."Source dimension code")
                {
                }
                field("Destination dimension code"; Rec."Destination dimension code")
                {
                }
                field("Account interval"; Rec."Account interval")
                {
                }
                field("Dest. Dimension processing"; Rec."Dest. Dimension processing")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("From Posting Date"; Rec."From Posting Date")
                {
                }
                field("To Posting Date"; Rec."To Posting Date")
                {
                }
            }
            part(AnalyticalDistributionSubfor; "Analytical Distribution Subfor")
            {
                SubPageLink = "Document No." = FIELD("Document No.");
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetupNewRecord();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        TotalDistRate: Decimal;
        DistrLines: Record "Anaylitical Distrib. Lines";
    begin
        TotalDistRate := Rec.GetTotalDistribRate();
        IF TotalDistRate < 100 THEN BEGIN
            DistrLines.RESET();
            DistrLines.SETRANGE("Document No.", Rec."Document No.");
            IF (TotalDistRate <> 0) OR (DistrLines.COUNT > 0) THEN
                ERROR(Text_PorcentajeNoAlcanzado);
        END;
    end;

    var
        Text_PorcentajeNoAlcanzado: Label 'Sum of Distribution % must be 100%';

    local procedure SetupNewRecord()
    begin
        Rec.TestNoSeries();
        Rec."No. Series" := Rec.GetNoSeriesCode();
    end;
}
