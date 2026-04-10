page 50063 "EDUCAMOS DescuentosConcepto"
{
    PageType = List;
    SourceTable = "EDUCAMOS DescuentoConcepto";
    Caption = 'Concept Discounts', Comment = 'ESP="EDUCAMOS DescuentosConcepto"';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(descuentoId; Rec.descuentoId)
                {
                    ApplicationArea = All;
                }
                field(nombreDescuento; Rec.nombreDescuento)
                {
                    ApplicationArea = All;
                }
                field(importe; Rec.importe)
                {
                    ApplicationArea = All;
                }
                field(porcentaje; Rec.porcentaje)
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