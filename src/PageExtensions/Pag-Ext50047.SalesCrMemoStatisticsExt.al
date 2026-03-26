pageextension 50047 "Sales Cr. Memo Statistics Ext" extends "Sales Credit Memo Statistics"
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
        // >> IRPF
        CuGestionIRPF.EstadisiticasAbVentaRegIRPF(Rec, BaseIRPF, RetencionIRPF);
        // <<
    end;

    var
        CuGestionIRPF: Codeunit "Gestión IRPF";
        BaseIRPF: Decimal;
        RetencionIRPF: Decimal;
}
