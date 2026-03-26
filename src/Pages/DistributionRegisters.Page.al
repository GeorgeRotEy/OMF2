page 50028 "Distribution Registers"
{
    Caption = 'Distribution Registers', Comment = 'ESP="Registros distribución"';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Distribution Registers";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("From Entry No."; Rec."From Entry No.")
                {
                }
                field("To Entry No."; Rec."To Entry No.")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Source code"; Rec."Source code")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field(Reversed; Rec.Reversed)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Entry")
            {
                Caption = 'Entry', Comment = 'ESP="Entrada"';
                Image = Entry;
                action("&Distribution Entries")
                {
                    Caption = 'Distribution Entries', Comment = 'ESP="Entradas de distribución"';
                    Image = CostEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunPageOnRec = true;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    var
                        rDistributionEntry: Record "Distribution Entry";
                    begin
                        rDistributionEntry.RESET();
                        rDistributionEntry.SETCURRENTKEY("Transaction No.");
                        rDistributionEntry.SETRANGE("Transaction No.", Rec."No.");
                        //rDistributionEntry.SETRANGE("Entry No.","From Entry No.","To Entry No.");
                        PAGE.RUN(PAGE::"Distribution Entry", rDistributionEntry);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'Functions', Comment = 'ESP="Funciones"';
                Image = "Action";
                action("&Delete Distribution Entries")
                {
                    Caption = 'Delete Distribution Entries', Comment = 'ESP="Eliminar entradas de distribución"';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunPageOnRec = true;

                    trigger OnAction()
                    var
                        RptDeleteEntry: Report "Delete Analitic G/L Allocation";
                    begin
                        IF Rec."No." <> 0 THEN BEGIN
                            Rec.TESTFIELD(Reversed, FALSE);

                            CLEAR(RptDeleteEntry);
                            RptDeleteEntry.setTransactionNo(Rec."No.");
                            RptDeleteEntry.USEREQUESTPAGE(FALSE);
                            RptDeleteEntry.RUNMODAL;
                        END;
                    end;
                }
            }
        }
    }
}
