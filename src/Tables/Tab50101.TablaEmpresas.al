table 50101 TablaEmpresas
{
    fields
    {
        field(1; Empresa; Text[80])
        {
            Caption = 'Company', Comment = 'ESP="Empresa"';
        }
    }

    keys
    {
        key(Key1; Empresa)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
