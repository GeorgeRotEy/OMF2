pageextension 50086 "Sales Return Order Ext" extends "Sales Return Order"
{
    layout
    {
        addafter("Bill-to")
        {
            group(Retenciones)
            {
                Caption = 'Retenciones';
                field("Control IRPF"; Rec."Control IRPF")
                {
                    ApplicationArea = All;
                }
                field("Grupo registro IRPF"; Rec."Grupo registro IRPF")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                // (CJ08) S2G (JDT) 25-10-19:
                Rec.fBloquearRegistro;
                // (CJ08) S2G (JDT) 25-10-19:
            end;
        }
        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            begin
                // (CJ08) S2G (JDT) 25-10-19:
                Rec.fBloquearRegistro;
                // (CJ08) S2G (JDT) 25-10-19:
            end;
        }
        modify("Post &Batch")
        {
            trigger OnBeforeAction()
            begin
                // (CJ08) S2G (JDT) 25-10-19:
                Rec.fBloquearRegistro;
                // (CJ08) S2G (JDT) 25-10-19:
            end;
        }
    }
}
