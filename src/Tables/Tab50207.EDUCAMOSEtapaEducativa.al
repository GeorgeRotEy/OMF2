table 50207 "EDUCAMOS EtapaEducativa" //EDUCAMOS
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    DataPerCompany = false;

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
    }

    keys
    {
        key(Key1; "ID Alumno", "ID Colegio")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
