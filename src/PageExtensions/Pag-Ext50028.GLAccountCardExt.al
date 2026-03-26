pageextension 50028 "G/L Account Card Ext" extends "G/L Account Card"
{
    // Mod. S2G 16/12/2017 (JGS) : GF001 � Plan de cuentas corporativo.
    // Mod. S2G (RBM-R) GF-007: Control Presupuestario

    layout
    {
        addafter(Totaling)
        {
            field("Cod retencion"; Rec."Cod retencion")
            {
                ApplicationArea = All;
            }
        }
        addafter(Blocked)
        {
            field("Baja en Plan Corporativo"; Rec."Baja en Plan Corporativo")
            {
                ApplicationArea = All;
            }
        }
        addafter("Omit Default Descr. in Jnl.")
        {
            field("Budget Control Not Applied"; Rec."Budget Control Not Applied")
            {
                ApplicationArea = All;
            }
        }
    }
}
