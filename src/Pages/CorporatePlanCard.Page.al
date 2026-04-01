page 50041 "Corporate Plan Card"
{
    // // Mod. S2G 16/12/2017 (JGS) : GF001 ã Plan de cuentas corporativo.

    Caption = 'Corporate Plan Card', Comment = 'ESP="Ficha plan corporativo"';
    DelayedInsert = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Plan Corporativo";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';

                field("No."; Rec."No.")
                {
                }
                field("Descripción amplia"; Rec."Descripción amplia")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Income/Balance"; Rec."Income/Balance")
                {
                }
                field("Debit/Credit"; Rec."Debit/Credit")
                {
                }
                field("Account Type"; Rec."Account Type")
                {
                }
                field(Totaling; Rec.Totaling)
                {
                }
                field("Search Name"; Rec."Search Name")
                {
                }
                field("Baja en Plan Corporativo"; Rec."Baja en Plan Corporativo")
                {
                }
                field("Direct Posting"; Rec."Direct Posting")
                {
                }
                field("Income Stmt. Bal. Acc."; Rec."Income Stmt. Bal. Acc.")
                {
                    Lookup = true;
                    LookupPageID = "Corporate Plan";
                }
            }
            group(Posting)
            {
                Caption = 'Posting', Comment = 'ESP="Registro"';

                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                }
            }
            group(Consolidation)
            {
                Caption = 'Consolidation', Comment = 'ESP="Consolidación"';

                field("Consol. Debit Acc."; Rec."Consol. Debit Acc.")
                {
                }
                field("Consol. Credit Acc."; Rec."Consol. Credit Acc.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Mapping cuenta grupo")
            {
                Caption = 'Group Account Mapping', Comment = 'ESP="Mapeo de cuenta de grupo"';
                Image = RoutingVersions;
                Visible = false;

                trigger OnAction()
                begin
                    //NameDataTypeSubtypeLength
                    //clMappingCodeunitCodeunit50151
                    //(MAP)
                    //CLEAR(clMapping);
                    //clMapping.fAbrirPaginaCuentaGrupo(0,"No.");
                end;
            }
        }
        area(Promoted)
        {
            group(Process)
            {
                Caption = 'Process', Comment = 'ESP="Procesar"';

                actionref(GroupAccountMapping_Promoted; "Mapping cuenta grupo")
                {
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewGLAcc(xRec, BelowxRec);
    end;
}