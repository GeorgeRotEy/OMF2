table 50102 TablaCuentas
{
    fields
    {
        field(1; id; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID', Comment = 'ESP="Identificador"';
        }
        field(2; "Nº Cuenta"; Code[20])
        {
            Caption = 'Account No.', Comment = 'ESP="Nº Cuenta"';
        }
        field(3; Descripcion; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(4; Empresa; Code[50])
        {
            Caption = 'Company', Comment = 'ESP="Empresa"';
        }
        field(5; "Año"; Code[50])
        {
            Caption = 'Year', Comment = 'ESP="Año"';
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
