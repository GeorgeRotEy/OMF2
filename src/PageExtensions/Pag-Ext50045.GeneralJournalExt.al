pageextension 50045 "General Journal Ext" extends "General Journal"
{
    // Mod. S2G (RBM-R) GF-007: Control Presupuestario

    //   (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple

    //   (SIDS-466) S2G (LAG): Mod dimension acceso directo:
    //     -Cambiamos Propiedad visible a TRUE de los siguientes campos:
    //       -ShortcutDimCode[3]
    //       -ShortcutDimCode[4]
    //       -ShortcutDimCode[5]
    //       -ShortcutDimCode[6]

    layout
    {
        modify(ShortcutDimCode3)
        {
            Visible = true;
        }
        modify(ShortcutDimCode4)
        {
            Visible = true;
        }
        modify(ShortcutDimCode5)
        {
            Visible = true;
        }
        modify(ShortcutDimCode6)
        {
            Visible = true;
        }
        addafter(Description)
        {
            field("Posting concept"; Rec."Posting concept")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(DeferralSchedule)
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