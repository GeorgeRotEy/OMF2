table 50213 "EDUCAMOS Dep. Economico"
{
    fields
    {
        field(1; personaId; Text[50])
        {
            Caption = 'Person ID', Comment = 'ESP="ID persona"';
            TableRelation = "EDUCAMOS Pagador".personaId;
        }
        field(2; dependientePersonaId; Text[50])
        {
            Caption = 'Dependent Person ID', Comment = 'ESP="ID persona dependiente"';
        }
        field(3; porDefecto; Boolean)
        {
            Caption = 'Default Dependent', Comment = 'ESP="Por defecto (dependiente)"';
        }
        field(70; "Importation DateTime"; DateTime)
        {
            Caption = 'Import Date/Time', Comment = 'ESP="Fecha y hora de importación"';
        }
        field(71; Processed; Boolean)
        {
            Caption = 'Processed', Comment = 'ESP="Procesado"';
        }
    }

    keys
    {
        key(PK; personaId, dependientePersonaId) { Clustered = true; }
    }
}
