table 50109 TablaMovContabilidadCur
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
        field(3; "Nº mov"; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº movimiento"';
        }
        field(4; "Nº Cuenta"; Code[20])
        {
            Caption = 'Account No.', Comment = 'ESP="Nº Cuenta"';
        }
        field(5; "Fecha registro"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
        }
        field(6; Importe; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(7; Fecha2; Code[20])
        {
            Caption = 'Secondary Date', Comment = 'ESP="Fecha 2"';
        }
        field(8; Descripcion; Text[50])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(9; "Entidad Codigo"; Code[50])
        {
            Caption = 'Entity Code', Comment = 'ESP="Entidad Código"';
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
