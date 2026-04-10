page 50039 "Sales Invoice List - Fact. Col"
{
    Caption = 'Sales Invoices', Comment = 'ESP="Facturas venta - fact. colegios"';
    CardPageID = "Sales Invoice - Fact. colegios";
    DataCaptionFields = "Sell-to Customer No.";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = CONST(Invoice));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the sales document.', Comment = 'ESP="Especifica el número del documento de venta."';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default.', Comment = 'ESP="Especifica el número del cliente que recibirá los productos y al que se facturará por defecto."';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.', Comment = 'ESP="Especifica el nombre del cliente que recibirá los productos y al que se facturará por defecto."';
                }
                field("Posting date"; Rec."Posting date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the posting of the sales document will be recorded.', Comment = 'ESP="Especifica la fecha en la que se registrará la contabilización del documento de venta."';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount on the purchase document.', Comment = 'ESP="Especifica una fórmula que calcula la fecha de vencimiento del pago, la fecha de descuento por pronto pago y el importe del descuento en el documento de compra."';
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the sum of amounts in the Line Amount field on the sales order lines. It is used to calculate the invoice discount of the sales order.', Comment = 'ESP="Especifica la suma de los importes del campo Importe línea en las líneas del pedido de venta. Se utiliza para calcular el descuento de factura del pedido de venta."';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                }
                field("User Full Name"; Rec."User Full Name")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(CustomerStatisticsFactBox; "Customer Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Bill-to Customer No."),
                              "Date Filter" = FIELD("Date Filter");
            }
            part(CustomerDetailsFactBox; "Customer Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Bill-to Customer No."),
                              "Date Filter" = FIELD("Date Filter");
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = All;
                ShowFilter = false;
                Visible = false;
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
                actionref(DimensionsPromoted; Dimensions)
                {
                }
                actionref(ApprovalsPromoted; Approvals)
                {
                }
                actionref(CustomerPromoted; Customer)
                {
                }
            }

            group(ReleasePromoted)
            {
                Caption = 'Release', Comment = 'ESP="Liberar"';

                actionref(ReleaseActionPromoted; "Re&lease")
                {
                }
                actionref(ReopenActionPromoted; "Re&open")
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

                actionref(PostActionPromoted; Post_Action)
                {
                }
                actionref(PostBatchPromoted; "Post &Batch")
                {
                }
                actionref(PostAndSendPromoted; PostAndSend)
                {
                }
            }
        }
        area(navigation)
        {
            group(InvoiceNav)
            {
                Caption = 'Invoice', Comment = 'ESP="Factura"';
                Image = Invoice;

                action(Statistics)
                {
                    Caption = 'Statistics', Comment = 'ESP="Estadísticas"';
                    Image = Statistics;
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.', Comment = 'ESP="Ver información estadística, como el valor de los movimientos contabilizados, del registro."';

                    trigger OnAction()
                    begin
                        Rec.CalcInvDiscForHeader;
                        Commit;
                        Page.RunModal(Page::"Sales Statistics", Rec);
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Comments', Comment = 'ESP="Comentarios"';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                    ToolTip = 'View or add notes about the sales invoice.', Comment = 'ESP="Ver o agregar notas sobre la factura de venta."';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions', Comment = 'ESP="Dimensiones"';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', Comment = 'ESP="Ver o editar dimensiones, como área, proyecto o departamento, que puede asignar a documentos de venta y compra para distribuir costes y analizar el historial de movimientos."';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                    end;
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
                        ApprovalEntries.SetRecordFilters(Database::"Sales Header", Rec."Document Type", Rec."No.");
                        ApprovalEntries.Run();
                    end;
                }
                action(Customer)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer', Comment = 'ESP="Cliente"';
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the customer on the selected sales document.', Comment = 'ESP="Ver o editar información detallada del cliente en el documento de venta seleccionado."';
                }
            }
        }
        area(processing)
        {
            group(InvoiceGroup)
            {
                Caption = 'Invoice', Comment = 'ESP="Factura"';
                Image = Invoice;
            }

            group(ReleaseGroup)
            {
                Caption = 'Release', Comment = 'ESP="Liberar"';
                Image = ReleaseDoc;

                action("Re&lease")
                {
                    Caption = 'Release', Comment = 'ESP="Liberar"';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Reopen', Comment = 'ESP="Reabrir"';
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

            group(RequestApprovalGroup)
            {
                Caption = 'Request Approval', Comment = 'ESP="Solicitar aprobación"';
                Image = "Action";

                action(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request', Comment = 'ESP="Enviar solicitud de aprobación"';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    ToolTip = 'Send an approval request.', Comment = 'ESP="Enviar una solicitud de aprobación."';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckSalesApprovalPossible(Rec) then
                            ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request', Comment = 'ESP="Cancelar solicitud de aprobación"';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.', Comment = 'ESP="Cancelar la solicitud de aprobación."';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                    end;
                }
            }

            group(PostingGroup)
            {
                Caption = 'Posting', Comment = 'ESP="Registro"';
                Image = Post;

                action("Test Report")
                {
                    Caption = 'Test Report', Comment = 'ESP="Informe de prueba"';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.', Comment = 'ESP="Ver un informe de prueba para poder encontrar y corregir errores antes de realizar la contabilización real del diario o documento."';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }
                action(Post_Action)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post', Comment = 'ESP="Registrar"';
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.', Comment = 'ESP="Finalizar el documento o diario contabilizando los importes y las cantidades en las cuentas relacionadas de la empresa."';

                    trigger OnAction()
                    begin
                        Post(Codeunit::"Sales-Post (Yes/No)");
                    end;
                }
                action("Post &Batch")
                {
                    Caption = 'Post Batch', Comment = 'ESP="Registrar en lote"';
                    Ellipsis = true;
                    Image = PostBatch;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Batch Post Sales Invoices", true, true, Rec);
                        CurrPage.Update(false);
                    end;
                }
                action(PostAndSend)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and Send', Comment = 'ESP="Registrar y enviar"';
                    Ellipsis = true;
                    Image = PostSendTo;
                    ToolTip = 'Finalize and prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.', Comment = 'ESP="Finalizar y preparar el envío del documento según el perfil de envío del cliente, por ejemplo como adjunto en un correo electrónico. Primero se abre la ventana Enviar documento para que pueda confirmar o seleccionar un perfil de envío."';

                    trigger OnAction()
                    begin
                        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
                        Rec.SendToPosting(Codeunit::"Sales-Post and Send");
                    end;
                }
                action("Remove From Job Queue")
                {
                    Caption = 'Remove From Job Queue', Comment = 'ESP="Eliminar de cola de trabajos"';
                    Image = RemoveLine;
                    ToolTip = 'Remove the scheduled processing of this record from the job queue.', Comment = 'ESP="Eliminar el procesamiento programado de este registro de la cola de trabajos."';
                    Visible = JobQueueActive;

                    trigger OnAction()
                    begin
                        Rec.CancelBackgroundPosting;
                    end;
                }
                action(Preview)
                {
                    Caption = 'Preview Posting', Comment = 'ESP="Previsualizar registro"';
                    Image = ViewPostedOrder;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.', Comment = 'ESP="Revisar los distintos tipos de movimientos que se crearán al contabilizar el documento o diario."';

                    trigger OnAction()
                    begin
                        ShowPreview;
                    end;
                }
            }
        }
        area(reporting)
        {
            group(Reports)
            {
                Caption = 'Reports', Comment = 'ESP="Informes"';
                Image = "Report";

                group(FinanceReports)
                {
                    Caption = 'Finance Reports', Comment = 'ESP="Informes financieros"';
                    Image = "Report";

                    action("Report Statement")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Statement', Comment = 'ESP="Extracto"';
                        Image = "Report";
                        ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.', Comment = 'ESP="Ver una lista de los movimientos de un cliente para un período seleccionado, por ejemplo para enviársela al cierre de un período contable. Puede elegir mostrar todos los saldos vencidos independientemente del período especificado o incluir una antigüedad de saldos."';

                        trigger OnAction()
                        var
                            Customer: Record Customer;
                        begin
                            Codeunit.Run(Codeunit::"Customer Layout - Statement", Customer);
                        end;
                    }
                    action("Customer - Balance to Date")
                    {
                        Caption = 'Customer - Balance to Date', Comment = 'ESP="Cliente - Saldo a fecha"';
                        Image = "Report";
                        RunObject = Report "Customer - Balance to Date";
                        ToolTip = 'View, print, or save customers'' balances on a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.', Comment = 'ESP="Ver, imprimir o guardar los saldos de clientes en una fecha determinada. Puede utilizar el informe para extraer sus ingresos totales por ventas al cierre de un período contable o ejercicio fiscal."';
                    }
                    action("Customer - Trial Balance")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Customer - Trial Balance', Comment = 'ESP="Cliente - Balance de comprobación"';
                        Image = "Report";
                        RunObject = Report "Customer - Trial Balance";
                        ToolTip = 'View the beginning and ending balance for customers with entries within a specified period. The report can be used to verify that the balance for a customer posting group is equal to the balance on the corresponding general ledger account on a certain date.', Comment = 'ESP="Ver el saldo inicial y final de los clientes con movimientos dentro de un período determinado. El informe puede usarse para comprobar que el saldo de un grupo contable de clientes coincide con el saldo de la cuenta contable correspondiente en una fecha concreta."';
                    }
                    action("Customer - Detail Trial Bal.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Detail Trial Bal.', Comment = 'ESP="Cliente - Balance detallado"';
                        Image = "Report";
                        RunObject = Report "Customer - Detail Trial Bal.";
                        ToolTip = 'View the balance for customers with balances on a specified date. For example, the report can be used at the close of an accounting period or for an audit.', Comment = 'ESP="Ver el saldo de los clientes con saldo en una fecha determinada. Por ejemplo, el informe puede utilizarse al cierre de un período contable o para una auditoría."';
                    }
                    action("Customer - Summary Aging")
                    {
                        Caption = 'Customer - Summary Aging', Comment = 'ESP="Cliente - Resumen de antigüedad"';
                        Image = "Report";
                        RunObject = Report "Customer - Summary Aging";
                        ToolTip = 'View, print, or save a summary of each customer''s total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer''s creditworthiness, or to prepare liquidity analyses.', Comment = 'ESP="Ver, imprimir o guardar un resumen de los pagos totales vencidos de cada cliente, dividido en tres períodos de tiempo. El informe puede utilizarse para decidir cuándo emitir recordatorios, evaluar la solvencia del cliente o preparar análisis de liquidez."';
                    }
                    action("Customer - Detailed Aging")
                    {
                        Caption = 'Customer - Detailed Aging', Comment = 'ESP="Cliente - Antigüedad detallada"';
                        Image = "Report";
                        RunObject = Report "Customer Detailed Aging";
                        ToolTip = 'View, print, or save a detailed list of each customer''s total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer''s creditworthiness, or to prepare liquidity analyses.', Comment = 'ESP="Ver, imprimir o guardar una lista detallada de los pagos totales vencidos de cada cliente, dividida en tres períodos de tiempo. El informe puede utilizarse para decidir cuándo emitir recordatorios, evaluar la solvencia del cliente o preparar análisis de liquidez."';
                    }
                    action("Aged Accounts Receivable")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged Accounts Receivable', Comment = 'ESP="Antigüedad de cuentas por cobrar"';
                        Image = "Report";
                        RunObject = Report "Aged Accounts Receivable";
                        ToolTip = 'View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.', Comment = 'ESP="Ver un resumen de cuándo vencen o están vencidos los pagos de clientes, dividido en cuatro períodos. Debe especificar la fecha a partir de la cual desea calcular la antigüedad y la duración del período del que cada columna contendrá datos."';
                    }
                    action("Customer - Payment Receipt")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Customer - Payment Receipt', Comment = 'ESP="Cliente - Recibo de pago"';
                        Image = "Report";
                        RunObject = Report "Customer - Payment Receipt";
                        ToolTip = 'View a document showing which customer ledger entries that a payment has been applied to. This report can be used as a payment receipt that you send to the customer.', Comment = 'ESP="Ver un documento que muestra a qué movimientos de cliente se ha aplicado un pago. Este informe puede utilizarse como justificante de pago para enviárselo al cliente."';
                    }
                }
                group(SalesReports)
                {
                    Caption = 'Sales Reports', Comment = 'ESP="Informes de ventas"';
                    Image = "Report";

                    action("Customer - Top 10 List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Top 10 List', Comment = 'ESP="Cliente - Top 10"';
                        Image = "Report";
                        RunObject = Report "Customer - Top 10 List";
                        ToolTip = 'View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.', Comment = 'ESP="Ver qué clientes compran más o deben más en un período seleccionado. Solo se incluirán los clientes que tengan compras durante el período o saldo al final del mismo."';
                    }
                    action("Customer - Sales List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Sales List', Comment = 'ESP="Cliente - Lista de ventas"';
                        Image = "Report";
                        RunObject = Report "Customer - Sales List";
                        ToolTip = 'View customer sales in a period, for example, to report sales activity to customs and tax authorities.', Comment = 'ESP="Ver las ventas de clientes en un período, por ejemplo para informar de la actividad de ventas a las autoridades aduaneras y fiscales."';
                    }
                    action("Sales Statistics")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Statistics', Comment = 'ESP="Estadísticas de ventas"';
                        Image = "Report";
                        RunObject = Report "Sales Statistics";
                        ToolTip = 'View the customer''s total cost, sale, and profit over time, for example, to analyze earnings trends. The report shows amounts for original and adjusted cost, sales, profit, invoice discount, payment discount, and profit percentage in three adjustable periods.', Comment = 'ESP="Ver el coste, la venta y el beneficio totales del cliente a lo largo del tiempo, por ejemplo para analizar tendencias de rentabilidad. El informe muestra importes de coste original y ajustado, ventas, beneficio, descuento de factura, descuento por pronto pago y porcentaje de beneficio en tres períodos ajustables."';
                    }
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    end;

    trigger OnOpenPage()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        Rec.SetSecurityFilterOnRespCenter;
        JobQueueActive := SalesSetup.JobQueueActive;

        Rec.CopySellToCustomerFilter;
    end;

    var
        DummyApplicationAreaMgmt: Codeunit "Application Area Mgmt. Facade";
        ReportPrint: Codeunit "Test Report-Print";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        JobQueueActive: Boolean;
        OpenApprovalEntriesExist: Boolean;
        OpenPostedSalesInvQst: Label 'The invoice has been posted and moved to the Posted Sales Invoice list.\\Do you want to open the posted invoice?';
        CanCancelApprovalForRecord: Boolean;

    procedure ShowPreview()
    var
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
    begin
        SalesPostYesNo.Preview(Rec);
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
    end;

    local procedure Post(PostingCodeunitID: Integer)
    var
        PreAssignedNo: Code[20];
    begin
        if DummyApplicationAreaMgmt.IsFoundationEnabled then begin
            LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
            PreAssignedNo := Rec."No.";
        end;

        Rec.SendToPosting(PostingCodeunitID);

        if DummyApplicationAreaMgmt.IsFoundationEnabled then
            ShowPostedConfirmationMessage(PreAssignedNo);
    end;

    local procedure ShowPostedConfirmationMessage(PreAssignedNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader.SetRange("Pre-Assigned No.", PreAssignedNo);
        if SalesInvoiceHeader.FindFirst() then
            if Dialog.Confirm(OpenPostedSalesInvQst, false) then
                Page.Run(Page::"Posted Sales Invoice", SalesInvoiceHeader);
    end;
}