page 50051 "EDUCAMOS RecibosRemesa"
{
    Caption = 'EDUCAMOS RemittanceReceipt', Comment = 'ESP="EDUCAMOS RecibosRemesa"';
    Editable = false;
    PageType = List;
    SourceTable = "EDUCAMOS RecibosRemesa";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID Remesa BC"; Rec."ID Remesa BC")
                {
                }
                field(remesaid; Rec.remesaid)
                {
                }
                field("ID Recibo BC"; Rec."ID Recibo BC")
                {
                }
                field(reciboId; Rec.reciboId)
                {
                }
                field(medioPago; Rec.medioPago)
                {
                }
                field(pagadorMedioPagoId; Rec.pagadorMedioPagoId)
                {
                }
                field(prefijo; Rec.prefijo)
                {
                }
                field(numero; Rec.numero)
                {
                }
                field(sufijoAnulacion; Rec.sufijoAnulacion)
                {
                }
                // Grupo conceptos
                field(reciboConceptoId; Rec.reciboConceptoId)
                {
                }
                field(importeConcepto; Rec.importeConcepto)
                {
                }
                field(importePagado; Rec.importePagado)
                {
                }
                field(fechaPago; Rec.fechaPago)
                {
                }
                field(conceptoId; Rec.conceptoId)
                {
                }
                field(texto; Rec.texto)
                {
                }
                field(personaId; Rec.personaId)
                {
                }
                field(estado; Rec.estado)
                {
                }
                // Grupo descuentos
                field(descuentoId; Rec.descuentoId)
                {
                }
                field(nombreDescuento; Rec.nombreDescuento)
                {
                }
                field(importe; Rec.importe)
                {
                }
                field(porcentaje; Rec.porcentaje)
                {
                }
                // Grupo movimientos
                field(nombreResponsable; Rec.nombreResponsable)
                {
                }
                field(apellido1Responsable; Rec.apellido1Responsable)
                {
                }
                field(apellido2Responsable; Rec.apellido2Responsable)
                {
                }
                field(fechaMovimiento; Rec.fechaMovimiento)
                {
                }
                field(fechaValor; Rec.fechaValor)
                {
                }
                field(estadoRecibo; Rec.estadoRecibo)
                {
                }
                field(motivoDevolucion; Rec.motivoDevolucion)
                {
                }
                field(comentario; Rec.comentario)
                {
                }
                field(domiciliado; Rec.domiciliado)
                {
                }
                // Grupo pagos dentro de movimientos
                field(pago_importePago; Rec.pago_importePago)
                {
                }
                field(pago_reciboConceptoId; Rec.pago_reciboConceptoId)
                {
                }
                field(pago_importePagado; Rec.pago_importePagado)
                {
                }
                //Independiente
                field("Importation DateTime"; Rec."Importation DateTime")
                {
                }
                field(Processed; Rec.Processed)
                {
                }
            }
        }
    }
}
