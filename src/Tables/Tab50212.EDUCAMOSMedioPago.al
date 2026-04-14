table 50212 "EDUCAMOS MedioPago"
{
    DataPerCompany = false;

    fields
    {
        field(1; personaId; Text[50])
        {
            Caption = 'Person ID', Comment = 'ESP="ID persona"';
            TableRelation = "EDUCAMOS Pagador".personaId;
        }
        field(2; pagadorMedioPagoId; Text[50])
        {
            Caption = 'Payer Payment Method ID', Comment = 'ESP="ID medio de pago"';
        }
        field(3; medioPago; Text[100])
        {
            Caption = 'Payment Method', Comment = 'ESP="Medio de pago"';
        }
        field(4; porDefecto; Boolean)
        {
            Caption = 'Default Payment Method', Comment = 'ESP="Por defecto (medio de pago)"';
        }
        field(5; bic; Text[20])
        {
            Caption = 'BIC', Comment = 'ESP="BIC"';
        }
        field(6; codigoPais; Text[5])
        {
            Caption = 'Country Code', Comment = 'ESP="Código país"';
        }
        field(7; digitoControlIban; Text[5])
        {
            Caption = 'IBAN Check Digit', Comment = 'ESP="Dígito control IBAN"';
        }
        field(8; entidad; Text[10])
        {
            Caption = 'Entity', Comment = 'ESP="Entidad"';
        }
        field(9; sucursal; Text[10])
        {
            Caption = 'Branch', Comment = 'ESP="Sucursal"';
        }
        field(10; digitoControl; Text[5])
        {
            Caption = 'Control Digit', Comment = 'ESP="Dígito control"';
        }
        field(11; numeroCuenta; Text[20])
        {
            Caption = 'Account Number', Comment = 'ESP="Número de cuenta"';
        }
        field(70; "Importation DateTime"; DateTime)
        {
            Caption = 'Import Date/Time', Comment = 'ESP="Fecha y hora de importación"';
        }
        field(71; Processed; Boolean)
        {
            Caption = 'Processed', Comment = 'ESP="Procesado"';
        }
    }

    keys
    {
        key(PK; personaId, pagadorMedioPagoId) { Clustered = true; }
    }
}