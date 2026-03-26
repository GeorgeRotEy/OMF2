tableextension 50042 "Sales Shipment Header Ext" extends "Sales Shipment Header"
{
    fields
    {
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
