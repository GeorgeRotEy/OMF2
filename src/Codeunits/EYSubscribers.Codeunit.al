codeunit 50016 "EY Subscribers"
{
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
    // Reaplicamos en extensión la asignación de "Posting concept"
    // dentro de CopyFromGenJnlLine usando el IntegrationEvent estándar.
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure es_t17_OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        GLEntry."Posting concept" := GenJournalLine."Posting concept";
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin
    end;
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin

    [EventSubscriber(ObjectType::Table, Database::Customer, OnBeforeGetCustNoOpenCard, '', false, false)]
    local procedure es_t18_OnBeforeGetCustNoOpenCard(CustomerText: Text; ShowCustomerCard: Boolean; var ShowCreateCustomerOption: Boolean; var CustomerNo: Code[20]; var IsHandled: Boolean)
    var
        Customer: Record Customer;
        NoFiltersApplied: Boolean;
        CustomerWithoutQuote: Text;
        CustomerFilterFromStart: Text;
        CustomerFilterContains: Text;
        SelectCustErr: Label 'You must select an existing customer.', Comment = 'ESP="Debe seleccionar un cliente existente"';
    begin
        IsHandled := true;

        if CustomerText = '' then
            CustomerNo := '';

        if StrLen(CustomerText) <= MaxStrLen(Customer."No.") then
            if Customer.Get(CopyStr(CustomerText, 1, MaxStrLen(Customer."No."))) then
                CustomerNo := Customer."No.";

        Customer.SetRange(Blocked, Customer.Blocked::" ");
        Customer.SetRange(Name, CustomerText);
        if Customer.FindFirst() then
            CustomerNo := Customer."No.";

        Customer.SetCurrentKey(Name);

        CustomerWithoutQuote := ConvertStr(CustomerText, '''', '?');
        Customer.SetFilter(Name, '''@' + CustomerWithoutQuote + '''');
        if Customer.FindFirst() then
            CustomerNo := Customer."No.";
        Customer.SetRange(Name);

        CustomerFilterFromStart := '''@' + CustomerWithoutQuote + '*''';

        Customer.FilterGroup := -1;
        Customer.SetFilter("No.", CustomerFilterFromStart);

        Customer.SetFilter(Name, CustomerFilterFromStart);

        if Customer.FindFirst() then
            if Customer.Count() = 1 then
                CustomerNo := Customer."No.";

        CustomerFilterContains := '''@*' + CustomerWithoutQuote + '*''';

        Customer.SetFilter("No.", CustomerFilterContains);
        Customer.SetFilter(Name, CustomerFilterContains);
        Customer.SetFilter(City, CustomerFilterContains);
        Customer.SetFilter(Contact, CustomerFilterContains);
        Customer.SetFilter("Phone No.", CustomerFilterContains);
        Customer.SetFilter("Post Code", CustomerFilterContains);

        if Customer.Count() = 0 then
            EYFunctions.MarkCustomersWithSimilarName(Customer, CustomerText);

        if Customer.Count() = 1 then begin
            Customer.FindFirst();
            CustomerNo := Customer."No."
        end;

        if not GuiAllowed() then
            Error(SelectCustErr);

        // (CJ03) S2G (JDT) 25-10-19: Bloquear creaci�n de Clientes o Proveedores, si no se crean desde Terceros
        // if Customer.Count = 0 then begin
        //     if Customer.WritePermission then
        //         if ShowCreateCustomerOption then
        //             case StrMenu(
        //                    StrSubstNo(
        //                      '%1,%2', StrSubstNo(CreateNewCustTxt, ConvertStr(CustomerText, ',', '.')), SelectCustTxt), 1, CustNotRegisteredTxt) of
        //                 0:
        //                     Error(SelectCustErr);
        //                 1:
        //                     CustomerNo := CreateNewCustomer(CopyStr(CustomerText, 1, MaxStrLen(Customer.Name)), ShowCustomerCard);
        //             end
        //         else
        //             CustomerNo := '';
        //     Customer.Reset();
        //     NoFiltersApplied := true;
        // end;
        // (CJ03) S2G (JDT) 25-10-19: Bloquear creaci�n de Clientes o Proveedores, si no se crean desde Terceros

        if ShowCustomerCard then
            CustomerNo := EYFunctions.PickCustomer(Customer, NoFiltersApplied)
        else
            // LookupRequested := true;
            CustomerNo := '';

        if CustomerNo <> '' then
            CustomerNo := CustomerNo;

        Error(SelectCustErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure es_t21_OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        //APA--
        CustLedgerEntry."Posting concept" := GenJournalLine."Posting concept";
        //APA++
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, OnBeforeGetVendorNoOpenCard, '', false, false)]
    local procedure es_t23_OnBeforeGetVendorNoOpenCard(VendorText: Text; ShowVendorCard: Boolean; var VendorNo: Code[20]; var IsHandled: Boolean; var ShowCreateVendorOption: Boolean)
    var
        Vendor: Record Vendor;
        NoFiltersApplied: Boolean;
        VendorWithoutQuote: Text;
        VendorFilterFromStart: Text;
        VendorFilterContains: Text;
        SelectVendorErr: Label 'You must select an existing vendor.', Comment = 'ESP="Debe seleccionar un proveedor existente"';
    begin
        if VendorText = '' then
            VendorNo := '';

        if StrLen(VendorText) <= MaxStrLen(Vendor."No.") then
            if Vendor.Get(VendorText) then
                VendorNo := Vendor."No.";

        Vendor.SetRange(Blocked, Vendor.Blocked::" ");
        Vendor.SetRange(Name, VendorText);
        if Vendor.FindFirst() then
            VendorNo := Vendor."No.";

        VendorWithoutQuote := ConvertStr(VendorText, '''', '?');

        Vendor.SetFilter(Name, '''@' + VendorWithoutQuote + '''');
        if Vendor.FindFirst() then
            if Vendor.Count() = 1 then
                VendorNo := Vendor."No.";
        Vendor.SetRange(Name);

        VendorFilterFromStart := '''@' + VendorWithoutQuote + '*''';

        Vendor.FilterGroup := -1;
        Vendor.SetFilter("No.", VendorFilterFromStart);
        Vendor.SetFilter(Name, VendorFilterFromStart);
        if Vendor.FindFirst() then
            if Vendor.Count() = 1 then
                VendorNo := Vendor."No.";

        VendorFilterContains := '''@*' + VendorWithoutQuote + '*''';

        Vendor.SetFilter("No.", VendorFilterContains);
        Vendor.SetFilter(Name, VendorFilterContains);
        Vendor.SetFilter(City, VendorFilterContains);
        Vendor.SetFilter(Contact, VendorFilterContains);
        Vendor.SetFilter("Phone No.", VendorFilterContains);
        Vendor.SetFilter("Post Code", VendorFilterContains);

        if Vendor.Count() = 0 then
            EYFunctions.MarkVendorsWithSimilarName(Vendor, VendorText);

        if Vendor.Count() = 1 then begin
            Vendor.FindFirst();
            VendorNo := Vendor."No.";
        end;

        if not GuiAllowed() then
            Error(SelectVendorErr);

        // (CJ03) S2G (JDT) 25-10-19: Bloquear creaci�n de Clientes o Proveedores, si no se crean desde Terceros
        // if Vendor.Count = 0 then begin
        //     if Vendor.WritePermission then
        //         if ShowCreateVendorOption then
        //             case StrMenu(StrSubstNo('%1,%2', StrSubstNo(CreateNewVendTxt, VendorText), SelectVendTxt), 1, VendNotRegisteredTxt) of
        //                 0:
        //                     Error(SelectVendorErr);
        //                 1:
        //                     exit(CreateNewVendor(CopyStr(VendorText, 1, MaxStrLen(Vendor.Name)), ShowVendorCard));
        //             end
        //         else
        //             VendorNo := '';
        //     Vendor.Reset();
        //     NoFiltersApplied := true;
        // end;
        // (CJ03) S2G (JDT) 25-10-19: Bloquear creaci�n de Clientes o Proveedores, si no se crean desde Terceros

        if ShowVendorCard then
            VendorNo := EYFunctions.PickVendor(Vendor, NoFiltersApplied)
        else
            VendorNo := '';

        if VendorNo <> '' then
            VendorNo := VendorNo;

        Error(SelectVendorErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure es_t25_OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        //APA--
        VendorLedgerEntry."Posting concept" := GenJournalLine."Posting concept";
        //APA++
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnInitInsertOnBeforeInitRecord, '', false, false)]
    local procedure OnInitInsertOnBeforeInitRecord(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    var
        rlUser: Record User;
        TextNELbl: Label 'El usuario no existe';
    begin
        //(FVC001) S2G (JPB) 31/07/2019: Facturaci�n de ventas desde colegios. INICIO
        CLEAR(rlUser);
        IF NOT (rlUser.GET(USERSECURITYID())) THEN
            MESSAGE(TextNELbl)
        ELSE BEGIN
            SalesHeader."User Name" := rlUser."User Name";
            SalesHeader."User Full Name" := rlUser."Full Name";
            //Rec.MODIFY();
        END;
        //(FVC001) S2G (JPB) 31/07/2019: Facturaci�n de ventas desde colegios. FIN
    end;

    [EventSubscriber(ObjectType::Table, Database::"Analysis View Entry", OnBeforeDrilldown, '', false, false)]
    local procedure es_t365_OnBeforeDrilldown(var AnalysisViewEntry: Record "Analysis View Entry"; var IsHandled: Boolean)
    var
        TempGLEntry: Record "G/L Entry" temporary;
        TempCFForecastEntry: Record "Cash Flow Forecast Entry" temporary;
        TempDistrEntry: Record "Distribution Entry" temporary;
        AnalysisViewEntryToGLEntries: Codeunit AnalysisViewEntryToGLEntries;
    begin
        IsHandled := true;
        case AnalysisViewEntry."Account Source" of
            AnalysisViewEntry."Account Source"::"G/L Account":
                begin
                    TempGLEntry.Reset();
                    TempGLEntry.DeleteAll();
                    AnalysisViewEntryToGLEntries.GetGLEntries(AnalysisViewEntry, TempGLEntry);
                    PAGE.RunModal(PAGE::"General Ledger Entries", TempGLEntry);
                    //Mod. S2G (CPA) <ANA001> Reparto anal�tico.BEGIN
                end;
            AnalysisViewEntry."Account Source"::"Distribution Account":
                begin
                    TempDistrEntry.RESET();
                    if TempDistrEntry.IsTemporary then
                        TempDistrEntry.DELETEALL();
                    EYFunctions.GetDistribEntries(AnalysisViewEntry, TempDistrEntry);
                    PAGE.RUNMODAL(PAGE::"Distribution Entry", TempDistrEntry);
                    //Mod. S2G (CPA) <ANA001> Reparto anal�tico.BEGIN
                end;
            else begin
                TempCFForecastEntry.Reset();
                TempCFForecastEntry.DeleteAll();
                AnalysisViewEntryToGLEntries.GetCFLedgEntries(AnalysisViewEntry, TempCFForecastEntry);
                PAGE.RunModal(PAGE::"Cash Flow Forecast Entries", TempCFForecastEntry);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnValidateNoOnCopyFromTempSalesLine, '', false, false)]
    local procedure es_t37_OnValidateNoOnCopyFromTempSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    begin
        // >> IRPF - Recupero el tipo de la Línea.
        SalesLine."IRPF Line" := TempSalesLine."IRPF Line";
        // <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeZeroAmountLine, '', false, false)]
    local procedure es_t37_OnBeforeZeroAmountLine(var SalesLine: Record "Sales Line"; QtyType: Option General,Invoicing,Shipping; var Result: Boolean; var IsHandled: Boolean)
    begin
        if QtyType = QtyType::Invoicing then
            if SalesLine."Qty. to Invoice" = 0 then
                // >> IRPF
                IF NOT SalesLine."IRPF Line" THEN
                    // <<
                    Result := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterInitHeaderDefaults, '', false, false)]
    local procedure es_t37_OnAfterInitHeaderDefaults(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; xSalesLine: Record "Sales Line")
    begin
        // >> IRPF
        // Esta Línea no debe tener Grupo IRPF ya que indicar� el importe de IRPF calculado, ni debe de haber sido creada automaticamente
        // por el sistema, ya que si as� podr�a tratarse de una Línea de prepago.
        IF NOT (SalesLine."IRPF Line") AND NOT (SalesLine."System-Created Entry") THEN
            SalesLine.VALIDATE("IRPF Posting Group", SalesHeader."Grupo registro IRPF");
        // <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Analysis View", OnValidateAccountFilter, '', false, false)]
    local procedure es_t363_OnValidateAccountFilter(var AnalysisView: Record "Analysis View"; var xRecAnalysisView: Record "Analysis View")
    var
        AnalysisViewEntry: Record "Analysis View Entry";
        AnalysisViewBudgetEntry: Record "Analysis View Budget Entry";
        GLAcc: Record "G/L Account";
        DistribAccount: Record "Schedule of Distrib. Accounts";
    begin
        //IGG - Necesrio para leer variables. Begin.
        IF AnalysisView."Account Source" = AnalysisView."Account Source"::"G/L Account" THEN BEGIN
            IF (AnalysisView."Last Entry No." <> 0) AND (xRecAnalysisView."Account Filter" = '') AND (AnalysisView."Account Filter" <> '')
            THEN BEGIN
                AnalysisView.ValidateModify(AnalysisView.FIELDCAPTION("Account Filter"));
                GLAcc.SETFILTER("No.", AnalysisView."Account Filter");
                IF GLAcc.FIND('-') THEN
                    REPEAT
                        GLAcc.MARK := TRUE;
                    UNTIL GLAcc.NEXT() = 0;
                GLAcc.SETRANGE("No.");
                IF GLAcc.FIND('-') THEN
                    REPEAT
                        IF NOT GLAcc.MARK() THEN BEGIN
                            AnalysisViewEntry.SETRANGE("Analysis View Code", AnalysisView.Code);
                            AnalysisViewEntry.SETRANGE("Account No.", GLAcc."No.");
                            AnalysisViewEntry.DELETEALL();
                            AnalysisViewBudgetEntry.SETRANGE("Analysis View Code", AnalysisView.Code);
                            AnalysisViewBudgetEntry.SETRANGE("G/L Account No.", GLAcc."No.");
                            AnalysisViewBudgetEntry.DELETEALL();
                        END;
                    UNTIL GLAcc.NEXT() = 0;
            END;
            IF (AnalysisView."Last Entry No." <> 0) AND (AnalysisView."Account Filter" <> xRecAnalysisView."Account Filter") AND (xRecAnalysisView."Account Filter" <> '')
            THEN BEGIN
                AnalysisView.ValidateDelete(AnalysisView.FIELDCAPTION("Account Filter"));
                AnalysisView.AnalysisViewRESET();
            END;
            //Mod. S2G (CPA) <ANA001> Reparto analítico.BEGIN
        END ELSE
            //IGG - Necesrio para leer variables. End.
            //Mod. S2G (CPA) <ANA001> Reparto analítico.BEGIN
            IF AnalysisView."Account Source" = AnalysisView."Account Source"::"G/L Account" THEN BEGIN
                IF (AnalysisView."Last Entry No." <> 0) AND (xRecAnalysisView."Account Filter" = '') AND (AnalysisView."Account Filter" <> '') THEN begin
                    AnalysisView.ValidateModify(AnalysisView.FIELDCAPTION("Account Filter"));
                    DistribAccount.SETFILTER("No.", AnalysisView."Account Filter");
                    IF DistribAccount.FIND('-') THEN
                        REPEAT
                            DistribAccount.MARK := TRUE;
                        UNTIL DistribAccount.NEXT() = 0;
                    DistribAccount.SETRANGE("No.");
                    IF DistribAccount.FIND('-') THEN
                        REPEAT
                            IF NOT DistribAccount.MARK() THEN BEGIN
                                AnalysisViewEntry.SETRANGE("Analysis View Code", AnalysisView.Code);
                                AnalysisViewEntry.SETRANGE("Account No.", GLAcc."No.");
                                AnalysisViewEntry.DELETEALL();
                                AnalysisViewBudgetEntry.SETRANGE("Analysis View Code", AnalysisView.Code);
                                AnalysisViewBudgetEntry.SETRANGE("G/L Account No.", DistribAccount."No.");
                                AnalysisViewBudgetEntry.DELETEALL();
                            END;
                        UNTIL DistribAccount.NEXT() = 0;
                end;
                IF (AnalysisView."Last Entry No." <> 0) AND (AnalysisView."Account Filter" <> xRecAnalysisView."Account Filter") AND (xRecAnalysisView."Account Filter" <> '')
                            THEN BEGIN
                    AnalysisView.ValidateDelete(AnalysisView.FIELDCAPTION(AnalysisView."Account Filter"));
                    AnalysisView.AnalysisViewRESET();
                END;
            END;
        //Mod. S2G (CPA) <ANA001> Reparto analítico.END
    end;

    [EventSubscriber(ObjectType::Table, Database::"Analysis View", OnAfterCopyAnalysisViewFilters, '', false, false)]
    local procedure es_t363_OnAfterCopyAnalysisViewFilters(var AnalysisView: Record "Analysis View"; ObjectType: Integer; ObjectID: Integer; AnalysisViewCode: Code[10]; var GLAcc: Record "G/L Account")
    var
        SelectedDim: Record "Selected Dimension";
        CFAcc: Record "Cash Flow Account";
        DistribAcc: Record "Schedule of Distrib. Accounts";
        DimensionCode: Text[30];
    begin
        if AnalysisView.Get(AnalysisViewCode) then
            if AnalysisView."Account Filter" <> '' then begin
                case AnalysisView."Account Source" of
                    AnalysisView."Account Source"::"G/L Account":
                        DimensionCode := GLAcc.TableCaption();
                    //Mod. S2G (CPA) <ANA001> Reparto anal�tico.Begin
                    AnalysisView."Account Source"::"Analytic Distribution Account":
                        DimensionCode := DistribAcc.TABLECAPTION();
                    //Mod. S2G (CPA) <ANA001> Reparto anal�tico.End
                    else
                        DimensionCode := CFAcc.TableCaption();
                end;

                if SelectedDim.Get(
                     UserId, ObjectType, ObjectID, AnalysisViewCode, DimensionCode)
                then begin
                    if SelectedDim."Dimension Value Filter" = '' then begin
                        SelectedDim."Dimension Value Filter" := AnalysisView."Account Filter";
                        SelectedDim.Modify();
                    end;
                end else begin
                    SelectedDim.Init();
                    SelectedDim."User ID" := CopyStr(UserId(), 1, MaxStrLen(SelectedDim."User ID"));
                    SelectedDim."Object Type" := ObjectType;
                    SelectedDim."Object ID" := ObjectID;
                    SelectedDim."Analysis View Code" := AnalysisViewCode;
                    SelectedDim."Dimension Code" := DimensionCode;
                    SelectedDim."Dimension Value Filter" := AnalysisView."Account Filter";
                    SelectedDim.Insert();
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Registration No. Format", OnBeforeCheckConfirmVATRegNo, '', false, false)]
    local procedure es_t381_OnBeforeCheckConfirmVATRegNo(VATRegNo: Text[20]; var IsHandled: Boolean)
    var
        rlVATRegNoFormat: Record "VAT Registration No. Format";
        ErrorText: Text[120];
        Text1100000Lbl: Label 'The VAT Registration number is not valid.', Comment = 'ESP="El nº de registro de IVA no es válido"';
    begin
        ErrorText := '';
        if not rlVATRegNoFormat.ValidateVATRegNo(VATRegNo, ErrorText) then
            //(CJ02) S2G (JDT) 12-12-19: Validaci�n de CIF en Alta Terceros
            //IF NOT CONFIRM(Text1100000Lbl + '\' + ErrorText + '\\' + Text1100001,FALSE) THEN
            //ERROR(Text1100002);
          ERROR(Text1100000Lbl);
        //(CJ02) S2G (JDT) 12-12-19: Validaci�n de CIF en Alta Terceros
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Registration No. Format", OnTestTable, '', false, false)]
    local procedure es_t381_OnTestTable(VATRegNo: Text[20]; CountryCode: Code[10]; Number: Code[20]; TableID: Option)
    var
        rlVATRegNoFormat: Record "VAT Registration No. Format";
    begin
        case TableID of
            //(CR002) S2G (RBM-R) 29-08-18: Validaci�n de CIF en Terceros. Inicio
            DATABASE::"Third Party":
                rlVATRegNoFormat.fCheckThirdParty(VATRegNo, Number);
            //(CR002) S2G (RBM-R) 29-08-18: Validaci�n de CIF en Terceros. Fin
            //(CJ02) S2G (JDT) 28-10-19: Validaci�n de CIF en Alta Terceros
            DATABASE::"Alta Terceros":
                rlVATRegNoFormat.fCheckAltaTerceros(VATRegNo, Number);
        //(CJ02) S2G (JDT) 28-10-19: Validaci�n de CIF en Alta Terceros
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnValidateNoOnCopyFromTempPurchLine, '', false, false)]
    local procedure es_t39_OnValidateNoOnCopyFromTempPurchLine(var PurchLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary; xPurchLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        // >> IRPF - Recupero el tipo de la Línea.
        PurchLine."Línea IRPF" := TempPurchaseLine."Línea IRPF";
        // <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterInitHeaderDefaults, '', false, false)]
    local procedure es_t39_OnAfterInitHeaderDefaults(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; var TempPurchLine: record "Purchase Line" temporary)
    begin
        // >> IRPF
        // Esta Línea no debe tener Grupo IRPF ya que indicar� el importe de IRPF calculado, ni debe haber sido creada automaticamente
        // por el sistema, ya que si as� podr�a tratarse de una Línea de prepago.
        IF NOT (PurchLine."Línea IRPF") AND NOT (PurchLine."System-Created Entry") THEN
            PurchLine.VALIDATE("Grupo registro IRPF", PurchHeader."Grupo registro IRPF");
        // <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnBeforeZeroAmountLine, '', false, false)]
    local procedure es_t39_OnBeforeZeroAmountLine(var PurchaseLine: Record "Purchase Line"; QtyType: Option General,Invoicing,Shipping; var Result: Boolean; var IsHandled: Boolean)
    begin
        IF QtyType = QtyType::Invoicing THEN
            IF PurchaseLine."Qty. to Invoice" = 0 THEN
                // >> IRPF
                IF NOT PurchaseLine."Línea IRPF" THEN
                    // <<
                    Result := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", OnBeforeUpdate, '', false, false)]
    local procedure es_t55_OnBeforeUpdate(var InvoicePostingBuffer: Record "Invoice Posting Buffer"; var FromInvoicePostingBuffer: Record "Invoice Posting Buffer")
    begin
        //Tabla reemplazada (49 por 55)
        if not InvoicePostingBuffer.Find() then
            //Mod. SGP retenciones
        InvoicePostingBuffer."Retention Entry No." := FromInvoicePostingBuffer."Retention Entry No.";
        //Mod SGp retenciones
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", OnPrepareLineOnAfterFillInvoicePostingBuffer, '', false, false)]
    local procedure es_c816_PurchPostInvoiceEvents_OnPrepareLineOnAfterFillInvoicePostingBuffer(var InvoicePostingBuffer: Record "Invoice Posting Buffer"; PurchLine: Record "Purchase Line"; var TempInvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var FALineNo: Integer; var InvDefLineNo: Integer; var DeferralLineNo: Integer; var IsHandled: Boolean)
    begin
        if PurchLine."Línea IRPF" then
            InvoicePostingBuffer."Retention Entry No." := cuGestionIRPF.GetRetentionEntryNoFromPurchLine(PurchLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", OnPrepareLineOnAfterFillInvoicePostingBuffer, '', false, false)]
    local procedure es_c817_SalesPostInvoiceEvents_OnPrepareLineOnAfterFillInvoicePostingBuffer(var InvoicePostingBuffer: Record "Invoice Posting Buffer"; SalesLine: Record "Sales Line")
    begin
        if SalesLine."IRPF Line" then
            InvoicePostingBuffer."Retention Entry No." := cuGestionIRPF.GetRetentionEntryNoFromSalesLine(SalesLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", OnAfterPrepareGenJnlLine, '', false, false)]
    local procedure es_c816_PurchPostInvoiceEvents_OnAfterPrepareGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header"; InvoicePostingBuffer: Record "Invoice Posting Buffer")
    begin
        //- Mod. S2G 11/05/2017 (SGP) : GF-010
        if InvoicePostingBuffer."Retention Entry No." <> 0 then
            GenJnlLine."No. mov. retención" := InvoicePostingBuffer."Retention Entry No.";
        //- Mod. S2G 11/05/2017 (SGP) : GF-010
        // TER001 - Maestro de terceros.begin
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" THEN BEGIN
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::" ";
            GenJnlLine."Source No." := '';
        END;
        // TER001 - Maestro de terceros.end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", OnAfterPrepareGenJnlLine, '', false, false)]
    local procedure es_c817_SalesPostInvoiceEvents_OnAfterPrepareGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; InvoicePostingBuffer: Record "Invoice Posting Buffer")
    begin
        //- Mod. S2G 11/05/2017 (SGP) : GF-010
        if InvoicePostingBuffer."Retention Entry No." <> 0 then
            GenJnlLine."No. mov. retención" := InvoicePostingBuffer."Retention Entry No.";
        //- Mod. S2G 11/05/2017 (SGP) : GF-010
        // TER001 - Maestro de terceros.begin
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" THEN BEGIN
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::" ";
            GenJnlLine."Source No." := '';
        END;
        // TER001 - Maestro de terceros.end
    end;


    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterCopyGenJnlLineFromPurchHeader, '', false, false)]
    local procedure es_t81_OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Inicio
        GenJournalLine."Budg. Cont. Doc. No." := PurchaseHeader."No.";
        //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Fin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterCopyGenJnlLineFromSalesHeader, '', false, false)]
    local procedure es_t81_OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Inicio
        GenJournalLine."Budg. Cont. Doc. No." := SalesHeader."No.";
        //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Fin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterAccountNoOnValidateGetGLAccount, '', false, false)]
    local procedure es_t81_OnAfterAccountNoOnValidateGetGLAccount(var GenJournalLine: Record "Gen. Journal Line"; var GLAccount: Record "G/L Account"; CallingFieldNo: Integer)
    var
        grGLAccount: Record "G/L Account";
    begin
        //+Mod. S2G 26/01/2017 (SGP) : GF - 010
        IF grGLAccount.GET(GenJournalLine."Account No.") THEN
            GenJournalLine."Código IRPF" := grGLAccount."Cod retencion";
        //-Mod. S2G 26/01/2017 (SGP) : GF - 010
    end;

    [EventSubscriber(ObjectType::Table, Database::"Acc. Schedule Line", OnAfterLookupTotaling, '', false, false)]
    local procedure es_t85_OnAfterLookupTotaling(var AccScheduleLine: Record "Acc. Schedule Line")
    var
        pDistributionSched: page "Chart of schedule List";
    begin
        CASE AccScheduleLine."Totaling Type" OF
            //ABC
            AccScheduleLine."Totaling Type"::"Distribution Entry":
                BEGIN
                    pDistributionSched.LOOKUPMODE(TRUE);
                    IF pDistributionSched.RUNMODAL() = ACTION::LookupOK THEN
                        AccScheduleLine.VALIDATE(Totaling, pDistributionSched.GetSelectionFilter());
                END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeCode, '', false, false)]
    local procedure es_c12_OnBeforeCode(var GenJnlLine: Record "Gen. Journal Line"; CheckLine: Boolean; var IsPosted: Boolean; var GLReg: Record "G/L Register"; var GLEntryNo: Integer)
    begin
        // Mod. S2G 28/12/2017 (SGP) : Retenciones. IRPF.inicio
        cuGestionIRPF.CalcularIRPFJnlLine(GenJnlLine);
        // Mod. S2G 28/12/2017 (SGP) : Retenciones. IRPF.fiN
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnCodeOnAfterCheckGenJnlLine, '', false, false)]
    local procedure es_c12_OnCodeOnAfterCheckGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; CheckLine: Boolean)
    var
        rlBudgetControl: Record "Budget Control Setup";
        vError: Text;
    begin
        //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Inicio
        vError := '';
        IF NOT rlBudgetControl.fCheckBudget_GenJnlLine(GenJnlLine, vError) THEN
            ERROR(vError);
        //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Fin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeInsertGlobalGLEntry, '', false, false)]
    local procedure es_c12_OnBeforeInsertGlobalGLEntry(var GlobalGLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; FiscalYearStartDate: Date)
    begin
        // Mod. S2G 28/12/2017 (SGP) : Retenciones. IRPF.inicio
        CLEAR(cuGestionIRPF);
        cuGestionIRPF.fCompletarCamposRetencion(GlobalGLEntry, GenJournalLine);
        GlobalGLEntry."Movimiento IRPF liquidado" := GenJournalLine."Movimiento IRPF liquidado";
        // Mod. S2G 28/12/2017 (SGP) : Retenciones. IRPF.fin
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnBeforeRaiseExceedLengthError, '', false, false)]
    // local procedure es_c13_OnBeforeRaiseExceedLengthError(var GenJournalBatch: Record "Gen. Journal Batch"; var RaiseError: Boolean; var GenJnlLine: Record "Gen. Journal Line")
    // begin
    //INTERCOMPANY
    // // Mod. S2G (JMP) 16/04/2018 GF008
    // IF EYFunctions.fExistIntercompanyTransactionLines(GenJnlLine) THEN BEGIN
    //     CLEAR(cIntercompanyPostingMgt);
    //     cIntercompanyPostingMgt.fProcessIntercompanyGenJnlLine(GenJnlLine);
    // END;
    // // Mod. S2G (JMP) 16/04/2018 GF008
    // end;

    //Intercompany
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnBeforeUpdateAndDeleteLines, '', false, false)]
    // local procedure es_c13_OnBeforeUpdateAndDeleteLines(var GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean)
    // begin
    //     // Mod. S2G (JMP) 16/04/16 GF008
    //     rICTransactionLine.RESET();
    //     rICTransactionLine.SETRANGE("Table ID", DATABASE::"Gen. Journal Line");
    //     rICTransactionLine.SETRANGE("Source Doc. No.", GenJournalLine."Journal Template Name");
    //     rICTransactionLine.SETRANGE("Source Doc. Subtype", GenJournalLine."Journal Batch Name");
    //     IF GenJournalLine.GETFILTER("Line No.") <> '' THEN
    //         rICTransactionLine.SETFILTER("Source Doc. Line No.", GenJournalLine.GETFILTER("Line No."));
    //     rICTransactionLine.SETRANGE("Source Company Name", COMPANYNAME);
    //     IF NOT rICTransactionLine.ISEMPTY THEN
    //         rICTransactionLine.DELETEALL();
    //     // Mod. S2G (JMP) 16/04/16 GF008
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Update Analysis View", OnGetEntriesForUpdate, '', false, false)]
    local procedure es_c410_OnGetEntriesForUpdate(var AnalysisView: Record "Analysis View"; var UpdAnalysisViewEntryBuffer: Record "Upd Analysis View Entry Buffer")
    begin
        //Mod. S2G (CPA) <ANA001> Reparto anal�tico.BEGIN
        IF AnalysisView."Account Source" = AnalysisView."Account Source"::"Analytic Distribution Account" THEN
            EYSingleInstance410.UpdateEntriesForDistribccount(AnalysisView);
        //Mod. S2G (CPA) <ANA001> Reparto anal�tico.END
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Update Analysis View", OnUpdateEntriesForGLAccountDetailedOnAfterGLEntrySetFilters, '', false, false)]
    local procedure es_c410_OnUpdateEntriesForGLAccountDetailedOnAfterGLEntrySetFilters(var GLEntry: Record "G/L Entry"; var AnalysisView: Record "Analysis View")
    begin
        // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n. begin
        IF AnalysisView."Source Code Filter" <> '' THEN
            GLEntry.SETFILTER("Source Code", AnalysisView."Source Code Filter");
        // (FCO) S2G (CSM) 07/04/2020 : end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnAfterReleaseATOs, '', false, false)]
    local procedure es_c414_OnAfterReleaseATOs(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; PreviewMode: Boolean)
    begin
        // >> IRPF
        CuGestionIRPF.CalcularIRPFVtas(SalesHeader);//Mod S2G SGP
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnReopenOnBeforeSalesHeaderModify, '', false, false)]
    local procedure es_c414_OnReopenOnBeforeSalesHeaderModify(var SalesHeader: Record "Sales Header")
    begin
        //>>IRPF
        CuGestionIRPF.EliminarCalculoIRPFVtas(SalesHeader);
        //<<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", OnCodeOnBeforeModifyHeader, '', false, false)]
    local procedure es_c415_OnCodeOnBeforeModifyHeader(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; PreviewMode: Boolean; var LinesWereModified: Boolean; var NotOnlyDropShipment: Boolean)
    begin
        // >> IRPF - si se trata de una oferta o de un pedido no se calcula IRPF
        //IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Credit Memo"] THEN//comentado SGP 08/09/17
        IF PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo", PurchaseHeader."Document Type"::"Return Order"] THEN//MOD. S2G (SGP) 08/09/17 a�adido tipo documento devolucion
            CuGestionIRPF.CalcularIRPF(PurchaseHeader);
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", OnReopenOnBeforePurchaseHeaderModify, '', false, false)]
    local procedure es_c415_OnReopenOnBeforePurchaseHeaderModify(var PurchaseHeader: Record "Purchase Header")
    begin
        // >> IRPF
        //IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Credit Memo"] THEN //Mod. SGP
        IF PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo", PurchaseHeader."Document Type"::"Return Order"] THEN//MOD. S2G (SGP) 08/09/17 a�adido tipo documento devolucion
            CuGestionIRPF.EliminarCalculoIRPF(PurchaseHeader);
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnCopyPurchDocPurchLineOnAfterSetFilters, '', false, false)]
    local procedure es_c6620_OnCopyPurchDocPurchLineOnAfterSetFilters(FromPurchHeader: Record "Purchase Header"; var FromPurchLine: Record "Purchase Line"; var ToPurchHeader: Record "Purchase Header"; var RecalculateLines: Boolean)
    begin
        // >> IRPF - No copia las lineas de IRPF
        FromPurchLine.SETRANGE("Línea IRPF", FALSE);
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnCopyPurchDocRcptLineOnAfterSetFilters, '', false, false)]
    local procedure es_c6620_OnCopyPurchDocRcptLineOnAfterSetFilters(var ToPurchHeader: Record "Purchase Header"; var FromPurchRcptHeader: Record "Purch. Rcpt. Header"; var FromPurchRcptLine: Record "Purch. Rcpt. Line"; var RecalculateLines: Boolean)
    begin
        // >> IRPF - No copia las lineas de IRPF
        FromPurchRcptLine.SETRANGE("Línea IRPF", FALSE);
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnCopyPurchDocInvLineOnAfterSetFilters, '', false, false)]
    local procedure es_c6620_OnCopyPurchDocInvLineOnAfterSetFilters(var ToPurchHeader: Record "Purchase Header"; var FromPurchInvLine: Record "Purch. Inv. Line"; var LinesNotCopied: Integer; var MissingExCostRevLink: Boolean; RecalculateLines: Boolean)
    begin
        // >> IRPF - No copia las lineas de IRPF
        FromPurchInvLine.SETRANGE("Línea IRPF", FALSE);
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnCopyPurchDocCrMemoLineOnAfterSetFilters, '', false, false)]
    local procedure es_c6620_OnCopyPurchDocCrMemoLineOnAfterSetFilters(var ToPurchHeader: Record "Purchase Header"; var FromPurchCrMemoLine: Record "Purch. Cr. Memo Line"; var LinesNotCopied: Integer; var MissingExCostRevLink: Boolean; RecalculateLines: Boolean)
    begin
        // >> IRPF - No copia las lineas de IRPF
        FromPurchCrMemoLine.SETRANGE("Línea IRPF", FALSE);
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::AccSchedManagement, OnCalcCellValueOnElseTotalingType, '', false, false)]
    local procedure es_c8_OnCalcCellValueOnElseTotalingType(AccSchedLine: Record "Acc. Schedule Line"; AccountScheduleLine: Record "Acc. Schedule Line"; var ColumnLayout: Record "Column Layout"; var Result: Decimal)
    var
        DistrAcc: Record "Schedule of Distrib. Accounts";
    begin
        //M�d. S2G (ABC) ANA001 11-10-17 Tener en cuenta nuevo tipo del campo "Totaling type" begin

        IF AccSchedLine."Totaling Type" IN
          [AccSchedLine."Totaling Type"::"Distribution Entry"]
        THEN BEGIN
            AccSchedLine.COPYFILTERS(AccountScheduleLine);
            EYFunctions.SetDistrAccRowFilters(DistrAcc, AccSchedLine);
            EYFunctions.SetDistrAccColumnFilters(DistrAcc, AccSchedLine, ColumnLayout);
            //IF (AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Cost Type")//OLD CPA

            IF (AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Distribution Entry") AND
               (STRLEN(AccSchedLine.Totaling) <= MAXSTRLEN(DistrAcc.Totaling)) AND (STRPOS(AccSchedLine.Totaling, '*') = 0)
            THEN BEGIN
                DistrAcc.Type := DistrAcc.Type::Total;
                DistrAcc.Totaling := AccSchedLine.Totaling;
                Result := Result + EYFunctions.CalcDistributionAcc(DistrAcc, AccSchedLine, ColumnLayout);
            END ELSE
                IF DistrAcc.FIND('-') THEN
                    REPEAT
                        Result := Result + EYFunctions.CalcDistributionAcc(DistrAcc, AccSchedLine, ColumnLayout);
                    UNTIL DistrAcc.NEXT() = 0;
        END;
        //M�d. S2G (ABC) ANA001 11-10-17 Tener en cuenta nuevo tipo del campo "Totaling type" End
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::AccSchedManagement, OnAfterSetGLAccGLEntryFilters, '', false, false)]
    local procedure es_c8_OnAfterSetGLAccGLEntryFilters(var GLAccount: Record "G/L Account"; var GLEntry: Record "G/L Entry"; var AccSchedLine: Record "Acc. Schedule Line"; var ColumnLayout: Record "Column Layout"; UseBusUnitFilter: Boolean; UseDimFilter: Boolean)
    begin
        // (Filtro-Cod-Origen) S2G (CSM) 07/04/2020 : begin
        //GLAcc.COPYFILTER("Source Code Filter", AccSchedLine."Source Code Filter");
        GLAccount."Source Code Filter" := AccSchedLine.GETFILTER("Source Code Filter");
        IF AccSchedLine.GETFILTER("Source Code Filter") <> '' THEN
            GLEntry.SETFILTER("Source Code", AccSchedLine.GETFILTER("Source Code Filter"));
        AccSchedLine.COPYFILTER("Source Code Filter", GLEntry."Source Code");
        // (FCO) S2G (CSM) 07/04/2020 : end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::AccSchedManagement, OnDrillDownTotalingTypeElseCase, '', false, false)]
    local procedure es_c8_OnDrillDownTotalingTypeElseCase(var TempColumnLayout: Record "Column Layout" temporary; var AccSchedLine: Record "Acc. Schedule Line")
    begin
        //Mod. S2G (CPA) 22/11/2017 <ANA001> Plan de cuentas de reparto.Begin
        IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Distribution Entry" THEN
            EYFunctions.DrillDownOnDistributionAccount(TempColumnLayout, AccSchedLine)
        //Mod. S2G (CPA) 22/11/2017 <ANA001> Plan de cuentas de reparto.End
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::AccSchedManagement, OnDrillDownOnGLAccountOnBeforeCopyFiltersEmptyAnalysisViewName, '', false, false)]
    local procedure es_c8_OnDrillDownOnGLAccountOnBeforeCopyFiltersEmptyAnalysisViewName(var AccScheduleLine: Record "Acc. Schedule Line"; var TempColumnLayout: Record "Column Layout"; var GLAcc: Record "G/L Account")
    begin
        // (FCO) S2G (CSM) 07/04/2020 : begin
        AccScheduleLine.COPYFILTER("Source Code Filter", GLAcc."Source Code Filter");
        // (FCO) S2G (CSM) 07/04/2020 : end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::AccSchedManagement, OnDrillDownOnGLAccountOnBeforeCopyFiltersWithAnalysisView, '', false, false)]
    local procedure es_c8_OnDrillDownOnGLAccountOnBeforeCopyFiltersWithAnalysisView(var AccScheduleLine: Record "Acc. Schedule Line"; var TempColumnLayout: Record "Column Layout"; var GLAcc: Record "G/L Account"; var GLAccAnalysisView: Record "G/L Account (Analysis View)")
    begin
        // (FCO) S2G (CSM) 07/04/2020 : begin
        AccScheduleLine.COPYFILTER("Source Code Filter", GLAcc."Source Code Filter");
        // (FCO) S2G (CSM) 07/04/2020 : end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]
    local procedure es_c80_OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean; var CalledBy: Integer)
    var
        rBudgetControl: Record "Budget Control Setup";
        rSalesLine: Record "Sales Line";
        vError: Text;
    begin
        // >> IRPF
        IF (SalesHeader."Control IRPF" <> SalesHeader."Control IRPF"::" ") AND (SalesHeader.Status = SalesHeader.Status::Open) THEN
            SalesHeader.FIELDERROR(Status);
        // <<

        //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Inicio
        rSalesLine.RESET();
        rSalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        rSalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF rSalesLine.FINDFIRST() THEN
            REPEAT
                vError := '';
                IF NOT rBudgetControl.fCheckBudget_Sales(SalesHeader, rSalesLine, vError) THEN
                    ERROR(vError);
            UNTIL rSalesLine.NEXT() = 0;
        //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Fin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePostPurchaseDoc, '', false, false)]
    local procedure es_c90_OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean)
    var
        rBudgetControl: Record "Budget Control Setup";
        rPurchLine: Record "Purchase Line";
        vError: Text;
    begin
        // >> IRPF
        IF (PurchaseHeader."Control IRPF" <> PurchaseHeader."Control IRPF"::" ") AND (PurchaseHeader.Status = PurchaseHeader.Status::Open) THEN
            PurchaseHeader.FIELDERROR(Status);
        // <<

        //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Inicio

        rPurchLine.RESET();
        rPurchLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        rPurchLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF rPurchLine.FINDFIRST() THEN
            REPEAT
                vError := '';
                IF NOT rBudgetControl.fCheckBudget_Purchase(PurchaseHeader, rPurchLine, vError) THEN
                    ERROR(vError);
            UNTIL rPurchLine.NEXT() = 0;
        //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Fin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnRunOnAfterCalcVATAmountLines, '', false, false)]
    local procedure es_c90_OnRunOnAfterCalcVATAmountLines(var PurchaseHeader: Record "Purchase Header"; var TempPurchLineGlobal: Record "Purchase Line" temporary)
    begin
        // >> IRPF - No se tiene en cuenta las Líneas IRPF. Se volver�n a generar
        //TempPurchLineGlobal.SETRANGE("Línea IRPF", FALSE);
        // <<
    end;

    //Se cambia el valor del campo para que cumpla los requerimientos de NAV y se reestablece su valor en OnAfterPostItemTrackingLine
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnPostPurchLineOnBeforeRoundAmount, '', false, false)]
    local procedure es_c90_OnPostPurchLineOnBeforeRoundAmount(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr."; SrcCode: Code[10])
    begin
        // >> IRPF - No tiene en cuenta las Líneas de IRPF
        //IF PurchLine."Prepayment Line" THEN//original NAV 2017
        IF (PurchaseLine."Prepayment Line") AND (not PurchaseLine."Línea IRPF") then// [THEN] Then
            PurchaseLine."Prepayment Line" := false;
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterPostItemTrackingLine, '', false, false)]
    local procedure es_c90_OnAfterPostItemTrackingLine(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; WhseReceive: Boolean; WhseShip: Boolean; InvtPickPutaway: Boolean)
    begin
        PurchaseLine."Prepayment Line" := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnUpdatePurchLineBeforePostOnAfterCalcInitQtyToInvoiceNeeded, '', false, false)]
    local procedure es_c90_OnUpdatePurchLineBeforePostOnAfterCalcInitQtyToInvoiceNeeded(var PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var InitQtyToInvoiceNeeded: Boolean)
    begin
        // >> IRPF - No se tiene en cuenta las Líneas de IRPF
        //IF ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice) THEN//original NAV 2017
        InitQtyToInvoiceNeeded := (ABS(PurchLine."Qty. to Invoice") > ABS(PurchLine.MaxQtyToInvoice())) AND NOT (PurchLine."Línea IRPF")
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforeDeleteAfterPosting, '', false, false)]
    local procedure es_c90_OnBeforeDeleteAfterPosting(var PurchaseHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var SkipDelete: Boolean; CommitIsSupressed: Boolean; var TempPurchLine: Record "Purchase Line" temporary; var TempPurchLineGlobal: Record "Purchase Line" temporary; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        recLinCompra: Record "Purchase Line";
    begin
        // >> IRPF : Eliminaci�n del la Línea generada de IRPF automaticamente.
        recLinCompra := TempPurchLineGlobal;
        recLinCompra.SETRANGE("Línea IRPF", TRUE);
        recLinCompra.DELETE();
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterPurchInvHeaderInsert, '', false, false)]
    local procedure es_c90_OnAfterPurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        // >> IRPF
        CuGestionIRPF.ActualizarRegistroIRPF(PurchHeader, PurchInvHeader."No.", PurchInvHeader."Vendor Invoice No.");
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterPurchCrMemoHeaderInsert, '', false, false)]
    local procedure es_c90_OnAfterPurchCrMemoHeaderInsert(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; PreviewMode: Boolean)
    begin
        // >> IRPF
        CuGestionIRPF.ActualizarRegistroIRPF(PurchHeader, PurchCrMemoHdr."No.", PurchCrMemoHdr."Vendor Cr. Memo No.");
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesInvHeaderInsert, '', false, false)]
    local procedure es_c80_OnAfterSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header"; PreviewMode: Boolean)
    begin
        CuGestionIRPF.ActualizarRegistroIRPFVtas(SalesHeader, SalesInvHeader."No.", SalesInvHeader."External Document No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesCrMemoHeaderInsert, '', false, false)]
    local procedure es_c80_OnAfterSalesCrMemoHeaderInsert(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header")
    begin
        CuGestionIRPF.ActualizarRegistroIRPFVtas(SalesHeader, SalesCrMemoHeader."No.", SalesCrMemoHeader."External Document No.");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterValidatePostingAndDocumentDate, '', false, false)]
    local procedure es_c90_OnAfterValidatePostingAndDocumentDate(var PurchaseHeader: Record "Purchase Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        rlvendor: Record Vendor;
        tErrorLbl: Text;
        EL001Lbl: Label 'Ha caducado el porcentaje de retencion para el proveedor %1, cambie el grupo registro IRPF y modifique el código en el documento';
    begin
        //Mod. S2G 06/03/2017 (AAS) : GF-011 Cambio de porcentaje de retenci�n a proveedores de nueva creaci�n.inicio
        rlvendor.RESET();
        rlvendor.GET(PurchaseHeader."Buy-from Vendor No.");
        IF rlvendor."Due Date First IRPF" <> 0D THEN  //s2g SGP
            IF (rlvendor."Due Date First IRPF" < PurchaseHeader."Posting Date") AND (PurchaseHeader."Grupo registro IRPF" <> '') THEN begin
                tErrorLbl := STRSUBSTNO(EL001Lbl, rlvendor."No.");
                ERROR(tErrorLbl);
            end;
        //s2g SGP

        //Mod. S2G 06/03/2017 (AAS) : GF-011 Cambio de porcentaje de retenci�n a proveedores de nueva creaci�n.fin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Purch. Order to Order", OnBeforeRun, '', false, false)]
    local procedure es_c97_OnBeforeRun(var PurchaseHeader: Record "Purchase Header"; var SkipCommit: Boolean)
    begin
        // >> IRPF
        IF (PurchaseHeader."Control IRPF" <> PurchaseHeader."Control IRPF"::" ") AND (PurchaseHeader.Status = PurchaseHeader.Status::Open) THEN
            PurchaseHeader.FIELDERROR(Status);
        // <<
    end;

    [EventSubscriber(ObjectType::Page, Page::Companies, OnBeforeDeleteRecord, '', false, false)]
    local procedure es_p357_OnBeforeDeleteRecord(var Company: Record Company)
    var
        rlCompanyOFM: Record "Company OFM";
    begin
        if rlCompanyOFM.Get(Company.Name) then
            rlCompanyOFM.Delete();
    end;

    var
        cuGestionIRPF: Codeunit "Gestión IRPF";
        // rICTransactionLine: Record "Intercompany Transaction Line";
        // cIntercompanyPostingMgt: Codeunit "Intercompany Posting Mgt.";
        EYFunctions: Codeunit "EY Functions";
        EYSingleInstance410: Codeunit "EY Single Instance c410";
}
