pageextension 50076 "Purchase Credit Memo Ext" extends "Purchase Credit Memo"
{
    //Mod. S2G (RBM-R) GF-007: Control Presupuestario

    layout
    {
        addafter("Pay-to")
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
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                // (CJ08) S2G (JDT) 25-10-19:
                Rec.fBloquearRegistro;
                // (CJ08) S2G (JDT) 25-10-19:
            end;
        }
        addafter(Comment)
        {
            action("Desbloquear operación")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Inicio
                    CLEAR(rBudgetControlSetup);
                    //vDimkey[1] := FORMAT("Document Type");
                    CASE Rec."Document Type".AsInteger() OF
                        0:
                            vDimkey[1] := FORMAT(0);
                        1:
                            vDimkey[1] := FORMAT(1);
                        2:
                            vDimkey[1] := FORMAT(2);
                        3:
                            vDimkey[1] := FORMAT(3);
                        4:
                            vDimkey[1] := FORMAT(4);
                        5:
                            vDimkey[1] := FORMAT(5);
                        6:
                            vDimkey[1] := FORMAT(6);
                    END;
                    vDimkey[2] := Rec."No.";
                    vDimkey[3] := '';
                    rBudgetControlSetup.fUnblockPosting(3, vDimkey);
                    //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Fin
                end;
            }
        }
    }

    var
        rBudgetControlSetup: Record "Budget Control Setup";
        vDimkey: array[3] of Text;
}
