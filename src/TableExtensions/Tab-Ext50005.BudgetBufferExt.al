tableextension 50005 "Budget Buffer Ext" extends "Budget Buffer"
{
    fields
    {
        field(50000; "Budget Comment"; Text[249])
        {
            Caption = 'Budget Comment', Comment = 'ESP="Comentario presupuesto"';
        }
        field(50001; "Last Year Budget"; Decimal)
        {
            Caption = 'Previous Year Budget', Comment = 'ESP="Presupuesto último año"';
        }
        field(50002; "Last Year Real"; Decimal)
        {
            Caption = 'Previous Year Actual', Comment = 'ESP="Real último año"';
        }
    }
}
