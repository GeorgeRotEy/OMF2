tableextension 50348 "Dimension Ext" extends Dimension
{
    fields
    {
        field(50000; Distribution; Boolean)
        {
            Caption = 'Distribution', Comment = 'ESP="Distribución"';
        }
        field(50001; "Do not split if assigned"; Boolean)
        {
            Caption = 'Do not split if assigned', Comment = 'ESP="No dividir si está asignado"';
        }
        field(50002; "Easy Register Dimension"; Boolean)
        {
            Caption = 'Easy Register Dimension', Comment = 'ESP="Dimensión Registro Simple"';

            trigger OnValidate()
            begin
                rDimension.Reset();
                rDimension.SetFilter(Code, '<>%1', Code);
                rDimension.SetRange("Easy Register Dimension", true);

                if rDimension.FindFirst() then
                    Error(Error001, rDimension.Code);
            end;
        }
    }

    var
        rDimension: Record Dimension;
        Error001: Label 'Ya existe una dimensión marcada como de Registro Simple (%1)', Comment = 'ESP="Ya existe una dimensión marcada como de Registro Simple (%1)"';
}