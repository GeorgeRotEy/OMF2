page 50081 "Third Party List"
{
    // // Mod. S2G 18/12/2017 (JGS) : TER001 ã Terceros.

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
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Name 2"; Rec."Name 2")
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field(City; Rec.City)
                {
                }
                field(Contact; Rec.Contact)
                {
                }
                field("Phone No."; Rec."Phone No.")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field(County; Rec.County)
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("Home Page"; Rec."Home Page")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Third Party")
            {
                Caption = 'Third Party', Comment = 'ESP="Tercero"';
                action("Crear Tercero")
                {
                    Image = CreateDocument;
                    Caption = 'Create Third Party', Comment = 'ESP="Crear tercero"';
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Alta Terceros ";
                }
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions', Comment = 'ESP="Dimensiones"';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
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
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Third Party Bank Acc. List";
                    RunPageLink = "Third Party No." = FIELD("No.");
                    ToolTip = 'View or set up the vendor''s bank accounts. You can set up any number of bank accounts for each vendor.', Comment = 'ESP="Ver o configurar las cuentas bancarias del proveedor. Puede configurar cualquier número de cuentas bancarias para cada proveedor."';
                }
            }
            group(History)
            {
                Caption = 'History', Comment = 'ESP="Historial"';
                Image = History;
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ledger E&ntries', Comment = 'ESP="Movimientos"';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.', Comment = 'ESP="Ver el historial de movimientos que se han contabilizado para el registro seleccionado."';

                    trigger OnAction()
                    var
                        ThirdPartyLedgEntries: Page "Third Party Ledger Entries";

                    begin
                        ThirdPartyLedgEntries.SetFilters(0, Rec."No.", FALSE);
                        ThirdPartyLedgEntries.RUNMODAL;
                        CLEAR(ThirdPartyLedgEntries);
                    end;
                }
            }
        }
    }
}
