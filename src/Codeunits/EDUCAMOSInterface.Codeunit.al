codeunit 50007 "EDUCAMOS Interface"
{
    //TODO descomentar funciones

    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos
    //
    //
    // ESTRUCTURA:
    //   IngresoCuenta [Bloque1] --> No vendrá en el ws
    //   Remesa [Bloque2] --> Realmente no necesario, no se procesa. Se usará como enlace para el resto
    //   RecibosRemesa [Bloque3] --> Info que pasará a Cabecera factura. Enlazado con Remesa por remesaid
    //   ReciboAlumno [Bloque4] --> No necesario; más info que se guarda porque la envían por ws. Enlazado con RecibosRemesa por id_unique_recibo
    //   AlumnoConcepto [Bloque5] --> Info que pasará a Líneas de factura. Enlazado con RecibosRemesa por id_unique_recibo
    //   ConceptoDescuento [Bloque6] --> No vendrá en el ws
    //
    // (CR005) S2G (RBM-R) 29-11-18: Modificaciones Interfaz Educamos
    // (Varios) S2G (RBM-R) Modificaciones Interfaz Educamos
    //
    // S2G (JPB) Saltar la validación de CIF/NIF al crear tercero.
    //
    // (2.2) S2G (RBM-R) 03-04-20: Mapeo Código Servicio y Cuenta Contable
    // (2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados
    // EIM-1604 ACAMACHO 07/07/2022 Desarrollo para añadir la cuenta contable

    trigger OnRun()
    begin
        IF CONFIRM(Text005) THEN BEGIN
            fRunInterface;
            MESSAGE(Text006);
        END;
    end;

    var
        Window: Dialog;
        TextResult: Text;
        Warning001: Label 'Ninguna remesa que procesar para el colegio %1 y ordenante %2';
        Warning002: Label 'No se encontró Etapa Educativa para el alumno %1. Se deberá informar a mano en la factura';
        Warning003: Label 'No se encontró Etapa Educativa %1 como dimensión en Navision. Se deberá crear e informar a mano en la factura';
        Warning004: Label 'Ningún recibo que procesar para la remesa %1';
        Warning005: Label 'Ningún concepto que procesar para el recibo %1';
        Warning006: Label 'No se encontró en Navision la Actividad %1 importada desde Educamos. Se ha creado automáticamente y asignado a la factura';
        Text001: Label 'Se creó el Tercero %1 con ID Educamos %2. ';
        Text002: Label 'Se creó el Cliente %1 con ID Educamos %2. ';
        Text003: Label 'Se ha creado la factura %1. Se deberá revisar que es correcta antes de contabilizarla';
        "Text003-1": Label 'Se ha creado el abono %1. Se deberá revisar que es correcto antes de contabilizarlo';
        Text004: Label 'Revíselo porque llegó sin NIF desde Educamos';
        Text005: Label '¿Desea ejecutar la interfaz con Educamos para importar facturas?';
        Text006: Label 'Proceso finalizado. Por favor, revise el LOG';
        Error001: Label 'No se pudo crear la factura correspondiente al Recibo %1: ';
        "Error001-1": Label 'No se pudo crear el abono correspondiente al Recibo %1: ';
        Error002: Label 'Ya se encontró una factura o abono con el mismo ID de recibo: %1';
        Error003: Label 'Hubo un problema al crear la factura o abono';
        Error004: Label 'No se pudo crear la factura o abono porque hubo un problema con la búsqueda o creación del cliente %1';
        Error005: Label 'Se debe informar un ID de colegio en la empresa. No se procesó ninguna remesa';
        Error006: Label 'Llegó la cuenta contable %1 que no se encontró en Navision. Deberá informarse a mano';
        "Error006-2": Label 'Llegó la cuenta contable %1 que no se encontró en Navision. Se mapeó según su código de servicio';
        "Error006-3": Label 'Llegó la cuenta contable %1 que no se encontró en Navision, y no se pudo mapear según su código de servicio. Deberá informarse a mano';
        Error007: Label 'No se pudo insertar un concepto en la factura %1';
        Error008: Label 'Se produjo un error en la conexión con Educamos. Por favor revise el log y contacte con su administrador';
        txtEtapaEducativa: Label 'ETAPA';
        GeneralErrorText: Text;
        vSchoolID: Integer;
        txtActividad: Label 'ACTIVIDAD';
        txtDim: Label 'EDUCAMOS: %1';
        txtDialog2: Label 'Cargando datos...\\Importando Remesas @1@@@@@@\\Importando Remesas Recibo @2@@@@@@\\Importando Alumnos Concepto @3@@@@@@\\Importando Concepto Descuento @4@@@@@@';
        txtDialog: Label 'Estableciendo conexión...';

    procedure fRunInterface()
    var
        cuJSONWebservicesManagement: Codeunit "JSON Webservices Management";
        rlCompanyOFM: Record "Company OFM";
    begin
        //  -----------------------------------------------
        //  ---Llamar a webservice & Rellenar Input Data---
        //  -----------------------------------------------
        Window.OPEN(txtDialog);

        CLEAR(cuJSONWebservicesManagement);
        IF NOT cuJSONWebservicesManagement.Code THEN BEGIN
            COMMIT; //Para que deje reflejo en el log
            IF GUIALLOWED THEN
                ERROR(Error008);
        END;

        Window.CLOSE;

        COMMIT; //Por si acaso

        //  --------------------
        //  ---Procesar datos---
        //  --------------------
        Window.OPEN(txtDialog2);

        //Recorrer las remesas no procesadas
        rlCompanyOFM.RESET;
        rlCompanyOFM.SETRANGE(Name, COMPANYNAME);
        IF rlCompanyOFM.FINDFIRST THEN
            vSchoolID := rlCompanyOFM."School ID"
        ELSE BEGIN
            fSetLog(3, Error005, '', 1);
            EXIT;
        END;

        fProcessRemesa(vSchoolID);
    end;

    procedure fProcessRemesa(pSchoolID: Integer)
    var
        rlRemesa: Record "EDUCAMOS Remesa";
        rlRemesaAux: Record "EDUCAMOS Remesa";
        rlCompanyInfo: Record "Company Information";
        i: Integer;
    begin
        rlCompanyInfo.GET;

        Window.OPEN(txtDialog2);

        i := 1;
        rlRemesa.RESET;
        rlRemesa.SETCURRENTKEY(Processed, ordenante);
        rlRemesa.SETRANGE(Processed, FALSE);
        rlRemesa.SETRANGE(ordenante, rlCompanyInfo.Name);
        // rlRemesa.SETRANGE(accion, 1);
        IF rlRemesa.FINDSET THEN BEGIN
            REPEAT
                Window.UPDATE(1, ROUND(i / rlRemesa.COUNT * 10000, 1));
                fProcessRecibosRemesa(rlRemesa.remesaid);

                rlRemesaAux.GET(rlRemesa.remesaid);
                rlRemesaAux.Processed := TRUE;
                rlRemesaAux.MODIFY;
                i += 1;
            UNTIL rlRemesa.NEXT = 0;
        END ELSE
            fSetLog(2, STRSUBSTNO(Warning001, pSchoolID, rlCompanyInfo."VAT Registration No."), '', 1);
    end;

    local procedure fProcessRecibosRemesa(pIDUniqueRemesa: Text)
    var
        rlRecibosRemesa: Record "EDUCAMOS RecibosRemesa";
        rlRecibosRemesaAux: Record "EDUCAMOS RecibosRemesa";
        clInvoiceNo: Code[20];
        i: Integer;
        bIsCrMemo: Boolean;
    begin
        // i := 1;

        // rlRecibosRemesa.RESET;
        // rlRecibosRemesa.SETCURRENTKEY(Processed, remesaid);
        // rlRecibosRemesa.SETRANGE(Processed, FALSE);
        // rlRecibosRemesa.SETRANGE(remesaid, pIDUniqueRemesa);
        // IF rlRecibosRemesa.FINDSET THEN BEGIN
        //     REPEAT
        //         bIsCrMemo := FALSE;
        //         Window.UPDATE(2, ROUND(i / rlRecibosRemesa.COUNT * 10000, 1));
        //         clInvoiceNo := fCreateSalesHeader(rlRecibosRemesa, bIsCrMemo);
        //         IF clInvoiceNo <> '' THEN BEGIN

        //             //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Inicio
        //             IF bIsCrMemo THEN
        //                 fSetLog(1, STRSUBSTNO("Text003-1", clInvoiceNo), '', 1)
        //             ELSE
        //                 //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Inicio

        //                 fSetLog(1, STRSUBSTNO(Text003, clInvoiceNo), '', 1);
        //             fProcessAlumnoConcepto(rlRecibosRemesa.id_unique_recibo, clInvoiceNo, bIsCrMemo);
        //         END ELSE BEGIN

        //             //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Inicio
        //             IF bIsCrMemo THEN
        //                 fSetLog(3, STRSUBSTNO("Error001-1", rlRecibosRemesa.id_recibo) + GeneralErrorText, 'Remesa: ' + pIDUniqueRemesa, 2)
        //             ELSE
        //                 //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Fin

        //                 fSetLog(3, STRSUBSTNO(Error001, rlRecibosRemesa.id_recibo) + GeneralErrorText, 'Remesa: ' + pIDUniqueRemesa, 2);
        //         END;

        //         rlRecibosRemesaAux.GET(rlRecibosRemesa.remesaid, rlRecibosRemesa.id_unique_recibo);
        //         rlRecibosRemesaAux.Processed := TRUE;
        //         rlRecibosRemesaAux.MODIFY;
        //         i += 1;
        //     UNTIL rlRecibosRemesa.NEXT = 0;
        // END ELSE
        //     fSetLog(2, STRSUBSTNO(Warning004, pIDUniqueRemesa), '', 1);
    end;

    local procedure fCreateSalesHeader(pRecibosRemesa: Record "EDUCAMOS RecibosRemesa"; var pIsCrMemo: Boolean) InvNo: Code[20]
    var
        rlEDUCAMOSSetup: Record "EDUCAMOS Setup";
        rlSalesHeader: Record "Sales Header";
        clCustNo: Code[20];
        clInvNo: Code[20];
        blIsTicketCrMemo: Boolean;
        blistype5: Boolean;
        blNewInvoice: Boolean;
        rlSalesInvHdr: Record "Sales Invoice Header";
    begin
        // InvNo := '';
        // rlSalesHeader.RESET;
        // rlSalesHeader.SETCURRENTKEY("EDUCAMOS id_unique_recibo");
        // rlSalesHeader.SETRANGE("EDUCAMOS id_unique_recibo", pRecibosRemesa.id_unique_recibo);
        // IF rlSalesHeader.FINDFIRST THEN BEGIN
        //     GeneralErrorText := STRSUBSTNO(Error002, rlSalesHeader."No.");
        //     EXIT('');
        // END;

        // rlSalesHeader.INIT;

        // //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Inicio
        // IF pRecibosRemesa.estado_recibo = 5 THEN BEGIN
        //     pIsCrMemo := TRUE;
        //     rlSalesHeader."Document Type" := rlSalesHeader."Document Type"::"Credit Memo";
        // END ELSE
        //     //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Fin

        //     rlSalesHeader."Document Type" := rlSalesHeader."Document Type"::Invoice;
        // rlSalesHeader."No." := '';
        // IF NOT rlSalesHeader.INSERT(TRUE) THEN BEGIN
        //     GeneralErrorText := Error003;
        //     EXIT('');
        // END;

        // InvNo := rlSalesHeader."No.";
        // clCustNo := fFindCustomer(pRecibosRemesa);
        // IF clCustNo = '' THEN BEGIN
        //     GeneralErrorText := STRSUBSTNO(Error004, pRecibosRemesa.id_pagador);
        //     EXIT('');
        // END;

        // rlSalesHeader.SetHideValidationDialog(TRUE);

        // rlSalesHeader.VALIDATE("Sell-to Customer No.", clCustNo);
        // rlSalesHeader.VALIDATE("Posting Date", TODAY);
        // rlSalesHeader."External Document No." := COPYSTR(pRecibosRemesa.numero_recibo, 1, 35);
        // rlSalesHeader."EDUCAMOS id_unique_recibo" := pRecibosRemesa.id_unique_recibo;

        // //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Inicio
        // /*  //No lo querrán así finalmente...correo del 27/04/20
        // IF pIsCrMemo THEN BEGIN
        //   IF rlEDUCAMOSSetup."Credit Memo Payment Method" <> '' THEN
        //     rlSalesHeader.VALIDATE("Payment Method Code", rlEDUCAMOSSetup."Credit Memo Payment Method");
        // END ELSE BEGIN
        // */
        // //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Fin

        // rlEDUCAMOSSetup.GET;
        // CASE pRecibosRemesa.tipo_recibo OF
        //     0:
        //         BEGIN
        //             IF rlEDUCAMOSSetup."Ventanilla Payment Method" <> '' THEN
        //                 rlSalesHeader.VALIDATE("Payment Method Code", rlEDUCAMOSSetup."Ventanilla Payment Method");   //ventanilla
        //         END;
        //     1:
        //         BEGIN
        //             IF rlEDUCAMOSSetup."Bank Payment Method" <> '' THEN
        //                 rlSalesHeader.VALIDATE("Payment Method Code", rlEDUCAMOSSetup."Bank Payment Method");   //banco
        //         END;
        // END;

        // //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Inicio
        // IF pIsCrMemo THEN BEGIN
        //     clInvNo := fFindSalesHeader(clCustNo, pRecibosRemesa.numero_recibo);
        //     IF clCustNo <> '' THEN BEGIN
        //         //No lo querrán así finalmente...correo del 27/04/20
        //         /*
        //         rlSalesHeader."Applies-to Doc. Type" := rlSalesHeader."Applies-to Doc. Type"::Invoice;
        //         rlSalesHeader.VALIDATE("Applies-to Doc. No.", clInvNo);
        //         */
        //         rlSalesHeader."Corrected Invoice No." := clInvNo; //no hace falta validar porque si entró aquí es que existe
        //     END;
        // END;
        // //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Fin

        // IF NOT rlSalesHeader.MODIFY(TRUE) THEN BEGIN
        //     GeneralErrorText := Error003;
        //     EXIT('');
        // END;

        // EXIT(InvNo);
    end;

    local procedure fProcessAlumnoConcepto(pIDUniqueRecibo: Text; pInvoiceNo: Code[20]; pIsCrMemo: Boolean)
    var
        rlAlumnoConcepto: Record "EDUCAMOS AlumnoConcepto";
        rlAlumnoConceptoAux: Record "EDUCAMOS AlumnoConcepto";
        i: Integer;
    begin
        i := 1;
        rlAlumnoConcepto.RESET;
        rlAlumnoConcepto.SETCURRENTKEY(Processed, id_unique_recibo);
        rlAlumnoConcepto.SETRANGE(Processed, FALSE);
        rlAlumnoConcepto.SETRANGE(id_unique_recibo, pIDUniqueRecibo);
        IF rlAlumnoConcepto.FINDSET THEN BEGIN
            REPEAT
                Window.UPDATE(3, ROUND(i / rlAlumnoConcepto.COUNT * 10000, 1));
                fCreateSalesLine(rlAlumnoConcepto, pInvoiceNo, pIsCrMemo);

                rlAlumnoConceptoAux.GET(rlAlumnoConcepto.id_unique_recibo, rlAlumnoConcepto.id_unique_alumno, rlAlumnoConcepto.id_unique_concepto);
                rlAlumnoConceptoAux.Processed := TRUE;
                rlAlumnoConceptoAux.MODIFY;
                i += 1;
            UNTIL rlAlumnoConcepto.NEXT = 0;
        END ELSE
            fSetLog(2, STRSUBSTNO(Warning005, pIDUniqueRecibo), pInvoiceNo, 1);
    end;

    local procedure fCreateSalesLine(pAlumnoConcepto: Record "EDUCAMOS AlumnoConcepto"; pInvoiceNo: Code[20]; pIsCrMemo: Boolean)
    var
        rlSalesLine: Record "Sales Line";
        rlDimValue: Record "Dimension Value";
        rlGLAccount: Record "G/L Account";
        clDimValue: Code[20];
        dlDto: Decimal;
        dlRealUnitPrice: Decimal;
        ilLineNo: Integer;
    begin
        ilLineNo := 10000;
        rlSalesLine.RESET;

        //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Inicio
        IF pIsCrMemo THEN
            rlSalesLine.SETRANGE("Document Type", rlSalesLine."Document Type"::"Credit Memo")
        ELSE
            //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Fin

            rlSalesLine.SETRANGE("Document Type", rlSalesLine."Document Type"::Invoice);
        rlSalesLine.SETRANGE("Document No.", pInvoiceNo);
        IF rlSalesLine.FINDLAST THEN
            ilLineNo := rlSalesLine."Line No.";

        rlSalesLine.INIT;

        //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Inicio
        IF pIsCrMemo THEN
            rlSalesLine."Document Type" := rlSalesLine."Document Type"::"Credit Memo"
        ELSE
            //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados. Fin

            rlSalesLine."Document Type" := rlSalesLine."Document Type"::Invoice;
        rlSalesLine."Document No." := pInvoiceNo;
        rlSalesLine."Line No." := ilLineNo + 10000;
        rlSalesLine.Type := rlSalesLine.Type::"G/L Account";
        IF rlGLAccount.GET(pAlumnoConcepto.cuenta_contable) THEN
            rlSalesLine.VALIDATE("No.", pAlumnoConcepto.cuenta_contable)
        ELSE BEGIN

            //(2.2) S2G (RBM-R) 03-04-20: Mapeo Código Servicio y Cuenta Contable. Inicio
            //fSetLog(3, STRSUBSTNO(Error006, pAlumnoConcepto.cuenta_contable), pInvoiceNo + '(' + FORMAT(rlSalesLine."Line No.") + ')', 2);
            IF fGetGLAcc(pAlumnoConcepto.reducido_concepto) <> '' THEN
              //--EIM-1604
              BEGIN
                //fSetLog(2, STRSUBSTNO("Error006-2", pAlumnoConcepto.cuenta_contable), pInvoiceNo + '(' + FORMAT(rlSalesLine."Line No.") + ')', 2)
                pAlumnoConcepto.cuenta_contable := fGetGLAcc(pAlumnoConcepto.reducido_concepto);
                rlSalesLine.VALIDATE("No.", pAlumnoConcepto.cuenta_contable);
            END
            //++EIM-1604
            ELSE
                fSetLog(3, STRSUBSTNO("Error006-3", pAlumnoConcepto.cuenta_contable), pInvoiceNo + '(' + FORMAT(rlSalesLine."Line No.") + ')', 2);
            //(2.2) S2G (RBM-R) 03-04-20: Mapeo Código Servicio y Cuenta Contable. Fin
        END;
        rlSalesLine.VALIDATE(Quantity, 1);
        rlSalesLine.Description := pAlumnoConcepto.nombre_concepto;

        fCreateLineDiscount(pAlumnoConcepto, rlSalesLine, dlRealUnitPrice);

        rlSalesLine.VALIDATE("Unit Price", dlRealUnitPrice);

        clDimValue := '';
        IF fGetEtapaEducativa(pAlumnoConcepto.id_unique_alumno, vSchoolID, clDimValue) THEN
            rlSalesLine.VALIDATE("Shortcut Dimension 1 Code", clDimValue);

        IF NOT rlDimValue.GET(txtActividad, pAlumnoConcepto.reducido_concepto) THEN BEGIN
            rlDimValue.INIT;
            rlDimValue."Dimension Code" := txtActividad;
            rlDimValue.Code := pAlumnoConcepto.reducido_concepto;
            rlDimValue.Name := COPYSTR(STRSUBSTNO(txtDim, pAlumnoConcepto.nombre_concepto), 1, MAXSTRLEN(rlDimValue.Name));
            rlDimValue.INSERT(TRUE);

            fSetLog(2, STRSUBSTNO(Warning006, pAlumnoConcepto.reducido_concepto), rlSalesLine."Document No.", 2);
        END;
        rlSalesLine.VALIDATE("Shortcut Dimension 2 Code", pAlumnoConcepto.reducido_concepto);

        IF NOT rlSalesLine.INSERT(TRUE) THEN
            IF NOT rlSalesLine.MODIFY(TRUE) THEN
                fSetLog(3, STRSUBSTNO(Error007, pInvoiceNo), pAlumnoConcepto.id_unique_concepto, 2);
    end;

    local procedure fGetEtapaEducativa(pIDAlumno: Text; pIDColegio: Integer; var pEtapaEducativa: Code[20]): Boolean
    var
        rlEtapaEducativa: Record "EDUCAMOS EtapaEducativa";
        rlDimValue: Record "Dimension Value";
        rlReciboAlumno: Record "EDUCAMOS ReciboAlumno";
    begin
        pEtapaEducativa := '';
        rlEtapaEducativa.RESET;
        IF rlEtapaEducativa.GET(pIDAlumno, pIDColegio) THEN BEGIN
            IF rlDimValue.GET(txtEtapaEducativa, rlEtapaEducativa."Etapa educativa") THEN BEGIN
                pEtapaEducativa := COPYSTR(rlEtapaEducativa."Etapa educativa", 1, 20);
                EXIT(TRUE);
            END ELSE BEGIN
                fSetLog(2, STRSUBSTNO(Warning003, rlEtapaEducativa."Etapa educativa"), rlEtapaEducativa."Etapa educativa", 2);
                EXIT(FALSE);
            END;
        END ELSE BEGIN
            rlReciboAlumno.RESET;
            rlReciboAlumno.SETRANGE(id_unique_alumno, pIDAlumno);
            IF rlReciboAlumno.FINDFIRST THEN
                fSetLog(2, STRSUBSTNO(Warning002, rlReciboAlumno.nombre_alumno + ' ' + rlReciboAlumno.ape1_alumno + ' ' + rlReciboAlumno.ape2_alumno), pIDAlumno, 2)
            ELSE
                fSetLog(2, STRSUBSTNO(Warning002, '', pIDAlumno), pIDAlumno, 2);
            EXIT(FALSE);
        END;
    end;

    local procedure fGetGLAcc(pServiceCode: Code[20]) GLAccNo: Code[20]
    var
        rlMap: Record "EDUCAMOS Mapeo Servicio Cuenta";
    begin
        //(2.2) S2G (RBM-R) 03-04-20: Mapeo Código Servicio y Cuenta Contable
        GLAccNo := '';
        IF rlMap.GET(pServiceCode) THEN
            GLAccNo := rlMap."G/L Account No.";
    end;

    local procedure fFindCustomer(rlRecibosRemesa: Record "EDUCAMOS RecibosRemesa") NAVCustomer: Code[20]
    var
        rlCust: Record Customer;
        rlThirdParty: Record "Third Party";
        NewThirdParty: Record "Third Party";
    begin
        // NAVCustomer := '';

        // rlCust.RESET;
        // rlCust.SETCURRENTKEY("EDUCAMOS id_unique_pagador");
        // rlCust.SETRANGE("EDUCAMOS id_unique_pagador", rlRecibosRemesa.id_unique_pagador);
        // IF rlCust.FINDFIRST THEN
        //     NAVCustomer := rlCust."No."
        // ELSE BEGIN
        //     rlCust.RESET;
        //     rlCust.SETCURRENTKEY("VAT Registration No.");
        //     rlCust.SETRANGE("VAT Registration No.", rlRecibosRemesa.nif_pagador);
        //     IF rlCust.FINDFIRST THEN
        //         NAVCustomer := rlCust."No."
        //     ELSE BEGIN
        //         rlThirdParty.RESET;
        //         rlThirdParty.SETCURRENTKEY("EDUCAMOS id_unique_pagador");
        //         rlThirdParty.SETRANGE("EDUCAMOS id_unique_pagador", rlRecibosRemesa.id_unique_pagador);
        //         IF rlThirdParty.FINDFIRST THEN
        //             NAVCustomer := fCreateCustomer(rlRecibosRemesa, rlThirdParty)
        //         ELSE BEGIN
        //             rlThirdParty.RESET;
        //             rlThirdParty.SETCURRENTKEY("VAT Registration No.");
        //             rlThirdParty.SETRANGE("VAT Registration No.", rlRecibosRemesa.nif_pagador);
        //             IF rlThirdParty.FINDFIRST THEN
        //                 NAVCustomer := fCreateCustomer(rlRecibosRemesa, rlThirdParty)
        //             ELSE BEGIN
        //                 fCreateThirdParty(rlRecibosRemesa, NewThirdParty);
        //                 NAVCustomer := fCreateCustomer(rlRecibosRemesa, NewThirdParty);
        //             END;
        //         END;
        //     END;
        // END;
    end;

    local procedure fCreateThirdParty(pRecibosRemesa: Record "EDUCAMOS RecibosRemesa"; var pThirdParty: Record "Third Party")
    var
        rlSetup: Record "EDUCAMOS Setup";
    begin
        // rlSetup.GET;

        // pThirdParty."No." := '';
        // pThirdParty.VALIDATE(Name, COPYSTR(pRecibosRemesa.nombre_pagador + ' ' + pRecibosRemesa.apellidos_pagador, 1, 50));
        // pThirdParty."Name 2" := COPYSTR(pRecibosRemesa.nombre_pagador + ' ' + pRecibosRemesa.apellidos_pagador, 51, 50);
        // pThirdParty.Address := COPYSTR(pRecibosRemesa.direccion_pagador, 1, 50);
        // pThirdParty."Address 2" := COPYSTR(pRecibosRemesa.direccion_pagador, 51, 50);
        // pThirdParty.VALIDATE(City, COPYSTR(pRecibosRemesa.localidad_pagador, 1, 30));
        // pThirdParty.County := COPYSTR(pRecibosRemesa.provincia_pagador, 1, 30);
        // // S2G (JPB) Saltar la validación de CIF/NIF al crear tercero. INICIO
        // pThirdParty."VAT Registration No." := pRecibosRemesa.nif_pagador;
        // // S2G (JPB) Saltar la validación de CIF/NIF al crear tercero. FIN
        // pThirdParty."Post Code" := pRecibosRemesa.cp_pagador;
        // pThirdParty."Customer Template Code" := rlSetup."Thirdparty Template Code";
        // pThirdParty."EDUCAMOS id_unique_pagador" := pRecibosRemesa.id_unique_pagador;
        // IF pThirdParty.INSERT(TRUE) THEN
        //     fSetLog(1, STRSUBSTNO(Text001, pThirdParty."No.", pRecibosRemesa.id_unique_pagador), COMPANYNAME, 1);
    end;

    local procedure fCreateCustomer(rlRecibosRemesa: Record "EDUCAMOS RecibosRemesa"; pThirdParty: Record "Third Party") NAVCustomer: Code[20]
    var
        cuFunctionsS2G: Codeunit "Functions S2G";
        rlCust: Record Customer;
    begin
        // //Crear el cliente partiendo del nº de tercero existente y asignándole el peducamos
        // CLEAR(cuFunctionsS2G);
        // NAVCustomer := '';

        // cuFunctionsS2G.fFromEducamosInterface;
        // cuFunctionsS2G.EnableCustVendBasedOnThirdParty(pThirdParty, 0, NAVCustomer, COMPANYNAME);

        // rlCust.GET(NAVCustomer);
        // rlCust."EDUCAMOS id_unique_pagador" := rlRecibosRemesa.id_unique_pagador;
        // rlCust.MODIFY;

        // IF rlRecibosRemesa.nif_pagador <> '' THEN
        //     fSetLog(1, STRSUBSTNO(Text002, NAVCustomer, rlRecibosRemesa.id_unique_pagador), COMPANYNAME, 1)
        // ELSE
        //     fSetLog(2, STRSUBSTNO(Text002, NAVCustomer, rlRecibosRemesa.id_unique_pagador) + Text004, COMPANYNAME, 1);
    end;

    local procedure fCreateLineDiscount(pAlumnoConcepto: Record "EDUCAMOS AlumnoConcepto"; pSalesLine: Record "Sales Line"; var pRealUnitPrice: Decimal)
    var
        rlConceptoDescuento: Record "EDUCAMOS ConceptoDescuento";
        rlConceptoDescuentoAux: Record "EDUCAMOS ConceptoDescuento";
        rlSetup: Record "EDUCAMOS Setup";
        rlSalesLine: Record "Sales Line";
        rlDimValue: Record "Dimension Value";
        clDimValue: Code[20];
        ilLineNo: Integer;
        i: Integer;
    begin
        pRealUnitPrice := 0;
        i := 1;
        ilLineNo := pSalesLine."Line No." + 1;  //De 1 en 1 y así es más claro saber qué linea se generó como descuento aunque se cambie la cuenta...
        rlSetup.GET;
        rlConceptoDescuento.RESET;
        rlConceptoDescuento.SETCURRENTKEY(Processed, id_unique_recibo);
        rlConceptoDescuento.SETRANGE(Processed, FALSE);
        rlConceptoDescuento.SETRANGE(id_unique_recibo, pAlumnoConcepto.id_unique_recibo);

        //(CR005) S2G (RBM-R) 29-11-18: Modificaciones Interfaz Educamos. Inicio
        rlConceptoDescuento.SETRANGE(id_unique_concepto, pAlumnoConcepto.id_unique_concepto);
        //(CR005) S2G (RBM-R) 29-11-18: Modificaciones Interfaz Educamos. Fin

        IF rlConceptoDescuento.FINDSET THEN
            REPEAT  //por si tienen varios descuentos
                Window.UPDATE(4, ROUND(i / rlConceptoDescuento.COUNT * 10000, 1));
                rlSalesLine.INIT;
                rlSalesLine := pSalesLine;
                rlSalesLine."Line No." := ilLineNo;
                rlSalesLine.VALIDATE("No.", rlConceptoDescuento.cuenta_contable);
                rlSalesLine.VALIDATE(Quantity, -1);
                rlSalesLine.VALIDATE("Unit Price", rlConceptoDescuento.cantidad_descuento);
                rlSalesLine.Description := rlConceptoDescuento.nombre_descuento;

                //(Varios) S2G (RBM-R) Modificaciones Interfaz Educamos. Inicio
                clDimValue := '';
                IF fGetEtapaEducativa(pAlumnoConcepto.id_unique_alumno, vSchoolID, clDimValue) THEN
                    rlSalesLine.VALIDATE("Shortcut Dimension 1 Code", clDimValue);

                IF NOT rlDimValue.GET(txtActividad, pAlumnoConcepto.reducido_concepto) THEN BEGIN
                    rlDimValue.INIT;
                    rlDimValue."Dimension Code" := txtActividad;
                    rlDimValue.Code := pAlumnoConcepto.reducido_concepto;
                    rlDimValue.Name := COPYSTR(STRSUBSTNO(txtDim, pAlumnoConcepto.nombre_concepto), 1, MAXSTRLEN(rlDimValue.Name));
                    rlDimValue.INSERT(TRUE);

                    fSetLog(2, STRSUBSTNO(Warning006, pAlumnoConcepto.reducido_concepto), rlSalesLine."Document No.", 2);
                END;
                rlSalesLine.VALIDATE("Shortcut Dimension 2 Code", pAlumnoConcepto.reducido_concepto);
                //(Varios) S2G (RBM-R) Modificaciones Interfaz Educamos. Fin

                rlSalesLine.INSERT(TRUE);
                ilLineNo += 1;
                pRealUnitPrice += rlConceptoDescuento.cantidad_descuento;

                //(CR005) S2G (RBM-R) 29-11-18: Modificaciones Interfaz Educamos. Inicio
                //rlConceptoDescuentoAux.GET(rlConceptoDescuento.id_unique_recibo,rlConceptoDescuento.id_unique_descuento);
                rlConceptoDescuentoAux.GET(rlConceptoDescuento.id_unique_recibo, rlConceptoDescuento.id_unique_concepto, rlConceptoDescuento.id_unique_descuento);
                //(CR005) S2G (RBM-R) 29-11-18: Modificaciones Interfaz Educamos. Fin

                rlConceptoDescuentoAux.Processed := TRUE;
                rlConceptoDescuentoAux.MODIFY;
                i += 1;
            UNTIL rlConceptoDescuento.NEXT = 0;

        pRealUnitPrice += pAlumnoConcepto.importe_neto;
    end;

    local procedure fFindSalesHeader(pCustNo: Code[20]; pExtDocNo: Code[35]): Code[20]
    var
        rlSalesInvHdr: Record "Sales Invoice Header";
    begin
        //(2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados
        rlSalesInvHdr.SETCURRENTKEY("Sell-to Customer No.", "External Document No.");
        rlSalesInvHdr.SETRANGE("Sell-to Customer No.", pCustNo);
        rlSalesInvHdr.SETRANGE("External Document No.", pExtDocNo);
        IF rlSalesInvHdr.FINDFIRST THEN //no debería haber más de uno...
            EXIT(rlSalesInvHdr."No.");

        EXIT('');
    end;

    procedure fSetLog(ErrorType: Option " ",OK,Aviso,Error; MessageText: Text; ExtraInfo: Text; Indent: Integer)
    var
        rlLog: Record "EDUCAMOS Integration Log";
    begin
        rlLog.Init();
        rlLog."Log Status" := ErrorType;
        rlLog."Log Text" := CopyStr(MessageText, 1, 250);
        rlLog."Process DateTime" := CurrentDateTime();
        rlLog."Extra info" := ExtraInfo;
        rlLog.Indentation := Indent;
        rlLog.Insert(true);

        //++APAREJA
    end;

    procedure fSetLogWithResponse(ErrorType: Option " ",OK,Aviso,Error; MessageText: Text; ExtraInfo: Text; Indent: Integer; TempBlob: Codeunit "Temp Blob")
    var
        rlLog: Record "EDUCAMOS Integration Log";
        InStr: InStream;
        OuStr: OutStream;
    begin
        rlLog.INIT;
        rlLog."Log Status" := ErrorType;
        rlLog."Log Text" := COPYSTR(MessageText, 1, 250);
        rlLog."Process DateTime" := CURRENTDATETIME;
        rlLog."Extra info" := ExtraInfo;

        //gr adaptar el el tempBlop
        TempBlob.CreateInStream(InStr);
        rlLog."Errores Doc".CreateOutStream(OuStr);
        CopyStream(OuStr, InStr);

        rlLog.Indentation := Indent;
        rlLog.INSERT(TRUE);
        //--APAREJA
    end;
}
