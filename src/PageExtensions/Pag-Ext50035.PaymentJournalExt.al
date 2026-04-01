pageextension 50035 "Payment Journal Ext" extends "Payment Journal"
{
    // Mod. S2G (RBM-R) GF-007: Control Presupuestario
    //   KPMG DPM 310522 Sacampos "Posting concept"
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field("Posting concept"; Rec."Posting concept")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(Comment)
        {
            action("Desbloquear operación")
            {
                Caption = 'Unlock Operation', Comment = 'ESP="Desbloquear operación"';
                Image = Approve;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Inicio
                    CLEAR(rBudgetControlSetup);
                    vDimkey[1] := Rec."Journal Template Name";
                    vDimkey[2] := Rec."Journal Batch Name";
                    vDimkey[3] := FORMAT(Rec."Line No.");
                    rBudgetControlSetup.fUnblockPosting(1, vDimkey);
                    //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Fin
                end;
            }
        }
        addlast(Promoted)
        {
            group(Process)
            {
                Caption = 'Process', Comment = 'ESP="Procesar"';

                actionref(UnlockOperation_Promoted; "Desbloquear operación")
                {
                }
            }
        }
    }

    var
        rBudgetControlSetup: Record "Budget Control Setup";
        vDimkey: array[3] of Text;
}