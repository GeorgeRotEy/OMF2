page 50024 "Analytical Distribution Subfor"
{
    Caption = 'Analytical Distribution Subform', Comment = 'ESP="Subformulario distribución analítica"';
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Anaylitical Distrib. Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source dimension value"; Rec."Source dimension value")
                {
                }
                field("Destination dimension value"; Rec."Destination dimension value")
                {
                }
                field("Distribution percentage rate"; Rec."Distribution percentage rate")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CALCFIELDS("Source dimension code", "Destinati dimension code");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        IF AnalyticalDistHdr.GET(Rec."Document No.") THEN BEGIN
            Rec."Source dimension code" := AnalyticalDistHdr."Source dimension code";
            Rec."Destinati dimension code" := AnalyticalDistHdr."Destination dimension code";
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF AnalyticalDistHdr.GET(Rec."Document No.") THEN BEGIN
            Rec."Source dimension code" := AnalyticalDistHdr."Source dimension code";
            Rec."Destinati dimension code" := AnalyticalDistHdr."Destination dimension code";
        END;
    end;

    var
        AnalyticalDistHdr: Record "Analytical Distribution Hdr.";
}
