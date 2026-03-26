tableextension 50035 "Sales Cr.Memo Line Ext" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50110; "IRPF Posting Group"; Code[10])
        {
            Caption = 'IRPF Posting Group', Comment = 'ESP="Grupo registro IRPF"';
            TableRelation = "Grupo registro retención"."Cód. grupo";
        }
        field(50120; "IRPF Line"; Boolean)
        {
            Caption = 'IRPF Line', Comment = 'ESP="Línea IRPF"';
        }
    }
}
