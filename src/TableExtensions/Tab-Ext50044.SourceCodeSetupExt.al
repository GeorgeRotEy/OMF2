tableextension 50044 "Source Code Setup Ext" extends "Source Code Setup"
{
    fields
    {
        field(50000; "Analytic Distribution"; Code[10])
        {
            Caption = 'Analytic Distribution', Comment = 'ESP="Distribución analítica"';
            TableRelation = "Source Code";
        }
        field(50001; "Distribution Allocation"; Code[10])
        {
            Caption = 'Distribution Allocation', Comment = 'ESP="Asignación distribución"';
            TableRelation = "Source Code";
        }
        field(50002; "Easy Register Journal"; Code[10])
        {
            Caption = 'Cash Register Journal', Comment = 'ESP="Diario registro simplificado"';
            TableRelation = "Source Code";
        }
        field(51000; "Retention Application"; Code[10])
        {
            Caption = 'Retention Application', Comment = 'ESP="Aplicación retenciones"';
            TableRelation = "Source Code";
        }
    }
}
