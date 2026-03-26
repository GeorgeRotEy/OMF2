pageextension 50049 "Purch. Credit Memo Stats Ext" extends "Purch. Credit Memo Statistics"
{
    layout
    {
        addafter(TotalVolume)
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
        // Mod. S2G 19/10/2016 (CSM) : GF-010 Retenciones. IRPF. begin
        CuGestionIRPF.EstadisiticasAbCompraRegIRPF(Rec, BaseIRPF, RetencionIRPF);
        // Mod. S2G 19/10/2016 (CSM) : GF-010 Retenciones. IRPF. end
    end;

    var
        CuGestionIRPF: Codeunit "Gestión IRPF";
        BaseIRPF: Decimal;
        RetencionIRPF: Decimal;
}
