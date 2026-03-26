table 50121 "BalanceSituacion Niveles"
{
    fields
    {
        field(1; "Nivel 1"; Text[80])
        {
            Caption = 'Level 1', Comment = 'ESP="Nivel 1"';
        }
        field(2; "Nivel 2"; Text[80])
        {
            Caption = 'Level 2', Comment = 'ESP="Nivel 2"';
        }
        field(3; "Nivel 3"; Text[80])
        {
            Caption = 'Level 3', Comment = 'ESP="Nivel 3"';
        }
        field(4; "Nivel 4"; Text[80])
        {
            Caption = 'Level 4', Comment = 'ESP="Nivel 4"';
        }
        field(5; "Nivel 5"; Text[80])
        {
            Caption = 'Level 5', Comment = 'ESP="Nivel 5"';
        }
        field(6; Cuenta; Text[160])
        {
            Caption = 'Account', Comment = 'ESP="Cuenta"';
        }
        field(7; "Signo contrario"; Boolean)
        {
            Caption = 'Reverse Sign', Comment = 'ESP="Signo contrario"';
        }
        field(8; Muestra; Integer)
        {
            Caption = 'Display', Comment = 'ESP="Muestra"';
        }
    }

    keys
    {
        key(Key1; "Nivel 1", "Nivel 2", "Nivel 3", "Nivel 4", "Nivel 5")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
