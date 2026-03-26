table 50100 "Empresas configuradas"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Company Name"; Text[250])
        {
            Caption = 'Company Name', Comment = 'ESP="Nombre empresa"';
            TableRelation = Company;
        }
        field(2; "Set up"; Boolean)
        {
            Caption = 'Set up', Comment = 'ESP="Configurado"';
        }
    }

    keys
    {
        key(Key1; "Company Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
