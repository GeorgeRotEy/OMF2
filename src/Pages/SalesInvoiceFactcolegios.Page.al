page 50037 "Sales Invoice - Fact. colegios"
{
    Caption = 'Sales Invoice', Comment = 'ESP="Factura de venta"';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER(Invoice));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';

                field("No."; Rec."No.")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the sales document. The field can be filled automatically or manually and can be set up to be invisible.', Comment = 'ESP="Especifica el número del documento de venta. El campo puede rellenarse automáticamente o manualmente y puede configurarse como invisible."';
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer', Comment = 'ESP="Cliente"';
                    Importance = Promoted;
                    NotBlank = true;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.', Comment = 'ESP="Especifica el nombre del cliente que recibirá los productos y al que se facturará por defecto."';

                    trigger OnValidate()
                    var
                        ApplicationAreaMgmt: Codeunit "Application Area Mgmt. Facade";
                    begin
                        if Rec.GetFilter("Sell-to Customer No.") = xRec."Sell-to Customer No." then
                            if Rec."Sell-to Customer No." <> xRec."Sell-to Customer No." then
                                Rec.SetRange("Sell-to Customer No.");

                        if ApplicationAreaMgmt.IsFoundationEnabled then
                            SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0, Rec);

                        CurrPage.Update;
                    end;
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies how the customer must pay for products on the sales document.', Comment = 'ESP="Especifica cómo debe pagar el cliente los productos del documento de venta."';

                    trigger OnValidate()
                    begin
                        UpdatePaymentService;
                    end;
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                }
                field("User Full Name"; Rec."User Full Name")
                {
                    ApplicationArea = All;
                }
                group("Sell-to")
                {
                    Caption = 'Sell-to', Comment = 'ESP="Venta a"';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the posting of the sales document will be recorded.', Comment = 'ESP="Especifica la fecha en la que se registrará la contabilización del documento de venta."';
                }
                field("Incoming Document Entry No."; Rec."Incoming Document Entry No.")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the incoming document that this sales document is created for.', Comment = 'ESP="Especifica el número del documento entrante para el que se ha creado este documento de venta."';
                    Visible = false;
                }
            }
            part(SalesLines; "Sales Inv. S. - Fact. colegios")
            {
                ApplicationArea = Basic, Suite;
                Editable = Rec."Sell-to Customer No." <> '';
                Enabled = Rec."Sell-to Customer No." <> '';
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details', Comment = 'ESP="Detalles de factura"';

                group(Payment)
                {
                    Caption = 'Payment', Comment = 'ESP="Pago"';
                }
            }
        }
        area(factboxes)
        {
            part("Pending Approval FactBox"; "Pending Approval FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = CONST(36),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part("Sales Hist. Sell-to FactBox"; "Sales Hist. Sell-to FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = false;
            }
            part("Sales Hist. Bill-to FactBox"; "Sales Hist. Bill-to FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = false;
            }
            part("Customer Statistics FactBox"; "Customer Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
            }
            part("Customer Details FactBox"; "Customer Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
            }
            part("Cartera Receiv. Statistics FB"; "Cartera Receiv. Statistics FB")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = true;
            }
            part("Cartera Fact. Statistics FB"; "Cartera Fact. Statistics FB")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = true;
            }
            part("Sales Line FactBox"; "Sales Line FactBox")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                Visible = false;
            }
            part("Item Invoicing FactBox"; "Item Invoicing FactBox")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = All;
                ShowFilter = false;
                Visible = false;
            }
            part(ApprovalFactBox; "Approval FactBox")
            {
                ApplicationArea = All;
                Visible = false;
            }
            part("Resource Details FactBox"; "Resource Details FactBox")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            group(InvoicePromoted)
            {
                Caption = 'Invoice', Comment = 'ESP="Factura"';

                actionref(StatisticsPromoted; Statistics)
                {
                }
                actionref(CommentsPromoted; "Co&mments")
                {
                }
                actionref(FunctionCustomerCardPromoted; Function_CustomerCard)
                {
                }
                actionref(DimensionsPromoted; Dimensions)
                {
                }
            }

            group(ApprovePromoted)
            {
                Caption = 'Approve', Comment = 'ESP="Aprobar"';

                actionref(ApprovePromotedRef; Approve)
                {
                }
                actionref(RejectPromotedRef; Reject)
                {
                }
                actionref(DelegatePromotedRef; Delegate)
                {
                }
                actionref(CommentPromotedRef; Comment)
                {
                }
                actionref(UnblockOperationPromotedRef; "Desbloquear operación")
                {
                }
            }

            group(ReleasePromoted)
            {
                Caption = 'Release', Comment = 'ESP="Liberar"';

                actionref(ApprovalsPromoted; Approvals)
                {
                }
                actionref(ReleasePromotedRef; Release)
                {
                }
                actionref(ReopenPromotedRef; Reopen)
                {
                }
            }

            group(PreparePromoted)
            {
                Caption = 'Prepare', Comment = 'ESP="Preparar"';

                actionref(CalculateInvoiceDiscountPromoted; CalculateInvoiceDiscount)
                {
                }
                actionref(MoveNegativeLinesPromoted; "Move Negative Lines")
                {
                }
            }

            group(RequestApprovalPromoted)
            {
                Caption = 'Request Approval', Comment = 'ESP="Solicitar aprobación"';

                actionref(SendApprovalRequestPromoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequestPromoted; CancelApprovalRequest)
                {
                }
            }

            group(PostingPromoted)
            {
                Caption = 'Posting', Comment = 'ESP="Registro"';

                actionref(PostActionPromoted; PostAction)
                {
                }
                actionref(PostAndNewPromoted; PostAndNew)
                {
                }
                actionref(PostAndSendPromoted; PostAndSend)
                {
                }
                actionref(TestReportPromoted; "Test Report")
                {
                }
            }
        }

        area(navigation)
        {
            group(InvoiceNav)
            {
                Caption = '&Invoice', Comment = 'ESP="&Factura"';
                Image = Invoice;

                action(Statistics)
                {
                    Caption = 'Statistics', Comment = 'ESP="Estadísticas"';
                    Image = Statistics;
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.', Comment = 'ESP="Ver información estadística, como el valor de los movimientos contabilizados, del registro."';

                    trigger OnAction()
                    var
                        Handled: Boolean;
                    begin
                        OnBeforeStatisticsAction(Rec, Handled);
                        if not Handled then begin
                            Rec.CalcInvDiscForHeader;
                            Commit;
                            Page.RunModal(Page::"Sales Statistics", Rec);
                            SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(Rec);
                        end
                    end;
                }

                action("Co&mments")
                {
                    Caption = 'Co&mments', Comment = 'ESP="Comentarios"';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                    ToolTip = 'View or add notes about the sales invoice.', Comment = 'ESP="Ver o agregar notas sobre la factura de venta."';
                }

                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals', Comment = 'ESP="Aprobaciones"';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.', Comment = 'ESP="Ver una lista de los registros que están pendientes de aprobación. Por ejemplo, puede ver quién solicitó la aprobación del registro, cuándo se envió y cuándo debe aprobarse."';

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.SetRecordfilters(Database::"Sales Header", Rec."Document Type", Rec."No.");
                        ApprovalEntries.Run();
                    end;
                }

                action(Function_CustomerCard)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer', Comment = 'ESP="Cliente"';
                    Enabled = CustomerSelected;
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the customer on the sales document.', Comment = 'ESP="Ver o editar información detallada del cliente en el documento de venta."';
                }

                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions', Comment = 'ESP="Dimensiones"';
                    Enabled = Rec."No." <> '';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', Comment = 'ESP="Ver o editar dimensiones, como área, proyecto o departamento, que puede asignar a documentos de venta y compra para distribuir costes y analizar el historial de movimientos."';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
            }
        }

        area(processing)
        {
            group(ApprovalGroup)
            {
                Caption = 'Approval', Comment = 'ESP="Aprobación"';

                action(Approve)
                {
                    Caption = 'Approve', Comment = 'ESP="Aprobar"';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes.', Comment = 'ESP="Aprobar los cambios solicitados."';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }

                action(Reject)
                {
                    Caption = 'Reject', Comment = 'ESP="Rechazar"';
                    Image = Reject;
                    ToolTip = 'Reject the approval request.', Comment = 'ESP="Rechazar la solicitud de aprobación."';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }

                action(Delegate)
                {
                    Caption = 'Delegate', Comment = 'ESP="Delegar"';
                    Image = Delegate;
                    ToolTip = 'Delegate the approval to a substitute approver.', Comment = 'ESP="Delegar la aprobación a un aprobador sustituto."';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }

                action(Comment)
                {
                    Caption = 'Comments', Comment = 'ESP="Comentarios"';
                    Image = ViewComments;
                    ToolTip = 'View or add comments.', Comment = 'ESP="Ver o agregar comentarios."';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }

                action("Desbloquear operación")
                {
                    Caption = 'Unlock operation', Comment = 'ESP="Desbloquear operación"';
                    Image = Approve;

                    trigger OnAction()
                    begin
                        Clear(rBudgetControlSetup);
                        case Rec."Document Type".AsInteger() of
                            0:
                                vDimkey[1] := Format(0);
                            1:
                                vDimkey[1] := Format(1);
                            2:
                                vDimkey[1] := Format(2);
                            3:
                                vDimkey[1] := Format(3);
                            4:
                                vDimkey[1] := Format(4);
                            5:
                                vDimkey[1] := Format(5);
                            6:
                                vDimkey[1] := Format(6);
                        end;
                        vDimkey[2] := Rec."No.";
                        vDimkey[3] := '';
                        rBudgetControlSetup.fUnblockPosting(2, vDimkey);
                    end;
                }
            }

            group(ReleaseGroup)
            {
                Caption = 'Release', Comment = 'ESP="Liberar"';
                Image = ReleaseDoc;

                action(Release)
                {
                    Caption = 'Re&lease', Comment = 'ESP="Liberar"';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }

                action(Reopen)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&open', Comment = 'ESP="Reabrir"';
                    Enabled = Rec.Status <> Rec.Status::Open;
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.', Comment = 'ESP="Reabrir el documento para modificarlo después de que haya sido aprobado. Los documentos aprobados tienen el estado Lanzado y deben abrirse antes de poder modificarse."';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
            }

            group("F&unctions")
            {
                Caption = 'F&unctions', Comment = 'ESP="F&unciones"';
                Image = "Action";

                action(CreatePurchaseInvoice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Purchase Invoice', Comment = 'ESP="Crear factura de compra"';
                    Image = NewPurchaseInvoice;
                    ToolTip = 'Create a new purchase invoice so you can buy items from a vendor.', Comment = 'ESP="Crear una nueva factura de compra para poder adquirir artículos de un proveedor."';

                    trigger OnAction()
                    var
                        SelectedSalesLine: Record "Sales Line";
                        PurchInvFromSalesInvoice: Codeunit "Purch. Doc. From Sales Doc.";
                    begin
                        CurrPage.SalesLines.Page.SetSelectionFilter(SelectedSalesLine);
                        PurchInvFromSalesInvoice.CreatePurchaseInvoice(Rec, SelectedSalesLine);
                    end;
                }

                action(GetRecurringSalesLines)
                {
                    ApplicationArea = Suite;
                    Caption = 'Get Recurring Sales Lines', Comment = 'ESP="Obtener líneas de venta recurrentes"';
                    Ellipsis = true;
                    Image = CustomerCode;
                    ToolTip = 'Insert sales document lines that you have set up for the customer as recurring. Recurring sales lines could be for a monthly replenishment order or a fixed freight expense.', Comment = 'ESP="Insertar líneas de documento de venta que haya configurado como recurrentes para el cliente. Las líneas de venta recurrentes pueden ser, por ejemplo, para un pedido de reposición mensual o un gasto fijo de transporte."';

                    trigger OnAction()
                    var
                        StdCustSalesCode: Record "Standard Customer Sales Code";
                    begin
                        StdCustSalesCode.InsertSalesLines(Rec);
                    end;
                }

                action(CalculateInvoiceDiscount)
                {
                    AccessByPermission = TableData "Cust. Invoice Disc." = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Calculate &Invoice Discount', Comment = 'ESP="Calcular descuento de &factura"';
                    Image = CalculateInvoiceDiscount;
                    ToolTip = 'Calculate the invoice discount for the entire sales document when all sales invoice lines are entered.', Comment = 'ESP="Calcular el descuento de factura para todo el documento de venta cuando se hayan introducido todas las líneas de la factura de venta."';

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                        SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }

                action(CopyDocument)
                {
                    ApplicationArea = Suite;
                    Caption = 'Copy Document', Comment = 'ESP="Copiar documento"';
                    Ellipsis = true;
                    Image = CopyDocument;
                    ToolTip = 'Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.', Comment = 'ESP="Copiar líneas del documento e información de cabecera desde otro documento de venta a este documento. Puede copiar una factura de venta registrada en una nueva factura de venta para crear rápidamente un documento similar."';

                    trigger OnAction()
                    begin
                        CopySalesDoc.SetSalesHeader(Rec);
                        CopySalesDoc.RunModal;
                        Clear(CopySalesDoc);
                        if Rec.Get(Rec."Document Type", Rec."No.") then;
                    end;
                }

                action("Move Negative Lines")
                {
                    Caption = 'Move Negative Lines', Comment = 'ESP="Mover líneas negativas"';
                    Ellipsis = true;
                    Image = MoveNegativeLines;

                    trigger OnAction()
                    begin
                        Clear(MoveNegSalesLines);
                        MoveNegSalesLines.SetSalesHeader(Rec);
                        MoveNegSalesLines.RunModal;
                        MoveNegSalesLines.ShowDocument;
                    end;
                }

                group("Incoming Document")
                {
                    Caption = 'Incoming Document', Comment = 'ESP="Documento entrante"';
                    Image = Documents;

                    action(IncomingDocCard)
                    {
                        Caption = 'View Incoming Document', Comment = 'ESP="Ver documento entrante"';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        ToolTip = 'View any incoming document records and file attachments that exist for the entry or document.', Comment = 'ESP="Ver cualquier registro de documento entrante y archivo adjunto que exista para el movimiento o documento."';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            IncomingDocument.ShowCardFromEntryNo(Rec."Incoming Document Entry No.");
                        end;
                    }

                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData "Incoming Document" = R;
                        Caption = 'Select Incoming Document', Comment = 'ESP="Seleccionar documento entrante"';
                        Image = SelectLineToApply;
                        ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.', Comment = 'ESP="Seleccionar un registro de documento entrante y un archivo adjunto que desee vincular al movimiento o documento."';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            Rec.Validate("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument(Rec."Incoming Document Entry No.", Rec.RecordId));
                        end;
                    }

                    action(IncomingDocAttachFile)
                    {
                        Caption = 'Create Incoming Document from File', Comment = 'ESP="Crear documento entrante desde archivo"';
                        Ellipsis = true;
                        Enabled = not HasIncomingDocument;
                        Image = Attach;
                        ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.', Comment = 'ESP="Crear un registro de documento entrante seleccionando un archivo para adjuntar y, después, vincular el registro del documento entrante al movimiento o documento."';

                        trigger OnAction()
                        var
                            IncomingDocumentAttachment: Record "Incoming Document Attachment";
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromSalesDocument(Rec);
                        end;
                    }

                    action(RemoveIncomingDoc)
                    {
                        Caption = 'Remove Incoming Document', Comment = 'ESP="Eliminar documento entrante"';
                        Enabled = HasIncomingDocument;
                        Image = RemoveLine;
                        ToolTip = 'Remove incoming document records and file attachments.', Comment = 'ESP="Eliminar registros de documentos entrantes y archivos adjuntos."';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            if IncomingDocument.Get(Rec."Incoming Document Entry No.") then
                                IncomingDocument.RemoveLinkToRelatedRecord;
                            Rec."Incoming Document Entry No." := 0;
                            Rec.Modify(true);
                        end;
                    }
                }
            }

            group("Request Approval")
            {
                Caption = 'Request Approval', Comment = 'ESP="Solicitar aprobación"';

                action(SendApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Send A&pproval Request', Comment = 'ESP="Enviar solicitud de a&probación"';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    ToolTip = 'Send an approval request.', Comment = 'ESP="Enviar una solicitud de aprobación."';

                    trigger OnAction()
                    begin
                        if ApprovalsMgmt.CheckSalesApprovalPossible(Rec) then
                            ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                    end;
                }

                action(CancelApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest', Comment = 'ESP="Cancelar solicitud de aprobación"';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.', Comment = 'ESP="Cancelar la solicitud de aprobación."';

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                    end;
                }
            }

            group("P&osting")
            {
                Caption = 'P&osting', Comment = 'ESP="R&egistro"';
                Image = Post;

                action(PostAction)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost', Comment = 'ESP="R&egistrar"';
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.', Comment = 'ESP="Finalizar el documento o diario contabilizando los importes y las cantidades en las cuentas relacionadas de la empresa."';

                    trigger OnAction()
                    begin
                        Post(Codeunit::"Sales-Post (Yes/No)", NavigateAfterPost::"Posted Document");
                    end;
                }

                action(PostAndNew)
                {
                    Caption = 'Post and New', Comment = 'ESP="Registrar y nuevo"';
                    Ellipsis = true;
                    Image = PostOrder;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        Post(Codeunit::"Sales-Post (Yes/No)", NavigateAfterPost::"New Document");
                    end;
                }

                action(PostAndSend)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and &Send', Comment = 'ESP="Registrar y &enviar"';
                    Ellipsis = true;
                    Image = PostSendTo;
                    ToolTip = 'Finalize and prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.', Comment = 'ESP="Finalizar y preparar el envío del documento según el perfil de envío del cliente, por ejemplo como adjunto en un correo electrónico. Primero se abre la ventana Enviar documento para que pueda confirmar o seleccionar un perfil de envío."';

                    trigger OnAction()
                    begin
                        Post(Codeunit::"Sales-Post and Send", NavigateAfterPost::Nowhere);
                    end;
                }

                action(Preview)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Preview Posting', Comment = 'ESP="Previsualizar registro"';
                    Image = ViewPostedOrder;
                    ToolTip = 'View the sales invoice lines before you perform the actual posting.', Comment = 'ESP="Ver las líneas de la factura de venta antes de realizar la contabilización real."';

                    trigger OnAction()
                    begin
                        ShowPreview;
                    end;
                }

                action(PrintDraftInvoice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Draft Invoice', Comment = 'ESP="Imprimir factura borrador"';
                    Ellipsis = true;
                    Image = ViewPostedOrder;
                    ToolTip = 'View or print the sales invoice as a draft before you perform the actual posting.', Comment = 'ESP="Ver o imprimir la factura de venta como borrador antes de realizar la contabilización real."';

                    trigger OnAction()
                    var
                        DocumentPrint: Codeunit "Document-Print";
                    begin
                        DocumentPrint.PrintSalesHeader(Rec);
                    end;
                }

                action("Test Report")
                {
                    Caption = 'Test Report', Comment = 'ESP="Informe de prueba"';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }

                action("Remove From Job Queue")
                {
                    Caption = 'Remove From Job Queue', Comment = 'ESP="Eliminar de cola de trabajos"';
                    Image = RemoveLine;
                    ToolTip = 'Remove the scheduled processing of this record from the job queue.', Comment = 'ESP="Eliminar el procesamiento programado de este registro de la cola de trabajos."';

                    trigger OnAction()
                    begin
                        Rec.CancelBackgroundPosting;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        SIIManagement: Codeunit "SII Management";
    begin
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
        CurrPage.ApprovalFactBox.Page.UpdateApprovalEntriesFromSourceRecord(Rec.RecordId);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.Page.SetFilterOnWorkflowRecord(Rec.RecordId);

        UpdatePaymentService;

        SIIManagement.CombineOperationDescription(Rec."Operation Description", Rec."Operation Description 2", OperationDescription);
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
        WorkDescription := Rec.GetWorkDescription;
        UpdateShipToBillToGroupVisibility
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(Rec.ConfirmDeletion);
    end;

    trigger OnInit()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        JobQueuesUsed := SalesReceivablesSetup.JobQueueActive;
        SetExtDocNoMandatoryCondition;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if DocNoVisible then
            Rec.CheckCreditMaxBeforeInsert();

        if (Rec."Sell-to Customer No." = '') and (Rec.GetFilter("Sell-to Customer No.") <> '') then
            CurrPage.Update(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        xRec.Init();
        Rec."Responsibility Center" := UserMgt.GetSalesFilter;
        if (not DocNoVisible) and (Rec."No." = '') then
            Rec.SetSellToCustomerFromFilter;

        Rec.SetDefaultPaymentServices;
        UpdateShipToBillToGroupVisibility;
    end;

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
        SIIManagement: Codeunit "SII Management";
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FilterGroup(0);
        end;

        SetDocNoVisible;

        if Rec."Quote No." <> '' then
            ShowQuoteNo := true;

        if Rec."No." = '' then
            if OfficeMgt.CheckForExistingInvoice(Rec."Sell-to Customer No.") then
                Error('');

        SIIManagement.CombineOperationDescription(Rec."Operation Description", Rec."Operation Description 2", OperationDescription);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not DocumentIsPosted then
            exit(Rec.ConfirmCloseUnposted)
    end;

    var
        ApplicationAreaMgmt: Codeunit "Application Area Mgmt. Facade";
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        CustomerMgt: Codeunit "Customer Mgt.";
        NavigateAfterPost: Option "Posted Document","New Document",Nowhere;
        WorkDescription: Text;
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        ExternalDocNoMandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        PaymentServiceVisible: Boolean;
        PaymentServiceEnabled: Boolean;
        OpenPostedSalesInvQst: Label 'The invoice has been posted and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?', Comment = 'ESP="La factura se ha registrado y movido a la ventana de facturas de venta registradas.\\¿Desea abrir la factura registrada?"';
        CustomerSelected: Boolean;
        ShowQuoteNo: Boolean;
        JobQueuesUsed: Boolean;
        CanCancelApprovalForRecord: Boolean;
        DocumentIsPosted: Boolean;
        ShipToOptions: Enum "Sales Ship-to Options";
        BillToOptions: Enum "Sales Bill-to Options";
        OperationDescription: Text[500];
        rBudgetControlSetup: Record "Budget Control Setup";
        vDimkey: array[3] of Text;

    local procedure Post(PostingCodeunitID: Integer; Navigate: Option)
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        OfficeMgt: Codeunit "Office Management";
        InstructionMgt: Codeunit "Instruction Mgt.";
        PreAssignedNo: Code[20];
    begin
        if ApplicationAreaMgmt.IsFoundationEnabled then
            LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
        PreAssignedNo := Rec."No.";

        Rec.SendToPosting(PostingCodeunitID);

        DocumentIsPosted := not SalesHeader.Get(Rec."Document Type", Rec."No.");

        if Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting" then
            CurrPage.Close();
        CurrPage.Update(false);

        if PostingCodeunitID <> Codeunit::"Sales-Post (Yes/No)" then
            exit;

        if OfficeMgt.IsAvailable then begin
            SalesInvoiceHeader.SetCurrentKey("Pre-Assigned No.");
            SalesInvoiceHeader.SetRange("Pre-Assigned No.", PreAssignedNo);
            if SalesInvoiceHeader.FindFirst() then
                Page.Run(Page::"Posted Sales Invoice", SalesInvoiceHeader);
        end else
            case Navigate of
                NavigateAfterPost::"Posted Document":
                    if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) then
                        ShowPostedConfirmationMessage(PreAssignedNo);
                NavigateAfterPost::"New Document":
                    if DocumentIsPosted then begin
                        SalesHeader.Init();
                        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
                        SalesHeader.Insert(true);
                        Page.Run(Page::"Sales Invoice", SalesHeader);
                    end;
            end;
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.SalesLines.Page.ApproveCalcInvDisc;
    end;

    local procedure ShowPostedConfirmationMessage(PreAssignedNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        SalesInvoiceHeader.SetCurrentKey("Pre-Assigned No.");
        SalesInvoiceHeader.SetRange("Pre-Assigned No.", PreAssignedNo);
        if SalesInvoiceHeader.FindFirst() then
            if InstructionMgt.ShowConfirm(OpenPostedSalesInvQst, InstructionMgt.ShowPostedConfirmationMessageCode) then
                Page.Run(Page::"Posted Sales Invoice", SalesInvoiceHeader);
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.Page.UpdatePage(true);
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Invoice, Rec."No.");
    end;

    local procedure SetExtDocNoMandatoryCondition()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
    end;

    local procedure ShowPreview()
    var
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
    begin
        SalesPostYesNo.Preview(Rec);
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        SetExtDocNoMandatoryCondition;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

        CustomerSelected := Rec."Sell-to Customer No." <> '';
    end;

    local procedure UpdatePaymentService()
    var
        PaymentServiceSetup: Record "Payment Service Setup";
    begin
        PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;
        PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
    end;

    local procedure UpdateShipToBillToGroupVisibility()
    begin
        CustomerMgt.CalculateShipBillToOptions(ShipToOptions, BillToOptions, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeStatisticsAction(var SalesHeader: Record "Sales Header"; var Handled: Boolean)
    begin
    end;
}