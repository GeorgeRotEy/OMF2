table 50206 "EDUCAMOS Input Data" //EDUCAMOS
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº mov."';
        }
        field(2; "Importation DateTime"; DateTime)
        {
            Caption = 'Importation DateTime', Comment = 'ESP="FechaHora importación"';
        }
        field(3; Content; BLOB)
        {
            Caption = 'Content', Comment = 'ESP="Contenido"';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
