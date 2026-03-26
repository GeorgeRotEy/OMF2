tableextension 50024 "Purchase Line Archive Ext" extends "Purchase Line Archive"
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
            Caption = 'IRPF Line', Comment = 'ESP="Línea IRPF"';
        }
    }
}