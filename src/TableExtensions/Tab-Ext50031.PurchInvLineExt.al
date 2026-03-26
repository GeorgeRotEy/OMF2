tableextension 50031 "Purch. Inv. Line Ext" extends "Purch. Inv. Line"
{
    fields
    {
        field(50110; "Grupo registro IRPF"; Code[10])
        {
            Caption = 'IRPF Posting Group', Comment = 'ESP="Grupo registro IRPF"';
            TableRelation = "Grupo registro retención"."Cód. grupo";
        }
        field(50120; "Línea IRPF"; Boolean)
        {
            Caption = 'IRPF Line', Comment = 'ESP="Linea IRPF"';
        }
    }
}
