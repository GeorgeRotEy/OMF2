table 50216 "EDUCAMOS DescuentoConcepto"
{

    fields
    {
        field(1; calendarioEscolarId; Text[50])
        {
            Caption = 'School Calendar ID', Comment = 'ESP="ID calendario escolar"';
            TableRelation = "EDUCAMOS ConceptoRecibo".calendarioEscolarId;
        }
        field(2; remesaId; Text[50])
        {
            Caption = 'Remittance ID', Comment = 'ESP="ID remesa"';
            TableRelation = "EDUCAMOS ConceptoRecibo".remesaId
                where(calendarioEscolarId = field(calendarioEscolarId));
        }
        field(3; reciboConceptoId; Text[50])
        {
            Caption = 'Receipt Concept ID', Comment = 'ESP="ID concepto recibo"';
            TableRelation = "EDUCAMOS ConceptoRecibo".reciboConceptoId
                where(calendarioEscolarId = field(calendarioEscolarId),
                      remesaId = field(remesaId));
        }
        field(4; descuentoId; Text[50])
        {
            Caption = 'Discount ID', Comment = 'ESP="ID descuento"';
        }
        field(5; nombreDescuento; Text[100])
        {
            Caption = 'Discount Name', Comment = 'ESP="Nombre descuento"';
        }
        field(6; importe; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(7; porcentaje; Decimal)
        {
            Caption = 'Percentage', Comment = 'ESP="Porcentaje"';
        }
        field(70; "Importation DateTime"; DateTime)
        {
            Caption = 'Import Date/Time', Comment = 'ESP="Fecha y hora importación"';
        }
        field(71; Processed; Boolean)
        {
            Caption = 'Processed', Comment = 'ESP="Procesado"';
        }
    }

    keys
    {
        key(PK; calendarioEscolarId, remesaId, reciboConceptoId, descuentoId)
        {
            Clustered = true;
        }
    }
}