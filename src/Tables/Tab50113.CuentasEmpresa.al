table 50113 "Cuentas Empresa"
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
        field(3; "Nº Cuenta"; Code[20])
        {
            Caption = 'Account No.', Comment = 'ESP="Nº Cuenta"';
        }
        field(4; Descripcion; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(5; "Año"; Code[10])
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
