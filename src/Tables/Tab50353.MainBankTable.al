table 50353 "Main Bank Table"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Main Bank"; Text[50])
        {
            Caption = 'Main Bank', Comment = 'ESP="Banco Principal"';
        }
    }

    keys
    {
        key(Key1; "Main Bank")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
