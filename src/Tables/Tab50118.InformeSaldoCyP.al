table 50118 InformeSaldoCyP
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
        field(3; "Nombre Cuenta"; Text[100])
        {
            Caption = 'Account Name', Comment = 'ESP="Nombre cuenta"';
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
        field(10; "Source Description"; Text[201])
        {
            Caption = 'Source Description', Comment = 'ESP="Descripción origen"';
            Description = 'JPB';
        }
        field(11; "Cod Procedencia Mov"; Code[20])
        {
            Caption = 'Movement Source Code', Comment = 'ESP="Código procedencia movimiento"';
        }
        field(12; "Document Type"; Text[50])
        {
            Caption = 'Document Type', Comment = 'ESP="Tipo documento"';
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
