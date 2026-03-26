table 50204 "EDUCAMOS Integration Log" //EDUCAMOS
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    fields
    {
        field(1; "Entry no."; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº mov."';
        }
        field(2; "Log Status"; Option)
        {
            Caption = 'Log Status', Comment = 'ESP="Estado Log"';
            OptionMembers = " ",OK,Warning,Error;
        }
        field(3; "Log Text"; Text[250])
        {
            Caption = 'Log Description', Comment = 'ESP="Descripción"';
        }
        field(4; "Process DateTime"; DateTime)
        {
            Caption = 'Process DateTime', Comment = 'ESP="FechaHora proceso"';
        }
        field(5; "Extra info"; Text[250])
        {
            Caption = 'Extra Information', Comment = 'ESP="Información extra"';
        }
        field(6; Indentation; Integer)
        {
            Caption = 'Indentation', Comment = 'ESP="Indentación"';
        }
        field(7; "Errores Name"; Text[50])
        {
            Caption = 'Error Name', Comment = 'ESP="Nombre del error"';
        }
        field(8; "Errores Doc"; BLOB)
        {
            Caption = 'Error Document', Comment = 'ESP="Documento de error"';
        }
    }

    keys
    {
        key(Key1; "Entry no.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Entry no." := 1;
        IF xRec.FINDLAST THEN
            "Entry no." := xRec."Entry no." + 1;
    end;
}
