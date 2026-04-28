table 50217 "EDUCAMOS MovRecibo"
{

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
        field(4; movimientoId; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº movimiento"';
            AutoIncrement = true;
        }
        field(5; nombreResponsable; Text[100])
        {
            Caption = 'Responsible Name', Comment = 'ESP="Nombre responsable"';
        }
        field(6; apellido1Responsable; Text[100])
        {
            Caption = 'Responsible Last Name 1', Comment = 'ESP="Primer apellido responsable"';
        }
        field(7; apellido2Responsable; Text[100])
        {
            Caption = 'Responsible Last Name 2', Comment = 'ESP="Segundo apellido responsable"';
        }
        field(8; fechaMovimiento; DateTime)
        {
            Caption = 'Movement Date', Comment = 'ESP="Fecha movimiento"';
        }
        field(9; fechaValor; DateTime)
        {
            Caption = 'Value Date', Comment = 'ESP="Fecha valor"';
        }
        field(10; estadoRecibo; Text[50])
        {
            Caption = 'Receipt Status', Comment = 'ESP="Estado recibo"';
        }
        field(11; motivoDevolucion; Text[250])
        {
            Caption = 'Return Reason', Comment = 'ESP="Motivo devolución"';
        }
        field(12; comentario; Text[250])
        {
            Caption = 'Comment', Comment = 'ESP="Comentario"';
        }
        field(13; domiciliado; Boolean)
        {
            Caption = 'Direct Debit', Comment = 'ESP="Domiciliado"';
        }
        field(14; fechaPago; DateTime)
        {
            Caption = 'Payment Date', Comment = 'ESP="Fecha pago"';
        }
        field(15; importePago; Decimal)
        {
            Caption = 'Payment Amount', Comment = 'ESP="Importe pago"';
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
        key(PK; calendarioEscolarId, remesaId, reciboId, movimientoId)
        {
            Clustered = true;
        }
    }
}