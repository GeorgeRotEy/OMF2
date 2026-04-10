page 50035 "EDUCAMOS ConceptosRecibo"
{
    PageType = List;
    SourceTable = "EDUCAMOS ConceptoRecibo";
    Caption = 'EDUCAMOS ConceptoRecibo', Comment = 'ESP="EDUCAMOS ConceptoRecibo"';
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
                field(importe; Rec.importe)
                {
                    ApplicationArea = All;
                }
                field(importePagado; Rec.importePagado)
                {
                    ApplicationArea = All;
                }
                field(fechaPago; Rec.fechaPago)
                {
                    ApplicationArea = All;
                }
                field(conceptoId; Rec.conceptoId)
                {
                    ApplicationArea = All;
                }
                field(texto; Rec.texto)
                {
                    ApplicationArea = All;
                }
                field(personaId; Rec.personaId)
                {
                    ApplicationArea = All;
                }
                field(estado; Rec.estado)
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