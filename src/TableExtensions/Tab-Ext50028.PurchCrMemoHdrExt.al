tableextension 50028 "Purch. Cr. Memo Hdr. Ext" extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(50100; "Control IRPF"; Option)
        {
            Caption = 'IRPF Control', Comment = 'ESP="Control IRPF"';
            OptionCaption = ' ,Obligatorio,Opcional';
            OptionMembers = " ",Obligatorio,Opcional;
        }
        field(50110; "Grupo registro IRPF"; Code[10])
        {
            Caption = 'IRPF Posting Group', Comment = 'ESP="Grupo registro IRPF"';
            TableRelation = IF ("Control IRPF" = FILTER(<> ' ')) "Grupo registro retención"."Cód. grupo";
        }
    }
}
