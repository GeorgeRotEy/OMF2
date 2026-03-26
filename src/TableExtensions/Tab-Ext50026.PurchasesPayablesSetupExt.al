tableextension 50026 "Purchases & Payables Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(51001; "Banco previsto por defecto"; Code[20])
        {
            Caption = 'Default Expected Bank', Comment = 'ESP="Banco previsto por defecto"';
            TableRelation = "Bank Account";
        }
        field(51009; "Número serie Liquidación IRPF"; Code[10])
        {
            Caption = 'IRPF Settlement No. Series', Comment = 'ESP="Número serie Liquidación IRPF"';
            TableRelation = "No. Series";
        }
        field(51010; "Obligatoriedad claves"; Boolean)
        {
            Caption = 'Mandatory Keys', Comment = 'ESP="Obligatoriedad claves"';
        }
        field(51011; "Retention Jnl. Template"; Code[10])
        {
            Caption = 'Retention Journal Template', Comment = 'ESP="Plantilla diario retenciones"';
            TableRelation = "Gen. Journal Template" WHERE(Type = CONST(General));
        }
        field(51012; "Retention Jnl. Batch"; Code[10])
        {
            Caption = 'Retention Journal Batch', Comment = 'ESP="Sección diario retenciones"';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Retention Jnl. Template"));
        }
    }
}
