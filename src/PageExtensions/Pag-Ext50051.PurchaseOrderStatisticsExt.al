pageextension 50051 "Purchase Order Statistics Ext" extends "Purchase Order Statistics"
{
    layout
    {
        addafter(NoOfVATLines_General)
        {
            field(RetencionIRPF; RetencionIRPF)
            {
                AutoFormatExpression = Rec."Currency Code";
                AutoFormatType = 1;
                Caption = 'Retención IRPF';
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
        CuGestionIRPF.EstadisiticasIRPF(Rec, BaseIRPF, RetencionIRPF);
        // <<
    end;

    var
        CuGestionIRPF: Codeunit "Gestión IRPF";
        BaseIRPF: Decimal;
        RetencionIRPF: Decimal;
}
