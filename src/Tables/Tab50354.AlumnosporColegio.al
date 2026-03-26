table 50354 "Alumnos por Colegio"
{
    DataPerCompany = true;

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
        field(3; "Año"; Integer)
        {
            Caption = 'Year', Comment = 'ESP="Año"';
        }
        field(4; "Nº Alumnos"; Integer)
        {
            Caption = 'No. of Students', Comment = 'ESP="Nº Alumnos"';
        }
        field(5; m2; Decimal)
        {
            Caption = 'Square meters', Comment = 'ESP="m2"';
        }
        field(6; "Año Construccion"; Integer)
        {
            Caption = 'Construction Year', Comment = 'ESP="Año Construcción"';
        }
    }

    keys
    {
        key(Key1; "ID Colegio", "Año")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
