tableextension 50349 "Dimension Value Ext" extends "Dimension Value"
{
    fields
    {
        field(50000; "Easy Register Dimension"; Boolean)
        {
            Caption = 'Easy Register Dimension', Comment = 'ESP="Dimensión Registro Simple"';
            FieldClass = FlowField;
            CalcFormula = lookup(Dimension."Easy Register Dimension"
                                 where(Code = field("Dimension Code")));
        }
    }
}
