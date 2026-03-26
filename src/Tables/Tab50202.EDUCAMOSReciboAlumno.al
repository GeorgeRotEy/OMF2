table 50202 "EDUCAMOS ReciboAlumno" //EDUCAMOS
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    fields
    {
        field(1; id_recibo; Text[30])
        {
            Caption = 'Receipt ID', Comment = 'ESP="Id recibo"';
        }
        field(2; id_unique_recibo; Text[50])
        {
            Caption = 'Unique Receipt ID', Comment = 'ESP="Id único recibo"';
        }
        field(3; id_alumno; Text[30])
        {
            Caption = 'Student ID', Comment = 'ESP="Id alumno"';
        }
        field(4; id_unique_alumno; Text[50])
        {
            Caption = 'Unique Student ID', Comment = 'ESP="Id único alumno"';
        }
        field(5; nombre_alumno; Text[250])
        {
            Caption = 'Student Name', Comment = 'ESP="Nombre alumno"';
        }
        field(6; ape1_alumno; Text[250])
        {
            Caption = 'Student First Surname', Comment = 'ESP="Primer apellido alumno"';
        }
        field(7; ape2_alumno; Text[250])
        {
            Caption = 'Student Second Surname', Comment = 'ESP="Segundo apellido alumno"';
        }
        field(8; nif_alumno; Text[50])
        {
            Caption = 'Student Tax ID', Comment = 'ESP="NIF alumno"';
        }
        field(30; "Importation DateTime"; DateTime)
        {
            Caption = 'Import Date/Time', Comment = 'ESP="Fecha y hora de importación"';
        }
        field(31; Processed; Boolean)
        {
            Caption = 'Processed', Comment = 'ESP="Procesado"';
        }
    }

    keys
    {
        key(Key1; id_unique_recibo, id_unique_alumno)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
