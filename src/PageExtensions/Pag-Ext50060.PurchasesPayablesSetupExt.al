pageextension 50060 "Purchases & Payables Setup Ext" extends "Purchases & Payables Setup"
{
    // //Mod. S2G
    // //campos nuevos
    //   "Retention Jnl. Template"
    //   "Retention Jnl. Batch"
    //   "Número serie Liquidación IRPF"
    //   "Obligatoriedad claves"
    //   "Banco previsto por defecto"

    layout
    {
        addafter("Default Accounts")
        {
            group(Retentions)
            {
                Caption = 'Retentions', Comment = 'ESP="Retenciones"';
                field("Retention Jnl. Template"; Rec."Retention Jnl. Template")
                {
                    ApplicationArea = All;
                }
                field("Retention Jnl. Batch"; Rec."Retention Jnl. Batch")
                {
                    ApplicationArea = All;
                }
                field("Número serie Liquidación IRPF"; Rec."Número serie Liquidación IRPF")
                {
                    ApplicationArea = All;
                }
                field("Obligatoriedad claves"; Rec."Obligatoriedad claves")
                {
                    ApplicationArea = All;
                }
                field("Banco previsto por defecto"; Rec."Banco previsto por defecto")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
