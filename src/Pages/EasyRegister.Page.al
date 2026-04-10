page 50006 "Easy Register"
{
    // Mod. S2G (IVC) 18/05/15 Notificaciones por email
    // Mod. S2G (FMR) 23-06-15 Reversión movs. caja
    //                           Código
    //                             fViewEntries

    Caption = 'Easy Register', Comment = 'ESP="Registro simple"';
    PageType = Worksheet;
    SourceTable = "Gen. Journal Batch";
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';

                field(vCompanyName; vCompanyName)
                {
                    Caption = 'Company Name', Comment = 'ESP="Nombre empresa"';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
            }
            group(Options)
            {
                Caption = 'Options', Comment = 'ESP="Opciones"';

                field(vCashRegType; vCashRegType)
                {
                    Caption = 'Select Option', Comment = 'ESP="Seleccionar opción"';
                    OptionCaption = ' ,Income,Expense,Transfer,Payroll', Comment = 'ESP=" ,Ingreso,Gasto,Transferencia,Nómina"';

                    trigger OnValidate()
                    begin
                        vCashRcptOpType := 0;
                        vPmtOpType := 0;
                        fInitValues;

                        //RBM-R
                        /*
                        IF vCashRegType = vCashRegType::"View Entries" THEN BEGIN
                          fViewEntries;
                          vCashRegType := 0;
                          CurrPage.UPDATE;
                        END;
                        */
                        //RBM-R
                    end;
                }
            }
            group("Cash Receipts")
            {
                Caption = 'Cash Receipts', Comment = 'ESP="Recibos de caja"';
                Visible = vCashRegType = vCashRegType::"Receipts";

                field(CashRcptOperationType; vCashRcptOpType)
                {
                    Caption = 'Tipo operación';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        fInitValues;
                    end;

                    trigger OnValidate()
                    begin
                        fInitValues;
                    end;
                }
            }
            group("Bank Receipts Group")
            {
                Caption = 'Bank Receipts', Comment = 'ESP="Recibos bancarios"';
                Visible = (vCashRegType = vCashRegType::"Receipts") AND (vCashRcptOpType = vCashRcptOpType::"Ingreso");

                field(PostingDate4; vPostingDate)
                {
                    Caption = 'Payment Date', Comment = 'ESP="Fecha pago"';
                }
                field(Concepto4; vConcepto3)
                {
                    Caption = 'Concepto';
                    TableRelation = "Easy Register Concepts".Code WHERE(Type = CONST(Receipts));

                    trigger OnValidate()
                    begin
                        vConcepto := vConcepto3;
                        IF vConcepto = '' THEN
                            vConceptoName := ''
                        ELSE BEGIN
                            rConcepto.GET(vConcepto);
                            vConceptoName := rConcepto.Description;
                        END;
                    end;
                }
                field(ConceptoName4; vConceptoName)
                {
                    Caption = 'Nombre concepto';
                    Editable = false;
                    QuickEntry = false;
                }
                field("Banco/Caja"; vBanco)
                {
                    TableRelation = "Bank Account";

                    trigger OnValidate()
                    begin
                        IF vBanco = '' THEN
                            vBancoName := ''
                        ELSE BEGIN
                            rBank.GET(vBanco);
                            vBancoName := rBank.Name;
                        END;
                    end;
                }
                field(BankName4; vBancoName)
                {
                    Editable = false;
                    QuickEntry = false;
                }
                field(TotalAmount4; vTotalAmount)
                {
                    Caption = 'Total Amount to Refund', Comment = 'ESP="Importe total a reembolsar"';
                }
            }
            group(Payments)
            {
                Caption = 'Payments', Comment = 'ESP="Pagos"';
                Visible = vCashRegType = vCashRegType::Payments;

                field(PmtOperationType; vPmtOpType)
                {
                    Caption = 'Operation Type', Comment = 'ESP="Tipo operación"';

                    trigger OnValidate()
                    begin
                        fInitValues;

                        //>>
                        Rec.RESET();
                        Rec.SETRANGE("Journal Template Name", rGenJnlTemplate.Name);
                        Rec.FINDFIRST();
                        IF Rec.COUNT = 1 THEN
                            vGenJnlBatch := Rec.Name;
                        //<<
                    end;
                }
            }
            group("Customer Receipts")
            {
                Caption = 'Customer Receipts', Comment = 'ESP="Recibos de cliente"';
                Visible = (vCashRegType = vCashRegType::"Payments") AND ((vPmtOpType = vPmtOpType::"Con justificante (tique o factura)") OR (vPmtOpType = vPmtOpType::Abono));

                field(PostingDate3; vPostingDate)
                {
                }
                field(TotalAmount3; vTotalAmount)
                {
                    Caption = 'Total Amount to Refund', Comment = 'ESP="Importe total a reembolsar"';
                }
                field(VendNo3; vVendorNo)
                {
                    Caption = 'Vendor No.', Comment = 'ESP="Nº proveedor"';
                    TableRelation = Vendor;

                    trigger OnValidate()
                    begin
                        IF vVendorNo = '' THEN
                            vVendorName := ''
                        ELSE BEGIN
                            rVend.GET(vVendorNo);
                            vVendorName := rVend.Name;
                        END;
                    end;
                }
                field(VendName3; vVendorName)
                {
                    Editable = false;
                }
                field(DocExterno; vDocExt)
                {
                    Caption = 'External Document', Comment = 'ESP="Documento externo"';
                }
                field(Concepto3; vConcepto2)
                {
                    Caption = 'Concepto';
                    TableRelation = "Easy Register Concepts".Code WHERE(Type = CONST(Payments));

                    trigger OnValidate()
                    begin
                        vConcepto := vConcepto2;
                        IF vConcepto = '' THEN
                            vConceptoName := ''
                        ELSE BEGIN
                            rConcepto.GET(vConcepto);
                            vConceptoName := rConcepto.Description;
                        END;
                    end;
                }
                field(ConceptoName3; vConceptoName)
                {
                    Caption = 'Nombre concepto';
                    Editable = false;
                }
                field("Banco/Caja3"; vBanco)
                {
                    TableRelation = "Bank Account";

                    trigger OnValidate()
                    begin
                        IF vBanco = '' THEN
                            vBancoName := ''
                        ELSE BEGIN
                            rBank.GET(vBanco);
                            vBancoName := rBank.Name;
                        END;
                    end;
                }
                field(BankName3; vBancoName)
                {
                    Editable = false;
                }
            }
            group("Bank Receipts")
            {
                Caption = 'Bank Receipts', Comment = 'ESP="Recibos bancarios"';
                Visible = (vCashRegType = vCashRegType::"Payments") AND (vPmtOpType = vPmtOpType::"Sin justificante (tique o factura)");

                field(PostingDate5; vPostingDate)
                {
                }
                field(Concepto5; vConcepto4)
                {
                    Caption = 'Concepto';
                    TableRelation = "Easy Register Concepts".Code WHERE(Type = CONST(Payments));

                    trigger OnValidate()
                    begin
                        vConcepto := vConcepto4;
                        IF vConcepto = '' THEN
                            vConceptoName := ''
                        ELSE BEGIN
                            rConcepto.GET(vConcepto);
                            vConceptoName := rConcepto.Description;
                        END;
                    end;
                }
                field(ConceptoName5; vConceptoName)
                {
                    Caption = 'Nombre concepto';
                    Editable = false;
                }
                field("Banco/Caja5"; vBanco)
                {
                    Caption = 'Bank', Comment = 'ESP="Banco"';
                    TableRelation = "Bank Account";

                    trigger OnValidate()
                    begin
                        IF vBanco = '' THEN
                            vBancoName := ''
                        ELSE BEGIN
                            rBank.GET(vBanco);
                            vBancoName := rBank.Name;
                        END;
                    end;
                }
                field(BankName5; vBancoName)
                {
                    Caption = 'Customer Name', Comment = 'ESP="Nombre cliente"';
                    Editable = false;
                }
                field(TotalAmount5; vTotalAmount)
                {
                    Caption = 'Total Amount to Refund', Comment = 'ESP="Importe total a reembolsar"';
                }
            }
            group(TransferGroup)
            {
                Caption = 'Transfer', Comment = 'ESP="Transferencia"';
                Visible = vCashRegType = vCashRegType::Transfers;

                field(PostingDate6; vPostingDate)
                {
                    Caption = 'Payment Date', Comment = 'ESP="Fecha pago"';
                }
                field(Concepto6; vConcepto5)
                {
                    Caption = 'Concepto';
                    Editable = false;
                    TableRelation = "Easy Register Concepts".Code WHERE(Type = CONST(Transfers));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        vConcepto := vConcepto5;
                        IF vConcepto = '' THEN
                            vConceptoName := ''
                        ELSE BEGIN
                            rConcepto.GET(vConcepto);
                            vConceptoName := rConcepto.Description;
                        END;
                    end;
                }
                field(ConceptoName6; vConceptoName)
                {
                    Caption = 'Nombre concepto';
                    Editable = false;
                    Visible = false;
                }
                field("SaleBanco/Caja6"; vBanco)
                {
                    Caption = 'Bank', Comment = 'ESP="Banco"';
                    TableRelation = "Bank Account";

                    trigger OnValidate()
                    begin
                        IF vBanco = '' THEN
                            vBancoName := ''
                        ELSE BEGIN
                            rBank.GET(vBanco);
                            vBancoName := rBank.Name;
                        END;
                    end;
                }
                field(SaleBankName6; vBancoName)
                {
                    Caption = 'Customer Name', Comment = 'ESP="Nombre cliente"';
                    Editable = false;
                }
                field("EntraBanco/Caja6"; vBanco2)
                {
                    TableRelation = "Bank Account";

                    trigger OnValidate()
                    begin
                        IF vBanco2 = '' THEN
                            vBancoName2 := ''
                        ELSE BEGIN
                            rBank.GET(vBanco2);
                            vBancoName2 := rBank.Name;
                        END;
                    end;
                }
                field(EntraBankName6; vBancoName2)
                {
                    Editable = false;
                }
                field(TotalAmount6; vTotalAmount)
                {
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer', Comment = 'ESP="Transferencia"';
                Visible = vCashRegType = vCashRegType::Payroll;

                field(PostingDate7; vPostingDate)
                {
                }
                field(CocinaComedor; vTotalDevCocinaComedor)
                {
                }
                field(VigRecep; vTotalDevVigRecep)
                {
                }
                field(Limpieza; vTotalDevLimpieza)
                {
                }
                field(Biblioteca; vTotalDevBiblioteca)
                {
                    Caption = 'Imp. Devengado Biblioteca';
                }
                field(Enfermeria; vTotalDevEnfermeria)
                {
                    Caption = 'Imp. Devengado Enfermeria';
                }
                field(Otros; vTotalDevOtros)
                {
                    Caption = 'Imp. Devengado Otros';
                }
                field(SSCompany; vSSCompany)
                {
                    Caption = 'Seg. Social a cargo empresa';
                }
                field(SSEmployee; vSSEmployee)
                {
                    Caption = 'Seg. Social a cargo empleado';
                }
                field(IRPF; vIRPF)
                {
                    Caption = 'IRPF';
                }
                field(ImporteLiquido; vImporteLiquido)
                {
                    Caption = 'Importe Líquido';
                }
                field(CocinaComedorIT; vTotalDevCocinaComedor)
                {
                    Caption = 'Imp. Devengado Cocina Comedor IT';
                }
                field(VigRecepIT; vTotalDevVigRecep)
                {
                    Caption = 'Imp. Devengado Vigilancia/Recepción IT';
                }
                field(LimpiezaIT; vTotalDevLimpieza)
                {
                    Caption = 'Imp. Devengado Limpieza IT';
                }
                field(BibliotecaIT; vTotalDevBiblioteca)
                {
                    Caption = 'Imp. Devengado Biblioteca IT';
                }
                field(EnfermeriaIT; vTotalDevEnfermeria)
                {
                    Caption = 'Imp. Devengado Enfermeria IT';
                }
                field(OtrosIT; vTotalDevOtros)
                {
                    Caption = 'Imp. Devengado Otros IT';
                }
            }
        }
        area(factboxes)
        {
            part(Picture; Picture)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ShowFilter = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Post")
            {
                Caption = 'Post', Comment = 'ESP="Registrar"';
                Image = Post;

                trigger OnAction()
                begin
                    IF vCashRegType <> vCashRegType::Payroll THEN BEGIN
                        IF vTotalAmount <> 0 THEN
                            fPostOperation
                        ELSE
                            ERROR(ctBlankAmount);
                    END ELSE
                        fPostOperation;
                end;
            }
        }
        area(Promoted)
        {
            group(Process)
            {
                Caption = 'Process', Comment = 'ESP="Procesar"';

                actionref(Post_Promoted; "&Post")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        rGenJnlTemplate.RESET();
        rGenJnlTemplate.SETRANGE(Type, rGenJnlTemplate.Type::EasyRegister);
        IF NOT rGenJnlTemplate.FINDFIRST() THEN
            ERROR(ctTemplateNotFound);

        Rec.RESET();
        Rec.SETRANGE("Journal Template Name", rGenJnlTemplate.Name);
        Rec.FINDFIRST();

        vCompanyName := COMPANYNAME;
        fInitValues;

        rCompanyInfo.GET();
        rCompanyInfo.CALCFIELDS(Picture);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF (vTotalAmount <> 0) AND (NOT vPosted) THEN
            IF NOT CONFIRM(ctNonPostedOpWarning) THEN
                EXIT(FALSE);
    end;

    var
        rGenJnlTemplate: Record "Gen. Journal Template";
        rCompanyInfo: Record "Company Information";
        rVend: Record Vendor;
        rBank: Record "Bank Account";
        rConcepto: Record "Easy Register Concepts";
        vCompanyName: Text[50];
        vConcepto: Code[10];
        vConcepto1: Code[10];
        vConcepto2: Code[10];
        vConcepto3: Code[10];
        vConcepto4: Code[10];
        vConcepto5: Code[10];
        vConceptoName: Text[50];
        vTercero: Code[20];
        vTerceroName: Text[50];
        vBanco: Code[20];
        vBancoName: Text[50];
        vBanco2: Code[20];
        vBancoName2: Text[50];
        vDescrip: Text[50];
        vCustName: Text[50];
        vVendorName: Text[50];
        vGenJnlBatch: Code[20];
        vCustNo: Code[20];
        vVendorNo: Code[20];
        vCashRegType: Option " ",Receipts,Payments,Transfers,Payroll;
        vCashRcptOpType: Option " ",Ingreso;
        vPmtOpType: Option " ","Sin justificante (tique o factura)","Con justificante (tique o factura)",Abono;
        vPostingDate: Date;
        vTotalAmount: Decimal;
        vPosted: Boolean;
        ctProcessFinishedMsg: Label 'Process has successfully finished', Comment = 'ESP="El proceso ha finalizado correctamente"';
        ctNonPostedOpWarning: Label 'Aún no ha contabilizado la operación pulsando el botón "Registrar". Si cierra la página perderá los cambios realizados. ¿Confirma que desea cerrar la página de todos modos?';
        ctBlankAmount: Label 'El importe no puede ser cero.';
        vDocExt: Code[20];
        ctTemplateNotFound: Label 'Debe configurar un libro diario de tipo "Registro simple" antes de continuar.';
        vTotalDevCocinaComedor: Decimal;
        vTotalDevVigRecep: Decimal;
        vTotalDevLimpieza: Decimal;
        vTotalDevBiblioteca: Decimal;
        vTotalDevEnfermeria: Decimal;
        vTotalDevOtros: Decimal;
        vITTotalDevCocinaComedor: Decimal;
        vITTotalDevVigRecep: Decimal;
        vITTotalDevLimpieza: Decimal;
        vITTotalDevBiblioteca: Decimal;
        vITTotalDevEnfermeria: Decimal;
        vITTotalDevOtros: Decimal;
        vSSCompany: Decimal;
        vSSEmployee: Decimal;
        vIRPF: Decimal;
        vImporteLiquido: Decimal;

    procedure fInitValues()
    begin
        //vPostingDate := 0D;
        vPostingDate := WORKDATE;
        vConceptoName := '';
        vConcepto := '';
        vConcepto1 := '';
        vConcepto2 := '';
        vConcepto3 := '';
        vConcepto4 := '';
        vConcepto5 := '';
        vGenJnlBatch := '';
        vBanco := '';
        vBancoName := '';
        vBanco2 := '';
        vBancoName2 := '';
        vTercero := '';
        vTerceroName := '';
        vTotalAmount := 0;
        vDescrip := '';
        vVendorNo := '';
        vVendorName := '';
        vCustNo := '';
        vCustName := '';
        vPosted := FALSE;
    end;

    procedure fPostOperation()
    var
        clCashRegMgt: Codeunit "Easy Register Management";
    begin
        clCashRegMgt.fSetGenJnlTemplate(rGenJnlTemplate.Name);
        CASE TRUE OF
            // Mod. S2G (JMP) 12/03/2018 GF002: Antes este CASE estaba descomentado, pero se pidió eliminar el Type Ingreso Identificado

            //*** INGRESOS
            //  (vCashRegType = vCashRegType::Receipts) AND ((vCashRcptOpType = vCashRcptOpType::"Ingreso Identificado")):
            //   BEGIN
            //      clCashRegMgt.fSetCashRcptCustPostData(vPostingDate,vCustNo,vTotalAmount,vConcepto,vBanco);
            //      clCashRegMgt.fPostCustCashReceipt;
            //    END;

            // Mod. S2G (JMP) 12/03/2018 GF002: Antes este CASE estaba descomentado, pero se pidió eliminar el Type Ingreso Identificado
            (vCashRegType = vCashRegType::Receipts) AND (vCashRcptOpType = vCashRcptOpType::Ingreso):
                BEGIN
                    clCashRegMgt.fSetCashRcptBankPostData(vPostingDate, vBanco, vTotalAmount, vConcepto);
                    clCashRegMgt.fPostBankCashReceipt;
                END;

            //*** GASTOS
            (vCashRegType = vCashRegType::Payments) AND (vPmtOpType = vPmtOpType::"Con justificante (tique o factura)"):
                BEGIN
                    clCashRegMgt.fSetCashPmntVendPostData(vPostingDate, vVendorNo, vTotalAmount, vConcepto, vBanco, vDocExt);
                    clCashRegMgt.fPostVendCashPmnt;
                END;

            (vCashRegType = vCashRegType::Payments) AND (vPmtOpType = vPmtOpType::"Sin justificante (tique o factura)"):
                BEGIN
                    clCashRegMgt.fSetCashPmntBankPostData(vPostingDate, vBanco, vTotalAmount, vConcepto);
                    clCashRegMgt.fPostBankCashPmnt;
                END;

            (vCashRegType = vCashRegType::Payments) AND (vPmtOpType = vPmtOpType::Abono):
                BEGIN
                    clCashRegMgt.fSetCashPmntCrMemPostData(vPostingDate, vVendorNo, vTotalAmount, vConcepto, vBanco, vDocExt);
                    clCashRegMgt.fPostCrMemCashPmnt;
                END;

            //*** TRASPASO
            (vCashRegType = vCashRegType::Transfers):
                BEGIN
                    clCashRegMgt.fSetTransferBankPostData(vPostingDate, vBanco, vBanco2, vTotalAmount);
                    clCashRegMgt.fPostBankTransfer;
                END;

            //*** NOMINA
            (vCashRegType = vCashRegType::Payroll):
                BEGIN
                    clCashRegMgt.fSetPayrollPostData(vPostingDate, vTotalDevCocinaComedor, vTotalDevVigRecep, vTotalDevLimpieza, vTotalDevBiblioteca, vTotalDevEnfermeria, vTotalDevOtros,
                    vSSCompany, vSSEmployee, vIRPF, vImporteLiquido,
                    vITTotalDevCocinaComedor, vITTotalDevVigRecep, vITTotalDevLimpieza, vITTotalDevBiblioteca, vITTotalDevEnfermeria, vITTotalDevOtros);
                    clCashRegMgt.fPostPayRoll;
                END;
        END;
        CLEAR(clCashRegMgt);
        fInitValues;
        vCashRegType := 0;
        vPosted := TRUE;
        MESSAGE(ctProcessFinishedMsg);
    end;
}