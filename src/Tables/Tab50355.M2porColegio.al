table 50355 "M2 por Colegio"
{
    fields
    {
        field(1; "ID Colegio"; Integer)
        {
            Caption = 'School ID', Comment = 'ESP="ID Colegio"';
        }
        field(2; Empresa; Text[30])
        {
            Caption = 'Company', Comment = 'ESP="Empresa"';
        }
        field(3; m2; Decimal)
        {
            Caption = 'Square meters', Comment = 'ESP="m2"';
        }
        field(4; "Año construccion"; Integer)
        {
            Caption = 'Construction Year', Comment = 'ESP="Año construcción"';
        }
    }

    keys
    {
        key(Key1; "ID Colegio")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
