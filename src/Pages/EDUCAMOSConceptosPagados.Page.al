page 50324 "EDUCAMOS ConceptosPagados"
{
    PageType = List;
    SourceTable = "EDUCAMOS ConceptoPagado";
    Caption = 'Paid Concepts', Comment = 'ESP="EDUCAMOS ConceptoPagado"';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(reciboConceptoId; Rec.reciboConceptoId)
                {
                    ApplicationArea = All;
                }
                field(importePagado; Rec.importePagado)
                {
                    ApplicationArea = All;
                }
                field("Importation DateTime"; Rec."Importation DateTime")
                {
                    ApplicationArea = All;
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}