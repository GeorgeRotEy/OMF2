page 50323 "EDUCAMOS MovsRecibo"
{
    PageType = List;
    SourceTable = "EDUCAMOS MovRecibo";
    Caption = 'Receipt Movements', Comment = 'ESP="EDUCAMOS MovRecibo"';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(remesaId; Rec.remesaId)
                {
                    ApplicationArea = All;
                }
                field(reciboId; Rec.reciboId)
                {
                    ApplicationArea = All;
                }
                field(movimientoId; Rec.movimientoId)
                {
                    ApplicationArea = All;
                }
                field(nombreResponsable; Rec.nombreResponsable)
                {
                    ApplicationArea = All;
                }
                field(apellido1Responsable; Rec.apellido1Responsable)
                {
                    ApplicationArea = All;
                }
                field(apellido2Responsable; Rec.apellido2Responsable)
                {
                    ApplicationArea = All;
                }
                field(fechaMovimiento; Rec.fechaMovimiento)
                {
                    ApplicationArea = All;
                }
                field(fechaValor; Rec.fechaValor)
                {
                    ApplicationArea = All;
                }
                field(estadoRecibo; Rec.estadoRecibo)
                {
                    ApplicationArea = All;
                }
                field(motivoDevolucion; Rec.motivoDevolucion)
                {
                    ApplicationArea = All;
                }
                field(comentario; Rec.comentario)
                {
                    ApplicationArea = All;
                }
                field(domiciliado; Rec.domiciliado)
                {
                    ApplicationArea = All;
                }
                field(fechaPago; Rec.fechaPago)
                {
                    ApplicationArea = All;
                }
                field(importePago; Rec.importePago)
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
