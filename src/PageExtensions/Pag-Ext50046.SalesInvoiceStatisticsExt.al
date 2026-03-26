pageextension 50046 "Sales Invoice Statistics Ext" extends "Sales Invoice Statistics"
{
    layout
    {
        addafter("TotalAdjCostLCY - CostLCY")
        {
            field(RetencionIRPF; RetencionIRPF)
            {
                AutoFormatExpression = Rec."Currency Code";
                AutoFormatType = 1;
                Caption = 'Retencion IRPF';
                Editable = false;
                ApplicationArea = All;
            }
            field(BaseIRPF; BaseIRPF)
            {
                AutoFormatExpression = Rec."Currency Code";
                AutoFormatType = 1;
                Caption = 'Base IRPF';
                Editable = false;
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // << IRPF
        CuGestionIRPF.EstadisiticasFactVentaRegIRPF(Rec, BaseIRPF, RetencionIRPF);
        // <<
    end;

    var
        CuGestionIRPF: Codeunit "Gestión IRPF";
        BaseIRPF: Decimal;
        RetencionIRPF: Decimal;
}
