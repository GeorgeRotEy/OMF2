table 50104 TablaMovContabilidad
{
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
        field(11; Descripcion; Text[50])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(12; "Etapa Codigo"; Code[20])
        {
            Caption = 'Stage Code', Comment = 'ESP="Etapa Código"';
        }
        field(13; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(14; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE IF ("Source Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(15; "Source Description"; Text[101])
        {
            Caption = 'Source Description';
            Description = 'JPB';
        }
        field(16; "Account Name"; Text[101])
        {
            Caption = 'Account Name';
            Description = 'JPB';
        }
        field(17; "Entidad Nombre"; Text[100])
        {
            Caption = 'Entity Name', Comment = 'ESP="Entidad Nombre"';
        }
    }

    keys
    {
        key(Key1; id)
        {
            Clustered = true;
        }
        key(Key2; Empresa, "Nº mov")
        {
        }
    }

    fieldgroups
    {
    }
}
