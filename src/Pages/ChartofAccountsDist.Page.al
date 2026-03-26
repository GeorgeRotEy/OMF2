page 50018 "Chart of Accounts (Dist.)"
{
    // Mod. S2G (CPA) 22/11/2017 <ANA001> Contabilidad analítica

    Caption = 'Distr. Chart of Accounts', Comment = 'ESP="Plan de cuentas distribución"';
    CardPageID = "G/L Account Card";
    Editable = false;
    PageType = List;
    SourceTable = "Schedule of Distrib. Accounts";
    ApplicationArea = All;

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
                    ApplicationArea = Basic, Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the No. of the G/L Account you are setting up.', Comment = 'ESP="Especifica el número de la cuenta de contabilidad (G/L) que está configurando."';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the name of the general ledger account.', Comment = 'ESP="Especifica el nombre de la cuenta de contabilidad general."';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this.', Comment = 'ESP="Especifica el propósito de la cuenta. Las cuentas recién creadas se asignan automáticamente como cuentas de registro, pero puede cambiarlo."';
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an account interval or a list of account numbers.', Comment = 'ESP="Especifica un intervalo de cuentas o una lista de números de cuenta."';
                }
                field(Balance; Rec.Balance)
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the balance on this account.', Comment = 'ESP="Especifica el saldo de esta cuenta."';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
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
                Image = ChartOfAccounts;
                action(AccountGeneralLedgerEntries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ledger E&ntries', Comment = 'ESP="Movimientos de contabilidad"';
                    Image = GLRegisters;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Distribution Entry";
                    RunPageLink = "Distrib. account no." = FIELD("No.");
                    RunPageView = SORTING("Distrib. account no.", "Global Dimension 1 Code", "Global Dimension 2 Code");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.', Comment = 'ESP="Ver el historial de movimientos que se han contabilizado para el registro seleccionado."';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions', Comment = 'ESP="Dimensiones"';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Dimensions-Single', Comment = 'ESP="Dimensiones - Individual"';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(15),
                                      "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.', Comment = 'ESP="Ver o editar el conjunto único de dimensiones configurado para el registro seleccionado."';
                    }
                }
            }
            group("Underlying Entries")
            {
                Caption = 'Underlying Entries', Comment = 'ESP="Movimientos subyacentes"';
                action(NetChange)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Net Change', Comment = 'ESP="Cambio neto"';
                    Image = LedgerEntries;
                    RunObject = Page "Distribution Entry";
                    RunPageLink = "Distrib. account no." = FIELD(FILTER(Totaling)),
                                  "Posting date" = FIELD("Date Filter");
                    ToolTip = 'View the general ledger entries that make up the sum in the Net Change field.', Comment = 'ESP="Ver los movimientos de contabilidad general que componen la suma del campo Variación neta."';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        FormatLine;
    end;

    var
        Emphasize: Boolean;
        NameIndent: Integer;

    local procedure FormatLine()
    begin
        NameIndent := Rec.Indentation;
        Emphasize := Rec.Type <> Rec.Type::"Tipo coste";
    end;
}
