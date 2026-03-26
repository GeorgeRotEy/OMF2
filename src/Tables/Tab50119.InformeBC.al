table 50119 InformeBC
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
        field(3; "Nombre Cuenta"; Text[50])
        {
            Caption = 'Account Name', Comment = 'ESP="Nombre cuenta"';
        }
        field(4; "Nº Cuenta"; Code[20])
        {
            Caption = 'Account No.', Comment = 'ESP="Nº cuenta"';
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
        field(8; "Source Type"; Option)
        {
            Caption = 'Source Type', Comment = 'ESP="Tipo origen"';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(9; "Source No."; Code[20])
        {
            Caption = 'Source No.', Comment = 'ESP="Nº origen"';
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE IF ("Source Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(10; "Source Description"; Text[101])
        {
            Caption = 'Source Description', Comment = 'ESP="Descripción origen"';
            Description = 'JPB';
        }
        field(11; "Main Bank"; Text[50])
        {
            Caption = 'Main Bank', Comment = 'ESP="Banco principal"';
            FieldClass = Normal;
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
