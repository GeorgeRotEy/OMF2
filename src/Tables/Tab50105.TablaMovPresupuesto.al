table 50105 TablaMovPresupuesto
{
    fields
    {
        field(1; id; Integer)
        {
            Caption = 'ID', Comment = 'ESP="Identificador"';
        }
        field(2; Empresa; Code[50])
        {
            Caption = 'Company', Comment = 'ESP="Empresa"';
        }
        field(3; Fecha; Code[10])
        {
            Caption = 'Date', Comment = 'ESP="Fecha"';
        }
        field(4; "Nº cuenta"; Code[20])
        {
            Caption = 'Account No.', Comment = 'ESP="Nº cuenta"';
        }
        field(5; Importe; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(6; "Entidad Codigo"; Code[50])
        {
            Caption = 'Entity Code', Comment = 'ESP="Entidad Código"';
        }
        field(7; Comentario; Text[250])
        {
            Caption = 'Comment', Comment = 'ESP="Comentario"';
        }
        field(8; Alumnos; Integer)
        {
            Caption = 'Students', Comment = 'ESP="Alumnos"';
        }
        field(9; "Servicio Codigo"; Code[20])
        {
            Caption = 'Service Code', Comment = 'ESP="Servicio Código"';
        }
        field(10; Date; Date)
        {
            Caption = 'Date', Comment = 'ESP="Fecha"';
        }
        field(11; Descripcion; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
    }

    keys
    {
        key(Key1; id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
