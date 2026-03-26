table 50352 "CCC Cod. Bancos"
{
    DataPerCompany = false;

    fields
    {
        field(1; "CCC Bank No."; Text[4])
        {
            Caption = 'CCC Bank No.', Comment = 'ESP="CCC Banco"';
        }
        field(2; Alias; Code[50])
        {
            Caption = 'Alias', Comment = 'ESP="Alias"';
        }
    }

    keys
    {
        key(Key1; "CCC Bank No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "CCC Bank No.", Alias)
        {
        }
    }
}
