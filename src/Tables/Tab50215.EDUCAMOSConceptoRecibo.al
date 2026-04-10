table 50215 "EDUCAMOS ConceptoRecibo"
{
    Caption = 'EDUCAMOS ConceptoRecibo';

    fields
    {
        field(1; calendarioEscolarId; Text[50])
        {
            Caption = 'School Calendar ID', Comment = 'ESP="ID calendario escolar"';
            TableRelation = "EDUCAMOS ReciboRemesa".calendarioEscolarId;
        }
        field(2; remesaId; Text[50])
        {
            Caption = 'Remittance ID', Comment = 'ESP="ID remesa"';
            TableRelation = "EDUCAMOS ReciboRemesa".remesaId
                where(calendarioEscolarId = field(calendarioEscolarId));
        }
        field(3; reciboId; Text[50])
        {
            Caption = 'Receipt ID', Comment = 'ESP="ID recibo"';
            TableRelation = "EDUCAMOS ReciboRemesa".reciboId
                where(calendarioEscolarId = field(calendarioEscolarId),
                      remesaId = field(remesaId));
        }
        field(4; reciboConceptoId; Text[50])
        {
            Caption = 'Receipt Concept ID', Comment = 'ESP="ID concepto recibo"';
        }
        field(10; importe; Decimal)
        {
            Caption = 'Concept Amount', Comment = 'ESP="Importe concepto"';
        }
        field(11; importePagado; Decimal)
        {
            Caption = 'Paid Amount', Comment = 'ESP="Importe pagado"';
        }
        field(12; fechaPago; Date)
        {
            Caption = 'Payment Date', Comment = 'ESP="Fecha pago"';
        }
        field(13; conceptoId; Text[50])
        {
            Caption = 'Concept ID', Comment = 'ESP="ID concepto"';
        }
        field(14; texto; Text[250])
        {
            Caption = 'Text', Comment = 'ESP="Texto"';
        }
        field(15; personaId; Text[50])
        {
            Caption = 'Person ID', Comment = 'ESP="ID persona"';
        }
        field(16; estado; Text[50])
        {
            Caption = 'Status', Comment = 'ESP="Estado"';
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
        key(PK; calendarioEscolarId, remesaId, reciboId, reciboConceptoId)
        {
            Clustered = true;
        }
    }
}