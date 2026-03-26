table 50123 DimensionTable
{
    fields
    {
        field(1; Id; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID', Comment = 'ESP="Identificador"';
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code', Comment = 'ESP="Código"';
        }
        field(3; Name; Text[60])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(4; Company; Code[30])
        {
            Caption = 'Company', Comment = 'ESP="Empresa"';
        }
        field(5; "End Total"; Text[30])
        {
            Caption = 'End Total', Comment = 'ESP="Total final"';
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
