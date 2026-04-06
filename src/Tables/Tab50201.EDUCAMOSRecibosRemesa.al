table 50201 "EDUCAMOS RecibosRemesa"
{
    Caption = 'EDUCAMOS RecibosRemesa';

    fields
    {
        field(1; remesaid; Text[50])
        {
            Caption = 'remesaid';
        }
        field(2; reciboId; Guid)
        {
            Caption = 'reciboId';
        }
        field(3; "ID Remesa BC"; Text[30])
        {
            Caption = 'ID Remesa BC';
        }
        field(4; "ID Recibo BC"; Blob)
        {
            Caption = 'ID Recibo BC';
        }
        field(5; medioPago; Text[100])
        {
            Caption = 'medioPago';
        }
        field(6; pagadorMedioPagoId; Guid)
        {
            Caption = 'pagadorMedioPagoId';
        }
        field(7; prefijo; Text[50])
        {
            Caption = 'prefijo';
        }
        field(8; numero; Integer)
        {
            Caption = 'numero';
        }
        field(9; sufijoAnulacion; Text[50])
        {
            Caption = 'sufijoAnulacion';
        }
        // Grupo conceptos
        field(20; reciboConceptoId; Guid)
        {
            Caption = 'reciboConceptoId';
        }
        field(21; importeConcepto; Decimal)
        {
            Caption = 'importeConcepto';
        }
        field(22; importePagado; Decimal)
        {
            Caption = 'importePagado';
        }
        field(23; fechaPago; Date)
        {
            Caption = 'fechaPago';
        }
        field(24; conceptoId; Guid)
        {
            Caption = 'conceptoId';
        }
        field(25; texto; Text[250])
        {
            Caption = 'texto';
        }
        field(26; personaId; Guid)
        {
            Caption = 'personaId';
        }
        field(27; estado; Text[50])
        {
            Caption = 'estado';
        }
        // Grupo descuentos
        field(40; descuentoId; Guid)
        {
            Caption = 'descuentoId';
        }
        field(41; nombreDescuento; Text[150])
        {
            Caption = 'nombreDescuento';
        }
        field(42; importe; Decimal)
        {
            Caption = 'importe';
        }
        field(43; porcentaje; Decimal)
        {
            Caption = 'porcentaje';
        }
        // Grupo movimientos
        field(50; nombreResponsable; Text[100])
        {
            Caption = 'nombreResponsable';
        }
        field(51; apellido1Responsable; Text[100])
        {
            Caption = 'apellido1Responsable';
        }
        field(52; apellido2Responsable; Text[100])
        {
            Caption = 'apellido2Responsable';
        }
        field(53; fechaMovimiento; DateTime)
        {
            Caption = 'fechaMovimiento';
        }
        field(54; fechaValor; DateTime)
        {
            Caption = 'fechaValor';
        }
        field(55; estadoRecibo; Text[50])
        {
            Caption = 'estadoRecibo';
        }
        field(56; motivoDevolucion; Text[250])
        {
            Caption = 'motivoDevolucion';
        }
        field(57; comentario; Text[250])
        {
            Caption = 'comentario';
        }
        field(58; domiciliado; Boolean)
        {
            Caption = 'domiciliado';
        }
        // Grupo pagos dentro de movimientos
        field(70; pago_importePago; Decimal)
        {
            Caption = 'pago_importePago';
        }
        field(71; pago_reciboConceptoId; Guid)
        {
            Caption = 'pago_reciboConceptoId';
        }
        field(72; pago_importePagado; Decimal)
        {
            Caption = 'pago_importePagado';
        }
        field(80; "Importation DateTime"; DateTime)
        {
            Caption = 'Import Date/Time', Comment = 'ESP="Fecha y hora de importación"';
        }
        field(81; Processed; Boolean)
        {
            Caption = 'Processed', Comment = 'ESP="Procesado"';
        }
    }

    keys
    {
        key(Key1; remesaid, reciboId)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}