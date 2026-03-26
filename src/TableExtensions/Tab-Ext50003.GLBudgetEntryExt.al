tableextension 50003 "G/L Budget Entry Ext" extends "G/L Budget Entry"
{
    fields
    {
        field(50000; "Budget Comment"; Text[250])
        {
            Caption = 'Budget Comment',
            Comment = 'ESP="Comentario de presupuesto"';
        }
        field(50001; "Power BI"; Boolean)
        {
            Caption = 'Power BI',
            Comment = 'ESP="Presupuesto está disponible para Power BI"';
            TableRelation = "G/L Budget Name"."Power BI";
        }
    }
}
