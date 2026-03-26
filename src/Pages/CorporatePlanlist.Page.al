page 50042 "Corporate Plan list"
{
    // // Mod. S2G 16/12/2017(JGS) : GF-001 : Plan de cuentas corporativo

    Caption = 'Corporate Plan List', Comment = 'ESP="Lista plan corporativo"';
    CardPageID = "Corporate Plan Card";
    DataCaptionFields = "Search Name";
    Editable = false;
    PageType = Card;
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
                field("Descripción amplia"; Rec."Descripción amplia")
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
                }
                field("Direct Posting"; Rec."Direct Posting")
                {
                }
                field("Income Stmt. Bal. Acc."; Rec."Income Stmt. Bal. Acc.")
                {
                }
                field("Cost Type No."; Rec."Cost Type No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("A&ccount")
            {
                Caption = 'Account', Comment = 'ESP="Cuenta"';
                action(Card)
                {
                    Caption = 'Card', Comment = 'ESP="Ficha"';
                    Image = EditLines;
                    RunObject = Page "Corporate Plan Card";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F5';
                }
                action("Mapping cuenta grupo")
                {
                    Caption = 'Group account mapping', Comment = 'ESP="Mapeo de cuenta de grupo"';
                    Image = RoutingVersions;
                    Promoted = true;
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
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        NoOnFormat;
        NameOnFormat;
    end;

    var
        "No.Emphasize": Boolean;
        NameEmphasize: Boolean;
        NameIndent: Integer;

    procedure SetSelection(var GLAcc: Record "Plan Corporativo")
    begin
        CurrPage.SETSELECTIONFILTER(GLAcc);
    end;

    procedure GetSelectionFilter(): Code[80]
    var
        GLAcc: Record "Plan Corporativo";
        FirstAcc: Text[20];
        LastAcc: Text[20];
        SelectionFilter: Code[80];
        GLAccCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(GLAcc);
        GLAcc.SETCURRENTKEY("No.");
        GLAccCount := GLAcc.COUNT;
        IF GLAccCount > 0 THEN BEGIN
            GLAcc.FIND('-');
            WHILE GLAccCount > 0 DO BEGIN
                GLAccCount := GLAccCount - 1;
                GLAcc.MARKEDONLY(FALSE);
                FirstAcc := GLAcc."No.";
                LastAcc := FirstAcc;
                More := (GLAccCount > 0);
                WHILE More DO
                    IF GLAcc.NEXT() = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT GLAcc.MARK THEN
                            More := FALSE
                        ELSE BEGIN
                            LastAcc := GLAcc."No.";
                            GLAccCount := GLAccCount - 1;
                            IF GLAccCount = 0 THEN
                                More := FALSE;
                        END;
                IF SelectionFilter <> '' THEN
                    SelectionFilter := SelectionFilter + '|';
                IF FirstAcc = LastAcc THEN
                    SelectionFilter := SelectionFilter + FirstAcc
                ELSE
                    SelectionFilter := SelectionFilter + FirstAcc + '..' + LastAcc;
                IF GLAccCount > 0 THEN BEGIN
                    GLAcc.MARKEDONLY(TRUE);
                    GLAcc.NEXT;
                END;
            END;
        END;
        EXIT(SelectionFilter);
    end;

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
