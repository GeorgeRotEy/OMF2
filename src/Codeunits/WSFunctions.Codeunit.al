codeunit 50002 "WS Functions"
{
    SingleInstance = true;
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
    //
    // SIDS-431 S2G (FMR) 06-11-19 Mostrar registro contable y bancos

    trigger OnRun()
    begin
        //fPostTransfer('0049-7744','0237-2454',010118D,1.1);
    end;

    procedure fLogin(pUsuario: Code[20]; pPassword: Text[30]): Boolean
    var
        rEmployee: Record Employee;
    begin
        rEmployee.RESET();
        rEmployee.SETRANGE("User Web", pUsuario);
        rEmployee.SETRANGE("Password Web", pPassword);
        IF rEmployee.FINDFIRST() THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    procedure fPostIngreso(pBanco: Code[20]; pConcepto: Code[10]; pPostingDate: Date; pTotalAmount: Decimal; pPostingConcept: Text) resp: Text
    var
        clCashRegMgt: Codeunit "Easy Register Management";
    begin
        rGenJnlTemplate.RESET();
        rGenJnlTemplate.SETRANGE(Type, rGenJnlTemplate.Type::EasyRegister);
        IF NOT rGenJnlTemplate.FINDFIRST() THEN
            resp := ctTemplateNotFound
        ELSE
            clCashRegMgt.fSetGenJnlTemplate(rGenJnlTemplate.Name);

        clCashRegMgt.fSetCashRcptBankPostData(pPostingDate, pBanco, pTotalAmount, pConcepto);

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        clCashRegMgt.fSetPostingConcept(pPostingConcept);
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        clCashRegMgt.fPostBankCashReceipt2;
        resp := Text000Lbl1;
    end;

    procedure fPostGastoConFactura(pBanco: Code[20]; pVendorNo: Code[20]; pConcepto: Code[10]; pPostingDate: Date; pTotalAmount: Decimal; pDocExt: Code[35]; pPostingConcept: Text) resp: Text
    var
        clCashRegMgt: Codeunit "Easy Register Management";
    begin
        rGenJnlTemplate.RESET();
        rGenJnlTemplate.SETRANGE(Type, rGenJnlTemplate.Type::EasyRegister);
        IF NOT rGenJnlTemplate.FINDFIRST() THEN
            resp := ctTemplateNotFound
        ELSE
            clCashRegMgt.fSetGenJnlTemplate(rGenJnlTemplate.Name);

        clCashRegMgt.fSetCashPmntVendPostData(pPostingDate, pVendorNo, pTotalAmount, pConcepto, pBanco, pDocExt);

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        clCashRegMgt.fSetPostingConcept(pPostingConcept);
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        clCashRegMgt.fPostVendCashPmnt2;

        resp := Text000Lbl1;
    end;

    procedure fPostGastoSinFactura(pBanco: Code[20]; pConcepto: Code[10]; pPostingDate: Date; pTotalAmount: Decimal; pPostingConcept: Text) resp: Text
    var
        clCashRegMgt: Codeunit "Easy Register Management";
    begin
        rGenJnlTemplate.RESET();
        rGenJnlTemplate.SETRANGE(Type, rGenJnlTemplate.Type::EasyRegister);
        IF NOT rGenJnlTemplate.FINDFIRST() THEN
            resp := ctTemplateNotFound
        ELSE
            clCashRegMgt.fSetGenJnlTemplate(rGenJnlTemplate.Name);

        clCashRegMgt.fSetCashPmntBankPostData(pPostingDate, pBanco, pTotalAmount, pConcepto);

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        clCashRegMgt.fSetPostingConcept(pPostingConcept);
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        clCashRegMgt.fPostBankCashPmnt2;

        resp := Text000Lbl1;
    end;

    procedure fPostTransfer(pBanco: Code[20]; pBanco2: Code[20]; pPostingDate: Date; pTotalAmount: Decimal; pPostingConcept: Text) resp: Text
    var
        clCashRegMgt: Codeunit "Easy Register Management";
    begin
        rGenJnlTemplate.RESET();
        rGenJnlTemplate.SETRANGE(Type, rGenJnlTemplate.Type::EasyRegister);
        IF NOT rGenJnlTemplate.FINDFIRST() THEN
            resp := ctTemplateNotFound
        ELSE
            clCashRegMgt.fSetGenJnlTemplate(rGenJnlTemplate.Name);

        clCashRegMgt.fSetTransferBankPostData(pPostingDate, pBanco, pBanco2, pTotalAmount);

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        clCashRegMgt.fSetPostingConcept(pPostingConcept);
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        clCashRegMgt.fPostBankTransfer2;

        resp := Text000Lbl1;
    end;

    procedure fPostPayroll(pPostingDate: Date; pCocinaComedor: Decimal; pVigilanciaRecepcion: Decimal; pLimpieza: Decimal; pBiblioteca: Decimal; pEnfermeria: Decimal; pOtros: Decimal;
    pCompanySS: Decimal; pEmployeeSS: Decimal; pIRPF: Decimal; pNetAmount: Decimal; pPostingConcept: Text;
    pITCocinaComedor: Decimal; pITVigilanciaRecepcion: Decimal; pITLimpieza: Decimal; pITBiblioteca: Decimal; pITEnfermeria: Decimal; pITOtros: Decimal) resp: Text
    var
        clCashRegMgt: Codeunit "Easy Register Management";
    begin
        rGenJnlTemplate.RESET();
        rGenJnlTemplate.SETRANGE(Type, rGenJnlTemplate.Type::EasyRegister);
        IF NOT rGenJnlTemplate.FINDFIRST() THEN
            //resp := ctTemplateNotFound
            exit(ctTemplateNotFound);
        //ELSE
        clCashRegMgt.fSetGenJnlTemplate(rGenJnlTemplate.Name);

        clCashRegMgt.fSetPayrollPostData(pPostingDate, pCocinaComedor, pVigilanciaRecepcion, pLimpieza, pBiblioteca, pEnfermeria, pOtros, pCompanySS, pEmployeeSS, pIRPF, pNetAmount,
        pITCocinaComedor, pITVigilanciaRecepcion, pITLimpieza, pITBiblioteca, pITEnfermeria, pITOtros);

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        clCashRegMgt.fSetPostingConcept(pPostingConcept);
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        clCashRegMgt.fPostPayRoll;

        resp := Text000Lbl1;
    end;

    procedure fPostCreditMemo(pBanco: Code[20]; pVendorNo: Code[20]; pConcepto: Code[10]; pPostingDate: Date; pTotalAmount: Decimal; pDocExt: Code[20]; pPostingConcept: Text) resp: Text
    var
        clCashRegMgt: Codeunit "Easy Register Management";
    begin
        rGenJnlTemplate.RESET();
        rGenJnlTemplate.SETRANGE(Type, rGenJnlTemplate.Type::EasyRegister);
        IF NOT rGenJnlTemplate.FINDFIRST() THEN
            resp := ctTemplateNotFound
        ELSE
            clCashRegMgt.fSetGenJnlTemplate(rGenJnlTemplate.Name);

        clCashRegMgt.fSetCashPmntCrMemPostData(pPostingDate, pVendorNo, pTotalAmount, pConcepto, pBanco, pDocExt);

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        clCashRegMgt.fSetPostingConcept(pPostingConcept);
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        clCashRegMgt.fPostCrMemCashPmnt;

        resp := Text000Lbl1;
    end;

    procedure fBancos(): Text
    var
        vlXMLBancos: XMLport "Bancos Empresa";
    begin
        cTempBlob.CreateOutStream(vOutStr);

        vlXMLBancos.SetDestination(vOutStr);
        vlXMLBancos.Export();

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    procedure fCompanies(): Text
    var
        vlXMLCompanies: XMLport Companies;
    begin
        cTempBlob.CreateOutStream(vOutStr);

        vlXMLCompanies.SetDestination(vOutStr);
        vlXMLCompanies.Export();

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    procedure fProveedores(): Text
    var
        vlXMLProveedores: XMLport Proveedores;
    begin
        cTempBlob.CreateOutStream(vOutStr);

        vlXMLProveedores.SetDestination(vOutStr);
        vlXMLProveedores.Export();

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    procedure fConceptosGastos(): Text
    var
        vlXMLConcepGastos: XMLport "Conceptos Gastos";
    begin
        cTempBlob.CreateOutStream(vOutStr);

        vlXMLConcepGastos.SetDestination(vOutStr);
        vlXMLConcepGastos.Export();

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    procedure fConceptoIngresos(): Text
    var
        vlXMLConcepIngresos: XMLport "Conceptos Ingresos";
    begin
        cTempBlob.CreateOutStream(vOutStr);

        vlXMLConcepIngresos.SetDestination(vOutStr);
        vlXMLConcepIngresos.Export();

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    procedure fConceptoTransfer(): Text
    var
        vlXMLConcepTransfer: XMLport "Conceptos Transfer";
    begin
        cTempBlob.CreateOutStream(vOutStr);

        vlXMLConcepTransfer.SetDestination(vOutStr);
        vlXMLConcepTransfer.Export();

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    procedure fGLAccounts(): Text
    var
        vlXMLGLAccountList: XMLport "G/L Account List";
    begin
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
        cTempBlob.CreateOutStream(vOutStr);

        vlXMLGLAccountList.SetDestination(vOutStr);
        vlXMLGLAccountList.Export();

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    procedure fClientes(): Text
    var
        vlXMLClientes: XMLport Clientes;
    begin
        cTempBlob.CreateOutStream(vOutStr);

        vlXMLClientes.SetDestination(vOutStr);
        vlXMLClientes.Export();

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    procedure fActivos(): Text
    var
        vlXMLActivos: XMLport Activos;
    begin
        cTempBlob.CreateOutStream(vOutStr);

        vlXMLActivos.SetDestination(vOutStr);
        vlXMLActivos.Export();

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    //Sustituido por la página 50048 "GL Posting WS". Dada de alta en Servicios Web.
    // procedure fGLPosting(): Text
    // var
    //     rlGLRegister: Record "G/L Register";
    //     rlSourceCodeSetup: Record "Source Code Setup";
    //     vlXMLGLPosting: XMLport "G/L Posting";
    //     vlFirstEntry: Integer;
    //     vlLastEntry: Integer;
    // begin
    //     //SIDS-431 S2G (FMR) 06-11-19 Mostrar registro contable y bancos.inicio
    //     rlSourceCodeSetup.GET();

    //     rlGLRegister.Reset();
    //     rlGLRegister.SETRANGE("Source Code", rlSourceCodeSetup."Easy Register Journal");
    //     IF rlGLRegister.FINDLAST() THEN BEGIN
    //         cTempBlob.CreateOutStream(vOutStr);

    //         vlLastEntry := rlGLRegister."No.";
    //         rlGLRegister.Next(-9);
    //         vlFirstEntry := rlGLRegister."No.";

    //         vlXMLGLPosting.fSetTransactionFilter(rlSourceCodeSetup."Easy Register Journal", vlLastEntry, vlFirstEntry);

    //         vlXMLGLPosting.SetDestination(vOutStr);
    //         vlXMLGLPosting.Export();

    //         cTempBlob.CreateInStream(vInStr);

    //         exit(cBase64Convert.ToBase64(vInStr));
    //     END;
    //     //SIDS-431 S2G (FMR) 06-11-19 Mostrar registro contable y bancos.fin
    // end;

    //Sustituido por la página 50047 "Banks Balance". Dada de alta en Servicios Web.
    // procedure fBankAccounts(pStartDate: Date; pEndDate: Date): Text
    // var
    //     vlXMLBankAccounts: XMLport "Bank Accounts";
    //     rlBankAccount: Record "Bank Account";
    //     rlGLAccount: Record "G/L Account";
    //     vlTrialBalanceBanks: Report "Trial Balance (Banks)";
    // begin
    // if (pStartDate = 0D) and (pEndDate = 0D) then begin
    //     cTempBlob.CreateOutStream(vOutStr);

    //     rlBankAccount.SetRange("Date Filter", pStartDate, pEndDate);

    //     vlXMLBankAccounts.SetTableView(rlBankAccount);
    //     vlXMLBankAccounts.SetDestination(vOutStr);
    //     vlXMLBankAccounts.Export();

    //     cTempBlob.CreateInStream(vInStr);

    //     exit(cBase64Convert.ToBase64(vInStr));
    // end else begin
    //     vFileName := 'Balance sumas y saldos (bancos)_' + FORMAT(pStartDate, 0, '<Day,2><Month,2><Year,4>')
    //           + '_' + FORMAT(pEndDate, 0, '<Day,2><Month,2><Year,4>') + '.pdf';

    //     if pEndDate = 0D then
    //         rlGLAccount.SetRange("Date Filter", pStartDate)
    //     else
    //         rlGLAccount.SetRange("Date Filter", pStartDate, pEndDate);

    //     cTempBlob.CreateOutStream(vOutStr);

    //     vlTrialBalanceBanks.SetTableView(rlGLAccount);
    //     vlTrialBalanceBanks.SaveAs('', ReportFormat::Pdf, vOutStr);

    //     cTempBlob.CreateInStream(vInStr);

    //     exit(cBase64Convert.ToBase64(vInStr));
    // end;
    // end;

    //1.1-Diario contable
    procedure fReport_GLRegister2(pStartDate: Date; pEndDate: Date): Text
    var
        rlGLRegister: Record "G/L Register";
        vlGLRegister2: Report "G/L Register 2";
    begin
        rlGLRegister.SetRange("Posting Date", pStartDate, pEndDate);

        cTempBlob.CreateOutStream(vOutStr);

        vlGLRegister2.SetTableView(rlGLRegister);
        vlGLRegister2.SaveAs('', ReportFormat::Pdf, vOutStr);

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    //2-Libro mayor - Cuentas de 1 a 5
    procedure fReport_MainAccBookOFM(pStartDate: Date; pEndDate: Date; pStartAccount: Code[20]; pEndAccount: Code[20]; pThirdPartyType: Option " ","Customer","Vendor","Bank Account","Fixed Asset"; pThirdPartyNo: Code[20]): Text
    var
        rlGLAccount: Record "G/L Account";
        vlMAinAccBookOFM: Report "Main Accounting Book OFM";
    begin
        flSetAccountNoFilter(pStartAccount, pEndAccount, rlGLAccount);
        flSetDateFilter(pStartDate, pEndDate, rlGLAccount);

        cTempBlob.CreateOutStream(vOutStr);

        vlMAinAccBookOFM.fSetGLEntryParameters(pThirdPartyType, pThirdPartyNo);
        vlMAinAccBookOFM.fSetAPI(true);
        vlMAinAccBookOFM.SetTableView(rlGLAccount);
        vlMAinAccBookOFM.SaveAs('', ReportFormat::Pdf, vOutStr);

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    //3-Libro mayor - Cuentas de Gestión
    procedure fReport_DetailAccStatement(pStartMonth: Integer; pStartYear: Integer; pEndMonth: Integer; pEndYear: Integer; pStartAccount: Code[20]; pEndAccount: Code[20]): Text
    var
        rlGLAccount: Record "G/L Account";
        vlDetailAccStatement: Report "Detail Account Statement";
    begin
        vStartDate := DMY2DATE(1, pStartMonth, pStartYear);
        vEndDate := CALCDATE('<CM>', DMY2DATE(1, pEndMonth, pEndYear));

        flSetAccountNoFilter(pStartAccount, pEndAccount, rlGLAccount);
        flSetDateFilter(vStartDate, vEndDate, rlGLAccount);

        cTempBlob.CreateOutStream(vOutStr);

        vlDetailAccStatement.SetTableView(rlGLAccount);
        vlDetailAccStatement.SaveAs('', ReportFormat::Pdf, vOutStr);

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    //4-Balance de sumas y saldos - Cuentas de 1 a 5
    procedure fReport_BanksTrialBalance(pStartMonth: Integer; pEndMonth: Integer; pYear: Integer): Text
    var
        rlGLAccount: Record "G/L Account";
        rlGLEntry: Record "G/L Entry";
        vlBanksTrialBalance: Report "Trial Balance (Banks)";
    begin
        vStartDate := DMY2DATE(1, pStartMonth, pYear);
        vEndDate := CALCDATE('<CM>', DMY2DATE(1, pEndMonth, pYear));

        flSetDateFilter(vStartDate, vEndDate, rlGLAccount);

        cTempBlob.CreateOutStream(vOutStr);

        vlBanksTrialBalance.SetTableView(rlGLAccount);
        vlBanksTrialBalance.SaveAs('', ReportFormat::Pdf, vOutStr);

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    //5-Balance de sumas y saldos - Cuentas de Gestión
    procedure fReport_TrialBalance(pStartMonth: Integer; pStartYear: Integer; pEndMonth: Integer; pEndYear: Integer): Text
    var
        rlGLAccount: Record "G/L Account";
        vlTrialBalance: Report "Trial Balance";
    begin
        vStartDate := DMY2DATE(1, pStartMonth, pStartYear);
        vEndDate := CALCDATE('<CM>', DMY2DATE(1, pEndMonth, pEndYear));

        flSetDateFilter(vStartDate, vEndDate, rlGLAccount);

        cTempBlob.CreateOutStream(vOutStr);

        vlTrialBalance.SetTableView(rlGLAccount);
        vlTrialBalance.SaveAs('', ReportFormat::Pdf, vOutStr);

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    //5.1-Balance de sumas y saldos - Cuentas de Gestión con arrendamientos
    procedure fReport_TrialBalance2(pStartMonth: Integer; pStartYear: Integer; pEndMonth: Integer; pEndYear: Integer): Text
    var
        rlGLAccount: Record "G/L Account";
        vlTrialBalance2: Report "Trial Balance 2";
    begin
        vStartDate := DMY2DATE(1, pStartMonth, pStartYear);
        vEndDate := CALCDATE('<CM>', DMY2DATE(1, pEndMonth, pEndYear));

        flSetDateFilter(vStartDate, vEndDate, rlGLAccount);

        cTempBlob.CreateOutStream(vOutStr);

        vlTrialBalance2.SetTableView(rlGLAccount);
        vlTrialBalance2.SaveAs('', ReportFormat::Pdf, vOutStr);

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    //6-Estudio del presupuesto
    procedure fReport_BudgetStudy2(pYear: Enum Years; pStartMonth: Enum Months; pEndMonth: Enum Months): Text
    var
        vlBudgetStudy2: Report "Budget Study2";
    begin
        cTempBlob.CreateOutStream(vOutStr);

        vlBudgetStudy2.fSetParameters(Format(pYear), Format(pStartMonth), Format(pEndMonth));
        vlBudgetStudy2.SaveAs('', ReportFormat::Excel, vOutStr);

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    //7-Preparar presupuesto para próximo ejercicio
    procedure fReport_ExportTempBudExcel(pYear: Integer; pMonth: Text): Text
    var
        rlDimCodeBuffer: Record "Dimension Code Buffer";
        rlExcelBuffer: Record "Excel Buffer";
        vlExportTempBudExcel: Report "Export Templ Bud Excel";
        vlMonthInt: Integer;
    begin
        cTempBlob.CreateOutStream(vOutStr);

        CASE pMonth OF
            '', ' ':
                vlMonthInt := 0;
            'Enero', '1', '01':
                vlMonthInt := 1;
            'Febrero', '2', '02':
                vlMonthInt := 2;
            'Marzo', '3', '03':
                vlMonthInt := 3;
            'Abril', '4', '04':
                vlMonthInt := 4;
            'Mayo', '5', '05':
                vlMonthInt := 5;
            'Junio', '6', '06':
                vlMonthInt := 6;
            'Julio', '7', '07':
                vlMonthInt := 7;
            'Agosto', '8', '08':
                vlMonthInt := 8;
            'Septiembre', '9', '09':
                vlMonthInt := 9;
            'Octubre', '10':
                vlMonthInt := 10;
            'Noviembre', '11':
                vlMonthInt := 11;
            'Diciembre', '12':
                vlMonthInt := 12;
        end;

        vlExportTempBudExcel.SetRefYear(pYear);
        vlExportTempBudExcel.SetMonth(vlMonthInt);

        vlExportTempBudExcel.SetTestMode(true);
        vlExportTempBudExcel.fSetPowerApps(true);
        vlExportTempBudExcel.fSetAPI(true);

        vlExportTempBudExcel.Run();

        cTempBlob.CreateInStream(vInStr);

        exit(cBase64Convert.ToBase64(vInStr));
    end;

    local procedure flSetAccountNoFilter(pStartAccount: Code[20]; pEndAccount: Code[20]; var pGLAccount: Record "G/L Account")
    begin
        if (pStartAccount <> '') and (pEndAccount <> '') then
            pGLAccount.SetRange("No.", pStartAccount, pEndAccount);
        if (pStartAccount = '') and (pEndAccount <> '') then
            pGLAccount.SetFilter("No.", '..%1', pEndAccount);
        if (pStartAccount <> '') and (pEndAccount = '') then
            pGLAccount.SetFilter("No.", '%1..', pStartAccount);
    end;

    local procedure flSetDateFilter(pStartDate: Date; pEndDate: Date; var pGLAccount: Record "G/L Account")
    begin
        if (pStartDate <> 0D) and (pEndDate <> 0D) then
            pGLAccount.SetRange("Date Filter", pStartDate, pEndDate);
        if (pStartDate = 0D) and (pEndDate <> 0D) then
            pGLAccount.SetFilter("Date Filter", '..%1', pEndDate);
        if (pStartDate <> 0D) and (pEndDate = 0D) then
            pGLAccount.SetFilter("Date Filter", '%1..', pStartDate);
    end;

    //IGG - Necesario para pasar valor por Base64 para PowerApps para fReport_ExportTempBudExcel
    [EventSubscriber(ObjectType::Report, Report::"Export Templ Bud Excel", OnAfterRunReport, '', false, false)]
    local procedure es_r50006_OnAfterRunReport(pInStr: InStream; pName: Text)
    begin
        vFileName := pName + '.xlsx';
        CopyStream(vOutStr, pInStr);
    end;

    procedure fRevertirMovimientoContable(pGLEntryNo: Integer): Text
    var
        rlGLEntry: Record "G/L Entry";
        clEYFunctions: Codeunit "EY Functions";
        jlResponse: JsonObject;
        vlResponseText: Text;
        vlTransactionNo: Integer;
        vbVendorEntryFound: Boolean;
        vbVendorUnapplied: Boolean;
    begin
        CLEAR(rlGLEntry);
        IF NOT rlGLEntry.GET(pGLEntryNo) THEN BEGIN
            jlResponse.Add('success', FALSE);
            jlResponse.Add('glEntryNo', pGLEntryNo);
            jlResponse.Add('transactionNo', 0);
            jlResponse.Add('vendorEntryFound', FALSE);
            jlResponse.Add('vendorUnapplied', FALSE);
            jlResponse.Add('message', STRSUBSTNO(TextWSGLEntryNotFoundLbl, pGLEntryNo, COMPANYNAME));
            jlResponse.WriteTo(vlResponseText);
            EXIT(vlResponseText);
        END;

        vlTransactionNo := rlGLEntry."Transaction No.";
        IF vlTransactionNo = 0 THEN BEGIN
            jlResponse.Add('success', FALSE);
            jlResponse.Add('glEntryNo', pGLEntryNo);
            jlResponse.Add('transactionNo', 0);
            jlResponse.Add('vendorEntryFound', FALSE);
            jlResponse.Add('vendorUnapplied', FALSE);
            jlResponse.Add('message', STRSUBSTNO(TextWSMissingTransactionNoLbl, pGLEntryNo));
            jlResponse.WriteTo(vlResponseText);
            EXIT(vlResponseText);
        END;

        CLEARLASTERROR();
        IF clEYFunctions.lfTryRevertirMovimientoContable(pGLEntryNo, vbVendorEntryFound, vbVendorUnapplied) THEN BEGIN
            jlResponse.Add('success', TRUE);
            jlResponse.Add('glEntryNo', pGLEntryNo);
            jlResponse.Add('transactionNo', vlTransactionNo);
            jlResponse.Add('vendorEntryFound', vbVendorEntryFound);
            jlResponse.Add('vendorUnapplied', vbVendorUnapplied);
            jlResponse.Add('message', clEYFunctions.lfGetReversionMessage(vbVendorEntryFound, vbVendorUnapplied));
        END ELSE BEGIN
            jlResponse.Add('success', FALSE);
            jlResponse.Add('glEntryNo', pGLEntryNo);
            jlResponse.Add('transactionNo', vlTransactionNo);
            jlResponse.Add('vendorEntryFound', FALSE);
            jlResponse.Add('vendorUnapplied', FALSE);
            jlResponse.Add('message', GetLastErrorText());
        END;

        jlResponse.WriteTo(vlResponseText);
        EXIT(vlResponseText);
    end;





    // [TryFunction]
    // local procedure lfTryRevertirMovimientoContable(pGlEntryNo: Integer; var pVendorEntryFound: Boolean; var pVendorUnapplied: Boolean)
    // var
    //     rlGlEntry: Record "G/L Entry";
    // begin
    //     rlGlEntry.Get(pGlEntryNo);
    //     rlGlEntry.TestField("Transaction No.");

    //     lfDesliquidarProveedor(rlGlEntry."Transaction No.", pVendorEntryFound, pVendorUnapplied);
    //     lfRevertirTransaccion(rlGlEntry."Transaction No.");

    // end;

    // local procedure lfDesliquidarProveedor(pTransactionNo: Integer; var PvendorEntryFound: Boolean; var pVendorUnapplied: Boolean)
    // var
    //     rlVendLedgEntry: Record "Vendor Ledger Entry";
    //     rlDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    //     rlApplyUnapplyParameters: Record "Apply Unapply Parameters";
    //     clVendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
    //     vlApplicationEntryNo: Integer;
    //     vbRetry: Boolean;
    // begin
    //     REPEAT
    //         vbRetry := FALSE;
    //         vlApplicationEntryNo := 0;

    //         rlVendLedgEntry.RESET();
    //         rlVendLedgEntry.SETRANGE("Transaction No.", pTransactionNo);
    //         IF rlVendLedgEntry.FINDSET() THEN
    //             REPEAT
    //                 pVendorEntryFound := TRUE;
    //                 vlApplicationEntryNo := clVendEntryApplyPostedEntries.FindLastApplEntry(rlVendLedgEntry."Entry No.");
    //                 IF vlApplicationEntryNo <> 0 THEN BEGIN
    //                     rlDtldVendLedgEntry.GET(vlApplicationEntryNo);
    //                     CLEAR(rlApplyUnapplyParameters);
    //                     rlApplyUnapplyParameters."Document No." := rlDtldVendLedgEntry."Document No.";
    //                     rlApplyUnapplyParameters."Posting Date" := rlDtldVendLedgEntry."Posting Date";
    //                     clVendEntryApplyPostedEntries.PostUnApplyVendor(rlDtldVendLedgEntry, rlApplyUnapplyParameters);
    //                     pVendorUnapplied := TRUE;
    //                     vbRetry := TRUE;
    //                 END;
    //             UNTIL (rlVendLedgEntry.NEXT() = 0) OR vbRetry;
    //     UNTIL NOT vbRetry;
    // end;

    // local procedure lfRevertirTransaccion(pTransactionNo: Integer)
    // var
    //     rlReversalEntry: Record "Reversal Entry";
    // begin
    //     CLEAR(rlReversalEntry);
    //     rlReversalEntry.SetHideWarningDialogs();
    //     rlReversalEntry.ReverseTransaction(pTransactionNo);
    // end;

    // local procedure lfGetReversionMessage(pVendorEntryFound: Boolean; pVendorUnapplied: Boolean): Text
    // begin
    //     IF pVendorUnapplied THEN
    //         EXIT(TextWSReversionWithVendorUnapplyLbl);

    //     IF pVendorEntryFound THEN
    //         EXIT(TextWSReversionWithVendorLbl);

    //     EXIT(TextWSReversionLbl);
    // end;


    var
        rGenJnlTemplate: Record "Gen. Journal Template";
        cTempBlob: Codeunit "Temp Blob";
        cBase64Convert: Codeunit "Base64 Convert";
        vOutStr: OutStream;
        vInStr: InStream;
        vFileName: Text;
        vStartDate: Date;
        vEndDate: Date;
        ctTemplateNotFound: Label 'Debe configurar un libro diario de tipo "Registro simple" antes de continuar.';
        Text000Lbl1: Label 'El "Registro Simple" se ha llevado a cabo correctamente';
        TextWSReversionLbl: Label 'La transaccion se ha revertido correctamente.';
        TextWSReversionWithVendorLbl: Label 'La transaccion se ha revertido correctamente. Se han detectado movimientos de proveedor sin necesidad de desaplicacion.';
        TextWSReversionWithVendorUnapplyLbl: Label 'Se ha desaplicado el movimiento de proveedor y se ha revertido la transaccion correctamente.';
        TextWSGLEntryNotFoundLbl: Label 'No existe el movimiento contable %1 en la empresa %2.';
        TextWSMissingTransactionNoLbl: Label 'El movimiento contable %1 no tiene numero de transaccion. No se puede revertir desde esta funcion.';
}
