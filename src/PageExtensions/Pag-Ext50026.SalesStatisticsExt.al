pageextension 50026 "Sales Statistics Ext" extends "Sales Statistics"
{
    layout
    {
        addafter("TotalAdjCostLCY - TotalSalesLineLCY.""Unit Cost (LCY)""")
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
        CuGestionIRPF.EstadisiticasIRPFVtas(Rec, BaseIRPF, RetencionIRPF);
        // <<
    end;

    var
        CuGestionIRPF: Codeunit "Gestión IRPF";
        BaseIRPF: Decimal;
        RetencionIRPF: Decimal;
}
