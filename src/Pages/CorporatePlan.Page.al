page 50040 "Corporate Plan"
{
    // // Mod. S2G 16/12/2017 (JGS) : GF001 ã Plan de cuentas corporativo.

    Caption = 'Corporate Plan', Comment = 'ESP="Plan corporativo"';
    CardPageID = "Corporate Plan Card";
    DelayedInsert = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Plan Corporativo";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Income/Balance"; Rec."Income/Balance")
                {
                }
                field("Account Type"; Rec."Account Type")
                {
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    Visible = false;
                }
                field("Direct Posting"; Rec."Direct Posting")
                {
                }
                field(Totaling; Rec.Totaling)
                {
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLaccList: Page "Corporate Plan list";
                    begin
                        GLaccList.LOOKUPMODE(TRUE);
                        IF NOT (GLaccList.RUNMODAL() = ACTION::LookupOK) THEN
                            EXIT(FALSE)
                        ELSE
                            Text := GLaccList.GetSelectionFilter;
                        EXIT(TRUE);
                    end;
                }
                field("Consol. Debit Acc."; Rec."Consol. Debit Acc.")
                {
                }
                field("Consol. Credit Acc."; Rec."Consol. Credit Acc.")
                {
                }
                field("Income Stmt. Bal. Acc."; Rec."Income Stmt. Bal. Acc.")
                {
                    Lookup = true;
                    LookupPageID = "Corporate Plan";
                }
                field("Baja en Plan Corporativo"; Rec."Baja en Plan Corporativo")
                {
                }
                field("Cost Type No."; Rec."Cost Type No.")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        //No existe la página 51001 en producción
        // area(navigation)
        // {
        //     group("A&ccount")
        //     {
        //         Caption = 'A&ccount';
        //         action(Card)
        //         {
        //             Caption = 'Card';
        //             Image = EditLines;
        //             RunObject = Page 51001;
        //             RunPageLink = Field1 = FIELD("No.");
        //             ShortCutKey = 'Shift+F5';
        //         }
        //     }
        // }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'Functions', Comment = 'ESP="Funciones"';
                action("Indent Chart of Accounts")
                {
                    Caption = 'Indent Distribution Accounts', Comment = 'ESP="Sangrar cuentas de distribución"';
                    Image = IndentChartOfAccounts;

                    trigger OnAction()
                    begin
                        cFuncionesPLC.fIndentar();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        NoOnFormat;
        NameOnFormat;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewGLAcc(xRec, BelowxRec);
    end;

    var
        cFuncionesPLC: Codeunit "Functions S2G";
        "No.Emphasize": Boolean;
        NameEmphasize: Boolean;
        NameIndent: Integer;

    local procedure NoOnFormat()
    begin
        "No.Emphasize" := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;

    local procedure NameOnFormat()
    begin
        NameIndent := Rec.Indentation;
        NameEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;
}
