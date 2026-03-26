codeunit 50003 "EY Single Instance"
{
    SingleInstance = true;

    //CheckAndUpdate
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostCommitPurchaseDoc', '', false, false)]
    local procedure es_c90_OnBeforePostCommitPurchaseDoc(var PurchaseHeader: Record "Purchase Header";
                                                         var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; var ModifyHeader: Boolean;
                                                         var CommitIsSupressed: Boolean; var TempPurchLineGlobal: Record "Purchase Line" temporary)
    begin
        // >> IRPF - Creo las líneas de IRPF
        CuGestionIRPF.CrearLinIRPFReg(PurchaseHeader, TempIRPFRecPurchLine);
        // <<
    end;

    //GetNextPurchline
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnRunOnAfterInvoiceRounding', '', false, false)]
    local procedure es_c90_OnRunOnAfterInvoiceRounding(var PurchHeader: Record "Purchase Header"; var TempPurchLineGlobal: Record "Purchase Line" temporary)
    begin
        // >> IRPF
        // Se crean las líneas de IRPF de manera similar a como se crean las líneas de prepago estándar.
        IF TempIRPFRecPurchLine.FIND('-') THEN BEGIN
            TempPurchLineGlobal := TempIRPFRecPurchLine;
            TempIRPFRecPurchLine.DELETE();
            //     EXIT(FALSE);
        END;
        // <<
    end;

    //Se rellenan las variables en OnAfterProcessPurchLines para que aquí tengan valor
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePostInvoice, '', false, false)]
    local procedure es_c90_OnBeforePostInvoice(var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var IsHandled: Boolean; var Window: Dialog; HideProgressWindow: Boolean; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; var InvoicePostingInterface: Interface "Invoice Posting"; var InvoicePostingParameters: Record "Invoice Posting Parameters"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; GenJnlLineDocType: Enum "Gen. Journal Document Type"; SrcCode: Code[10])
    var
        rlMovRetencion: Record "Movs. retenciones";
    begin
        // Mod. S2G 19/10/2016 (CSM) : GF-010 Retenciones. IRPF. - begin
        IF TotalPurchLine."Línea IRPF" THEN BEGIN
            rlMovRetencion.RESET();
            rlMovRetencion.SETRANGE(rlMovRetencion.Tipo, rlMovRetencion.Tipo::Compra);

            IF ((TotalPurchLine."Document Type" = TotalPurchLine."Document Type"::Invoice) OR
                (TotalPurchLine."Document Type" = TotalPurchLine."Document Type"::Order))
            THEN BEGIN
                rlMovRetencion.SETRANGE(rlMovRetencion."Tipo documento", rlMovRetencion."Tipo documento"::"Fact. Registrada");
                rlMovRetencion.SETRANGE(rlMovRetencion."Nº documento", rPurchInvHeader."No.");
                rlMovRetencion.SETRANGE(rlMovRetencion."Nº linea IRPF", TotalPurchLine."Line No.");
            END;

            IF (TotalPurchLine."Document Type" = TotalPurchLine."Document Type"::"Credit Memo") THEN BEGIN
                rlMovRetencion.SETRANGE(rlMovRetencion."Tipo documento", rlMovRetencion."Tipo documento"::"Abono Registrado");
                rlMovRetencion.SETRANGE(rlMovRetencion."Nº documento", rPurchCrMemoHeader."No.");
                rlMovRetencion.SETRANGE(rlMovRetencion."Nº linea IRPF", TotalPurchLine."Line No.");
            END;

            IF rlMovRetencion.FINDLAST() THEN
                InvoicePostingParameters."Retention Entry No." := rlMovRetencion."Nº mov.";
        END;
        // Mod. S2G 19/10/2016 (CSM) : GF-010 Retenciones. IRPF. - end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterProcessPurchLines, '', false, false)]
    local procedure es_c90_OnAfterProcessPurchLines(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShipmentHeader: Record "Return Shipment Header"; WhseShip: Boolean; WhseReceive: Boolean; var PurchLinesProcessed: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean)
    begin
        rPurchInvHeader := PurchInvHeader;
        rPurchCrMemoHeader := PurchCrMemoHdr;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCommitSalesDoc', '', false, false)]
    local procedure es_c80_OnBeforePostCommitSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; var ModifyHeader: Boolean; var CommitIsSuppressed: Boolean; var TempSalesLineGlobal: Record "Sales Line" temporary)
    begin
        CuGestionIRPF.CrearLinIRPFRegVtas(SalesHeader, TempIRPFRecSalesLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesLines', '', false, false)]
    local procedure es_c80_OnBeforePostSalesLines(var SalesHeader: Record "Sales Header"; var TempSalesLineGlobal: Record "Sales Line" temporary; var TempVATAmountLine: Record "VAT Amount Line" temporary; var EverythingInvoiced: Boolean)
    begin
        if TempIRPFRecSalesLine.FindSet() then
            repeat
                TempSalesLineGlobal := TempIRPFRecSalesLine;
                TempSalesLineGlobal.Insert();
            until TempIRPFRecSalesLine.Next() = 0;

        TempIRPFRecSalesLine.DeleteAll();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure es_c80_OnBeforeDeleteAfterPosting(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SkipDelete: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean; var TempSalesLineGlobal: Record "Sales Line" temporary)
    var
        recLinVenta: Record "Sales Line";
    begin
        recLinVenta := TempSalesLineGlobal;
        recLinVenta.SetRange("IRPF Line", true);
        recLinVenta.DeleteAll();
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterNavigateFindRecords, '', false, false)]
    local procedure es_p344_OnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; var NewSourceRecVar: Variant; ExtDocNo: Code[250]; HideDialog: Boolean)
    var
        DocType: Enum "Document Entry Document Type";
    begin
        // >> IRPF
        IF RecMovIRPF.READPERMISSION THEN BEGIN
            RecMovIRPF.RESET();
            RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
            RecMovIRPF.SETFILTER("Nº documento", DocNoFilter);
            RecMovIRPF.SETFILTER("Fecha registro", PostingDateFilter);
            DocumentEntry.InsertIntoDocEntry(
              DATABASE::"Movs. retenciones", DocType::Quote, RecMovIRPF.TABLECAPTION, RecMovIRPF.COUNT);
        END;
        // <<
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterShowRecords, '', false, false)]
    local procedure es_p344_OnAfterShowRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; ContactType: Enum "Navigate Contact Type"; ContactNo: Code[250]; ExtDocNo: Code[250])
    begin
        // >> IRPF
        if DocumentEntry."Table ID" = DATABASE::"Movs. retenciones" then
            PAGE.RUN(0, RecMovIRPF);
        // <<
    end;

    var
        rPurchInvHeader: Record "Purch. Inv. Header";
        rPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        TempIRPFRecPurchLine: Record "Purchase Line" temporary;
        TempIRPFRecSalesLine: Record "Sales Line" temporary;
        RecMovIRPF: Record "Movs. retenciones";
        cuGestionIRPF: Codeunit "Gestión IRPF";
}
