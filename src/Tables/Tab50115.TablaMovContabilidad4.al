table 50115 TablaMovContabilidad4
{
    // Table que se usa para el informe de power Bi:Aportación de Fondo Comun.
    // Page a la que se refiere: MovContabilidad4.
    // Campos a utilizar: Empresa, NºCuenta, Fecha registro, Importe, Entidad Codigo y Actividad codigo

    DataPerCompany = false;

    fields
    {
        field(1; id; Integer)
        {
            AutoIncrement = true;
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
        field(8; "Entidad Codigo"; Code[20])
        {
            Caption = 'Entity Code', Comment = 'ESP="Entidad Código"';
        }
        field(9; "Actividad Codigo"; Code[20])
        {
            Caption = 'Activity Code', Comment = 'ESP="Actividad Código"';
        }
        field(10; "Servicio Codigo"; Code[20])
        {
            Caption = 'Service Code', Comment = 'ESP="Servicio Código"';
        }
        field(11; Descripcion; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(12; "Etapa Codigo"; Code[20])
        {
            Caption = 'Stage Code', Comment = 'ESP="Etapa Código"';
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
