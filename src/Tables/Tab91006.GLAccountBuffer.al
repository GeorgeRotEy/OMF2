table 91006 "G/L Account Buffer."
{
    // // Mod. S2G 16/12/2017 (JGS) : GF001 ã Plan de cuentas corporativo.

    fields
    {
        field(50000; Account; Text[250])
        {
            Caption = 'Account', Comment = 'ESP="Cuenta"';
            Description = 'GF001 Plan Corporativo';
        }
        field(50001; Name; Text[50])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
            Description = 'GF001 Plan Corporativo';
        }
    }

    keys
    {
        key(Key1; Account)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
