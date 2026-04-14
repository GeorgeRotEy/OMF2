table 50218 "EDUCAMOS ConceptoPagado"
{
    DataPerCompany = false;

    fields
    {
        field(1; calendarioEscolarId; Text[50])
        {
            Caption = 'School Calendar ID', Comment = 'ESP="ID calendario escolar"';
            TableRelation = "EDUCAMOS MovRecibo".calendarioEscolarId;
        }
        field(2; remesaId; Text[50])
        {
            Caption = 'Remittance ID', Comment = 'ESP="ID remesa"';
            TableRelation = "EDUCAMOS MovRecibo".remesaId
                where(calendarioEscolarId = field(calendarioEscolarId));
        }
        field(3; reciboId; Text[50])
        {
            Caption = 'Receipt ID', Comment = 'ESP="ID recibo"';
            TableRelation = "EDUCAMOS MovRecibo".reciboId
                where(calendarioEscolarId = field(calendarioEscolarId));
        }
        field(4; movimientoId; Integer)
        {
            Caption = 'Movement Entry No.', Comment = 'ESP="Nº movimiento"';
            TableRelation = "EDUCAMOS MovRecibo".movimientoId
                where(calendarioEscolarId = field(calendarioEscolarId),
                      remesaId = field(remesaId));
        }
        field(5; reciboConceptoId; Text[50])
        {
            Caption = 'Receipt Concept ID', Comment = 'ESP="ID concepto recibo"';
        }
        field(6; importePagado; Decimal)
        {
            DataClassification = ToBeClassified;
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
        key(PK; calendarioEscolarId, remesaId, movimientoId)
        {
            Clustered = true;
        }
    }
}