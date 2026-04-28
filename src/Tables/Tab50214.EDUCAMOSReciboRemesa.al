table 50214 "EDUCAMOS ReciboRemesa"
{
    Caption = 'EDUCAMOS ReciboRemesa';
    fields
    {
        field(1; calendarioEscolarId; Text[50])
        {
            Caption = 'School Calendar ID', Comment = 'ESP="ID calendario escolar"';
        }
        field(2; remesaId; Text[50])
        {
            Caption = 'Remittance ID', Comment = 'ESP="ID remesa"';
        }
        field(3; "ID Remesa BC"; Integer)
        {
            Caption = 'BC Remittance ID', Comment = 'ESP="ID remesa BC"';
        }
        field(4; reciboId; Text[50])
        {
            Caption = 'Receipt ID', Comment = 'ESP="ID recibo"';
        }
        field(5; "ID Recibo BC"; Integer)
        {
            Caption = 'BC Receipt ID', Comment = 'ESP="ID recibo BC"';
        }
        field(6; estado; Text[30])
        {
            Caption = 'Status', Comment = 'ESP="Estado"';
        }
        field(7; reciboOrigenId; Text[50])
        {
            Caption = 'Origin Receipt ID', Comment = 'ESP="ID recibo origen"';
        }
        field(8; medioPago; Text[100])
        {
            Caption = 'Payment Method', Comment = 'ESP="Medio de pago"';
        }
        field(9; pagadorMedioPagoId; Text[50])
        {
            Caption = 'Payer Payment Method ID', Comment = 'ESP="ID medio pago pagador"';
        }
        field(10; prefijo; Text[20])
        {
            Caption = 'Prefix', Comment = 'ESP="Prefijo"';
        }
        field(11; numero; Integer)
        {
            Caption = 'Number', Comment = 'ESP="Número"';
        }
        field(12; sufijoAnulacion; Text[20])
        {
            Caption = 'Cancellation Suffix', Comment = 'ESP="Sufijo anulación"';
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
        key(PK; calendarioEscolarId, remesaId, reciboId)
        {
            Clustered = true;
        }
    }
}