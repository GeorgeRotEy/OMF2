page 50050 "EDUCAMOS Remesa"
{
    Editable = false;
    Caption = 'EDUCAMOS Remittance', Comment = 'ESP="EDUCAMOS Remesa"';
    PageType = List;
    SourceTable = "EDUCAMOS Remesa";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(calendarioEscolarId; Rec.calendarioEscolarId)
                {
                }
                field("ID Remesa BC"; Rec."ID Remesa BC")
                {
                }
                field(remesaId; Rec.remesaId)
                {
                }
                field(descripcion; Rec.descripcion)
                {
                }
                field(reducido; Rec.reducido)
                {
                }
                field(periodoFacturacionId; Rec.periodoFacturacionId)
                {
                }
                field(nombrePeriodo; Rec.nombrePeriodo)
                {
                }
                field(pagadorComun; Rec.pagadorComun)
                {
                }
                field(fechaCreacion; Rec.fechaCreacion)
                {
                }
                field(fechaEmision; Rec.fechaEmision)
                {
                }
                field(importe; Rec.importe)
                {
                }
                field(ordenanteCuentaBancariaId; Rec.ordenanteCuentaBancariaId)
                {
                }
                field(ordenante; Rec.ordenante)
                {
                }
                field(presentador; Rec.presentador)
                {
                }
                field(datosBancarios; Rec.datosBancarios)
                {
                }
                field(fechaCargo; Rec.fechaCargo)
                {
                }
                field(cuadernoBancario; Rec.cuadernoBancario)
                {
                }
                field(esquemaSEPA; Rec.esquemaSEPA)
                {
                }
                field(textoReciboRecargo; Rec.textoReciboRecargo)
                {
                }
                field(importeRecargo; Rec.importeRecargo)
                {
                }
                field(numeroRecibosBanco; Rec.numeroRecibosBanco)
                {
                }
                field(importeTotalBanco; Rec.importeTotalBanco)
                {
                }
                field(numeroRecibosVentanilla; Rec.numeroRecibosVentanilla)
                {
                }
                field(importeTotalVentanilla; Rec.importeTotalVentanilla)
                {
                }
                field(esRemitida; Rec.esRemitida)
                {
                }
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
