page 50021 "Distribution Entry"
{
    Caption = 'Distribution Entry', Comment = 'ESP="Movimiento distribución"';
    Editable = false;
    PageType = List;
    SourceTable = "Distribution Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Distrib. account no."; Rec."Distrib. account no.")
                {
                }
                field("Posting date"; Rec."Posting date")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description of assignment"; Rec."Description of assignment")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("G/L Account"; Rec."G/L Account")
                {
                }
                field("Source code"; Rec."Source code")
                {
                }
                field(Assigned; Rec.Assigned)
                {
                }
                field("Assignment Document No."; Rec."Assignment Document No.")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Distribution Id."; Rec."Distribution Id.")
                {
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                }
                field("Source Entry No."; Rec."Source Entry No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Suite;
                Caption = 'Dimensions', Comment = 'ESP="Dimensiones"';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that can be assigned to sales and purchase documents to distribute costs and analyze transaction history.', Comment = 'ESP="Ver o editar dimensiones, como área, proyecto o departamento, que se pueden asignar a documentos de ventas y compras para distribuir costes y analizar el historial de transacciones."';

                trigger OnAction()
                begin
                    Rec.ShowDimensions;
                    CurrPage.SAVERECORD;
                end;
            }
            action("Asociated G/L Entry")
            {
                ApplicationArea = Suite;
                Caption = 'Associated G/L Entry', Comment = 'ESP="Asiento de G/L asociado"';
                Image = GeneralLedger;
                RunObject = Page "General Ledger Entries";
                RunPageLink = "Entry No." = FIELD("G/L Entry No.");
            }
        }
        area(processing)
        {
            action("Traer movimientos de contabilidad")
            {
                Ellipsis = true;
                Caption = 'Bring G/L Entries', Comment = 'ESP="Copiar asientos de G/L a distribución"';
                Image = ImportChartOfAccounts;
                RunObject = Report "Copy GL Entry to Distribution";
            }
        }
        area(Promoted)
        {
            group(Process)
            {
                Caption = 'Process', Comment = 'ESP="Procesar"';

                actionref(Dimensions_Promoted; Dimensions)
                {
                }
            }
        }
    }
}