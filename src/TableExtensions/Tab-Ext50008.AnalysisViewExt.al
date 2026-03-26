tableextension 50008 "Analysis View Ext" extends "Analysis View"
{
    fields
    {
        modify("Account Filter")
        {
            TableRelation = IF ("Account Source" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Account Source" = CONST("Cash Flow Account")) "Cash Flow Account"
            ELSE IF ("Account Source" = CONST("Analytic Distribution Account")) "Schedule of Distrib. Accounts";
        }
        field(50000; "Vista analítica"; Boolean)
        {
            Caption = 'Analytical View', Comment = 'ESP="Vista analítica"';
        }
        field(50005; "Source Code"; Code[20])
        {
            Caption = 'Source Code', Comment = 'ESP="Cód. origen"';
            TableRelation = "Source Code";
        }
        field(50006; "Source Code Filter"; Code[20])
        {
            Caption = 'Source Code Filter', Comment = 'ESP="Filtro cód. origen"';
            FieldClass = FlowFilter;
            TableRelation = "Source Code";
        }
    }
}