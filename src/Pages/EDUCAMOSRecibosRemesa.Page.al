page 50051 "EDUCAMOS RecibosRemesa"
{
    Caption = 'EDUCAMOS RemittanceReceipt', Comment = 'ESP="EDUCAMOS ReciboRemesa"';
    Editable = false;
    PageType = List;
    SourceTable = "EDUCAMOS ReciboRemesa";
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
