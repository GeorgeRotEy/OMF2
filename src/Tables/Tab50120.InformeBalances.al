table 50120 InformeBalances
{
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
        field(3; Descripcion; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
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
        field(7; "Nº mov"; Decimal)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº movimiento"';
        }
        field(8; "Account Name"; Text[30])
        {
            Caption = 'Account Name', Comment = 'ESP="Nombre cuenta"';
        }
        field(9; "Debe Amount"; Decimal)
        {
            Caption = 'Debit Amount', Comment = 'ESP="Importe debe"';
        }
        field(10; "Haber Amount"; Decimal)
        {
            Caption = 'Credit Amount', Comment = 'ESP="Importe haber"';
        }
        field(11; "Business Unit Code"; Code[50])
        {
            Caption = 'Business Unit Code', Comment = 'ESP="Cód. unidad de negocio"';
        }
        field(12; "Actividad Codigo"; Code[20])
        {
            Caption = 'Activity Code', Comment = 'ESP="Actividad Código"';
        }
        field(13; "Entidad Codigo"; Code[20])
        {
            Caption = 'Entity Code', Comment = 'ESP="Entidad Código"';
        }
        field(14; "Entidad Nombre"; Text[50])
        {
            Caption = 'Entity Name', Comment = 'ESP="Entidad Nombre"';
        }
        field(15; "Actividad Nombre"; Text[50])
        {
            Caption = 'Activity Name', Comment = 'ESP="Actividad Nombre"';
        }
        field(16; "Servicio Codigo"; Code[20])
        {
            Caption = 'Service Code', Comment = 'ESP="Servicio Código"';
        }
        field(17; "Servicio Nombre"; Text[50])
        {
            Caption = 'Service Name', Comment = 'ESP="Servicio Nombre"';
        }
        field(18; Astoregul; Text[30])
        {
            Caption = 'Auto Posting Group', Comment = 'ESP="Astoregul"';
        }
    }

    keys
    {
        key(Key1; id, Empresa)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
