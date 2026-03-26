table 50114 Entidades
{
    // Table que se usa para el informe de power Bi:Aportación de Fondo Comun.
    // Page a la que se refiere: Entidad.
    // Campos a utilizar: Codigo y Nombre

    fields
    {
        field(1; Id; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID', Comment = 'ESP="Identificador"';
        }
        field(2; Codigo; Code[20])
        {
            Caption = 'Code', Comment = 'ESP="Código"';
        }
        field(3; Nombre; Text[50])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
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
