table 50110 TablaMovPresupuestoCur
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
        field(7; Descripcion; Text[50])
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
