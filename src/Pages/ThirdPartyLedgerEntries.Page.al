page 50086 "Third Party Ledger Entries"
{
    Caption = 'Third Party Ledger Entries', Comment = 'ESP="Movimientos tercero"';
    DataCaptionFields = "Third Party No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Cust. Ledger Entry";
    SourceTableTemporary = true;
    SourceTableView = SORTING("Entry No.")
                     ORDER(Descending);
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                field("Source Company Name"; Rec."Source Company Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the customer entry''s posting date.', Comment = 'ESP="Especifica la fecha de contabilización del movimiento de cliente."';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the document type that the customer entry belongs to.', Comment = 'ESP="Especifica el tipo de documento al que pertenece el movimiento de cliente."';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the entry''s document number.', Comment = 'ESP="Especifica el número de documento del movimiento."';
                }
                field("Bill No."; Rec."Bill No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Shows the bill number related to the customer entry.', Comment = 'ESP="Muestra el número de efecto relacionado con el movimiento de cliente."';
                }
                field("Document Situation"; Rec."Document Situation")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Shows the document location.', Comment = 'ESP="Muestra la ubicación del documento."';
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Shows the status of the document.', Comment = 'ESP="Muestra el estado del documento."';
                }
                field("Third Party No."; Rec."Third Party No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the third party number that the entry is linked to.', Comment = 'ESP="Especifica el número de tercero al que está vinculado el movimiento."';
                }
                field("Message to Recipient"; Rec."Message to Recipient")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.', Comment = 'ESP="Especifica el mensaje exportado al archivo de pagos cuando utiliza la función Exportar pagos a archivo en la ventana Diario de pagos."';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies a description of the customer entry.', Comment = 'ESP="Especifica una descripción del movimiento de cliente."';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code linked to the entry.', Comment = 'ESP="Especifica el código de valor de dimensión vinculado al movimiento."';
                    Visible = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code linked to the entry.', Comment = 'ESP="Especifica el código de valor de dimensión vinculado al movimiento."';
                    Visible = false;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the code for the salesperson whom the entry is linked to.', Comment = 'ESP="Especifica el código del vendedor al que está vinculado el movimiento."';
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the currency code for the amount on the line.', Comment = 'ESP="Especifica el código de divisa del importe de la línea."';
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the original entry.', Comment = 'ESP="Especifica el importe del movimiento original."';
                }
                field("Original Amt. (LCY)"; Rec."Original Amt. (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the amount that the entry originally consisted of, in LCY.', Comment = 'ESP="Especifica el importe del que constaba originalmente el movimiento, en divisa local."';
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the entry.', Comment = 'ESP="Especifica el importe del movimiento."';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the entry in LCY.', Comment = 'ESP="Especifica el importe del movimiento en divisa local."';
                    Visible = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry has been completely applied.', Comment = 'ESP="Especifica el importe pendiente de aplicar antes de que el movimiento se haya aplicado completamente."';
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.', Comment = 'ESP="Especifica el importe pendiente de aplicar antes de que el movimiento quede totalmente aplicado."';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of balancing account used on the entry.', Comment = 'ESP="Especifica el tipo de cuenta de contrapartida utilizado en el movimiento."';
                    Visible = false;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the balancing account number used on the entry.', Comment = 'ESP="Especifica el número de cuenta de contrapartida utilizado en el movimiento."';
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the due date on the entry.', Comment = 'ESP="Especifica la fecha de vencimiento del movimiento."';
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.', Comment = 'ESP="Especifica la fecha en la que debe pagarse el importe del movimiento para que se conceda un descuento por pronto pago."';
                }
                field("Pmt. Disc. Tolerance Date"; Rec."Pmt. Disc. Tolerance Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the last date the amount in the entry must be paid in order for a payment discount tolerance to be granted.', Comment = 'ESP="Especifica la última fecha en la que debe pagarse el importe del movimiento para que se conceda una tolerancia de descuento por pronto pago."';
                }
                field("Original Pmt. Disc. Possible"; Rec."Original Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the discount that the customer can obtain if the entry is applied to before the payment discount date.', Comment = 'ESP="Especifica el descuento que puede obtener el cliente si el movimiento se aplica antes de la fecha de descuento por pronto pago."';
                    Visible = false;
                }
                field("Remaining Pmt. Disc. Possible"; Rec."Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the remaining payment discount that is available if the entry is totally applied to within the payment period.', Comment = 'ESP="Especifica el descuento por pronto pago restante disponible si el movimiento se aplica totalmente dentro del período de pago."';
                    Visible = false;
                }
                field("Max. Payment Tolerance"; Rec."Max. Payment Tolerance")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the maximum tolerated amount the entry can differ from the amount on the invoice or credit memo.', Comment = 'ESP="Especifica el importe máximo tolerado en el que el movimiento puede diferir del importe de la factura o abono."';
                }
                field("Pmt. Disc. Given (LCY)"; Rec."Pmt. Disc. Given (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the payment method that was used to make the payment that resulted in the entry.', Comment = 'ESP="Especifica la forma de pago que se utilizó para realizar el pago que originó el movimiento."';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.', Comment = 'ESP="Especifica si el importe del movimiento se ha pagado completamente o si aún queda un importe pendiente de aplicar."';
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies when an entry for an unpaid invoice has been posted and you create a finance charge memo or reminder.', Comment = 'ESP="Especifica cuándo se ha contabilizado un movimiento por una factura impagada y se crea una factura de intereses o un recordatorio."';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the ID of the user associated with the entry.', Comment = 'ESP="Especifica el ID del usuario asociado al movimiento."';
                    Visible = false;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the source code that is linked to the entry.', Comment = 'ESP="Especifica el código de origen vinculado al movimiento."';
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the reason code on the entry.', Comment = 'ESP="Especifica el código de motivo del movimiento."';
                    Visible = false;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the entry has been part of a reverse transaction.', Comment = 'ESP="Especifica si el movimiento ha formado parte de una transacción revertida."';
                    Visible = false;
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the correcting entry that replaced the original entry in the reverse transaction.', Comment = 'ESP="Especifica el número del movimiento corrector que sustituyó al movimiento original en la transacción de reversión."';
                    Visible = false;
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the original entry that was undone by the reverse transaction.', Comment = 'ESP="Especifica el número del movimiento original que fue deshecho por la transacción de reversión."';
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the entry number that is assigned to the entry.', Comment = 'ESP="Especifica el número de movimiento asignado al movimiento."';
                }
                field("Exported to Payment File"; Rec."Exported to Payment File")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the entry was created as a result of exporting a payment journal line.', Comment = 'ESP="Especifica que el movimiento se creó como resultado de exportar una línea del diario de pagos."';
                }
                field("Direct Debit Mandate ID"; Rec."Direct Debit Mandate ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the direct-debit mandate that the customer has signed to allow direct debit collection of payments.', Comment = 'ESP="Especifica el mandato de adeudo directo que el cliente ha firmado para permitir el cobro de pagos por domiciliación bancaria."';
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
        area(Promoted)
        {
            group(ProcessPromoted)
            {
                Caption = 'Process', Comment = 'ESP="Proceso"';

                actionref(NavigatePromoted; "&Navigate")
                {
                }
                actionref(ShowPostedDocumentPromoted; "Show Posted Document")
                {
                }
            }
        }
        area(navigation)
        {
            group(EntryNav)
            {
                Caption = 'Entry', Comment = 'ESP="Movimiento"';
                Image = Entry;

                action("Reminder/Fin. Charge Entries")
                {
                    Caption = 'Reminder/Fin. Charge Entries', Comment = 'ESP="Recordatorios/Movs. de recargo financiero"';
                    Enabled = CustomerActionsEnabled;
                    Image = Reminder;
                    RunObject = Page "Reminder/Fin. Charge Entries";
                    RunPageLink = "Customer Entry No." = FIELD("Entry No.");
                    RunPageView = SORTING("Customer Entry No.");
                    Scope = Repeater;
                    ToolTip = 'View the reminders and finance charge entries that you have entered for the customer.', Comment = 'ESP="Ver los recordatorios y movimientos de intereses que ha introducido para el cliente."';
                }
                action("Applied E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Applied E&ntries', Comment = 'ESP="Movimientos aplicados"';
                    Enabled = CustomerActionsEnabled;
                    Image = Approve;
                    RunObject = Page "Applied Customer Entries";
                    RunPageOnRec = true;
                    Scope = Repeater;
                    ToolTip = 'View the ledger entries that have been applied to this record.', Comment = 'ESP="Ver los movimientos que se han aplicado a este registro."';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions', Comment = 'ESP="Dimensiones"';
                    Image = Dimensions;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', Comment = 'ESP="Ver o editar dimensiones, como área, proyecto o departamento, que se pueden asignar a documentos de ventas y compras para distribuir costes y analizar el historial de transacciones."';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Detailed &Ledger Entries', Comment = 'ESP="Movimientos contables detallados"';
                    Enabled = CustomerActionsEnabled;
                    Image = View;
                    RunObject = Page "Detailed Cust. Ledg. Entries";
                    RunPageLink = "Cust. Ledger Entry No." = FIELD("Entry No."),
                                  "Customer No." = FIELD("Customer No.");
                    RunPageView = SORTING("Cust. Ledger Entry No.", "Posting Date");
                    Scope = Repeater;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a summary of the all posted entries and adjustments related to a specific customer ledger entry.', Comment = 'ESP="Ver un resumen de todos los movimientos contabilizados y ajustes relacionados con un movimiento específico de cliente."';
                }
            }
        }
        area(processing)
        {
            group(FunctionsNav)
            {
                Caption = 'Functions', Comment = 'ESP="Funciones"';
                Image = "Action";

                action("Apply Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply Entries', Comment = 'ESP="Aplicar movimientos"';
                    Enabled = CustomerActionsEnabled;
                    Image = ApplyEntries;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.', Comment = 'ESP="Seleccionar uno o varios movimientos a los que desea aplicar este registro para que los documentos contabilizados relacionados queden cerrados como pagados o reembolsados."';

                    trigger OnAction()
                    var
                        CustLedgEntry: Record "Cust. Ledger Entry";
                        CustEntryApplyPostEntries: Codeunit "CustEntry-Apply Posted Entries";
                    begin
                        if not CustomerActionsEnabled then
                            Error(CustomerOnlyActionErrLbl);
                        CustLedgEntry.Copy(Rec);
                        CustEntryApplyPostEntries.ApplyCustEntryFormEntry(CustLedgEntry);
                        Rec := CustLedgEntry;
                        CurrPage.Update;
                    end;
                }
                action(UnapplyEntries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unapply Entries', Comment = 'ESP="Desaplicar movimientos"';
                    Enabled = CustomerActionsEnabled;
                    Ellipsis = true;
                    Image = UnApply;
                    Scope = Repeater;
                    ToolTip = 'Unselect one or more ledger entries that you want to unapply this record.', Comment = 'ESP="Deseleccionar uno o varios movimientos a los que desea deshacer la aplicación de este registro."';

                    trigger OnAction()
                    var
                        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
                    begin
                        if not CustomerActionsEnabled then
                            Error(CustomerOnlyActionErrLbl);
                        CustEntryApplyPostedEntries.UnApplyCustLedgEntry(Rec."Entry No.");
                    end;
                }
                action(ReverseTransaction)
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = CustomerActionsEnabled;
                    Caption = 'Reverse Transaction', Comment = 'ESP="Revertir transacción"';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Scope = Repeater;
                    ToolTip = 'Reverse an erroneous customer ledger entry.', Comment = 'ESP="Revertir un movimiento erróneo de cliente."';

                    trigger OnAction()
                    var
                        ReversalEntry: Record "Reversal Entry";
                    begin
                        if not CustomerActionsEnabled then
                            Error(CustomerOnlyActionErrLbl);
                        Clear(ReversalEntry);
                        if Rec.Reversed then
                            ReversalEntry.AlreadyReversedEntry(Rec.TableCaption, Rec."Entry No.");
                        if Rec."Journal Batch Name" = '' then
                            ReversalEntry.TestFieldError;
                        Rec.TestField("Transaction No.");
                        ReversalEntry.ReverseTransaction(Rec."Transaction No.");
                    end;
                }
                group(IncomingDocument)
                {
                    Caption = 'Incoming Document', Comment = 'ESP="Documento entrante"';
                    Image = Documents;

                    action(IncomingDocCard)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'View Incoming Document', Comment = 'ESP="Ver documento entrante"';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        ToolTip = 'View any incoming document records and file attachments that exist for the entry or document.', Comment = 'ESP="Ver cualquier registro de documento entrante y archivo adjunto que exista para el movimiento o documento."';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            IncomingDocument.ShowCard(Rec."Document No.", Rec."Posting Date");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData "Incoming Document" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Select Incoming Document', Comment = 'ESP="Seleccionar documento entrante"';
                        Enabled = not HasIncomingDocument;
                        Image = SelectLineToApply;
                        ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.', Comment = 'ESP="Seleccionar un registro de documento entrante y un archivo adjunto que desee vincular al movimiento o documento."';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            IncomingDocument.SelectIncomingDocumentForPostedDocument(Rec."Document No.", Rec."Posting Date", Rec.RecordId);
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Create Incoming Document from File', Comment = 'ESP="Crear documento entrante desde archivo"';
                        Ellipsis = true;
                        Enabled = not HasIncomingDocument;
                        Image = Attach;
                        ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.', Comment = 'ESP="Crear un registro de documento entrante seleccionando un archivo para adjuntar y, después, vincular el registro del documento entrante al movimiento o documento."';

                        trigger OnAction()
                        var
                            IncomingDocumentAttachment: Record "Incoming Document Attachment";
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromPostedDocument(Rec."Document No.", Rec."Posting Date");
                        end;
                    }
                }
            }

            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Navigate', Comment = 'ESP="Navegar"';
                Image = Navigate;
                Scope = Repeater;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.', Comment = 'ESP="Buscar todos los movimientos y documentos que existan para el número de documento y la fecha de contabilización del movimiento o documento seleccionado."';

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run();
                end;
            }

            action("Show Posted Document")
            {
                ApplicationArea = Basic, Suite;
                Enabled = CustomerActionsEnabled;
                Caption = 'Show Posted Document', Comment = 'ESP="Mostrar documento registrado"';
                Image = Document;
                ShortCutKey = 'Return';
                ToolTip = 'Show details for the posted payment, invoice, or credit memo.', Comment = 'ESP="Mostrar detalles del pago, factura o abono contabilizado."';

                trigger OnAction()
                begin
                    if not CustomerActionsEnabled then
                        Error(CustomerOnlyActionErrLbl);
                    Rec.ShowDoc;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        IncomingDocument: Record "Incoming Document";
    begin
        HasIncomingDocument := IncomingDocument.PostedDocExists(Rec."Document No.", Rec."Posting Date");
        CustomerActionsEnabled := Rec."Customer No." <> '';
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle;
        CustomerActionsEnabled := Rec."Customer No." <> '';
    end;

    trigger OnOpenPage()
    begin
        FillInTable;
    end;

    var
        Navigate: Page Navigate;
        StyleTxt: Text;
        HasIncomingDocument: Boolean;
        CustomerActionsEnabled: Boolean;
        ThirdPartyType: Option All,Customer,Vendor;
        ThirdPartyNo: Code[20];
        OnlyOpen: Boolean;
        CustomerOnlyActionErrLbl: Label 'This action is only available for customer ledger entries in third-party history.', Comment = 'ESP="Esta acción solo está disponible para movimientos de cliente en el historial de terceros."';

    procedure SetFilters(pThirdPartyType: Option All,Customer,Vendor; pThirdPartyNo: Code[20]; pOnlyOpen: Boolean)
    begin
        ThirdPartyType := pThirdPartyType;
        ThirdPartyNo := pThirdPartyNo;
        OnlyOpen := pOnlyOpen;
    end;

    local procedure FillInTable()
    var
        Company: Record Company;
        ThirdParty: Record "Third Party";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        bThirdPartyEnabled: Boolean;
        vCustNo: Code[20];
        vVendNo: Code[20];
        NextEntryNo: Integer;
    begin
        NextEntryNo := 0;
        Company.SetRange("Evaluation Company", false);
        if Company.FindFirst() then
            repeat
                if UpperCase(CopyStr(Company.Name, 1, 2)) <> 'ZZ' then begin
                    if ThirdPartyType in [0, 1] then begin
                        bThirdPartyEnabled := false;
                        CustLedgEntry.Reset();
                        CustLedgEntry.ChangeCompany(Company.Name);
                        if ThirdPartyNo <> '' then begin
                            ThirdParty.CheckThirdPartyEnabled(Company.Name, 0, ThirdPartyNo, bThirdPartyEnabled, vCustNo);
                            if bThirdPartyEnabled then begin
                                CustLedgEntry.SetCurrentKey("Customer No.", Open);
                                CustLedgEntry.SetRange("Customer No.", vCustNo);
                            end;
                        end;
                        if ((ThirdPartyNo <> '') and bThirdPartyEnabled) or (ThirdPartyNo = '') then begin
                            if not bThirdPartyEnabled then
                                CustLedgEntry.SetCurrentKey(Open);
                            if OnlyOpen then
                                CustLedgEntry.SetRange(Open, true);
                            if CustLedgEntry.FindFirst() then
                                repeat
                                    NextEntryNo := NextEntryNo + 1;
                                    Rec.Init();
                                    Rec := CustLedgEntry;
                                    Rec."Entry No." := NextEntryNo;
                                    Rec.Insert();
                                until CustLedgEntry.Next() = 0;
                        end;
                    end;

                    if ThirdPartyType in [0, 2] then begin
                        bThirdPartyEnabled := false;
                        VendLedgEntry.Reset();
                        VendLedgEntry.ChangeCompany(Company.Name);
                        if ThirdPartyNo <> '' then begin
                            ThirdParty.CheckThirdPartyEnabled(Company.Name, 1, ThirdPartyNo, bThirdPartyEnabled, vVendNo);
                            if bThirdPartyEnabled then begin
                                VendLedgEntry.SetCurrentKey("Vendor No.", Open);
                                VendLedgEntry.SetRange("Vendor No.", vVendNo);
                            end;
                        end;
                        if ((ThirdPartyNo <> '') and bThirdPartyEnabled) or (ThirdPartyNo = '') then begin
                            if not bThirdPartyEnabled then
                                VendLedgEntry.SetCurrentKey(Open);
                            if OnlyOpen then
                                VendLedgEntry.SetRange(Open, true);
                            if VendLedgEntry.FindSet() then
                                repeat
                                    NextEntryNo := NextEntryNo + 1;
                                    Rec.Init();
                                    Rec."Entry No." := NextEntryNo;
                                    Rec."Third Party No." := VendLedgEntry."Third Party No.";
                                    Rec."Customer No." := '';
                                    Rec."Posting Date" := VendLedgEntry."Posting Date";
                                    Rec."Document Type" := VendLedgEntry."Document Type";
                                    Rec."Document No." := VendLedgEntry."Document No.";
                                    Rec.Description := VendLedgEntry.Description;
                                    Rec."Currency Code" := VendLedgEntry."Currency Code";
                                    Rec."Sales (LCY)" := VendLedgEntry."Purchase (LCY)";
                                    Rec."Inv. Discount (LCY)" := VendLedgEntry."Inv. Discount (LCY)";
                                    Rec."Sell-to Customer No." := VendLedgEntry."Buy-from Vendor No.";
                                    Rec."Customer Posting Group" := VendLedgEntry."Vendor Posting Group";
                                    Rec."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                                    Rec."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
                                    Rec."Salesperson Code" := VendLedgEntry."Purchaser Code";
                                    Rec."User ID" := VendLedgEntry."User ID";
                                    Rec."Source Code" := VendLedgEntry."Source Code";
                                    Rec."On Hold" := VendLedgEntry."On Hold";
                                    Rec.Open := VendLedgEntry.Open;
                                    Rec."Due Date" := VendLedgEntry."Due Date";
                                    Rec."Pmt. Discount Date" := VendLedgEntry."Pmt. Discount Date";
                                    Rec."Original Pmt. Disc. Possible" := VendLedgEntry."Original Pmt. Disc. Possible";
                                    Rec."Pmt. Disc. Given (LCY)" := VendLedgEntry."Pmt. Disc. Rcd.(LCY)";
                                    Rec.Positive := VendLedgEntry.Positive;
                                    Rec."Closed by Entry No." := VendLedgEntry."Closed by Entry No.";
                                    Rec."Closed at Date" := VendLedgEntry."Closed at Date";
                                    Rec."Closed by Amount" := VendLedgEntry."Closed by Amount";
                                    Rec."Journal Batch Name" := VendLedgEntry."Journal Batch Name";
                                    Rec."Reason Code" := VendLedgEntry."Reason Code";
                                    Rec."Bal. Account Type" := VendLedgEntry."Bal. Account Type";
                                    Rec."Bal. Account No." := VendLedgEntry."Bal. Account No.";
                                    Rec."Transaction No." := VendLedgEntry."Transaction No.";
                                    Rec."Closed by Amount (LCY)" := VendLedgEntry."Closed by Amount (LCY)";
                                    Rec."Document Date" := VendLedgEntry."Document Date";
                                    Rec."External Document No." := VendLedgEntry."External Document No.";
                                    Rec."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
                                    Rec.Reversed := VendLedgEntry.Reversed;
                                    Rec."Reversed by Entry No." := VendLedgEntry."Reversed by Entry No.";
                                    Rec."Reversed Entry No." := VendLedgEntry."Reversed Entry No.";
                                    Rec.Prepayment := VendLedgEntry.Prepayment;
                                    Rec."Payment Terms Code" := VendLedgEntry."Payment Terms Code";
                                    Rec."Payment Method Code" := VendLedgEntry."Payment Method Code";
                                    Rec."Recipient Bank Account" := VendLedgEntry."Recipient Bank Account";
                                    Rec."Message to Recipient" := VendLedgEntry."Message to Recipient";
                                    Rec."Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                                    Rec."Source Company Name" := VendLedgEntry."Source Company Name";
                                    Rec."Bill No." := VendLedgEntry."Bill No.";
                                    Rec."Document Situation" := VendLedgEntry."Document Situation";
                                    Rec."Document Status" := VendLedgEntry."Document Status";
                                    Rec."Remaining Amount (LCY) stats." := VendLedgEntry."Remaining Amount (LCY) stats.";
                                    Rec."Amount (LCY) stats." := VendLedgEntry."Amount (LCY) stats.";
                                    Rec.Insert();
                                until VendLedgEntry.Next() = 0;
                        end;
                    end;
                end;
            until Company.Next() = 0;
    end;

    procedure CalcGlobalCustBalance(pThirdPartyNo: Code[20]; LCY: Boolean): Decimal
    var
        Company: Record Company;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;
        if pThirdPartyNo = '' then
            exit(0);
        Company.SetRange("Evaluation Company", false);
        if Company.FindFirst() then
            repeat
                if UpperCase(CopyStr(Company.Name, 1, 2)) <> 'ZZ' then begin
                    DtldCustLedgEntry.Reset();
                    DtldCustLedgEntry.ChangeCompany(Company.Name);
                    DtldCustLedgEntry.SetCurrentKey("Third Party No.", "Currency Code", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Initial Entry Due Date", "Posting Date", "Excluded from calculation");
                    DtldCustLedgEntry.SetRange("Third Party No.", pThirdPartyNo);
                    DtldCustLedgEntry.SetRange("Excluded from calculation", false);
                    DtldCustLedgEntry.CalcSums(Amount, "Amount (LCY)");
                    if LCY then
                        TotalAmount := TotalAmount + DtldCustLedgEntry."Amount (LCY)"
                    else
                        TotalAmount := TotalAmount + DtldCustLedgEntry.Amount;
                end;
            until Company.Next() = 0;
        exit(TotalAmount);
    end;

    procedure CalcGlobalVendBalance(pThirdPartyNo: Code[20]; LCY: Boolean): Decimal
    var
        Company: Record Company;
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;
        if pThirdPartyNo = '' then
            exit(0);
        Company.SetRange("Evaluation Company", false);
        if Company.FindFirst() then
            repeat
                if UpperCase(CopyStr(Company.Name, 1, 2)) <> 'ZZ' then begin
                    DtldVendLedgEntry.Reset();
                    DtldVendLedgEntry.ChangeCompany(Company.Name);
                    DtldVendLedgEntry.SetCurrentKey("Third Party No.", "Currency Code", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Initial Entry Due Date", "Posting Date", "Excluded from calculation");
                    DtldVendLedgEntry.SetRange("Third Party No.", pThirdPartyNo);
                    DtldVendLedgEntry.SetRange("Excluded from calculation", false);
                    DtldVendLedgEntry.CalcSums(Amount, "Amount (LCY)");
                    if LCY then
                        TotalAmount := TotalAmount + DtldVendLedgEntry."Amount (LCY)"
                    else
                        TotalAmount := TotalAmount + DtldVendLedgEntry.Amount;
                end;
            until Company.Next() = 0;
        exit(TotalAmount);
    end;

    procedure CalcGlobalGLBalance(pThirdPartyNo: Code[20]): Decimal
    var
        Company: Record Company;
        GLEntry: Record "G/L Entry";
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;
        if pThirdPartyNo = '' then
            exit(0);
        Company.SetRange("Evaluation Company", false);
        if Company.FindFirst() then
            repeat
                if UpperCase(CopyStr(Company.Name, 1, 2)) <> 'ZZ' then begin
                    GLEntry.Reset();
                    GLEntry.ChangeCompany(Company.Name);
                    GLEntry.SetCurrentKey("Third Party No.");
                    GLEntry.SetRange("Third Party No.", pThirdPartyNo);
                    GLEntry.CalcSums(Amount);
                    TotalAmount := TotalAmount + GLEntry.Amount;
                end;
            until Company.Next() = 0;
        exit(TotalAmount);
    end;
}