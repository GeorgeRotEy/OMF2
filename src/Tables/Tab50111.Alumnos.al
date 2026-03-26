table 50111 Alumnos
{
    fields
    {
        field(1; "ID Alumno"; Text[50])
        {
            Caption = 'Student ID', Comment = 'ESP="ID Alumno"';
        }
        field(2; "ID Colegio"; Text[50])
        {
            Caption = 'School ID', Comment = 'ESP="ID Colegio"';
        }
        field(3; "Etapa educativa"; Text[50])
        {
            Caption = 'Educational Stage', Comment = 'ESP="Etapa educativa"';
        }
        field(4; ID; Integer)
        {
            Caption = 'ID', Comment = 'ESP="Identificador"';
        }
    }

    keys
    {
        key(Key1; "ID Alumno")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
