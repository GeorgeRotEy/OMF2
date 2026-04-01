codeunit 50008 "Gestión IRPF"
{
    // S2G SGP GF-010 -- 13/03/2017
    //   -Creada funcion CalcularIRPFJnlLine(p_GenJnlLineTemplate : Code[10];p_GenJnlLineBatch : Code[10]) --> inserta mov IRPF desde un diario

    Permissions = TableData "VAT Entry" = rm;

    var
        Text60100: Label '¿Desea aplicar los cambios a las líneas del documento?';
        Text60101: Label 'Especifique el Grupo Registro IRPF en las líneas del documento.';
        Text60110: Label 'No puede insertar un diferencia de IRPF que exceda de %1 %2.';

    procedure ActualizarIRPFLinCompra(pDocType: Option Oferta,Pedido,Factura,Abono,"Pedido abierto","Devolución"; pNumDoc: Code[20]; pCodRegIRPF: Code[10])
    var
        RecLinCompra: Record "Purchase Line";
    begin
        RecLinCompra.RESET();
        RecLinCompra.SETRANGE("Document Type", pDocType);
        RecLinCompra.SETRANGE("Document No.", pNumDoc);
        RecLinCompra.SETRANGE("Línea IRPF", FALSE);
        IF NOT (RecLinCompra.ISEMPTY) THEN
            IF (pCodRegIRPF <> '') THEN BEGIN
                IF CONFIRM(Text60100, TRUE) THEN
                    RecLinCompra.MODIFYALL("Grupo registro IRPF", pCodRegIRPF);
            END ELSE
                RecLinCompra.MODIFYALL("Grupo registro IRPF", pCodRegIRPF);
    end;

    procedure CalcularIRPF(var pRecCabCompra: Record "Purchase Header")
    var
        RecLinCompra: Record "Purchase Line";
        RecMovIRPF: Record "Movs. retenciones";
        RecGrupoIRPF: Record "Grupo registro retención";
        RecLinCompraAux: Record "Purchase Line";
        Currency: Record Currency;
        NumLinea: Integer;
        NumMov: Integer;
        LinOrigen: Integer;
        LinSiguiente: Integer;
    begin
        //Función que calculará e insertará la línea del IRPF en la factura y creará su respectivo Mov. IRPF.
        RecLinCompra.RESET();
        RecLinCompra.SETCURRENTKEY("Document Type", "Document No.", "Línea IRPF", "Grupo registro IRPF");
        RecLinCompra.SETRANGE("Document Type", pRecCabCompra."Document Type");
        RecLinCompra.SETRANGE("Document No.", pRecCabCompra."No.");
        RecLinCompra.SETRANGE("Línea IRPF", FALSE);
        RecLinCompra.FILTERGROUP(2);
        RecLinCompra.SETFILTER("Grupo registro IRPF", '<>%1', '');
        RecLinCompra.FILTERGROUP(0);
        IF RecLinCompra.FIND('-') THEN
            REPEAT
                // CSM. 02.marzo.2017. : se comenta a petición de NETCO.
                //RecLinCompra.SETRANGE("Grupo registro IRPF", RecLinCompra."Grupo registro IRPF");

                RecGrupoIRPF.GET(RecLinCompra."Grupo registro IRPF");
                RecGrupoIRPF.TESTFIELD("% retención");
                RecGrupoIRPF.TESTFIELD("Cuenta compras");
                RecGrupoIRPF.TESTFIELD("Tipo retención");

                RecMovIRPF.RESET();
                IF (RecMovIRPF.FINDLAST) THEN
                    NumMov := RecMovIRPF."Nº mov." + 1
                ELSE
                    NumMov := 1;

                RecMovIRPF.INIT();
                RecMovIRPF."Nº mov." := NumMov;
                RecMovIRPF."Fecha registro" := pRecCabCompra."Posting Date";
                RecMovIRPF."Grupo registro retención" := RecLinCompra."Grupo registro IRPF";
                RecMovIRPF."% retención" := RecGrupoIRPF."% retención";
                RecMovIRPF."Tipo retención" := RecGrupoIRPF."Tipo retención";
                RecMovIRPF.Tipo := RecMovIRPF.Tipo::Compra;
                RecMovIRPF."Cuenta retención" := RecGrupoIRPF."Cuenta compras"; // 21.11.2016

                RecMovIRPF."Tipo documento" := pRecCabCompra."Document Type";
                RecMovIRPF."Nº documento" := pRecCabCompra."No.";
                RecMovIRPF."Tipo documento original" := pRecCabCompra."Document Type";
                RecMovIRPF."Nº documento original" := pRecCabCompra."No.";

                // CSM. 02.marzo.2017. : se comenta a petición de NETCO.
                //RecLinCompra.CALCSUMS("VAT Base Amount");

                CASE RecMovIRPF."Tipo documento" OF
                    RecMovIRPF."Tipo documento"::Oferta, RecMovIRPF."Tipo documento"::Pedido,
                    RecMovIRPF."Tipo documento"::Factura, RecMovIRPF."Tipo documento"::"Fact. Registrada":

                        RecMovIRPF.Base := RecLinCompra."VAT Base Amount" * (RecLinCompra."Qty. to Invoice" / RecLinCompra.Quantity);
                    RecMovIRPF."Tipo documento"::Abono, RecMovIRPF."Tipo documento"::Devolución,
                    RecMovIRPF."Tipo documento"::"Abono Registrado":

                        RecMovIRPF.Base := (-1) * RecLinCompra."VAT Base Amount" * (RecLinCompra."Qty. to Invoice" / RecLinCompra.Quantity);
                END;

                // >> Se ajusta la precisión de los decimales
                //RecMovIRPF.Importe := RecMovIRPF.Base * (RecGrupoIRPF."% IRPF" / 100);
                //RecMovIRPF."Importe Calculado" := RecMovIRPF.Base * (RecGrupoIRPF."% IRPF" / 100);
                IF pRecCabCompra."Currency Code" = '' THEN
                    Currency.InitRoundingPrecision
                ELSE BEGIN
                    Currency.GET(pRecCabCompra."Currency Code");
                    Currency.TESTFIELD("Amount Rounding Precision");
                END;
                RecMovIRPF.Importe := ROUND(RecMovIRPF.Base * (RecGrupoIRPF."% retención" / 100), Currency."Amount Rounding Precision");
                RecMovIRPF."Importe calculado" := RecMovIRPF.Importe;
                // <<

                RecMovIRPF."Cod. origen" := pRecCabCompra."Buy-from Vendor No.";
                RecMovIRPF."Id. usuario" := USERID();
                RecMovIRPF."CIF/NIF" := pRecCabCompra."VAT Registration No.";
                IF (RecMovIRPF.Importe <> 0) THEN BEGIN
                    RecMovIRPF.INSERT();

                    RecLinCompraAux.RESET();
                    RecLinCompraAux.SETRANGE("Document Type", pRecCabCompra."Document Type");
                    RecLinCompraAux.SETRANGE("Document No.", pRecCabCompra."No.");
                    // CSM. 02.marzo.2017. : se modifica a petición de NETCO. begin
                    /*
                    // CSM. 02.marzo.2017. : se modifica a petición de NETCO. end
                    IF (RecLinCompraAux.FINDLAST) THEN
                      NumLinea:= RecLinCompraAux."Line No." + 10000
                    ELSE
                      NumLinea:= 10000;
                    // CSM. 02.marzo.2017. : se modifica a petición de NETCO. begin
                    */
                    LinOrigen := RecLinCompra."Line No.";
                    RecLinCompraAux.SETRANGE("Line No.", RecLinCompra."Line No." + 1);
                    IF RecLinCompraAux.FINDFIRST() THEN
                        LinSiguiente := RecLinCompraAux."Line No."
                    ELSE
                        LinSiguiente := LinOrigen + 10000;
                    NumLinea := (LinOrigen + LinSiguiente) / 2;
                    // CSM. 02.marzo.2017. : se modifica a petición de NETCO. end

                    RecLinCompraAux.INIT();
                    RecLinCompraAux.VALIDATE("Document Type", pRecCabCompra."Document Type");
                    RecLinCompraAux.VALIDATE("Document No.", pRecCabCompra."No.");
                    RecLinCompraAux.VALIDATE("Line No.", NumLinea);
                    RecLinCompraAux.VALIDATE("System-Created Entry", TRUE);
                    RecLinCompraAux.VALIDATE("Buy-from Vendor No.", pRecCabCompra."Buy-from Vendor No.");
                    RecLinCompraAux.VALIDATE(Type, RecLinCompraAux.Type::"G/L Account");
                    RecLinCompraAux.VALIDATE("No.", RecGrupoIRPF."Cuenta compras");
                    //      RecLinCompraAux.VALIDATE(Description, RecGrupoIRPF.Descripción);
                    RecLinCompraAux.VALIDATE(Quantity, -1);

                    //RecLinCompraAux.VALIDATE("Direct Unit Cost", RecMovIRPF.Importe);
                    CASE RecMovIRPF."Tipo documento" OF
                        RecMovIRPF."Tipo documento"::Oferta, RecMovIRPF."Tipo documento"::Pedido,
                        RecMovIRPF."Tipo documento"::Factura, RecMovIRPF."Tipo documento"::"Fact. Registrada":

                            RecLinCompraAux.VALIDATE("Direct Unit Cost", RecMovIRPF.Importe);
                        RecMovIRPF."Tipo documento"::Abono, RecMovIRPF."Tipo documento"::Devolución,
                        RecMovIRPF."Tipo documento"::"Abono Registrado":

                            RecLinCompraAux.VALIDATE("Direct Unit Cost", -RecMovIRPF.Importe);
                    END;

                    //GR-mdf-28/01/27 RecLinCompraAux.VALIDATE("Qty. to Receive", 0);
                    //RecLinCompraAux.VALIDATE("Qty. to Invoice", 0);
                    RecLinCompraAux.VALIDATE("Línea IRPF", TRUE);
                    //Importante hacerlo al final para que se pueda insertar la línea correctamente.
                    RecLinCompraAux.INSERT(TRUE);

                    RecMovIRPF."Nº linea retención original" := RecLinCompraAux."Line No.";
                    RecMovIRPF."Nº linea IRPF" := RecLinCompraAux."Line No.";
                    RecMovIRPF.MODIFY();
                END;

            // CSM. 02.marzo.2017. : se comenta a petición de NETCO. begin
            /*
            // CSM. 02.marzo.2017. : se comenta a petición de NETCO. end
            RecLinCompra.FIND('+');
            RecLinCompra.SETRANGE("Grupo registro IRPF");
            // CSM. 02.marzo.2017. : se comenta a petición de NETCO. begin
            */
            // CSM. 02.marzo.2017. : se comenta a petición de NETCO. end
            UNTIL (RecLinCompra.NEXT() = 0)
        ELSE
            IF (pRecCabCompra."Control IRPF" = pRecCabCompra."Control IRPF"::Obligatorio) THEN
                ERROR(Text60101);
    end;

    procedure EliminarCalculoIRPF(var pRecCabCompra: Record "Purchase Header")
    var
        RecLinCompra: Record "Purchase Line";
        RecMovIRPF: Record "Movs. retenciones";
    begin
        // Función que elimina la línea del IRPF en la factura y las de su respectivo Mov. IRPF.
        RecLinCompra.RESET();
        RecLinCompra.SETCURRENTKEY("Document Type", "Document No.", "Línea IRPF", "Grupo registro IRPF");
        RecLinCompra.SETRANGE("Document Type", pRecCabCompra."Document Type");
        RecLinCompra.SETRANGE("Document No.", pRecCabCompra."No.");
        RecLinCompra.SETRANGE("Línea IRPF", TRUE);
        IF RecLinCompra.FINDSET(TRUE) THEN
            REPEAT
                RecLinCompra."Línea IRPF" := FALSE; //Para poder borrarla
                RecLinCompra.DELETE(TRUE);
            UNTIL (RecLinCompra.NEXT() = 0);

        RecMovIRPF.RESET();
        RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
        RecMovIRPF.SETRANGE(Tipo, RecMovIRPF.Tipo::Compra);
        RecMovIRPF.SETRANGE("Tipo documento", pRecCabCompra."Document Type");
        RecMovIRPF.SETRANGE("Nº documento", pRecCabCompra."No.");
        RecMovIRPF.DELETEALL(TRUE);
    end;

    procedure ActualizarRegistroIRPF(var pRecCabCompra: Record "Purchase Header"; pNumDocReg: Code[20]; pNumDocExterno: Code[20])
    var
        RecMovIRPF: Record "Movs. retenciones";
    begin
        // Función que actualiza los datos de los movs. IRPF en el registro de un documento.
        RecMovIRPF.RESET();
        RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
        RecMovIRPF.SETRANGE(Tipo, RecMovIRPF.Tipo::Compra);
        RecMovIRPF.SETRANGE("Tipo documento", pRecCabCompra."Document Type");
        RecMovIRPF.SETRANGE("Nº documento", pRecCabCompra."No.");
        RecMovIRPF.MODIFYALL("Fecha registro", pRecCabCompra."Posting Date");
        RecMovIRPF.MODIFYALL("Nº documento externo", pNumDocExterno);
        //RecMovIRPF.MODIFYALL("Fecha Emision Documento", WORKDATE);
        RecMovIRPF.MODIFYALL("Fecha emision documento", pRecCabCompra."Document Date");
        IF (pRecCabCompra."Document Type" IN [pRecCabCompra."Document Type"::"Return Order", pRecCabCompra."Document Type"::"Credit Memo"])
        THEN BEGIN
            RecMovIRPF.MODIFYALL("Tipo documento", RecMovIRPF."Tipo documento"::"Abono Registrado");
            RecMovIRPF.SETRANGE("Tipo documento", RecMovIRPF."Tipo documento"::"Abono Registrado");
        END ELSE BEGIN
            RecMovIRPF.MODIFYALL("Tipo documento", RecMovIRPF."Tipo documento"::"Fact. Registrada");
            RecMovIRPF.SETRANGE("Tipo documento", RecMovIRPF."Tipo documento"::"Fact. Registrada");
        END;
        RecMovIRPF.MODIFYALL("Nº documento", pNumDocReg);
    end;

    procedure CrearLinIRPFReg(pRecCabCompra: Record "Purchase Header"; var pTempIRPFRecPurchLine: Record "Purchase Line")
    var
        RecLinCompra: Record "Purchase Line";
    begin
        // Función que crear las líneas de IRPF de una factura en una tabla temporal de manera similar a como
        // crea el estandar las líneas de los prepagos.
        RecLinCompra.SETRANGE("Document Type", pRecCabCompra."Document Type");
        RecLinCompra.SETRANGE("Document No.", pRecCabCompra."No.");
        RecLinCompra.SETRANGE("Línea IRPF", TRUE);
        IF (RecLinCompra.FINDFIRST) THEN
            REPEAT
                pTempIRPFRecPurchLine.INIT();
                pTempIRPFRecPurchLine."Document Type" := RecLinCompra."Document Type";
                pTempIRPFRecPurchLine."Document No." := RecLinCompra."Document No.";
                pTempIRPFRecPurchLine."Line No." := RecLinCompra."Line No.";
                pTempIRPFRecPurchLine."System-Created Entry" := TRUE;
                pTempIRPFRecPurchLine.VALIDATE(Type, pTempIRPFRecPurchLine.Type::"G/L Account");
                pTempIRPFRecPurchLine.VALIDATE("No.", RecLinCompra."No.");
                pTempIRPFRecPurchLine.VALIDATE(Quantity, -1);
                pTempIRPFRecPurchLine.VALIDATE("Direct Unit Cost", RecLinCompra."Direct Unit Cost");
                pTempIRPFRecPurchLine."Línea IRPF" := TRUE;
                // Mod. S2G 22/11/2016 (CSM) : AN-001 Gestión analítica. begin
                pTempIRPFRecPurchLine."Dimension Set ID" := RecLinCompra."Dimension Set ID";
                // Mod. S2G 22/11/2016 (CSM) : AN-001 Gestión analítica. end
                pTempIRPFRecPurchLine.INSERT();
            UNTIL (RecLinCompra.NEXT() = 0);
    end;

    procedure ActualizarImporteIRPF(var pRecLinCompra: Record "Purchase Line")
    var
        RecMovIRPF: Record "Movs. retenciones";
        RecCabCompra: Record "Purchase Header";
    begin
        // Función que actualiza los movimientos de IRPF después de la modificación del campo
        // "Direct Unit Cost" del documento en una línea de IRPF

        RecCabCompra.GET(pRecLinCompra."Document Type", pRecLinCompra."Document No.");
        RecMovIRPF.RESET();
        RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
        RecMovIRPF.SETRANGE(Tipo, RecMovIRPF.Tipo::Compra);
        RecMovIRPF.SETRANGE("Tipo documento", pRecLinCompra."Document Type");
        RecMovIRPF.SETRANGE("Nº documento", pRecLinCompra."Document No.");
        RecMovIRPF.SETRANGE("Nº linea IRPF", pRecLinCompra."Line No.");
        RecMovIRPF.FINDSET(TRUE);
        CheckDiferenciaIRPF(pRecLinCompra."Direct Unit Cost" - RecMovIRPF."Importe calculado", RecCabCompra."Currency Code");
        RecMovIRPF.Importe := pRecLinCompra."Direct Unit Cost";
        RecMovIRPF.MODIFY();
    end;

    procedure EstadisiticasIRPF(pRecCabCompra: Record "Purchase Header"; var pBase: Decimal; var pRetencion: Decimal)
    var
        RecMovIRPF: Record "Movs. retenciones";
    begin
        // Función que calcula el importe de la Base y la Retención de IRPF para el documento pasado por parámetro.
        RecMovIRPF.RESET();
        RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
        RecMovIRPF.SETRANGE(Tipo, RecMovIRPF.Tipo::Compra);
        RecMovIRPF.SETRANGE("Tipo documento", pRecCabCompra."Document Type");
        RecMovIRPF.SETRANGE("Nº documento", pRecCabCompra."No.");
        RecMovIRPF.CALCSUMS(Base, Importe);
        pBase := RecMovIRPF.Base;
        pRetencion := RecMovIRPF.Importe;
    end;

    procedure EstadisiticasFactCompraRegIRPF(pRecFactCompraReg: Record "Purch. Inv. Header"; var pBase: Decimal; var pRetencion: Decimal)
    var
        RecMovIRPF: Record "Movs. retenciones";
    begin
        // Función que calcula el importe de la Base y la Retención de IRPF para el documento pasado por parámetro.
        RecMovIRPF.RESET();
        RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
        RecMovIRPF.SETRANGE(Tipo, RecMovIRPF.Tipo::Compra);
        RecMovIRPF.SETRANGE("Tipo documento", RecMovIRPF."Tipo documento"::"Fact. Registrada");
        RecMovIRPF.SETRANGE("Nº documento", pRecFactCompraReg."No.");
        RecMovIRPF.CALCSUMS(Base, Importe);
        pBase := RecMovIRPF.Base;
        pRetencion := RecMovIRPF.Importe;
    end;

    procedure EstadisiticasAbCompraRegIRPF(pRecAbCompraReg: Record "Purch. Cr. Memo Hdr."; var pBase: Decimal; var pRetencion: Decimal)
    var
        RecMovIRPF: Record "Movs. retenciones";
    begin
        // Función que calcula el importe de la Base y la Retención de IRPF para el documento pasado por parámetro.
        RecMovIRPF.RESET();
        RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
        RecMovIRPF.SETRANGE(Tipo, RecMovIRPF.Tipo::Compra);
        RecMovIRPF.SETRANGE("Tipo documento", RecMovIRPF."Tipo documento"::"Abono Registrado");
        RecMovIRPF.SETRANGE("Nº documento", pRecAbCompraReg."No.");
        RecMovIRPF.CALCSUMS(Base, Importe);
        pBase := RecMovIRPF.Base;
        pRetencion := RecMovIRPF.Importe;
    end;

    procedure CheckDiferenciaIRPF(pDiferenciaIRPF: Decimal; pCodDivisa: Code[10])
    var
        RecConfigCompra: Record "Purchases & Payables Setup";
        RecDivisa: Record Currency;
    begin
        // Función que chequea la diferencia de IRPF insertada en el documento de compra de la misma manera que chequea el estandar
        // la diferencias de IVA (se utilizá la configuración de diferencia de IVA).

        RecConfigCompra.GET();

        IF (pCodDivisa = '') THEN
            RecDivisa.InitRoundingPrecision
        ELSE
            RecDivisa.GET(pCodDivisa);

        IF NOT (RecConfigCompra."Allow VAT Difference") THEN BEGIN
            IF (pDiferenciaIRPF <> 0) THEN
                ERROR(Text60110, 0);
        END ELSE
            IF ABS(pDiferenciaIRPF) > RecDivisa."Max. VAT Difference Allowed" THEN
                ERROR(Text60110, RecDivisa."Max. VAT Difference Allowed", pCodDivisa);
    end;

    procedure "-----------"()
    begin
    end;

    procedure ActualizarIRPFLinVenta(pDocType: Enum "Sales Document Type"; pNumDoc: Code[20]; pCodRegIRPF: Code[10])
    var
        RecLinVenta: Record "Sales Line";
    begin
        RecLinVenta.RESET();
        RecLinVenta.SETRANGE("Document Type", pDocType);
        RecLinVenta.SETRANGE("Document No.", pNumDoc);
        RecLinVenta.SETRANGE("IRPF Line", FALSE);
        IF NOT (RecLinVenta.ISEMPTY) THEN
            IF (pCodRegIRPF <> '') THEN BEGIN
                IF CONFIRM(Text60100, TRUE) THEN
                    RecLinVenta.MODIFYALL("IRPF Posting Group", pCodRegIRPF);
            END ELSE
                RecLinVenta.MODIFYALL("IRPF Posting Group", pCodRegIRPF);
    end;

    procedure CalcularIRPFVtas(var pRecCabVenta: Record "Sales Header")
    var
        RecLinVenta: Record "Sales Line";
        RecMovIRPF: Record "Movs. retenciones";
        RecGrupoIRPF: Record "Grupo registro retención";
        RecLinVentaAux: Record "Sales Line";
        Currency: Record Currency;
        NumLinea: Integer;
        NumMov: Integer;
    begin
        // Función que calculará e insertará la línea del IRPF en la factura y creará su respectivo Mov. IRPF.
        RecLinVenta.RESET();
        RecLinVenta.SETCURRENTKEY("Document Type", "Document No.", "IRPF Line", "IRPF Posting Group");
        RecLinVenta.SETRANGE("Document Type", pRecCabVenta."Document Type");
        RecLinVenta.SETRANGE("Document No.", pRecCabVenta."No.");
        RecLinVenta.SETRANGE("IRPF Line", FALSE);
        RecLinVenta.FILTERGROUP(2);
        RecLinVenta.SETFILTER("IRPF Posting Group", '<>%1', '');
        RecLinVenta.FILTERGROUP(0);
        IF RecLinVenta.FIND('-') THEN
            REPEAT
                RecLinVenta.SETRANGE("IRPF Posting Group", RecLinVenta."IRPF Posting Group");

                RecGrupoIRPF.GET(RecLinVenta."IRPF Posting Group");
                RecGrupoIRPF.TESTFIELD("% retención");
                RecGrupoIRPF.TESTFIELD("Cuenta ventas");
                RecGrupoIRPF.TESTFIELD("Tipo retención");

                RecMovIRPF.RESET();
                IF (RecMovIRPF.FINDLAST) THEN
                    NumMov := RecMovIRPF."Nº mov." + 1
                ELSE
                    NumMov := 1;

                RecMovIRPF.INIT();
                RecMovIRPF."Nº mov." := NumMov;
                RecMovIRPF."Fecha registro" := pRecCabVenta."Posting Date";
                RecMovIRPF."Grupo registro retención" := RecLinVenta."IRPF Posting Group";
                RecMovIRPF."% retención" := RecGrupoIRPF."% retención";
                RecMovIRPF."Tipo retención" := RecGrupoIRPF."Tipo retención";
                RecMovIRPF.Tipo := RecMovIRPF.Tipo::Venta;
                RecMovIRPF."Cuenta retención" := RecGrupoIRPF."Cuenta ventas"; // 21.11.2016

                RecMovIRPF."Tipo documento" := pRecCabVenta."Document Type";
                RecMovIRPF."Nº documento" := pRecCabVenta."No.";
                RecMovIRPF."Tipo documento original" := pRecCabVenta."Document Type";
                RecMovIRPF."Nº documento original" := pRecCabVenta."No.";

                RecLinVenta.CALCSUMS("VAT Base Amount");

                CASE RecMovIRPF."Tipo documento" OF
                    RecMovIRPF."Tipo documento"::Oferta, RecMovIRPF."Tipo documento"::Pedido,
                    RecMovIRPF."Tipo documento"::Factura, RecMovIRPF."Tipo documento"::"Fact. Registrada":

                        RecMovIRPF.Base := RecLinVenta."VAT Base Amount" * (RecLinVenta."Qty. to Invoice" / RecLinVenta.Quantity);
                    RecMovIRPF."Tipo documento"::Abono, RecMovIRPF."Tipo documento"::Devolución,
                    RecMovIRPF."Tipo documento"::"Abono Registrado":

                        RecMovIRPF.Base := (1) * RecLinVenta."VAT Base Amount" * (RecLinVenta."Qty. to Invoice" / RecLinVenta.Quantity);
                END;

                // >> Se ajusta la precisión de los decimales
                //RecMovIRPF.Importe := RecMovIRPF.Base * (RecGrupoIRPF."% IRPF" / 100);
                //RecMovIRPF."Importe Calculado" := RecMovIRPF.Base * (RecGrupoIRPF."% IRPF" / 100);
                IF pRecCabVenta."Currency Code" = '' THEN
                    Currency.InitRoundingPrecision
                ELSE BEGIN
                    Currency.GET(pRecCabVenta."Currency Code");
                    Currency.TESTFIELD("Amount Rounding Precision");
                END;
                RecMovIRPF.Importe := ROUND(RecMovIRPF.Base * (RecGrupoIRPF."% retención" / 100), Currency."Amount Rounding Precision");
                RecMovIRPF."Importe calculado" := RecMovIRPF.Importe;
                // <<

                RecMovIRPF."Cod. origen" := pRecCabVenta."Sell-to Customer No.";
                RecMovIRPF."Id. usuario" := USERID();
                RecMovIRPF."CIF/NIF" := pRecCabVenta."VAT Registration No.";
                IF (RecMovIRPF.Importe <> 0) THEN BEGIN
                    RecMovIRPF.INSERT();

                    RecLinVentaAux.RESET();
                    RecLinVentaAux.SETRANGE("Document Type", pRecCabVenta."Document Type");
                    RecLinVentaAux.SETRANGE("Document No.", pRecCabVenta."No.");
                    IF (RecLinVentaAux.FINDLAST) THEN
                        NumLinea := RecLinVentaAux."Line No." + 10000
                    ELSE
                        NumLinea := 10000;

                    RecLinVentaAux.INIT();
                    RecLinVentaAux.VALIDATE("Document Type", pRecCabVenta."Document Type");
                    RecLinVentaAux.VALIDATE("Document No.", pRecCabVenta."No.");
                    RecLinVentaAux.VALIDATE("Line No.", NumLinea);
                    RecLinVentaAux.VALIDATE("System-Created Entry", TRUE);
                    RecLinVentaAux.VALIDATE("Sell-to Customer No.", pRecCabVenta."Sell-to Customer No.");
                    RecLinVentaAux.VALIDATE(Type, RecLinVentaAux.Type::"G/L Account");
                    RecLinVentaAux.VALIDATE("No.", RecGrupoIRPF."Cuenta ventas");
                    RecLinVentaAux.VALIDATE(Quantity, 1);

                    //RecLinCompraAux.VALIDATE("Direct Unit Cost", RecMovIRPF.Importe);
                    CASE RecMovIRPF."Tipo documento" OF
                        RecMovIRPF."Tipo documento"::Oferta, RecMovIRPF."Tipo documento"::Pedido,
                        RecMovIRPF."Tipo documento"::Factura, RecMovIRPF."Tipo documento"::"Fact. Registrada":

                            RecLinVentaAux.VALIDATE("Unit Price", -RecMovIRPF.Importe);
                        RecMovIRPF."Tipo documento"::Abono, RecMovIRPF."Tipo documento"::Devolución,
                        RecMovIRPF."Tipo documento"::"Abono Registrado":

                            RecLinVentaAux.VALIDATE("Unit Price", -RecMovIRPF.Importe);
                    END;
                    IF NOT (RecLinVentaAux."Document Type" = RecLinVentaAux."Document Type"::"Credit Memo") THEN
                        RecLinVentaAux.VALIDATE("Qty. to Ship", 1);
                    RecLinVentaAux.VALIDATE("Qty. to Invoice", 1);
                    RecLinVentaAux.VALIDATE("IRPF Line", TRUE);
                    //Importante hacerlo al final para que se pueda insertar la línea correctamente.
                    RecLinVentaAux.INSERT(TRUE);

                    RecMovIRPF."Nº linea retención original" := RecLinVentaAux."Line No.";
                    RecMovIRPF."Nº linea IRPF" := RecLinVentaAux."Line No.";
                    RecMovIRPF.MODIFY();
                END;

                RecLinVenta.FIND('+');
                RecLinVenta.SETRANGE("IRPF Posting Group");
            UNTIL (RecLinVenta.NEXT() = 0)
        ELSE
            IF (pRecCabVenta."Control IRPF" = pRecCabVenta."Control IRPF"::Obligatorio) THEN
                ERROR(Text60101);
    end;

    procedure EliminarCalculoIRPFVtas(var pRecCabVenta: Record "Sales Header")
    var
        RecLinVenta: Record "Sales Line";
        RecMovIRPF: Record "Movs. retenciones";
    begin
        // Función que elimina la línea del IRPF en la factura y las de su respectivo Mov. IRPF.
        RecLinVenta.RESET();
        RecLinVenta.SETCURRENTKEY("Document Type", "Document No.", "IRPF Line", "IRPF Posting Group");
        RecLinVenta.SETRANGE("Document Type", pRecCabVenta."Document Type");
        RecLinVenta.SETRANGE("Document No.", pRecCabVenta."No.");
        RecLinVenta.SETRANGE("IRPF Line", TRUE);
        IF RecLinVenta.FINDSET(TRUE) THEN
            REPEAT
                RecLinVenta."IRPF Line" := FALSE; //Para poder borrarla
                RecLinVenta.DELETE(TRUE);
            UNTIL (RecLinVenta.NEXT() = 0);

        RecMovIRPF.RESET();
        RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
        RecMovIRPF.SETRANGE(Tipo, RecMovIRPF.Tipo::Venta);
        RecMovIRPF.SETRANGE("Tipo documento", pRecCabVenta."Document Type");
        RecMovIRPF.SETRANGE("Nº documento", pRecCabVenta."No.");
        RecMovIRPF.DELETEALL(TRUE);
    end;

    procedure ActualizarRegistroIRPFVtas(var pRecCabVenta: Record "Sales Header"; pNumDocReg: Code[20]; pNumDocExterno: Code[20])
    var
        RecMovIRPF: Record "Movs. retenciones";
    begin
        // Función que actualiza los datos de los movs. IRPF en el registro de un documento.
        RecMovIRPF.RESET();
        RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
        RecMovIRPF.SETRANGE(Tipo, RecMovIRPF.Tipo::Venta);
        RecMovIRPF.SETRANGE("Tipo documento", pRecCabVenta."Document Type");
        RecMovIRPF.SETRANGE("Nº documento", pRecCabVenta."No.");
        RecMovIRPF.MODIFYALL("Fecha registro", pRecCabVenta."Posting Date");
        RecMovIRPF.MODIFYALL("Nº documento externo", pNumDocExterno);
        //RecMovIRPF.MODIFYALL("Fecha Emision Documento", WORKDATE);
        RecMovIRPF.MODIFYALL("Fecha emision documento", pRecCabVenta."Posting Date");
        IF (pRecCabVenta."Document Type" IN [pRecCabVenta."Document Type"::"Return Order", pRecCabVenta."Document Type"::"Credit Memo"])
        THEN BEGIN
            RecMovIRPF.MODIFYALL("Tipo documento", RecMovIRPF."Tipo documento"::"Abono Registrado");
            RecMovIRPF.SETRANGE("Tipo documento", RecMovIRPF."Tipo documento"::"Abono Registrado");
        END ELSE BEGIN
            RecMovIRPF.MODIFYALL("Tipo documento", RecMovIRPF."Tipo documento"::"Fact. Registrada");
            RecMovIRPF.SETRANGE("Tipo documento", RecMovIRPF."Tipo documento"::"Fact. Registrada");
        END;
        RecMovIRPF.MODIFYALL("Nº documento", pNumDocReg);
        RecMovIRPF.MODIFYALL("Fecha registro", pRecCabVenta."Posting Date");
    end;

    procedure CrearLinIRPFRegVtas(pRecCabVenta: Record "Sales Header"; var pTempIRPFRecSalesLine: Record "Sales Line")
    var
        RecLinVenta: Record "Sales Line";
    begin
        // Función que crear las líneas de IRPF de una factura en una tabla temporal de manera similar a como crea el estandar las líneas de los prepagos.
        RecLinVenta.SETRANGE("Document Type", pRecCabVenta."Document Type");
        RecLinVenta.SETRANGE("Document No.", pRecCabVenta."No.");
        RecLinVenta.SETRANGE("IRPF Line", TRUE);
        IF (RecLinVenta.FINDFIRST) THEN
            REPEAT
                pTempIRPFRecSalesLine.INIT();
                pTempIRPFRecSalesLine."Document Type" := RecLinVenta."Document Type";
                pTempIRPFRecSalesLine."Document No." := RecLinVenta."Document No.";
                pTempIRPFRecSalesLine."Line No." := RecLinVenta."Line No.";
                pTempIRPFRecSalesLine."System-Created Entry" := TRUE;
                pTempIRPFRecSalesLine.VALIDATE(Type, pTempIRPFRecSalesLine.Type::"G/L Account");
                pTempIRPFRecSalesLine.VALIDATE("No.", RecLinVenta."No.");
                pTempIRPFRecSalesLine.VALIDATE(Quantity, -1);
                IF NOT (pTempIRPFRecSalesLine."Document Type" = pTempIRPFRecSalesLine."Document Type"::"Credit Memo") THEN
                    pTempIRPFRecSalesLine.VALIDATE("Qty. to Ship", -1);
                //>>MIG
                //pTempIRPFRecSalesLine.VALIDATE("Unit Price", RecLinVenta."Unit Price");
                //IF pTempIRPFRecSalesLine."Document Type" = pTempIRPFRecSalesLine."Document Type"::"Credit Memo" THEN
                pTempIRPFRecSalesLine.VALIDATE("Unit Price", -RecLinVenta."Unit Price");
                //ELSE
                //<<MIG
                pTempIRPFRecSalesLine."IRPF Line" := TRUE;
                // Mod. S2G 22/11/2016 (CSM) : AN-001 Gestión analítica. begin
                pTempIRPFRecSalesLine."Dimension Set ID" := RecLinVenta."Dimension Set ID";
                // Mod. S2G 22/11/2016 (CSM) : AN-001 Gestión analítica. end
                pTempIRPFRecSalesLine.INSERT();
            UNTIL (RecLinVenta.NEXT() = 0);
    end;

    procedure ActualizarImporteIRPFVtas(var pRecLinVenta: Record "Sales Line")
    var
        RecMovIRPF: Record "Movs. retenciones";
        RecCabVenta: Record "Sales Header";
    begin
        // Función que actualiza los movimientos de IRPF después de la modificación del campo "Direct Unit Cost" del documento en una línea de IRPF

        RecCabVenta.GET(pRecLinVenta."Document Type", pRecLinVenta."Document No.");
        RecMovIRPF.RESET();
        RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
        RecMovIRPF.SETRANGE(Tipo, RecMovIRPF.Tipo::Venta);
        RecMovIRPF.SETRANGE("Tipo documento", pRecLinVenta."Document Type");
        RecMovIRPF.SETRANGE("Nº documento", pRecLinVenta."Document No.");
        RecMovIRPF.SETRANGE("Nº linea IRPF", pRecLinVenta."Line No.");
        RecMovIRPF.FINDSET(TRUE);
        CheckDiferenciaIRPF(pRecLinVenta."Unit Price" - RecMovIRPF."Importe calculado", RecCabVenta."Currency Code");
        RecMovIRPF.Importe := pRecLinVenta."Unit Price";
        RecMovIRPF.MODIFY();
    end;

    procedure EstadisiticasIRPFVtas(pRecCabVenta: Record "Sales Header"; var pBase: Decimal; var pRetencion: Decimal)
    var
        RecMovIRPF: Record "Movs. retenciones";
    begin
        // Función que calcula el importe de la Base y la Retención de IRPF para el documento pasado por parámetro.
        RecMovIRPF.RESET();
        RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
        RecMovIRPF.SETRANGE(Tipo, RecMovIRPF.Tipo::Venta);
        RecMovIRPF.SETRANGE("Tipo documento", pRecCabVenta."Document Type");
        RecMovIRPF.SETRANGE("Nº documento", pRecCabVenta."No.");
        RecMovIRPF.CALCSUMS(Base, Importe);
        pBase := RecMovIRPF.Base;
        pRetencion := RecMovIRPF.Importe;
    end;

    procedure EstadisiticasFactVentaRegIRPF(pRecFactVentaReg: Record "Sales Invoice Header"; var pBase: Decimal; var pRetencion: Decimal)
    var
        RecMovIRPF: Record "Movs. retenciones";
    begin
        // Función que calcula el importe de la Base y la Retención de IRPF para el documento pasado por parámetro.
        RecMovIRPF.RESET();
        RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
        RecMovIRPF.SETRANGE(Tipo, RecMovIRPF.Tipo::Venta);
        RecMovIRPF.SETRANGE("Tipo documento", RecMovIRPF."Tipo documento"::"Fact. Registrada");
        RecMovIRPF.SETRANGE("Nº documento", pRecFactVentaReg."No.");
        RecMovIRPF.CALCSUMS(Base, Importe);
        pBase := RecMovIRPF.Base;
        pRetencion := RecMovIRPF.Importe;
    end;

    procedure EstadisiticasAbVentaRegIRPF(pRecAbVentaReg: Record "Sales Cr.Memo Header"; var pBase: Decimal; var pRetencion: Decimal)
    var
        RecMovIRPF: Record "Movs. retenciones";
    begin
        // Función que calcula el importe de la Base y la Retención de IRPF para el documento pasado por parámetro.
        RecMovIRPF.RESET();
        RecMovIRPF.SETCURRENTKEY(Tipo, "Tipo documento", "Nº documento");
        RecMovIRPF.SETRANGE(Tipo, RecMovIRPF.Tipo::Venta);
        RecMovIRPF.SETRANGE("Tipo documento", RecMovIRPF."Tipo documento"::"Abono Registrado");
        RecMovIRPF.SETRANGE("Nº documento", pRecAbVentaReg."No.");
        RecMovIRPF.CALCSUMS(Base, Importe);
        pBase := RecMovIRPF.Base;
        pRetencion := RecMovIRPF.Importe;
    end;

    procedure CheckDiferenciaIRPFVtas(pDiferenciaIRPF: Decimal; pCodDivisa: Code[10])
    var
        RecConfigVenta: Record "Sales & Receivables Setup";
        RecDivisa: Record Currency;
    begin
        // Función que chequea la diferencia de IRPF insertada en el documento de compra de la misma manera
        // que chequea el estandar la diferencias de IVA (se utilizá la configuración de diferencia de IVA).

        RecConfigVenta.GET();

        IF (pCodDivisa = '') THEN
            RecDivisa.InitRoundingPrecision
        ELSE
            RecDivisa.GET(pCodDivisa);

        IF NOT (RecConfigVenta."Allow VAT Difference") THEN BEGIN
            IF (pDiferenciaIRPF <> 0) THEN
                ERROR(Text60110, 0);
        END ELSE
            IF ABS(pDiferenciaIRPF) > RecDivisa."Max. VAT Difference Allowed" THEN
                ERROR(Text60110, RecDivisa."Max. VAT Difference Allowed", pCodDivisa);
    end;

    procedure Excluir347(parTipo: Option " ",Purchase,Sale,Settlement; parTipoDocumento: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,Bill; parDocumento: Code[20]; parExcluir: Boolean)
    begin
        /*
        VATEntry.SETCURRENTKEY("Document No.","Document Type","Gen. Prod. Posting Group","VAT Prod. Posting Group",Type);
        VATEntry.SETRANGE(Type,parTipo);
        VATEntry.SETRANGE("Document Type",parTipoDocumento);
        VATEntry.SETRANGE("Document No.",parDocumento);
        IF NOT VATEntry.ISEMPTY THEN
          VATEntry.MODIFYALL("Excluir 347",parExcluir);
         */
    end;

    procedure Excluida347(parTipo: Option " ",Purchase,Sale,Settlement; parTipoDocumento: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,Bill; parDocumento: Code[20]): Boolean
    begin
        /*
        VATEntry.SETCURRENTKEY("Document No.","Document Type","Gen. Prod. Posting Group","VAT Prod. Posting Group",Type);
        VATEntry.SETRANGE(Type,parTipo);
        VATEntry.SETRANGE("Document Type",parTipoDocumento);
        VATEntry.SETRANGE("Document No.",parDocumento);
        VATEntry.SETRANGE("Excluir 347",TRUE);
        IF NOT VATEntry.ISEMPTY THEN
          EXIT(TRUE)
        ELSE
          EXIT(FALSE);
        */
    end;

    procedure "fVerMovimientoRetención"(pMovimiento: Integer)
    var
        "rlMovRetención": Record "Movs. retenciones";
        "flMovRetención": Page "Movs. retenciones";
    begin
        //(RET): Visualizar el movimiento de la retención
        CLEAR(rlMovRetención);
        rlMovRetención.SETRANGE("Nº mov.", pMovimiento);
        CLEAR(flMovRetención);
        flMovRetención.SETTABLEVIEW(rlMovRetención);
        flMovRetención.RUN();
    end;

    procedure "fLookupCódigoretención"(var "pCódigoRetención": Code[20]; "pIRPFGarantía": Option ,Profesionales,Alquiler,"No residente",Intereses)
    var
        "rlCódigosRetención": Record "Grupo registro retención";
        "rlCódigosRetención2": Record "Grupo registro retención";
        "flCódigosRetención": Page "Grupos registro retención";
    begin
        //(RET): Ver y validar el código de retención
        CLEAR(rlCódigosRetención);
        rlCódigosRetención.FILTERGROUP(2);
        rlCódigosRetención.SETRANGE("Tipo retención", pIRPFGarantía);
        rlCódigosRetención.FILTERGROUP(0);
        CLEAR(flCódigosRetención);
        flCódigosRetención.SETTABLEVIEW(rlCódigosRetención);
        IF pCódigoRetención <> '' THEN BEGIN
            CLEAR(rlCódigosRetención2);
            rlCódigosRetención2.SETRANGE("Cód. grupo", pCódigoRetención);
            rlCódigosRetención2.SETRANGE("Tipo retención", pIRPFGarantía);
            IF rlCódigosRetención2.FINDFIRST() THEN;
        END;
        flCódigosRetención.LOOKUPMODE(TRUE);
        flCódigosRetención.SETRECORD(rlCódigosRetención2);
        IF flCódigosRetención.RUNMODAL() = ACTION::LookupOK THEN BEGIN
            flCódigosRetención.GETRECORD(rlCódigosRetención);
            pCódigoRetención := rlCódigosRetención."Cód. grupo";
        END;
    end;

    procedure fCompletarCamposRetencion(var prGLEntry: Record "G/L Entry"; prGenJournalLine: Record "Gen. Journal Line")
    var
        "rlMovRetención": Record "Movs. retenciones";
        "rlCódigosRetención": Record "Grupo registro retención";
    begin
        //(RET): Registro de retenciones.
        //Relacionamos los dos movimientos de contabilidad con el de retención.
        //En el movimiento de retención sólo se introduce el movimiento de contabilidad de la cuenta de retención.

        IF prGenJournalLine."No. mov. retención" <> 0 THEN BEGIN
            CLEAR(rlMovRetención);
            rlMovRetención.GET(prGenJournalLine."No. mov. retención");
            IF rlMovRetención."No. mov. contabilidad" = 0 THEN BEGIN
                rlMovRetención."No. mov. contabilidad" := prGLEntry."Entry No.";
                rlMovRetención."Dimension Set ID" := prGenJournalLine."Dimension Set ID";
                rlMovRetención.MODIFY();
            END;
            UpdateMovIRPFDesdeMismoMovConta(rlMovRetención, prGLEntry."Entry No.");
            prGLEntry."No. mov. retención" := rlMovRetención."Nº mov.";
            CLEAR(rlCódigosRetención);
            IF rlCódigosRetención.GET(rlMovRetención."Grupo registro retención") THEN
                IF prGLEntry."G/L Account No." = rlCódigosRetención."Cuenta compras" THEN BEGIN
                    prGLEntry."Proveedor IRPF" := prGenJournalLine."Proveedor IRPF";
                    prGLEntry."Modalidad IRPF" := prGenJournalLine."Modalidad IRPF";
                    prGLEntry."Clave IRPF" := prGenJournalLine."Clave IRPF";
                    prGLEntry."Subclave IRPF" := prGenJournalLine."Subclave IRPF";
                    prGLEntry.Residencia := prGenJournalLine.Residencia;
                    prGLEntry."Código IRPF" := prGenJournalLine."Código IRPF";
                    prGLEntry."Base Retención IRPF" := rlMovRetención.Base;
                    prGLEntry."Porcentaje Retención" := rlMovRetención."% retención";
                END;
        END;

        //(RET): Liberar retenciones de garantía.
        IF prGenJournalLine."No. mov. retención a liberar" <> 0 THEN BEGIN
            CLEAR(rlMovRetención);
            rlMovRetención.GET(prGenJournalLine."No. mov. retención a liberar");
            rlMovRetención.Declarado := TRUE;
            rlMovRetención.MODIFY();
        END;
        //(RET): Fin.
    end;

    local procedure "//S2G SGP"()
    begin
    end;

    procedure CalcularIRPFJnlLine(var p_GenJournalLine: Record "Gen. Journal Line")
    var
        RecGrupoIRPF: Record "Grupo registro retención";
        RecMovIRPF: Record "Movs. retenciones";
        Currency: Record Currency;
        NumMov: Integer;
        Err001: Label 'En la linea %1 del diario, debe indicar el Nº documento externo';
    begin
        // Función que calculará creará el Mov. IRPF desde la linea de un diario general
        /*locGenJnlLine.RESET();
        locGenJnlLine.SETRANGE("Journal Template Name",p_GenJnlLineTemplate);
        locGenJnlLine.SETRANGE("Journal Batch Name",p_GenJnlLineBatch);
        locGenJnlLine.SETFILTER("Código IRPF", '<>%1', '');*/
        //IF locGenJnlLine.FINDSET() THEN BEGIN
        //REPEAT
        IF p_GenJournalLine."Código IRPF" <> '' THEN BEGIN
            RecGrupoIRPF.GET(p_GenJournalLine."Código IRPF");
            RecGrupoIRPF.TESTFIELD("% retención");
            //RecGrupoIRPF.TESTFIELD("Cuenta ventas");
            RecGrupoIRPF.TESTFIELD("Tipo retención");

            RecMovIRPF.RESET();
            IF (RecMovIRPF.FINDLAST) THEN
                NumMov := RecMovIRPF."Nº mov." + 1
            ELSE
                NumMov := 1;

            RecMovIRPF.INIT();
            RecMovIRPF."Nº mov." := NumMov;
            RecMovIRPF."Fecha registro" := p_GenJournalLine."Posting Date";
            RecMovIRPF."Grupo registro retención" := p_GenJournalLine."Código IRPF";
            RecMovIRPF."% retención" := RecGrupoIRPF."% retención";
            RecMovIRPF."Tipo retención" := RecGrupoIRPF."Tipo retención";
            RecMovIRPF.Tipo := RecMovIRPF.Tipo::Compra;
            RecMovIRPF."Cuenta retención" := RecGrupoIRPF."Cuenta compras";
            RecMovIRPF."Tipo documento" := p_GenJournalLine."Document Type";
            RecMovIRPF."Nº documento" := p_GenJournalLine."Document No.";
            //RecMovIRPF."Tipo documento original":= RecMovIRPF."Tipo documento original"::
            IF p_GenJournalLine."External Document No." <> '' THEN
                RecMovIRPF."Nº documento original" := p_GenJournalLine."External Document No."
            ELSE
                ERROR(Err001, p_GenJournalLine."Line No.");

            p_GenJournalLine.CALCSUMS("VAT Base Amount");

            RecMovIRPF.Base := p_GenJournalLine."Credit Amount" + p_GenJournalLine."Cuota Retencion";//ojo

            // >> Se ajusta la precisión de los decimales
            //RecMovIRPF.Importe := RecMovIRPF.Base * (RecGrupoIRPF."% IRPF" / 100);
            //RecMovIRPF."Importe Calculado" := RecMovIRPF.Base * (RecGrupoIRPF."% IRPF" / 100);
            IF p_GenJournalLine."Currency Code" = '' THEN
                Currency.InitRoundingPrecision
            ELSE BEGIN
                Currency.GET(p_GenJournalLine."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            END;
            RecMovIRPF.Importe := p_GenJournalLine."Cuota Retencion";
            RecMovIRPF."Importe calculado" := RecMovIRPF.Importe;
            // <<

            RecMovIRPF."Cod. origen" := p_GenJournalLine."Account No.";
            RecMovIRPF."Id. usuario" := USERID();
            RecMovIRPF."CIF/NIF" := p_GenJournalLine."VAT Registration No.";

            RecMovIRPF."Nº linea retención original" := p_GenJournalLine."Line No.";
            RecMovIRPF."Nº linea IRPF" := p_GenJournalLine."Line No.";

            //IF (RecMovIRPF.Importe <> 0) THEN BEGIN
            RecMovIRPF.INSERT();
            p_GenJournalLine."No. mov. retención" := RecMovIRPF."Nº mov.";
            p_GenJournalLine.Modify();
            //END;
            //UNTIL (locGenJnlLine.NEXT() = 0);
        END;
    end;

    local procedure UpdateMovIRPFDesdeMismoMovConta(p_Movsretenciones: Record "Movs. retenciones"; p_GLEntryNo: Integer)
    var
        locMovsretenciones: Record "Movs. retenciones";
    begin
        locMovsretenciones.RESET();
        locMovsretenciones.SETRANGE("Cuenta retención", p_Movsretenciones."Cuenta retención");
        locMovsretenciones.SETRANGE("Tipo documento", p_Movsretenciones."Tipo documento");
        locMovsretenciones.SETRANGE("Nº documento", p_Movsretenciones."Nº documento");
        IF locMovsretenciones.FINDSET() THEN
            REPEAT
                locMovsretenciones."No. mov. contabilidad" := p_GLEntryNo;
                locMovsretenciones.MODIFY();
            UNTIL locMovsretenciones.NEXT() = 0;
    end;

    procedure UpdateRetentionEntryFromGLEntry(RetentionEntryNo: Integer; GLEntryNo: Integer; DimensionSetID: Integer)
    var
        MovRetencion: Record "Movs. retenciones";
    begin
        if (RetentionEntryNo = 0) or (GLEntryNo = 0) then
            exit;

        if not MovRetencion.GET(RetentionEntryNo) then
            exit;

        if MovRetencion."No. mov. contabilidad" = 0 then begin
            MovRetencion."No. mov. contabilidad" := GLEntryNo;
            MovRetencion."Dimension Set ID" := DimensionSetID;
            MovRetencion.MODIFY();
        end;

        UpdateMovIRPFDesdeMismoMovConta(MovRetencion, GLEntryNo);
    end;


    procedure GetRetentionEntryNoFromPurchLine(PurchLine: Record "Purchase Line"): Integer
    var
        MovRetenciones: Record "Movs. retenciones";
    begin
        MovRetenciones.Reset();
        MovRetenciones.SetCurrentKey(Tipo, "Tipo documento", "Nº documento");
        MovRetenciones.SetRange(Tipo, MovRetenciones.Tipo::Compra);
        MovRetenciones.SetRange("Tipo documento", MapPurchDocumentTypeToRetentionDocumentType(PurchLine."Document Type"));
        MovRetenciones.SetRange("Nº documento", PurchLine."Document No.");
        MovRetenciones.SetRange("Nº linea IRPF", PurchLine."Line No.");
        if MovRetenciones.FindLast() then
            exit(MovRetenciones."Nº mov.");

        exit(0);
    end;

    procedure GetRetentionEntryNoFromSalesLine(SalesLine: Record "Sales Line"): Integer
    var
        MovRetenciones: Record "Movs. retenciones";
    begin
        MovRetenciones.Reset();
        MovRetenciones.SetCurrentKey(Tipo, "Tipo documento", "Nº documento");
        MovRetenciones.SetRange(Tipo, MovRetenciones.Tipo::Venta);
        MovRetenciones.SetRange("Tipo documento", MapSalesDocumentTypeToRetentionDocumentType(SalesLine."Document Type"));
        MovRetenciones.SetRange("Nº documento", SalesLine."Document No.");
        MovRetenciones.SetRange("Nº linea IRPF", SalesLine."Line No.");
        if MovRetenciones.FindLast() then
            exit(MovRetenciones."Nº mov.");

        exit(0);
    end;

    local procedure MapPurchDocumentTypeToRetentionDocumentType(PurchDocumentType: Enum "Purchase Document Type"): Integer
    begin
        case PurchDocumentType of
            PurchDocumentType::Quote:
                exit(0);
            PurchDocumentType::Order:
                exit(1);
            PurchDocumentType::Invoice:
                exit(2);
            PurchDocumentType::"Credit Memo":
                exit(3);
            PurchDocumentType::"Blanket Order":
                exit(4);
            PurchDocumentType::"Return Order":
                exit(5);
        end;

        exit(2);
    end;

    local procedure MapSalesDocumentTypeToRetentionDocumentType(SalesDocumentType: Enum "Sales Document Type"): Integer
    begin
        case SalesDocumentType of
            SalesDocumentType::Quote:
                exit(0);
            SalesDocumentType::Order:
                exit(1);
            SalesDocumentType::Invoice:
                exit(2);
            SalesDocumentType::"Credit Memo":
                exit(3);
            SalesDocumentType::"Blanket Order":
                exit(4);
            SalesDocumentType::"Return Order":
                exit(5);
        end;

        exit(2);
    end;


}
