table 50116 InformeExistencia
{
    fields
    {
        field(1; id; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID', Comment = 'ESP="Identificador"';
        }
        field(2; Empresa; Code[50])
        {
            Caption = 'Company', Comment = 'ESP="Empresa"';
        }
        field(3; "Nombre Cuenta"; Text[50])
        {
            Caption = 'Account Name', Comment = 'ESP="Nombre Cuenta"';
        }
        field(4; "Nº Cuenta"; Code[20])
        {
            Caption = 'Account No.', Comment = 'ESP="Nº Cuenta"';
        }
        field(5; "Fecha registro"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
        }
        field(6; Importe; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(7; "Nº mov"; Decimal)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº movimiento"';
        }
    }

    keys
    {
        key(Key1; id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
