page 50027 "Cost journal Distribution"
{
    AutoSplitKey = true;
    Caption = 'Cost Journal Distribution', Comment = 'ESP="Diario costes distribución"';
    PageType = Worksheet;
    SourceTable = "Cost Journal";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                field("Posting date"; Rec."Posting date")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Distribution Account No."; Rec."Distribution Account No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Debit amount"; Rec."Debit amount")
                {
                }
                field("Credit amount"; Rec."Credit amount")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
            }
            group(Group)
            {
                Caption = 'Group', Comment = 'ESP="Grupo"';
                fixed(fixed)
                {
                    group("Account Name")
                    {
                        Caption = 'Account Name', Comment = 'ESP="Nombre de cuenta"';

                        field(AccName; AccName)
                        {
                            ApplicationArea = Basic, Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies the name of the account.', Comment = 'ESP="Especifica el nombre de la cuenta."';
                        }
                    }
                    group("Bal. Account Name")
                    {
                        Caption = 'Bal. Account Name', Comment = 'ESP="Nombre cuenta contrapartida"';

                        field(BalAccName; BalAccName)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bal. Account Name';
                            Editable = false;
                            ToolTip = 'Specifies the name of the balancing account that has been entered on the journal line.', Comment = 'ESP="Especifica el nombre de la cuenta de contrapartida que se ha introducido en la línea del diario."';
                        }
                    }
                    group(BalanceGroup)
                    {
                        Caption = 'Balance', Comment = 'ESP="Saldo"';

                        field(Balance; Balance)
                        {
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies the balance that has accumulated in the general journal on the line where the cursor is.', Comment = 'ESP="Especifica el saldo que se ha acumulado en el diario general en la línea donde está el cursor."';
                            Visible = BalanceVisible;
                        }
                    }
                    group("Total Balance")
                    {
                        Caption = 'Total Balance', Comment = 'ESP="Saldo total"';

                        field(TotalBalance; TotalBalance)
                        {
                            AutoFormatType = 1;
                            Caption = 'Total Balance';
                            Editable = false;
                            ToolTip = 'Specifies the total balance in the general journal.', Comment = 'ESP="Especifica el saldo total en el diario general."';
                            Visible = TotalBalanceVisible;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part("Dimension Set Entries FactBox"; "Dimension Set Entries FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Dimension Set ID" = FIELD("Dimension Set ID");
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
            }
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
        area(processing)
        {
            action(Post)
            {
                Caption = 'Post', Comment = 'ESP="Registrar"';
                Image = Post;

                trigger OnAction()
                begin
                    DistributionMng.fPost(Rec);
                end;
            }
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
        }
        area(Promoted)
        {
            group(Process)
            {
                Caption = 'Process', Comment = 'ESP="Procesar"';

                actionref(Post_Promoted; Post)
                {
                }
                actionref(Dimensions_Promoted; Dimensions)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateBalance;
    end;

    var
        DistributionMng: Codeunit "Distribution Mngt";
        AccName: Text[50];
        BalAccName: Text[50];
        Balance: Decimal;
        TotalBalance: Decimal;
        BalanceVisible: Boolean;
        TotalBalanceVisible: Boolean;

    local procedure UpdateBalance()
    begin
        //GenJnlManagement.CalcBalance(Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
        //BalanceVisible := ShowBalance;
        //TotalBalanceVisible := ShowTotalBalance;
    end;
}