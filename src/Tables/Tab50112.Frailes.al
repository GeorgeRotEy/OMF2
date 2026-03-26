table 50112 Frailes
{
    DataPerCompany = false;

    fields
    {
        field(1; "ID Hermano"; Code[20])
        {
            Caption = 'Friar ID', Comment = 'ESP="ID Hermano"';
        }
        field(2; Fraternidad; Text[50])
        {
            Caption = 'Fraternity', Comment = 'ESP="Fraternidad"';
        }
        field(3; Inicio; Date)
        {
            Caption = 'Start Date', Comment = 'ESP="Inicio"';
        }
        field(4; Final; Date)
        {
            Caption = 'End Date', Comment = 'ESP="Final"';
        }
    }

    keys
    {
        key(Key1; "ID Hermano")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
