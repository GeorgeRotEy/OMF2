codeunit 50000 "Easy Register Management"
{
    // Mod. S2G (FMR) 29/10/14 CAR005 Gestión cajas centros
    // Mod. S2G (FMR) 13-05-15 Importe recaudado con IVA incl. en ingresos cafetería/teléfono
    // Mod. S2G (IVC) 18/05/15 Notificaciones por email
    // Mod. S2G (FMR) 24-06-15 Incluir nos. facturas en descripción cobros residentes
    //                         Código
    //                           fPostCustCashReceipt
    //                           fPostCustRefund
    //
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
    // (CJ16) S2G (JDT) 24-10-19: Modificaciones no registrar líneas en blanco en cuentas de salario
    // CR03 (KPMG) 27/07/21 Se hace el asiento inverso si viene el importe en negativo

    Permissions = TableData "Cust. Ledger Entry" = rimd,
                  tabledata "Budget Control Setup" = RIMD;

    var
        rRegisterItem: Record "Easy Register Concepts";
        rGenJnlBatch: Record "Gen. Journal Batch";
        vConcepto: Code[10];
        vBankAccNo: Code[20];
        vBankAccNo2: Code[20];
        vGenJnlTemplate: Code[20];
        vCustNo: Code[20];
        vVendorNo: Code[20];
        vGenJnlBatch: Code[10];
        vDescrip: Text[100];
        vPostingDate: Date;
        vAmount: Decimal;
        vFirstLineNo: Integer;
        vLastLineNo: Integer;
        vWindow: Dialog;
        vDocNo: Code[20];
        vDocExt: Code[35];
        vPostingConcept: Text;
        vTotalCocinaComedor: Decimal;
        vTotalVigRecep: Decimal;
        vTotalLimpieza: Decimal;
        vTotalBiblioteca: Decimal;
        vTotalEnfermeria: Decimal;
        vTotalOtros: Decimal;
        vITTotalCocinaComedor: Decimal;
        vITTotalVigRecep: Decimal;
        vITTotalLimpieza: Decimal;
        vITTotalBiblioteca: Decimal;
        vITTotalEnfermeria: Decimal;
        vITTotalOtros: Decimal;
        vSSCompany: Decimal;
        vSSEmployee: Decimal;
        vIRPF: Decimal;
        vImporteLiquido: Decimal;
        ctBlankCustDataErrorLbl: Label 'Debe rellenar nº cliente', Comment = 'ESP="Debe rellenar nº cliente"';
        ctBlankPostingDateErrorLbl: Label 'You must fill in posting date', Comment = 'ESP="Debe rellenar la fecha de registro"';
        ctBlankBankAccErrorLbl: Label 'You must fill in destination bank account', Comment = 'ESP="Debe rellenar la cuenta bancaria de destino"';
        ctBlankVendDataErrorLbl: Label 'Debe rellenar el código de Proveedor', Comment = 'ESP="Debe rellenar el código de Proveedor"';
        ctBlankDocExtErrorLbl: Label 'Debe rellenar el nº factura proveedor', Comment = 'ESP="Debe rellenar el nº factura proveedor"';
        ctCustCashRcptConfLbl: Label '¿Confirma que desea contabilizar el cobro?', Comment = 'ESP="¿Confirma que desea contabilizar el cobro?"';
        ctCustCashRcptIndLbl: Label 'Contabilizando cobro...', Comment = 'ESP="Contabilizando cobro..."';
        ctCustCashRcptDesc3Lbl: Label 'Receipt from %1', Comment = 'ESP="Cobro de %1"';
        ctBlankConceptoDataErrorLbl: Label 'Debe rellenar el código de Concepto', Comment = 'ESP="Debe rellenar el código de Concepto"';
        ctVendCashPmntConfLbl: Label '¿Confirma que desea contabilizar el gasto?', Comment = 'ESP="¿Confirma que desea contabilizar el gasto?"';
        ctVendCashPmntDescLbl: Label 'Gasto de %1', Comment = 'ESP="Gasto de %1"';
        ctVendCashPmnttIndLbl: Label 'Contabilizando gasto...', Comment = 'ESP="Contabilizando gasto..."';
        ctBlankBankAccOrigErrorLbl: Label 'Debe rellenar el código de Banco origen', Comment = 'ESP="Debe rellenar el código de Banco origen"';
        ctBlankBankAccDestErrorLbl: Label 'Debe rellenar el código de Banco destino', Comment = 'ESP="Debe rellenar el código de Banco destino"';
        ctTransferDescLbl: Label 'Traspaso a %1 desde %2', Comment = 'ESP="Traspaso a %1 desde %2"';
        ctTransferConfigLbl: Label '¿Confirma que desea contabilizar el traspaso?', Comment = 'ESP="¿Confirma que desea contabilizar el traspaso?"';
        ctTransferIndLbl: Label 'Contabilizando traspaso...', Comment = 'ESP="Contabilizando traspaso..."';
        ctNominaIndLbl: Label 'Contabilizando nómina...', Comment = 'ESP="Contabilizando nómina..."';

    procedure fSetGenJnlTemplate(pGenJnlTemplate: Code[20])
    begin
        vGenJnlTemplate := pGenJnlTemplate;
    end;

    procedure fSetCashRcptCustPostData(pPostingDate: Date; pCustNo: Code[20]; pAmount: Decimal; pConcepto: Code[10]; pBanco: Code[20])
    begin
        vPostingDate := pPostingDate;
        vCustNo := pCustNo;
        vAmount := pAmount;
        vConcepto := pConcepto;
        vBankAccNo := pBanco;
    end;

    procedure fSetCashRcptBankPostData(pPostingDate: Date; pBankNo: Code[20]; pAmount: Decimal; pConcepto: Code[10])
    begin
        vPostingDate := pPostingDate;
        vBankAccNo := pBankNo;
        vAmount := pAmount;
        vConcepto := pConcepto;
    end;

    procedure fSetCashPmntVendPostData(pPostingDate: Date; pVendNo: Code[20]; pAmount: Decimal; pConcepto: Code[10]; pBanco: Code[20]; pDocExt: Code[35])
    begin
        vPostingDate := pPostingDate;
        vVendorNo := pVendNo;
        vAmount := pAmount;
        vConcepto := pConcepto;
        vBankAccNo := pBanco;
        vDocExt := pDocExt;
    end;

    procedure fSetCashPmntBankPostData(pPostingDate: Date; pBankNo: Code[20]; pAmount: Decimal; pConcepto: Code[10])
    begin
        vPostingDate := pPostingDate;
        vBankAccNo := pBankNo;
        vAmount := pAmount;
        vConcepto := pConcepto;
    end;

    procedure fSetTransferBankPostData(pPostingDate: Date; pBankNo: Code[20]; pBankNo2: Code[20]; pAmount: Decimal)
    begin
        vPostingDate := pPostingDate;
        vBankAccNo2 := pBankNo2;
        vBankAccNo := pBankNo;
        vAmount := pAmount;
        //vConcepto:=pConcepto;

        //INGRESOS
    end;

    procedure fSetPayrollPostData(pPostingDate: Date; pCocinaComedor: Decimal; pVigilanciaRecepcion: Decimal; pLimpieza: Decimal; pBiblioteca: Decimal; pEnfermeria: Decimal; pOtros: Decimal;
    pCompanySS: Decimal; pEmployeeSS: Decimal; pIRPF: Decimal; pNetAmount: Decimal;
    pITCocinaComedor: Decimal; pITVigilanciaRecepcion: Decimal; pITLimpieza: Decimal; pITBiblioteca: Decimal; pITEnfermeria: Decimal; pITOtros: Decimal)
    begin
        vPostingDate := pPostingDate;
        vTotalCocinaComedor := pCocinaComedor;
        vTotalVigRecep := pVigilanciaRecepcion;
        vTotalLimpieza := pLimpieza;
        vTotalBiblioteca := pBiblioteca;
        vTotalEnfermeria := pEnfermeria;
        vTotalOtros := pOtros;
        //Incapacidad temporal. Begin.
        vITTotalCocinaComedor := pITCocinaComedor;
        vITTotalVigRecep := pITVigilanciaRecepcion;
        vITTotalLimpieza := pITLimpieza;
        vITTotalBiblioteca := pITBiblioteca;
        vITTotalEnfermeria := pITEnfermeria;
        vITTotalOtros := pITOtros;
        //Incapacidad temporal. End.
        vSSCompany := pCompanySS;
        vSSEmployee := pEmployeeSS;
        vIRPF := pIRPF;
        vImporteLiquido := pNetAmount;
    end;

    procedure fSetCashPmntCrMemPostData(pPostingDate: Date; pVendNo: Code[20]; pAmount: Decimal; pConcepto: Code[10]; pBanco: Code[20]; pDocExt: Code[20])
    begin
        vPostingDate := pPostingDate;
        vVendorNo := pVendNo;
        vAmount := pAmount;
        vConcepto := pConcepto;
        vBankAccNo := pBanco;
        vDocExt := pDocExt;
    end;

    procedure fPostCustCashReceipt()
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlCust: Record Customer;
        rlGenJnlBatch: Record "Gen. Journal Batch";
        rlGenJnlLine: Record "Gen. Journal Line";
        rlGenJnlLine2: Record "Gen. Journal Line";
        rlGLReg: Record "G/L Register";
        clGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        vlNextLineNo: Integer;
        vlFirstLineNo: Integer;
        vlLastLineNo: Integer;
        vlDocNoText: Text;
    begin
        //EPV
        IF vAmount = 0 THEN
            EXIT;

        vlDocNoText := '';

        IF vPostingDate = 0D THEN
            ERROR(ctBlankPostingDateErrorLbl);

        IF vCustNo = '' THEN
            ERROR(ctBlankCustDataErrorLbl);

        IF vConcepto = '' THEN
            ERROR(ctBlankConceptoDataErrorLbl);

        rlSourceCodeSetup.GET();
        rlSourceCodeSetup.TESTFIELD("Easy Register Journal");

        IF NOT CONFIRM(ctCustCashRcptConfLbl) THEN
            EXIT;

        rlCust.GET(vCustNo);

        // Coge la primera seccion asociada al Diario
        rlGenJnlBatch.RESET();
        rlGenJnlBatch.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlBatch.FINDFIRST();

        vWindow.OPEN(ctCustCashRcptIndLbl);

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        IF rlGenJnlLine.FINDLAST() THEN
            vlNextLineNo := rlGenJnlLine."Line No."
        ELSE
            vlNextLineNo := 0;

        vlNextLineNo := vlNextLineNo + 10000;

        vlFirstLineNo := vlNextLineNo;

        vGenJnlBatch := rlGenJnlBatch.Name;

        // PRIMERA LõNEA DE REGISTRO
        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::Invoice);

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);
        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::Customer);
        rlGenJnlLine.VALIDATE("Account No.", vCustNo);

        IF STRLEN(STRSUBSTNO(ctCustCashRcptDesc3Lbl, rlCust.Name)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
            rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctCustCashRcptDesc3Lbl, rlCust.Name), MAXSTRLEN(rlGenJnlLine.Description))
        ELSE
            rlGenJnlLine.Description := STRSUBSTNO(ctCustCashRcptDesc3Lbl, rlCust.Name);

        vDescrip := rlGenJnlLine.Description;

        rlGenJnlLine.VALIDATE(Amount, vAmount);

        IF rRegisterItem.GET(vConcepto) THEN BEGIN
            rlGenJnlLine.VALIDATE("Bal. Account Type", rRegisterItem."Account Type");
            rlGenJnlLine.VALIDATE("Bal. Account No.", rRegisterItem."Account No.");
        END;

        rlGenJnlLine.VALIDATE("Applies-to ID", '*' + USERID + '*');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Inicio
        fSetEasyRegisterDimension(rlGenJnlLine, rRegisterItem);
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;
        vlNextLineNo := vlNextLineNo + 10000;

        // SEGUNDA LÍNEA DE REGISTRO
        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::Payment);

        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::Customer);
        rlGenJnlLine.VALIDATE("Account No.", vCustNo);

        IF STRLEN(STRSUBSTNO(ctCustCashRcptDesc3Lbl, rlCust.Name)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
            rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctCustCashRcptDesc3Lbl, rlCust.Name), MAXSTRLEN(rlGenJnlLine.Description))
        ELSE
            rlGenJnlLine.Description := STRSUBSTNO(ctCustCashRcptDesc3Lbl, rlCust.Name);

        vDescrip := rlGenJnlLine.Description;

        rlGenJnlLine.VALIDATE(Amount, -vAmount);

        rlGenJnlLine.VALIDATE("Bal. Account Type", rlGenJnlLine."Bal. Account Type"::"Bank Account");
        rlGenJnlLine.VALIDATE("Bal. Account No.", vBankAccNo);

        rlGenJnlLine.VALIDATE("Applies-to ID", '');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine.VALIDATE("Applies-to Doc. Type", rlGenJnlLine."Applies-to Doc. Type"::Invoice);
        rlGenJnlLine.VALIDATE("Applies-to Doc. No.", vDocNo);
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Inicio
        fSetEasyRegisterDimension(rlGenJnlLine, rRegisterItem);
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;

        // REGISTRO DE LAS LÍNEAS
        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        rlGenJnlLine.SETRANGE("Line No.", vlFirstLineNo, vlLastLineNo);
        IF rlGenJnlLine.FINDSET() THEN BEGIN
            REPEAT
                rlGenJnlLine2 := rlGenJnlLine;
                clGenJnlPostLine.RUN(rlGenJnlLine2);
            UNTIL rlGenJnlLine.NEXT() = 0;
            clGenJnlPostLine.GetGLReg(rlGLReg);
            rlGenJnlLine.DELETEALL();
        END;

        vWindow.CLOSE();
    end;

    procedure fPostBankCashReceipt()
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlGenJnlBatch: Record "Gen. Journal Batch";
        rlGenJnlLine: Record "Gen. Journal Line";
        rlGenJnlLine2: Record "Gen. Journal Line";
        rlGLReg: Record "G/L Register";
        clGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        vlNextLineNo: Integer;
        vlFirstLineNo: Integer;
        vlLastLineNo: Integer;
        vlDocNoText: Text;
    begin
        //EPV
        IF vAmount = 0 THEN
            EXIT;

        vlDocNoText := '';

        IF vPostingDate = 0D THEN
            ERROR(ctBlankPostingDateErrorLbl);

        IF vConcepto = '' THEN
            ERROR(ctBlankConceptoDataErrorLbl);

        IF vBankAccNo = '' THEN
            ERROR(ctBlankBankAccErrorLbl);

        rlSourceCodeSetup.GET();
        rlSourceCodeSetup.TESTFIELD("Easy Register Journal");

        IF NOT CONFIRM(ctCustCashRcptConfLbl) THEN
            EXIT;

        rlGenJnlBatch.RESET();
        rlGenJnlBatch.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlBatch.FINDFIRST();

        vWindow.OPEN(ctCustCashRcptIndLbl);

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        IF rlGenJnlLine.FINDLAST() THEN
            vlNextLineNo := rlGenJnlLine."Line No."
        ELSE
            vlNextLineNo := 0;

        vlNextLineNo := vlNextLineNo + 10000;

        vlFirstLineNo := vlNextLineNo;

        vGenJnlBatch := rlGenJnlBatch.Name;

        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::Payment);

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);

        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::"Bank Account");
        rlGenJnlLine.VALIDATE("Account No.", vBankAccNo);

        IF rRegisterItem.GET(vConcepto) THEN BEGIN
            rlGenJnlLine.VALIDATE("Bal. Account Type", rRegisterItem."Account Type");
            rlGenJnlLine.VALIDATE("Bal. Account No.", rRegisterItem."Account No.");
        END;

        IF STRLEN(STRSUBSTNO(ctCustCashRcptDesc3Lbl, rRegisterItem.Description)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
            rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctCustCashRcptDesc3Lbl, rRegisterItem.Description), MAXSTRLEN(rlGenJnlLine.Description))
        ELSE
            rlGenJnlLine.Description := STRSUBSTNO(ctCustCashRcptDesc3Lbl, rRegisterItem.Description);

        vDescrip := rlGenJnlLine.Description;

        rlGenJnlLine.VALIDATE(Amount, vAmount);

        //rlGenJnlLine.VALIDATE("Applies-to ID",'*' + USERID + '*');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Inicio
        fSetEasyRegisterDimension(rlGenJnlLine, rRegisterItem);
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        rlGenJnlLine.SETRANGE("Line No.", vlFirstLineNo, vlLastLineNo);
        IF rlGenJnlLine.FINDSET() THEN BEGIN
            REPEAT
                rlGenJnlLine2 := rlGenJnlLine;
                clGenJnlPostLine.RUN(rlGenJnlLine2);
            UNTIL rlGenJnlLine.NEXT() = 0;
            clGenJnlPostLine.GetGLReg(rlGLReg);
            rlGenJnlLine.DELETEALL();
        END;

        vWindow.CLOSE();

        //GASTOS
    end;

    procedure fPostVendCashPmnt()
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlVendor: Record Vendor;
        rlGenJnlBatch: Record "Gen. Journal Batch";
        rlGenJnlLine: Record "Gen. Journal Line";
        rlGenJnlLine2: Record "Gen. Journal Line";
        rlGLReg: Record "G/L Register";
        clGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        vlNextLineNo: Integer;
        vlFirstLineNo: Integer;
        vlLastLineNo: Integer;
        vlDocNoText: Text;
    begin
        IF vAmount = 0 THEN
            EXIT;

        vlDocNoText := '';

        IF vPostingDate = 0D THEN
            ERROR(ctBlankPostingDateErrorLbl);

        IF vVendorNo = '' THEN
            ERROR(ctBlankVendDataErrorLbl);

        IF vConcepto = '' THEN
            ERROR(ctBlankConceptoDataErrorLbl);

        IF vDocExt = '' THEN
            ERROR(ctBlankDocExtErrorLbl);

        rlSourceCodeSetup.GET();
        rlSourceCodeSetup.TESTFIELD("Easy Register Journal");

        IF NOT CONFIRM(ctVendCashPmntConfLbl) THEN
            EXIT;

        rlVendor.GET(vVendorNo);

        // Coge la primera seccion asociada al Diario
        rlGenJnlBatch.RESET();
        rlGenJnlBatch.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlBatch.FINDFIRST();

        vWindow.OPEN(ctVendCashPmnttIndLbl);

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        IF rlGenJnlLine.FINDLAST() THEN
            vlNextLineNo := rlGenJnlLine."Line No."
        ELSE
            vlNextLineNo := 0;

        vlNextLineNo := vlNextLineNo + 10000;

        vlFirstLineNo := vlNextLineNo;

        vGenJnlBatch := rlGenJnlBatch.Name;

        // PRIMERA LÍNEA DEL REGISTRO
        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::Invoice);

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);
        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::Vendor);
        rlGenJnlLine.VALIDATE("Account No.", vVendorNo);
        rlGenJnlLine.VALIDATE("External Document No.", vDocExt);

        IF STRLEN(STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
            rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name), MAXSTRLEN(rlGenJnlLine.Description))
        ELSE
            rlGenJnlLine.Description := STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name);

        vDescrip := rlGenJnlLine.Description;

        rlGenJnlLine.VALIDATE(Amount, -vAmount);

        IF rRegisterItem.GET(vConcepto) THEN BEGIN
            rlGenJnlLine.VALIDATE("Bal. Account Type", rRegisterItem."Account Type");
            rlGenJnlLine.VALIDATE("Bal. Account No.", rRegisterItem."Account No.");
        END;

        rlGenJnlLine.VALIDATE("Applies-to ID", '*' + USERID + '*');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Inicio
        fSetEasyRegisterDimension(rlGenJnlLine, rRegisterItem);
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;
        vlNextLineNo := vlNextLineNo + 10000;

        // SEGUNDA LÍNEA DEL REGISTRO
        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::Payment);

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);
        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::Vendor);
        rlGenJnlLine.VALIDATE("Account No.", vVendorNo);

        IF STRLEN(STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
            rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name), MAXSTRLEN(rlGenJnlLine.Description))
        ELSE
            rlGenJnlLine.Description := STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name);

        vDescrip := rlGenJnlLine.Description;

        rlGenJnlLine.VALIDATE(Amount, vAmount);

        rlGenJnlLine.VALIDATE("Bal. Account Type", rlGenJnlLine."Bal. Account Type"::"Bank Account");
        rlGenJnlLine.VALIDATE("Bal. Account No.", vBankAccNo);

        rlGenJnlLine.VALIDATE("Applies-to ID", '');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";

        rlGenJnlLine.VALIDATE("Applies-to Doc. Type", rlGenJnlLine."Applies-to Doc. Type"::Invoice);
        rlGenJnlLine.VALIDATE("Applies-to Doc. No.", vDocNo);

        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Inicio
        fSetEasyRegisterDimension(rlGenJnlLine, rRegisterItem);
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;

        //REGISTRO
        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        rlGenJnlLine.SETRANGE("Line No.", vlFirstLineNo, vlLastLineNo);
        IF rlGenJnlLine.FINDSET() THEN BEGIN
            REPEAT
                rlGenJnlLine2 := rlGenJnlLine;
                clGenJnlPostLine.RUN(rlGenJnlLine2);
            UNTIL rlGenJnlLine.NEXT() = 0;
            clGenJnlPostLine.GetGLReg(rlGLReg);
            rlGenJnlLine.DELETEALL();
        END;

        vWindow.CLOSE();
    end;

    procedure fPostBankCashPmnt()
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlGenJnlBatch: Record "Gen. Journal Batch";
        rlGenJnlLine: Record "Gen. Journal Line";
        rlGenJnlLine2: Record "Gen. Journal Line";
        rlGLReg: Record "G/L Register";
        clGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        vlNextLineNo: Integer;
        vlFirstLineNo: Integer;
        vlLastLineNo: Integer;
        vlDocNoText: Text;
    begin
        //EPV
        IF vAmount = 0 THEN
            EXIT;

        vlDocNoText := '';

        IF vPostingDate = 0D THEN
            ERROR(ctBlankPostingDateErrorLbl);

        IF vConcepto = '' THEN
            ERROR(ctBlankConceptoDataErrorLbl);

        IF vBankAccNo = '' THEN
            ERROR(ctBlankBankAccErrorLbl);

        rlSourceCodeSetup.GET();
        rlSourceCodeSetup.TESTFIELD("Easy Register Journal");

        IF NOT CONFIRM(ctVendCashPmntConfLbl) THEN
            EXIT;

        rlGenJnlBatch.RESET();
        rlGenJnlBatch.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlBatch.FINDFIRST();

        vWindow.OPEN(ctVendCashPmnttIndLbl);

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        IF rlGenJnlLine.FINDLAST() THEN
            vlNextLineNo := rlGenJnlLine."Line No."
        ELSE
            vlNextLineNo := 0;

        vlNextLineNo := vlNextLineNo + 10000;

        vlFirstLineNo := vlNextLineNo;

        vGenJnlBatch := rlGenJnlBatch.Name;

        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::Payment);

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);
        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::"Bank Account");
        rlGenJnlLine.VALIDATE("Account No.", vBankAccNo);

        IF rRegisterItem.GET(vConcepto) THEN BEGIN
            rlGenJnlLine.VALIDATE("Bal. Account Type", rRegisterItem."Account Type");
            rlGenJnlLine.VALIDATE("Bal. Account No.", rRegisterItem."Account No.");
        END;

        IF STRLEN(STRSUBSTNO(ctVendCashPmntDescLbl, rRegisterItem.Description)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
            rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctVendCashPmntDescLbl, rRegisterItem.Description), MAXSTRLEN(rlGenJnlLine.Description))
        ELSE
            rlGenJnlLine.Description := STRSUBSTNO(ctVendCashPmntDescLbl, rRegisterItem.Description);

        vDescrip := rlGenJnlLine.Description;

        rlGenJnlLine.VALIDATE(Amount, -vAmount);

        //rlGenJnlLine.VALIDATE("Applies-to ID",'*' + USERID + '*');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Inicio
        fSetEasyRegisterDimension(rlGenJnlLine, rRegisterItem);
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        rlGenJnlLine.SETRANGE("Line No.", vlFirstLineNo, vlLastLineNo);
        IF rlGenJnlLine.FINDSET() THEN BEGIN
            REPEAT
                rlGenJnlLine2 := rlGenJnlLine;
                clGenJnlPostLine.RUN(rlGenJnlLine2);
            UNTIL rlGenJnlLine.NEXT() = 0;
            clGenJnlPostLine.GetGLReg(rlGLReg);
            rlGenJnlLine.DELETEALL();
        END;

        vWindow.CLOSE();

        // TRASPASO
    end;

    procedure fPostBankTransfer()
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlGenJnlBatch: Record "Gen. Journal Batch";
        rlGenJnlLine: Record "Gen. Journal Line";
        rlGenJnlLine2: Record "Gen. Journal Line";
        rlGLReg: Record "G/L Register";
        rlBank: Record "Bank Account";
        rlBank2: Record "Bank Account";
        clGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        vlNextLineNo: Integer;
        vlFirstLineNo: Integer;
        vlLastLineNo: Integer;
        vlDocNoText: Text;
    begin
        IF vAmount = 0 THEN
            EXIT;

        vlDocNoText := '';

        IF vPostingDate = 0D THEN
            ERROR(ctBlankPostingDateErrorLbl);

        IF vBankAccNo = '' THEN
            ERROR(ctBlankBankAccOrigErrorLbl);

        IF vBankAccNo2 = '' THEN
            ERROR(ctBlankBankAccDestErrorLbl);

        /*IF vConcepto = '' THEN
          ERROR(ctBlankConceptoDataErrorLbl);*/

        rlSourceCodeSetup.GET();
        rlSourceCodeSetup.TESTFIELD("Easy Register Journal");

        IF NOT CONFIRM(ctTransferConfigLbl) THEN
            EXIT;

        // Coge la primera seccion asociada al Diario
        rlGenJnlBatch.RESET();
        rlGenJnlBatch.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlBatch.FINDFIRST();

        vWindow.OPEN(ctTransferIndLbl);

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        IF rlGenJnlLine.FINDLAST() THEN
            vlNextLineNo := rlGenJnlLine."Line No."
        ELSE
            vlNextLineNo := 0;

        vlNextLineNo := vlNextLineNo + 10000;

        vlFirstLineNo := vlNextLineNo;

        vGenJnlBatch := rlGenJnlBatch.Name;

        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        //rlGenJnlLine.VALIDATE("Document Type",rlGenJnlLine."Document Type"::Invoice);

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);
        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::"Bank Account");
        rlGenJnlLine.VALIDATE("Account No.", vBankAccNo2);

        /*
        IF rRegisterItem.GET(vConcepto) THEN
          BEGIN
            rlGenJnlLine.VALIDATE("Bal. Account Type",rRegisterItem."Account Type");
            rlGenJnlLine.VALIDATE("Bal. Account No.",rRegisterItem."Account No.");

            IF STRLEN(STRSUBSTNO(ctTransferDescLbl,rRegisterItem.Description)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
              rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctTransferDescLbl,rRegisterItem.Description),MAXSTRLEN(rlGenJnlLine.Description))
            ELSE
              rlGenJnlLine.Description := STRSUBSTNO(ctTransferDescLbl,rRegisterItem.Description);
          END;
        */

        IF rlBank2.GET(vBankAccNo2) AND rlBank.GET(vBankAccNo) THEN
            IF STRLEN(STRSUBSTNO(ctTransferDescLbl, rlBank2.Name, rlBank.Name)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
                rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctTransferDescLbl, rlBank2.Name, rlBank.Name), MAXSTRLEN(rlGenJnlLine.Description))
            ELSE
                rlGenJnlLine.Description := STRSUBSTNO(ctTransferDescLbl, rlBank2.Name, rlBank.Name);

        rlGenJnlLine.VALIDATE("Bal. Account Type", rlGenJnlLine."Account Type"::"Bank Account");
        rlGenJnlLine.VALIDATE("Bal. Account No.", vBankAccNo);

        vDescrip := rlGenJnlLine.Description;

        rlGenJnlLine.VALIDATE(Amount, vAmount);

        //rlGenJnlLine.VALIDATE("Applies-to ID",'*' + USERID + '*');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;

        //REGISTRO
        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        rlGenJnlLine.SETRANGE("Line No.", vlFirstLineNo, vlLastLineNo);
        IF rlGenJnlLine.FINDSET() THEN BEGIN
            REPEAT
                rlGenJnlLine2 := rlGenJnlLine;
                clGenJnlPostLine.RUN(rlGenJnlLine2);
            UNTIL rlGenJnlLine.NEXT() = 0;
            clGenJnlPostLine.GetGLReg(rlGLReg);
            rlGenJnlLine.DELETEALL();
        END;

        vWindow.CLOSE();
    end;

    procedure fPostBankCashReceipt2()
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlGenJnlBatch: Record "Gen. Journal Batch";
        rlGenJnlLine: Record "Gen. Journal Line";
        rlGenJnlLine2: Record "Gen. Journal Line";
        rlGLReg: Record "G/L Register";
        clGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        vlNextLineNo: Integer;
        vlFirstLineNo: Integer;
        vlLastLineNo: Integer;
        vlDocNoText: Text;
    begin
        //EPV
        IF vAmount = 0 THEN
            EXIT;

        vlDocNoText := '';
        /*
        IF vPostingDate = 0D THEN
          ERROR(ctBlankPostingDateErrorLbl);

        IF vConcepto = '' THEN
          ERROR(ctBlankConceptoDataErrorLbl);

        IF vBankAccNo = '' THEN
          ERROR(ctBlankBankAccErrorLbl);
        */
        rlSourceCodeSetup.GET();
        rlSourceCodeSetup.TESTFIELD("Easy Register Journal");

        /*
        IF NOT CONFIRM(ctCustCashRcptConfLbl) THEN
          EXIT;
        */

        rlGenJnlBatch.RESET();
        rlGenJnlBatch.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlBatch.FINDFIRST();

        vWindow.OPEN(ctCustCashRcptIndLbl);

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        IF rlGenJnlLine.FINDLAST() THEN
            vlNextLineNo := rlGenJnlLine."Line No."
        ELSE
            vlNextLineNo := 0;

        vlNextLineNo := vlNextLineNo + 10000;

        vlFirstLineNo := vlNextLineNo;

        vGenJnlBatch := rlGenJnlBatch.Name;

        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::Payment);

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);

        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::"Bank Account");
        rlGenJnlLine.VALIDATE("Account No.", vBankAccNo);

        IF rRegisterItem.GET(vConcepto) THEN BEGIN
            rlGenJnlLine.VALIDATE("Bal. Account Type", rRegisterItem."Account Type");
            rlGenJnlLine.VALIDATE("Bal. Account No.", rRegisterItem."Account No.");
        END;

        IF STRLEN(STRSUBSTNO(ctCustCashRcptDesc3Lbl, rRegisterItem.Description)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
            rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctCustCashRcptDesc3Lbl, rRegisterItem.Description), MAXSTRLEN(rlGenJnlLine.Description))
        ELSE
            rlGenJnlLine.Description := STRSUBSTNO(ctCustCashRcptDesc3Lbl, rRegisterItem.Description);

        vDescrip := rlGenJnlLine.Description;
        //--CR03
        IF vAmount < 0 THEN
            rlGenJnlLine.VALIDATE("Debit Amount", vAmount)
        ELSE
            //++CR03
            rlGenJnlLine.VALIDATE(Amount, vAmount);

        //rlGenJnlLine.VALIDATE("Applies-to ID",'*' + USERID + '*');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Inicio
        fSetEasyRegisterDimension(rlGenJnlLine, rRegisterItem);
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        rlGenJnlLine.SETRANGE("Line No.", vlFirstLineNo, vlLastLineNo);
        IF rlGenJnlLine.FINDSET() THEN BEGIN
            REPEAT
                rlGenJnlLine2 := rlGenJnlLine;
                clGenJnlPostLine.RUN(rlGenJnlLine2);
            UNTIL rlGenJnlLine.NEXT() = 0;
            clGenJnlPostLine.GetGLReg(rlGLReg);
            rlGenJnlLine.DELETEALL();
        END;

        vWindow.CLOSE();

        //GASTOS
    end;

    procedure fPostVendCashPmnt2()
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlVendor: Record Vendor;
        rlGenJnlBatch: Record "Gen. Journal Batch";
        rlGenJnlLine: Record "Gen. Journal Line";
        rlGenJnlLine2: Record "Gen. Journal Line";
        rlGLReg: Record "G/L Register";
        clGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        vlNextLineNo: Integer;
        vlFirstLineNo: Integer;
        vlLastLineNo: Integer;
        vlDocNoText: Text;
    begin
        IF vAmount = 0 THEN
            EXIT;

        vlDocNoText := '';
        /*
        IF vPostingDate = 0D THEN
          ERROR(ctBlankPostingDateErrorLbl);

        IF vVendorNo = '' THEN
          ERROR(ctBlankVendDataErrorLbl);

        IF vConcepto = '' THEN
          ERROR(ctBlankConceptoDataErrorLbl);

        IF vDocExt = '' THEN
          ERROR(ctBlankDocExtErrorLbl);
        */
        rlSourceCodeSetup.GET();
        rlSourceCodeSetup.TESTFIELD("Easy Register Journal");
        /*
        IF NOT CONFIRM(ctVendCashPmntConfLbl) THEN
          EXIT;
        */
        rlVendor.GET(vVendorNo);

        // Coge la primera seccion asociada al Diario
        rlGenJnlBatch.RESET();
        rlGenJnlBatch.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlBatch.FINDFIRST();

        vWindow.OPEN(ctVendCashPmnttIndLbl);

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        IF rlGenJnlLine.FINDLAST() THEN
            vlNextLineNo := rlGenJnlLine."Line No."
        ELSE
            vlNextLineNo := 0;

        vlNextLineNo := vlNextLineNo + 10000;

        vlFirstLineNo := vlNextLineNo;

        vGenJnlBatch := rlGenJnlBatch.Name;

        // PRIMERA LÍNEA DEL REGISTRO
        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        //--CR03
        IF vAmount >= 0 THEN
            rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::Invoice)
        ELSE
            //++CR03
            rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::"Credit Memo");
        //--CR03
        //++CR03

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);
        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::Vendor);
        rlGenJnlLine.VALIDATE("Account No.", vVendorNo);
        rlGenJnlLine.VALIDATE("External Document No.", vDocExt);

        IF STRLEN(STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
            rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name), MAXSTRLEN(rlGenJnlLine.Description))
        ELSE
            rlGenJnlLine.Description := STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name);

        vDescrip := rlGenJnlLine.Description;

        rlGenJnlLine.VALIDATE(Amount, -vAmount);

        IF rRegisterItem.GET(vConcepto) THEN BEGIN
            rlGenJnlLine.VALIDATE("Bal. Account Type", rRegisterItem."Account Type");
            rlGenJnlLine.VALIDATE("Bal. Account No.", rRegisterItem."Account No.");
        END;

        rlGenJnlLine.VALIDATE("Applies-to ID", '*' + USERID + '*');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Inicio
        fSetEasyRegisterDimension(rlGenJnlLine, rRegisterItem);
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;
        vlNextLineNo := vlNextLineNo + 10000;

        // SEGUNDA LÍNEA DEL REGISTRO
        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        //--CRM03
        IF vAmount >= 0 THEN
            //++CR03
            rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::Payment)
        //-CR03
        ELSE
            rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::Refund);
        //++CR03

        //--CR03 Se quita para que se asocien las facturas y los abonos
        //vDocNo:= FORMAT(DATE2DMY(vPostingDate,3)) + FORMAT(DATE2DMY(vPostingDate,2)) + FORMAT(DATE2DMY(vPostingDate,1)) + STRSUBSTNO('%1',TIME);
        //++CR03
        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::Vendor);
        rlGenJnlLine.VALIDATE("Account No.", vVendorNo);

        IF STRLEN(STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
            rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name), MAXSTRLEN(rlGenJnlLine.Description))
        ELSE
            rlGenJnlLine.Description := STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name);

        vDescrip := rlGenJnlLine.Description;

        rlGenJnlLine.VALIDATE(Amount, vAmount);

        rlGenJnlLine.VALIDATE("Bal. Account Type", rlGenJnlLine."Bal. Account Type"::"Bank Account");
        rlGenJnlLine.VALIDATE("Bal. Account No.", vBankAccNo);

        rlGenJnlLine.VALIDATE("Applies-to ID", '');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        //--cr03
        IF vAmount < 0 THEN
            rlGenJnlLine.VALIDATE("Applies-to Doc. Type", rlGenJnlLine."Applies-to Doc. Type"::"Credit Memo")
        ELSE
            //++CR03
            rlGenJnlLine.VALIDATE("Applies-to Doc. Type", rlGenJnlLine."Applies-to Doc. Type"::Invoice);
        rlGenJnlLine.VALIDATE("Applies-to Doc. No.", vDocNo);
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Inicio
        fSetEasyRegisterDimension(rlGenJnlLine, rRegisterItem);
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;

        //REGISTRO
        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        rlGenJnlLine.SETRANGE("Line No.", vlFirstLineNo, vlLastLineNo);
        IF rlGenJnlLine.FINDSET() THEN BEGIN
            REPEAT
                rlGenJnlLine2 := rlGenJnlLine;
                clGenJnlPostLine.RUN(rlGenJnlLine2);
            UNTIL rlGenJnlLine.NEXT() = 0;
            clGenJnlPostLine.GetGLReg(rlGLReg);
            rlGenJnlLine.DELETEALL();
        END;

        vWindow.CLOSE();
    end;

    procedure fPostBankCashPmnt2()
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlGenJnlBatch: Record "Gen. Journal Batch";
        rlGenJnlLine: Record "Gen. Journal Line";
        rlGenJnlLine2: Record "Gen. Journal Line";
        rlGLReg: Record "G/L Register";
        clGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        vlNextLineNo: Integer;
        vlFirstLineNo: Integer;
        vlLastLineNo: Integer;
        vlDocNoText: Text;
    begin
        //EPV
        IF vAmount = 0 THEN
            EXIT;

        vlDocNoText := '';
        /*
        IF vPostingDate = 0D THEN
          ERROR(ctBlankPostingDateErrorLbl);

        IF vConcepto = '' THEN
          ERROR(ctBlankConceptoDataErrorLbl);

        IF vBankAccNo = '' THEN
          ERROR(ctBlankBankAccErrorLbl);
        */
        rlSourceCodeSetup.GET();
        rlSourceCodeSetup.TESTFIELD("Easy Register Journal");

        /*
        IF NOT CONFIRM(ctVendCashPmntConfLbl) THEN
          EXIT;
        */

        rlGenJnlBatch.RESET();
        rlGenJnlBatch.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlBatch.FINDFIRST();

        vWindow.OPEN(ctVendCashPmnttIndLbl);

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        IF rlGenJnlLine.FINDLAST() THEN
            vlNextLineNo := rlGenJnlLine."Line No."
        ELSE
            vlNextLineNo := 0;

        vlNextLineNo := vlNextLineNo + 10000;

        vlFirstLineNo := vlNextLineNo;

        vGenJnlBatch := rlGenJnlBatch.Name;

        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::Payment);

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);
        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::"Bank Account");
        rlGenJnlLine.VALIDATE("Account No.", vBankAccNo);

        IF rRegisterItem.GET(vConcepto) THEN BEGIN
            rlGenJnlLine.VALIDATE("Bal. Account Type", rRegisterItem."Account Type");
            rlGenJnlLine.VALIDATE("Bal. Account No.", rRegisterItem."Account No.");
        END;

        IF STRLEN(STRSUBSTNO(ctVendCashPmntDescLbl, rRegisterItem.Description)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
            rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctVendCashPmntDescLbl, rRegisterItem.Description), MAXSTRLEN(rlGenJnlLine.Description))
        ELSE
            rlGenJnlLine.Description := STRSUBSTNO(ctVendCashPmntDescLbl, rRegisterItem.Description);

        vDescrip := rlGenJnlLine.Description;
        //--CR03
        IF vAmount < 0 THEN
            rlGenJnlLine.VALIDATE("Credit Amount", vAmount)
        ELSE
            //++CR03
            rlGenJnlLine.VALIDATE(Amount, -vAmount);

        //rlGenJnlLine.VALIDATE("Applies-to ID",'*' + USERID + '*');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Inicio
        fSetEasyRegisterDimension(rlGenJnlLine, rRegisterItem);
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        rlGenJnlLine.SETRANGE("Line No.", vlFirstLineNo, vlLastLineNo);
        IF rlGenJnlLine.FINDSET() THEN BEGIN
            REPEAT
                rlGenJnlLine2 := rlGenJnlLine;
                clGenJnlPostLine.RUN(rlGenJnlLine2);
            UNTIL rlGenJnlLine.NEXT() = 0;
            clGenJnlPostLine.GetGLReg(rlGLReg);
            rlGenJnlLine.DELETEALL();
        END;

        vWindow.CLOSE();

        // TRASPASO
    end;

    procedure fPostBankTransfer2()
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlGenJnlBatch: Record "Gen. Journal Batch";
        rlGenJnlLine: Record "Gen. Journal Line";
        rlGenJnlLine2: Record "Gen. Journal Line";
        rlGLReg: Record "G/L Register";
        rlBank: Record "Bank Account";
        rlBank2: Record "Bank Account";
        clGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        vlNextLineNo: Integer;
        vlFirstLineNo: Integer;
        vlLastLineNo: Integer;
        vlDocNoText: Text;
    begin
        IF vAmount = 0 THEN
            EXIT;

        vlDocNoText := '';
        /*
        IF vPostingDate = 0D THEN
          ERROR(ctBlankPostingDateErrorLbl);

        IF vBankAccNo = '' THEN
          ERROR(ctBlankBankAccOrigErrorLbl);

        IF vBankAccNo2 = '' THEN
          ERROR(ctBlankBankAccDestErrorLbl);
        */
        /*IF vConcepto = '' THEN
          ERROR(ctBlankConceptoDataErrorLbl);*/

        rlSourceCodeSetup.GET();
        rlSourceCodeSetup.TESTFIELD("Easy Register Journal");
        /*
        IF NOT CONFIRM(ctTransferConfigLbl) THEN
          EXIT;
        */
        // Coge la primera seccion asociada al Diario
        rlGenJnlBatch.RESET();
        rlGenJnlBatch.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlBatch.FINDFIRST();

        vWindow.OPEN(ctTransferIndLbl);

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        IF rlGenJnlLine.FINDLAST() THEN
            vlNextLineNo := rlGenJnlLine."Line No."
        ELSE
            vlNextLineNo := 0;

        vlNextLineNo := vlNextLineNo + 10000;

        vlFirstLineNo := vlNextLineNo;

        vGenJnlBatch := rlGenJnlBatch.Name;

        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        //rlGenJnlLine.VALIDATE("Document Type",rlGenJnlLine."Document Type"::Invoice);

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);
        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::"Bank Account");
        rlGenJnlLine.VALIDATE("Account No.", vBankAccNo2);

        /*
        IF rRegisterItem.GET(vConcepto) THEN
          BEGIN
            rlGenJnlLine.VALIDATE("Bal. Account Type",rRegisterItem."Account Type");
            rlGenJnlLine.VALIDATE("Bal. Account No.",rRegisterItem."Account No.");

            IF STRLEN(STRSUBSTNO(ctTransferDescLbl,rRegisterItem.Description)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
              rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctTransferDescLbl,rRegisterItem.Description),MAXSTRLEN(rlGenJnlLine.Description))
            ELSE
              rlGenJnlLine.Description := STRSUBSTNO(ctTransferDescLbl,rRegisterItem.Description);
          END;
        */

        IF rlBank2.GET(vBankAccNo2) AND rlBank.GET(vBankAccNo) THEN
            IF STRLEN(STRSUBSTNO(ctTransferDescLbl, rlBank2.Name, rlBank.Name)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
                rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctTransferDescLbl, rlBank2.Name, rlBank.Name), MAXSTRLEN(rlGenJnlLine.Description))
            ELSE
                rlGenJnlLine.Description := STRSUBSTNO(ctTransferDescLbl, rlBank2.Name, rlBank.Name);

        rlGenJnlLine.VALIDATE("Bal. Account Type", rlGenJnlLine."Account Type"::"Bank Account");
        rlGenJnlLine.VALIDATE("Bal. Account No.", vBankAccNo);

        vDescrip := rlGenJnlLine.Description;
        //--CR03
        IF vAmount < 0 THEN
            rlGenJnlLine.VALIDATE("Debit Amount", vAmount)
        ELSE
            //++++CR03
            rlGenJnlLine.VALIDATE(Amount, vAmount);

        //rlGenJnlLine.VALIDATE("Applies-to ID",'*' + USERID + '*');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;

        //REGISTRO
        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        rlGenJnlLine.SETRANGE("Line No.", vlFirstLineNo, vlLastLineNo);
        IF rlGenJnlLine.FINDSET() THEN BEGIN
            REPEAT
                rlGenJnlLine2 := rlGenJnlLine;
                clGenJnlPostLine.RUN(rlGenJnlLine2);
            UNTIL rlGenJnlLine.NEXT() = 0;
            clGenJnlPostLine.GetGLReg(rlGLReg);
            rlGenJnlLine.DELETEALL();
        END;

        vWindow.CLOSE();
    end;

    procedure fPostPayRoll()
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlGenJnlLine: Record "Gen. Journal Line";
        rlGenJnlLine2: Record "Gen. Journal Line";
        rlGLReg: Record "G/L Register";
        clGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        rlGLSetUp: Record "General Ledger Setup";
        vlAmountType: Option Debit,Credit;
    begin
        rlGLSetUp.GET();

        rlSourceCodeSetup.GET();
        rlSourceCodeSetup.TESTFIELD("Easy Register Journal");

        vFirstLineNo := 0;
        vLastLineNo := 0;

        // Coge la primera seccion asociada al Diario
        IF vTotalCocinaComedor <> 0 THEN BEGIN
            flInitGenJournalLine(rlGLSetUp."Cta. Personal cocina y comedor", vlAmountType::Debit, vTotalCocinaComedor);

            //Incapacidad temporal. Begin.
            if vITTotalCocinaComedor <> 0 then begin
                //DEBIT
                flInitGenJournalLine(rlGLSetUp."Cta. debe IT", vlAmountType::Debit, vITTotalCocinaComedor);
                //CREDIT
                flInitGenJournalLine(rlGLSetUp."Cta. haber IT Pers. C/C", vlAmountType::Credit, vITTotalCocinaComedor);
            end;
            //Incapacidad temporal. End.
        END;

        IF vTotalVigRecep <> 0 THEN BEGIN
            flInitGenJournalLine(rlGLSetUp."Cta. Personal vigilancia/Rec.", vlAmountType::Debit, vTotalVigRecep);

            //Incapacidad temporal. Begin.
            if vITTotalVigRecep <> 0 then begin
                //DEBIT
                flInitGenJournalLine(rlGLSetUp."Cta. debe IT", vlAmountType::Debit, vITTotalVigRecep);
                //CREDIT
                flInitGenJournalLine(rlGLSetUp."Cta. haber IT Pers. Vig./Rec.", vlAmountType::Credit, vITTotalVigRecep);
            end;
            //Incapacidad temporal. End.
        END;

        IF vTotalLimpieza <> 0 THEN BEGIN
            flInitGenJournalLine(rlGLSetUp."Cta. Personal limpieza", vlAmountType::Debit, vTotalLimpieza);

            //Incapacidad temporal. Begin.
            if vITTotalLimpieza <> 0 then begin
                //DEBIT
                flInitGenJournalLine(rlGLSetUp."Cta. debe IT", vlAmountType::Debit, vITTotalLimpieza);
                //CREDIT
                flInitGenJournalLine(rlGLSetUp."Cta. haber IT Pers. limpieza", vlAmountType::Credit, vITTotalLimpieza);
            end;
            //Incapacidad temporal. End.
        END;

        IF vTotalBiblioteca <> 0 THEN BEGIN
            flInitGenJournalLine(rlGLSetUp."Cta. Personal bibloteca", vlAmountType::Debit, vTotalBiblioteca);

            //Incapacidad temporal. Begin.
            if vITTotalBiblioteca <> 0 then begin
                //DEBIT
                flInitGenJournalLine(rlGLSetUp."Cta. debe IT", vlAmountType::Debit, vITTotalBiblioteca);
                //CREDIT
                flInitGenJournalLine(rlGLSetUp."Cta. haber IT Pers. bibloteca", vlAmountType::Credit, vITTotalBiblioteca);
            end;
            //Incapacidad temporal. End.
        END;

        IF vTotalEnfermeria <> 0 THEN BEGIN
            flInitGenJournalLine(rlGLSetUp."Cta. Personal enfermería", vlAmountType::Debit, vTotalEnfermeria);
            //Incapacidad temporal. Begin.
            if vITTotalEnfermeria <> 0 then begin
                //DEBIT
                flInitGenJournalLine(rlGLSetUp."Cta. debe IT", vlAmountType::Debit, vITTotalEnfermeria);
                //CREDIT
                flInitGenJournalLine(rlGLSetUp."Cta. haber IT Pers. enfermeria", vlAmountType::Credit, vITTotalEnfermeria);
            end;
            //Incapacidad temporal. End.
        END;

        IF vTotalOtros <> 0 THEN BEGIN
            flInitGenJournalLine(rlGLSetUp."Cta. Otro Personal Colaborador", vlAmountType::Debit, vTotalOtros);

            //Incapacidad temporal. Begin.
            if vITTotalOtros <> 0 then begin
                //DEBIT
                flInitGenJournalLine(rlGLSetUp."Cta. debe IT", vlAmountType::Debit, vITTotalOtros);
                //CREDIT
                flInitGenJournalLine(rlGLSetUp."Cta. haber IT Otro colaborador", vlAmountType::Credit, vITTotalOtros);
            end;
            //Incapacidad temporal. End.
        END;

        IF vIRPF <> 0 THEN
            flInitGenJournalLine(rlGLSetUp."Cta. IRPF", vlAmountType::Credit, vIRPF);

        IF vImporteLiquido <> 0 THEN
            flInitGenJournalLine(rlGLSetUp."Cta. Importe Líquido", vlAmountType::Credit, vImporteLiquido);

        IF vSSCompany <> 0 THEN BEGIN
            //CREDIT
            flInitGenJournalLine(rlGLSetUp."Cta. haber S.S. Empresa", vlAmountType::Credit, vSSCompany);
            //DEBIT
            flInitGenJournalLine(rlGLSetUp."Cta. debe S.S. Empresa", vlAmountType::Debit, vSSCompany);
        END;

        IF vSSEmployee <> 0 THEN
            flInitGenJournalLine(rlGLSetUp."Cta. haber S.S. Empleado", vlAmountType::Credit, vSSEmployee);

        //REGISTRO
        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rGenJnlBatch.Name);
        rlGenJnlLine.SETRANGE("Line No.", vFirstLineNo, vLastLineNo);
        IF rlGenJnlLine.FINDSET() THEN BEGIN
            REPEAT
                rlGenJnlLine2 := rlGenJnlLine;
                clGenJnlPostLine.RUN(rlGenJnlLine2);
            UNTIL rlGenJnlLine.NEXT() = 0;
            clGenJnlPostLine.GetGLReg(rlGLReg);
            rlGenJnlLine.DELETEALL();
        END;

        vWindow.CLOSE();
    end;

    procedure fPostCrMemCashPmnt()
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlVendor: Record Vendor;
        rlGenJnlBatch: Record "Gen. Journal Batch";
        rlGenJnlLine: Record "Gen. Journal Line";
        rlGenJnlLine2: Record "Gen. Journal Line";
        rlGLReg: Record "G/L Register";
        clGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        vlNextLineNo: Integer;
        vlFirstLineNo: Integer;
        vlLastLineNo: Integer;
        vlDocNoText: Text;
    begin
        IF vAmount = 0 THEN
            EXIT;

        vlDocNoText := '';

        IF vPostingDate = 0D THEN
            ERROR(ctBlankPostingDateErrorLbl);

        IF vVendorNo = '' THEN
            ERROR(ctBlankVendDataErrorLbl);

        IF vConcepto = '' THEN
            ERROR(ctBlankConceptoDataErrorLbl);

        IF vDocExt = '' THEN
            ERROR(ctBlankDocExtErrorLbl);

        rlSourceCodeSetup.GET();
        rlSourceCodeSetup.TESTFIELD("Easy Register Journal");

        /*
        IF NOT CONFIRM(ctVendCashPmntConfLbl) THEN
          EXIT;
        */
        rlVendor.GET(vVendorNo);

        // Coge la primera seccion asociada al Diario
        rlGenJnlBatch.RESET();
        rlGenJnlBatch.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlBatch.FINDFIRST();

        vWindow.OPEN(ctVendCashPmnttIndLbl);

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        IF rlGenJnlLine.FINDLAST() THEN
            vlNextLineNo := rlGenJnlLine."Line No."
        ELSE
            vlNextLineNo := 0;

        vlNextLineNo := vlNextLineNo + 10000;

        vlFirstLineNo := vlNextLineNo;

        vGenJnlBatch := rlGenJnlBatch.Name;

        // PRIMERA LÍNEA DEL REGISTRO
        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::"Credit Memo");

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);
        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::Vendor);
        rlGenJnlLine.VALIDATE("Account No.", vVendorNo);
        rlGenJnlLine.VALIDATE("External Document No.", vDocExt);

        IF STRLEN(STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
            rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name), MAXSTRLEN(rlGenJnlLine.Description))
        ELSE
            rlGenJnlLine.Description := STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name);

        vDescrip := rlGenJnlLine.Description;

        rlGenJnlLine.VALIDATE(Amount, vAmount);

        IF rRegisterItem.GET(vConcepto) THEN BEGIN
            rlGenJnlLine.VALIDATE("Bal. Account Type", rRegisterItem."Account Type");
            rlGenJnlLine.VALIDATE("Bal. Account No.", rRegisterItem."Account No.");
        END;

        rlGenJnlLine.VALIDATE("Applies-to ID", '*' + USERID + '*');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Inicio
        fSetEasyRegisterDimension(rlGenJnlLine, rRegisterItem);
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;
        vlNextLineNo := vlNextLineNo + 10000;

        // SEGUNDA LÍNEA DEL REGISTRO
        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rlGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);
        rlGenJnlLine.VALIDATE("Document Type", rlGenJnlLine."Document Type"::Refund);

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);
        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::Vendor);
        rlGenJnlLine.VALIDATE("Account No.", vVendorNo);

        IF STRLEN(STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name)) > MAXSTRLEN(rlGenJnlLine.Description) THEN
            rlGenJnlLine.Description := PADSTR(STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name), MAXSTRLEN(rlGenJnlLine.Description))
        ELSE
            rlGenJnlLine.Description := STRSUBSTNO(ctVendCashPmntDescLbl, rlVendor.Name);

        vDescrip := rlGenJnlLine.Description;

        rlGenJnlLine.VALIDATE(Amount, -vAmount);

        rlGenJnlLine.VALIDATE("Bal. Account Type", rlGenJnlLine."Bal. Account Type"::"Bank Account");
        rlGenJnlLine.VALIDATE("Bal. Account No.", vBankAccNo);

        rlGenJnlLine.VALIDATE("Applies-to ID", '');
        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine.VALIDATE("Applies-to Doc. Type", rlGenJnlLine."Applies-to Doc. Type"::"Credit Memo");
        rlGenJnlLine.VALIDATE("Applies-to Doc. No.", vDocNo);
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Inicio
        fSetEasyRegisterDimension(rlGenJnlLine, rRegisterItem);
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vlLastLineNo := vlNextLineNo;

        //REGISTRO
        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rlGenJnlBatch.Name);
        rlGenJnlLine.SETRANGE("Line No.", vlFirstLineNo, vlLastLineNo);
        IF rlGenJnlLine.FINDSET() THEN BEGIN
            REPEAT
                rlGenJnlLine2 := rlGenJnlLine;
                clGenJnlPostLine.RUN(rlGenJnlLine2);
            UNTIL rlGenJnlLine.NEXT() = 0;
            clGenJnlPostLine.GetGLReg(rlGLReg);
            rlGenJnlLine.DELETEALL();
        END;

        vWindow.CLOSE();
    end;

    procedure fSetPostingConcept(pPostingConcept: Text)
    begin
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
        vPostingConcept := COPYSTR(pPostingConcept, 1, 250);
    end;

    local procedure fSetEasyRegisterDimension(var pGenJournalLine: Record "Gen. Journal Line"; pEasyRegisterConcepcept: Record "Easy Register Concepts")
    var
        TemprlDimensionSetEntry: Record "Dimension Set Entry" temporary;
        rlDimension: Record Dimension;
        DimMgt: Codeunit DimensionManagement;
    begin
        //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple
        rlDimension.RESET();
        rlDimension.SETRANGE("Easy Register Dimension", TRUE);
        IF NOT rlDimension.FINDFIRST() THEN //ya se controla que solo haya uno
            EXIT;
        IF pEasyRegisterConcepcept."Easy Register Dimension Value" = '' THEN
            EXIT;

        DimMgt.GetDimensionSet(TemprlDimensionSetEntry, 0);
        TemprlDimensionSetEntry.INIT();
        TemprlDimensionSetEntry.VALIDATE("Dimension Code", rlDimension.Code);
        TemprlDimensionSetEntry.VALIDATE("Dimension Value Code", pEasyRegisterConcepcept."Easy Register Dimension Value");
        TemprlDimensionSetEntry.INSERT(TRUE);
        pGenJournalLine."Dimension Set ID" := DimMgt.GetDimensionSetID(TemprlDimensionSetEntry);

        /*
        rlDimensionSetEntry.RESET();
        rlDimensionSetEntry.SETRANGE("Dimension Code", rlDimension.Code);
        rlDimensionSetEntry.SETRANGE("Dimension Value Code", pEasyRegisterConcepcept."Easy Register Dimension Value");
        IF NOT rlDimensionSetEntry.FINDFIRST() THEN BEGIN
          rlDimensionSetEntry.INIT();
          rlDimensionSetEntry.VALIDATE("Dimension Code", rlDimension.Code);
          rlDimensionSetEntry.VALIDATE("Dimension Value Code", pEasyRegisterConcepcept."Easy Register Dimension Value");
          rlDimensionSetEntry.INSERT(TRUE);
        //END;

        pGenJournalLine."Dimension Set ID" := DimMgt.GetDimensionSetID(rlDimensionSetEntry);

        DimSetID := GETRANGEMIN(rlDimensionSetEntry."Dimension Set ID");
        DimMgt.GetDimensionSet(rlDimensionSetEntry,DimSetID);
        xxx
        DimSetID := DimMgt.GetDimensionSetID(rlDimensionSetEntry);
        */
    end;

    local procedure flInitGenJournalLine(pGLAccount: Code[20]; pAmountType: Option Debit,Credit; pAmount: Decimal)
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlGenJnlLine: Record "Gen. Journal Line";
        vlNextLineNo: Integer;
    begin
        rGenJnlBatch.RESET();
        rGenJnlBatch.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rGenJnlBatch.FINDFIRST();

        vWindow.OPEN(ctNominaIndLbl);

        rlGenJnlLine.RESET();
        rlGenJnlLine.SETRANGE("Journal Template Name", vGenJnlTemplate);
        rlGenJnlLine.SETRANGE("Journal Batch Name", rGenJnlBatch.Name);
        IF rlGenJnlLine.FINDLAST() THEN
            vlNextLineNo := rlGenJnlLine."Line No."
        ELSE
            vlNextLineNo := 0;

        vlNextLineNo := vlNextLineNo + 10000;

        if vFirstLineNo = 0 then
            vFirstLineNo := vlNextLineNo;

        vGenJnlBatch := rGenJnlBatch.Name;

        rlGenJnlLine.INIT();
        rlGenJnlLine."Journal Template Name" := vGenJnlTemplate;
        rlGenJnlLine."Journal Batch Name" := rGenJnlBatch.Name;
        rlGenJnlLine."Line No." := vlNextLineNo;
        rlGenJnlLine.INSERT(TRUE);

        rlGenJnlLine.VALIDATE("Posting Date", vPostingDate);

        vDocNo := FORMAT(DATE2DMY(vPostingDate, 3)) + FORMAT(DATE2DMY(vPostingDate, 2)) + FORMAT(DATE2DMY(vPostingDate, 1)) + STRSUBSTNO('%1', TIME);
        rlGenJnlLine."Document No." := vDocNo;

        rlGenJnlLine.VALIDATE("Account Type", rlGenJnlLine."Account Type"::"G/L Account");
        rlGenJnlLine.VALIDATE("Account No.", pGLAccount);

        //rlGenJnlLine.VALIDATE("Bal. Account Type",rlGenJnlLine."Account Type"::"G/L Account");
        //rlGenJnlLine.VALIDATE("Bal. Account No.",rlGLSetUp."Cta. Importe Total Devengado");

        vDescrip := rlGenJnlLine.Description;

        if pAmountType = pAmountType::Debit then
            rlGenJnlLine.VALIDATE("Debit Amount", pAmount)
        else
            rlGenJnlLine.VALIDATE("Credit Amount", pAmount);

        rlGenJnlLine."Gen. Posting Type" := rlGenJnlLine."Gen. Posting Type"::" ";
        rlGenJnlLine."Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Gen. Prod. Posting Group" := '';
        rlGenJnlLine."VAT Bus. Posting Group" := '';
        rlGenJnlLine."VAT Prod. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Posting Type" := rlGenJnlLine."Bal. Gen. Posting Type"::" ";
        rlGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        rlGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Bus. Posting Group" := '';
        rlGenJnlLine."Bal. VAT Prod. Posting Group" := '';
        rlGenJnlLine."Source Code" := rlSourceCodeSetup."Easy Register Journal";
        rlGenJnlLine."System-Created Entry" := TRUE;

        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        rlGenJnlLine."Posting concept" := vPostingConcept;
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

        rlGenJnlLine.MODIFY(TRUE);

        vLastLineNo := vlNextLineNo;
    end;
}
