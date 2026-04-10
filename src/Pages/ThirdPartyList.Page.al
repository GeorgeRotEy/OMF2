page 50081 "Third Party List"
{
    Caption = 'Third Party List', Comment = 'ESP="Lista terceros"';
    CardPageID = "Third Party Card";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Third Party";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            group(NewPromoted)
            {
                Caption = 'New', Comment = 'ESP="Nuevo"';

                actionref(CreateThirdPartyPromoted; "Crear Tercero")
                {
                }
            }

            group(ProcessPromoted)
            {
                Caption = 'Process', Comment = 'ESP="Proceso"';

                actionref(DimensionsPromoted; Dimensions)
                {
                }
                actionref(BankAccountsPromoted; "Bank Accounts")
                {
                }
            }

            group(HistoryPromoted)
            {
                Caption = 'History', Comment = 'ESP="Historial"';

                actionref(LedgerEntriesPromoted; "Ledger E&ntries")
                {
                }
            }
        }
        area(navigation)
        {
            group(ThirdPartyNav)
            {
                Caption = 'Third Party', Comment = 'ESP="Tercero"';

                action("Crear Tercero")
                {
                    ApplicationArea = All;
                    Image = CreateDocument;
                    Caption = 'Create Third Party', Comment = 'ESP="Crear tercero"';
                    RunObject = Page "Alta Terceros ";
                }
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions', Comment = 'ESP="Dimensiones"';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(50040),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', Comment = 'ESP="Ver o editar dimensiones, como área, proyecto o departamento, que se pueden asignar a documentos de ventas y compras para distribuir costes y analizar el historial de transacciones."';
                }
                action("Bank Accounts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Accounts', Comment = 'ESP="Cuentas bancarias"';
                    Image = BankAccount;
                    RunObject = Page "Third Party Bank Acc. List";
                    RunPageLink = "Third Party No." = FIELD("No.");
                    ToolTip = 'View or set up the vendor''s bank accounts. You can set up any number of bank accounts for each vendor.', Comment = 'ESP="Ver o configurar las cuentas bancarias del proveedor. Puede configurar cualquier número de cuentas bancarias para cada proveedor."';
                }
            }

            group(HistoryNav)
            {
                Caption = 'History', Comment = 'ESP="Historial"';
                Image = History;

                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ledger Entries', Comment = 'ESP="Movimientos"';
                    Image = CustomerLedger;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.', Comment = 'ESP="Ver el historial de movimientos que se han contabilizado para el registro seleccionado."';

                    trigger OnAction()
                    var
                        ThirdPartyLedgEntries: Page "Third Party Ledger Entries";
                    begin
                        ThirdPartyLedgEntries.SetFilters(0, Rec."No.", false);
                        ThirdPartyLedgEntries.RunModal();
                        Clear(ThirdPartyLedgEntries);
                    end;
                }
            }
        }
    }
}
