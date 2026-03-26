tableextension 50039 "Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "VAT Registration Noº"; Code[20])
        {
            Caption = 'VAT Registration Noº', Comment = 'ESP="Nº registro IVA"';
            CalcFormula = Lookup(Customer."VAT Registration No." WHERE("No." = FIELD("Bill-to Customer No.")));
            FieldClass = FlowField;
        }
        field(50001; Email; Text[100])
        {
            Caption = 'Email', Comment = 'ESP="Email"';
            CalcFormula = Lookup(Customer."E-Mail" WHERE("No." = FIELD("Bill-to Customer No.")));
            FieldClass = FlowField;
        }
        field(50002; "Bank of collection"; Code[50])
        {
            Caption = 'Bank of Collection', Comment = 'ESP="Banco de cobro"';
            TableRelation = "Bank Account".IBAN;
        }
        field(50100; "Control IRPF"; Option)
        {
            Caption = 'IRPF Control', Comment = 'ESP="Control IRPF"';
            OptionCaption = ' ,Obligatorio,Opcional';
            OptionMembers = " ",Obligatorio,Opcional;
        }
        field(50101; "Grupo registro IRPF"; Code[10])
        {
            Caption = 'IRPF Posting Group', Comment = 'ESP="Grupo registro IRPF"';
            TableRelation = IF ("Control IRPF" = FILTER(<> ' ')) "Grupo registro retención"."Cód. grupo";
        }
    }
}
