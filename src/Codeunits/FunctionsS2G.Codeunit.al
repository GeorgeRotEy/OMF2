codeunit 50001 "Functions S2G"
{
    // // Mod. S2G 16/12/2017 (JGS) : GF001 ã Plan de cuentas corporativo.
    //             Modified functions
    //                      fDesarrolloPLC
    //                      fIndentar
    //                      fTraerCuentasCorporativas
    //                      fCrearCuentaCorporativa
    //                      fModificarCuentaCorporativa
    //                      fControlTipoGestionPlan
    //                      fTipoGestiónPlanCuentas
    //                      fLookupCuentaConsolidada
    //
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos
    // (CR003) S2G (GRL) 22-04-19: Forzar campo CIF en Terceros. Inicio
    // (Varios) S2G (RBM-R) 27-05-19 Modificaciones Interfaz Educamos: No validar CIF/NIF en procesos de interfaz
    //
    // (SIDS-466) S2G (LAG) 26-02-20: Mod dimensiones acceso directo
    //   New Function:
    //     -OnAfterInsertGLEntryDim
    //     -OnAfterInsertBankAccLE

    Permissions = TableData "Payment Terms" = rimd,
                  TableData Currency = rimd,
                  TableData "G/L Entry" = rimd,
                  TableData "Cust. Ledger Entry" = rimd,
                  TableData "Vendor Ledger Entry" = rimd,
                  TableData "Bank Account Ledger Entry" = rimd,
                  TableData "VAT Business Posting Group" = rimd,
                  TableData "FA Ledger Entry" = rimd,
                  TableData "Cartera Doc." = rimd,
                  TableData "Posted Cartera Doc." = rimd,
                  TableData "Closed Cartera Doc." = rimd;

    var
        bSkipConfirm: Boolean;
        TextPLC50000Lbl: Label 'Are you absolutely sure that you want to change the value of field% 1 to% 2?', Comment = 'ESP="¿Está completamente seguro de que desea cambiar el valor del campo %1 a %2?"';
        TextPLC50001Lbl: Label 'It brings %1 accounts of Corporate Plan of %2 selected', Comment = 'ESP="Se han traído %1 cuentas del Plan Corporativo de %2 seleccionadas"';
        TextPLC50002Lbl: Label 'You can not do this because the company follows the Corporative GL Account.', Comment = 'ESP="No puede hacer esto porque la empresa sigue el plan contable corporativo."';
        TextPLC50003Lbl: Label 'Will modify each account of accounts current plan for having the same values as Corporate account Plan. Do you want to continue?', Comment = 'ESP="Se modificará cada cuenta del plan actual para que tenga los mismos valores que el Plan de Cuentas Corporativo. ¿Desea continuar?"';
        TextPLC50005Lbl: Label 'This function checks the consistency of and completes the Chart of Accounts:\\', Comment = 'ESP="Esta función comprueba la consistencia y completa el plan de cuentas:\\\"';
        TextPLC50006Lbl: Label '- Checks that a corresponding heading account exists for every posting account.\', Comment = 'ESP="- Comprueba que existe una cuenta de encabezado correspondiente para cada cuenta de registro.\\"';
        TextPLC50007Lbl: Label '- Checks that all accounts comply with the Chart of Account account length requisites.\', Comment = 'ESP="- Comprueba que todas las cuentas cumplen los requisitos de longitud del plan de cuentas.\\"';
        TextPLC50008Lbl: Label '- Assigns values to the following fields: Income/Balance/Capital, Account Type, Indentation, Totaling and Debit/Credit.\', Comment = 'ESP="- Asigna valores a los siguientes campos: Comercial/Balance/Capital, Tipo de cuenta, Indentación, Sumatorio y Debe/Haber.\\"';
        TextPLC50009Lbl: Label '- Checks that an Adjustment Account exists for every account of the Income Statement and Capital types. \\', Comment = 'ESP="- Comprueba que existe una cuenta de regularización para cada cuenta de los tipos Pérdidas y Ganancias y Capital. \\\\"';
        TextPLC50010Lbl: Label 'Do you wish to check the Chart of Accounts?', Comment = 'ESP="¿Desea comprobar el plan de cuentas?"';
        TextPLC50011Lbl: Label 'Checking the Chart of Accounts #1########## @2@@@@@@@@@@@@@', Comment = 'ESP="Comprobando el plan de cuentas #1########## @2@@@@@@@@@@@@@"';
        TextPLC50012Lbl: Label 'The length of a heading account cannot be greater than 8, account %1', Comment = 'ESP="La longitud de una cuenta de encabezado no puede ser mayor que 8, cuenta %1"';
        TextPLC50013Lbl: Label ' Missing group %1 - Account No. %2', Comment = 'ESP=" Falta el grupo %1 - Nº cuenta %2"';
        TextPLC50014Lbl: Label '..';
        TextPLC50015Lbl: Label ' Missing group %1 - Account No. %2', Comment = 'ESP=" Falta el grupo %1 - Nº cuenta %2"';
        TextPLC50016Lbl: Label 'The length of account %1 cannot be different than the next ones', Comment = 'ESP="La longitud de la cuenta %1 no puede ser diferente de las siguientes"';
        TextPLC50017Lbl: Label 'The Chart of Accounts is correct.', Comment = 'ESP="El plan de cuentas es correcto."';
        ConfirmCustVendEnabledLbl: Label 'Do you want to enable %1 for third party %2 on company %3?', Comment = 'ESP="¿Desea habilitar %1 para el tercero %2 en la empresa %3?"';
        ConfirmCustVendDisabledLbl: Label 'Do you want to disable %1 for third party %2 on company %3?', Comment = 'ESP="¿Desea deshabilitar %1 para el tercero %2 en la empresa %3?"';
        CentralizedThirdPartyMgtIssueLbl: Label 'This company has centralized third party management. Please perform updates from third party card', Comment = 'ESP="Esta empresa tiene la gestión de terceros centralizada. Realice las actualizaciones desde la ficha de tercero"';

    procedure fIndentar()
    var
        rlBuscarPlanCorporativo: Record "Plan Corporativo";
        rlPlanCorporativo: Record "Plan Corporativo";
        vlWindow: Dialog;
        vlLineCounter: Integer;
        vlNoOfRecords: Integer;
        vlHidePrintDialog: Boolean;
    begin
        // Mod. S2G 16/12/2017 (JGS) : GF001 ã begin
        IF NOT CONFIRM(
          TextPLC50005Lbl +
          TextPLC50006Lbl +
          TextPLC50007Lbl +
          TextPLC50008Lbl +
          TextPLC50009Lbl +
          TextPLC50010Lbl, TRUE)
        THEN
            EXIT;
        vlWindow.OPEN(TextPLC50011Lbl);

        rlPlanCorporativo.RESET();
        vlLineCounter := 0;
        vlNoOfRecords := rlPlanCorporativo.COUNT;
        IF vlNoOfRecords <> 0 THEN
            IF rlPlanCorporativo.FIND('-') THEN
                REPEAT
                    vlWindow.UPDATE(1, rlPlanCorporativo."No.");

                    rlPlanCorporativo.TESTFIELD(Name);

                    IF STRLEN(rlPlanCorporativo."No.") > 5 THEN
                        rlPlanCorporativo."Account Type" := rlPlanCorporativo."Account Type"::Posting
                    ELSE
                        rlPlanCorporativo."Account Type" := rlPlanCorporativo."Account Type"::Heading;

                    IF rlPlanCorporativo."Account Type" = rlPlanCorporativo."Account Type"::Heading THEN BEGIN
                        //The length of a heading account cannot be greater than 9
                        IF STRLEN(rlPlanCorporativo."No.") > 8 THEN
                            ERROR(TextPLC50012Lbl, rlPlanCorporativo."No.");
                        //a heading account must exist at the previous higher level
                        IF STRLEN(rlPlanCorporativo."No.") > 1 THEN
                            IF NOT rlBuscarPlanCorporativo.GET(COPYSTR(rlPlanCorporativo."No.", 1, STRLEN(rlPlanCorporativo."No.") - 1)) THEN
                                ERROR(TextPLC50013Lbl, COPYSTR(rlPlanCorporativo."No.", 1, STRLEN(rlPlanCorporativo."No.") - 1), rlPlanCorporativo."No.");
                        rlPlanCorporativo.Totaling := rlPlanCorporativo."No." + TextPLC50014Lbl + PADSTR(rlPlanCorporativo."No.", 20 - (STRLEN(rlPlanCorporativo."No.") + 2), '9');
                        rlPlanCorporativo.Indentation := STRLEN(rlPlanCorporativo."No.") - 1;
                    END ELSE BEGIN
                        //the corresponding heading account must exist
                        IF NOT rlBuscarPlanCorporativo.GET(COPYSTR(rlPlanCorporativo."No.", 1, 3)) THEN
                            ERROR(TextPLC50015Lbl, COPYSTR(rlPlanCorporativo."No.", 1, 3), rlPlanCorporativo."No.");
                        //a posting account must be the same length as the next
                        rlBuscarPlanCorporativo := rlPlanCorporativo;
                        IF rlBuscarPlanCorporativo.NEXT() <> 0 THEN
                            IF (rlBuscarPlanCorporativo."Account Type" = rlBuscarPlanCorporativo."Account Type"::Posting) AND
                               (STRLEN(rlPlanCorporativo."No.") <> STRLEN(rlBuscarPlanCorporativo."No.")) THEN
                                ERROR(TextPLC50016Lbl, rlPlanCorporativo."No.");

                        IF COPYSTR(rlPlanCorporativo."No.", 1, 1) IN ['6', '7'] THEN
                            rlPlanCorporativo."Income/Balance" := rlPlanCorporativo."Income/Balance"::"Income Statement"
                        ELSE
                            IF COPYSTR(rlPlanCorporativo."No.", 1, 1) IN ['8', '9'] THEN
                                rlPlanCorporativo."Income/Balance" := rlPlanCorporativo."Income/Balance"::Capital
                            ELSE
                                rlPlanCorporativo."Income/Balance" := rlPlanCorporativo."Income/Balance"::"Balance Sheet";

                        IF rlPlanCorporativo."Income/Balance" IN [rlPlanCorporativo."Income/Balance"::"Income Statement", rlPlanCorporativo."Income/Balance"::Capital] THEN
                            rlPlanCorporativo.TESTFIELD("Income Stmt. Bal. Acc.")
                        ELSE
                            rlPlanCorporativo."Income Stmt. Bal. Acc." := '';
                        rlPlanCorporativo.Indentation := 4;
                    END;

                    rlPlanCorporativo.MODIFY();
                    vlLineCounter := vlLineCounter + 1;
                    vlWindow.UPDATE(2, ROUND(vlLineCounter / vlNoOfRecords * 10000, 1));
                UNTIL rlPlanCorporativo.NEXT() = 0;

        vlWindow.CLOSE();
        IF NOT vlHidePrintDialog THEN
            MESSAGE(TextPLC50017Lbl);
        // Mod. S2G 16/12/2017 (JGS) : GF001 ã end
    end;

    //GR-ADD-020225
    // procedure fTraerCuentasCorporativas()
    // var
    //     rltAuxPlanCorporativo: Record 50006 temporary;
    //     rlPlanCorporativo: Record "Plan Corporativo";
    //     vlContadorTraidas: Integer;
    //     vlContadorSeleccionadas: Integer;
    //     rlGLAccount: Record "G/L Account";
    //     PlAuxPlanCorporativo: Page "Aux. Corporate Plan";
    // begin
    //     // Mod. S2G 16/12/2017 (JGS) : GF001 ã begin
    //     CLEAR(rltAuxPlanCorporativo);
    //     rltAuxPlanCorporativo.DELETEALL();

    //     CLEAR(rlPlanCorporativo);
    //     IF rlPlanCorporativo.FIND('-') THEN
    //         REPEAT
    //             CLEAR(rltAuxPlanCorporativo);
    //             rltAuxPlanCorporativo.TRANSFERFIELDS(rlPlanCorporativo);
    //             //indicar si la cuenta existe en el plan de cuentas     //Indicate if the account exists in accounts plan
    //             CLEAR(rlGLAccount);
    //             IF rlGLAccount.GET(rlPlanCorporativo."No.") THEN
    //                 rltAuxPlanCorporativo."Existe en plan" := TRUE;
    //             rltAuxPlanCorporativo.INSERT();
    //         UNTIL rlPlanCorporativo.NEXT() = 0;

    //     vlContadorTraidas := 0;
    //     vlContadorSeleccionadas := 0;
    //     CLEAR(rltAuxPlanCorporativo);
    //     CLEAR(PlAuxPlanCorporativo);
    //     //PlAuxPlanCorporativo.LOOKUPMODE :=TRUE;
    //     //PlAuxPlanCorporativo.SETTABLEVIEW(rltAuxPlanCorporativo);
    //     //rltAuxPlanCorporativo.SETRANGE("Existe en plan",FALSE);
    //     IF PAGE.RUNMODAL(0, rltAuxPlanCorporativo) = ACTION::LookupOK THEN BEGIN
    //         //IF (PlAuxPlanCorporativo.RUNMODAL=ACTION :: LookupOK) THEN BEGIN
    //         CLEAR(rltAuxPlanCorporativo);
    //         rltAuxPlanCorporativo.SETRANGE(Acción, rltAuxPlanCorporativo.Acción::Traer);
    //         IF rltAuxPlanCorporativo.FIND('-') THEN
    //             REPEAT
    //                 vlContadorSeleccionadas += 1;
    //                 IF fCrearCuentaCorporativa(rltAuxPlanCorporativo, COMPANYNAME) THEN
    //                     vlContadorTraidas += 1;
    //             UNTIL rltAuxPlanCorporativo.NEXT() = 0;
    //     END;
    //     MESSAGE(TextPLC50001Lbl, vlContadorTraidas, vlContadorSeleccionadas);
    //     // Mod. S2G 16/12/2017 (JGS) : GF001 ã end
    // end;

    //GR-Modify-020326
    procedure fTraerCuentasCorporativas()
    var
        rlGLAccount: Record "G/L Account";
        TemprltAuxPlanCorporativo: Record "Aux plan corporativo" temporary;
        rlPlanCorporativo: Record "Plan Corporativo";
        PlAuxPlanCorporativo: Page "Aux. Corporate Plan";
        vlContadorTraidas: Integer;
        vlContadorSeleccionadas: Integer;
    begin
        TemprltAuxPlanCorporativo.DeleteAll();

        if rlPlanCorporativo.FindSet() then
            repeat
                TemprltAuxPlanCorporativo.Init();
                TemprltAuxPlanCorporativo.TransferFields(rlPlanCorporativo);

                if rlGLAccount.Get(rlPlanCorporativo."No.") then
                    TemprltAuxPlanCorporativo."Existe en plan" := true;

                TemprltAuxPlanCorporativo.Insert();
            until rlPlanCorporativo.Next() = 0;

        // DEBUG: confirmar si realmente has cargado registros
        Message(
            'Plan Corporativo (SQL): %1\Aux temporal (50006): %2',
            rlPlanCorporativo.Count(),
            TemprltAuxPlanCorporativo.Count());

        vlContadorTraidas := 0;
        vlContadorSeleccionadas := 0;

        PlAuxPlanCorporativo.SetTableView(TemprltAuxPlanCorporativo);
        PlAuxPlanCorporativo.LookupMode(true);

        if Page.RunModal(Page::"Aux. Corporate Plan") = Action::LookupOK then begin
            TemprltAuxPlanCorporativo.Reset();
            TemprltAuxPlanCorporativo.SetRange(Acción, TemprltAuxPlanCorporativo.Acción::Traer);

            if TemprltAuxPlanCorporativo.FindSet() then
                repeat
                    vlContadorSeleccionadas += 1;
                    if fCrearCuentaCorporativa(TemprltAuxPlanCorporativo, CompanyName) then
                        vlContadorTraidas += 1;
                until TemprltAuxPlanCorporativo.Next() = 0;
        end;

        Message(TextPLC50001Lbl, vlContadorTraidas, vlContadorSeleccionadas);
    end;

    //GR-ADD-020225
    procedure fCrearCuentaCorporativa(prAuxPlanCorporativo: Record "Aux plan corporativo"; pEmpresa: Text[50]): Boolean
    var
        rlGLAccount: Record "G/L Account";
    begin
        // Mod. S2G 16/12/2017 (JGS) : GF001 ã begin
        CLEAR(rlGLAccount);
        rlGLAccount.CHANGECOMPANY(pEmpresa);
        IF NOT rlGLAccount.GET(prAuxPlanCorporativo."Nº") THEN BEGIN
            CLEAR(rlGLAccount);
            rlGLAccount.fDesdeCuentaCorporativa(TRUE);
            rlGLAccount.fCambiarCompañia(pEmpresa);
            rlGLAccount.VALIDATE("No.", prAuxPlanCorporativo."Nº");
            rlGLAccount.INSERT(TRUE);
            fModificarCuentaCorporativa(rlGLAccount, prAuxPlanCorporativo, TRUE, TRUE, TRUE);
            rlGLAccount.fCambiarCompañia(pEmpresa);
            rlGLAccount.fDesdeCuentaCorporativa(FALSE);
            EXIT(TRUE);
        END;
        EXIT(FALSE);
        // Mod. S2G 16/12/2017 (JGS) : GF001 ã end
    end;

    //GR-ADD-020225
    procedure fModificarCuentaCorporativa(var prGLAccount: Record "G/L Account"; var prAuxPlanCorporativo: Record "Aux plan corporativo"; pModificarEntradaDirecta: Boolean; pModificarCtaConsolDebe: Boolean; pModificarCtaConsolHaber: Boolean)
    begin
        // Mod. S2G 16/12/2017 (JGS) : GF001 ã begin
        prGLAccount.VALIDATE(Name, prAuxPlanCorporativo.Nombre);
        //prGLAccount."Descripcion amplia" := prAuxPlanCorporativo."Descripción amplia";
        prGLAccount.VALIDATE("Search Name", prAuxPlanCorporativo.Alias);
        prGLAccount.VALIDATE("Account Type", prAuxPlanCorporativo."Tipo mov.");
        prGLAccount.VALIDATE("Income/Balance", prAuxPlanCorporativo."Comercial/Balance");
        prGLAccount.VALIDATE("Debit/Credit", prAuxPlanCorporativo."Debe/Haber");
        IF pModificarEntradaDirecta THEN
            prGLAccount.VALIDATE("Direct Posting", prAuxPlanCorporativo."Entrada directa");
        prGLAccount.VALIDATE(Indentation, prAuxPlanCorporativo.Indentar);
        prGLAccount.VALIDATE(Totaling, prAuxPlanCorporativo.Sumatorio);
        IF pModificarCtaConsolDebe THEN
            prGLAccount.VALIDATE("Consol. Debit Acc.", prAuxPlanCorporativo."Cta. consol. debe");
        IF pModificarCtaConsolHaber THEN
            prGLAccount.VALIDATE("Consol. Credit Acc.", prAuxPlanCorporativo."Cta. consol. haber");
        prGLAccount.VALIDATE("Gen. Posting Type", prAuxPlanCorporativo."Tipo IVA");
        prGLAccount.VALIDATE("Income Stmt. Bal. Acc.", prAuxPlanCorporativo."Cta. regularización");
        //prGLAccount."Identifica anticipo" := prAuxPlanCorporativo."Identifica anticipos";
        //prGLAccount."Identifica facts ptes" := prAuxPlanCorporativo."Identifica facts ptes";
        //prGLAccount."Identifica fianza" := prAuxPlanCorporativo."Identifica fianza";

        //Actualizar tipos de coste con el plan corporativo.    //Update costs types with corporate plan
        prGLAccount."Cost Type No." := prAuxPlanCorporativo."Nº tipo coste";
        prGLAccount.MODIFY(TRUE);
        // Mod. S2G 16/12/2017 (JGS) : GF001 ã end
    end;

    procedure fControlTipoGestionPlan("pInserciónCuentaCorporativa": Boolean)
    var
        rlGeneralLedgerSetup: Record "General Ledger Setup";
    begin
        // Mod. S2G 16/12/2017 (JGS) : GF001 ã begin
        CLEAR(rlGeneralLedgerSetup);
        rlGeneralLedgerSetup.GET();
        IF rlGeneralLedgerSetup."Tipo gestión plan de cuentas" =
           rlGeneralLedgerSetup."Tipo gestión plan de cuentas"::Corporativo THEN
            IF NOT pInserciónCuentaCorporativa THEN
                ERROR(TextPLC50002Lbl);
        // Mod. S2G 16/12/2017 (JGS) : GF001 ã end
    end;

    procedure fTipoGestionPlanCuentas(prGeneralLedgerSetup: Record "General Ledger Setup")
    var
        rlGLAccount: Record "G/L Account";
        rlPlanCorporativo: Record "Plan Corporativo";
    begin
        // Mod. S2G 16/12/2017 (JGS) : GF001 ã begin
        IF CONFIRM(TextPLC50000Lbl, FALSE,
                             prGeneralLedgerSetup.FIELDCAPTION("Tipo gestión plan de cuentas"),
                             prGeneralLedgerSetup."Tipo gestión plan de cuentas") THEN
            IF prGeneralLedgerSetup."Tipo gestión plan de cuentas" =
                                 prGeneralLedgerSetup."Tipo gestión plan de cuentas"::Corporativo THEN
                IF CONFIRM(TextPLC50003Lbl, FALSE) THEN BEGIN
                    CLEAR(rlGLAccount);
                    IF rlGLAccount.FIND('-') THEN
                        REPEAT
                            CLEAR(rlPlanCorporativo);
                            rlPlanCorporativo.GET(rlGLAccount."No.");
                            rlGLAccount.fDesdeCuentaCorporativa(TRUE);
                            rlGLAccount.VALIDATE(Name, rlPlanCorporativo.Name);
                            rlGLAccount.VALIDATE("Search Name", rlPlanCorporativo."Search Name");
                            rlGLAccount.VALIDATE("Account Type", rlPlanCorporativo."Account Type");
                            rlGLAccount.VALIDATE("Income/Balance", rlPlanCorporativo."Income/Balance");
                            rlGLAccount.VALIDATE("Debit/Credit", rlPlanCorporativo."Debit/Credit");
                            rlGLAccount.VALIDATE("Direct Posting", rlPlanCorporativo."Direct Posting");
                            rlGLAccount.VALIDATE(Indentation, rlPlanCorporativo.Indentation);
                            rlGLAccount.VALIDATE(Totaling, rlPlanCorporativo.Totaling);
                            rlGLAccount.VALIDATE("Consol. Debit Acc.", rlPlanCorporativo."Consol. Debit Acc.");
                            rlGLAccount.VALIDATE("Consol. Credit Acc.", rlPlanCorporativo."Consol. Credit Acc.");
                            rlGLAccount.VALIDATE("Gen. Posting Type", rlPlanCorporativo."Gen. Posting Type");
                            rlGLAccount.VALIDATE("Income Stmt. Bal. Acc.", rlPlanCorporativo."Income Stmt. Bal. Acc.");
                            //rlGLAccount."Descripcion amplia" := rlPlanCorporativo."Descripción amplia";
                            //rlGLAccount."Identifica anticipo" := rlPlanCorporativo."Identifica anticipo";
                            //rlGLAccount."Identifica facts ptes"  := rlPlanCorporativo."Identifica facts ptes";
                            //rlGLAccount."Identifica fianza" := rlPlanCorporativo."Identifica fianza";

                            //(TES36): Stand by
                            //rlGLAccount."Cód. procedencia obligatorio" := rlPlanCorporativo."Cód. procedencia obligatorio";
                            //rlGLAccount."Tipo procedencia ant/prov." := rlPlanCorporativo."Tipo procedencia ant/prov.";
                            //(TES36): Stand by
                            rlGLAccount.MODIFY(TRUE);
                            rlGLAccount.fDesdeCuentaCorporativa(FALSE);
                        UNTIL rlGLAccount.NEXT() = 0;
                END;
        // Mod. S2G 16/12/2017 (JGS) : GF001 ã end
    end;

    procedure fLookupCuentaConsolidada()
    begin
    end;

    local procedure InsertSourceCode(var SourceCodeDefCode: Code[10]; "Code": Code[10]; Description: Text[50])
    var
        SourceCode: Record "Source Code";
    begin
        SourceCodeDefCode := Code;
        SourceCode.INIT();
        SourceCode.Code := Code;
        SourceCode.Description := Description;
        SourceCode.INSERT();
    end;

    procedure DisableCustVendFromThirdParty(var pThirdParty: Record "Third Party"; pThirdPartyType: Option Customer,Vendor; CompName: Text[30])
    var
        Cust: Record Customer;
        Vend: Record Vendor;
    begin
        // TE001 - Maestro de terceros.begin
        IF pThirdPartyType = pThirdPartyType::Customer THEN BEGIN
            IF NOT CONFIRM(STRSUBSTNO(ConfirmCustVendDisabledLbl, Cust.TABLECAPTION, pThirdParty."No.", CompName)) THEN
                EXIT;

            Cust.RESET();
            Cust.CHANGECOMPANY(CompName);
            Cust.SETCURRENTKEY("Third Party No.");
            Cust.SETRANGE("Third Party No.", pThirdParty."No.");
            IF Cust.FINDLAST() THEN BEGIN
                // Mod. S2G (IVC).Begin
                //Chequeamos que no tenga Saldo
                Cust.CALCFIELDS(Balance);
                Cust.TESTFIELD(Balance, 0);
                //
                // Mod. S2G (IVC).End
                // Disable customer
                Cust.Disabled := TRUE;
                Cust.MODIFY();
                //pCustVendNo := '';
            END;
        END ELSE BEGIN
            IF NOT CONFIRM(STRSUBSTNO(ConfirmCustVendDisabledLbl, Vend.TABLECAPTION, pThirdParty."No.", CompName)) THEN
                EXIT;

            Vend.RESET();
            Vend.CHANGECOMPANY(CompName);
            Vend.SETCURRENTKEY("Third Party No.");
            Vend.SETRANGE("Third Party No.", pThirdParty."No.");
            IF Vend.FINDLAST() THEN BEGIN
                // Mod. S2G (IVC).Begin
                //Chequeamos que no tenga Saldo
                Vend.CALCFIELDS(Balance);
                Vend.TESTFIELD(Balance, 0);
                //
                // Mod. S2G (IVC).End
                // Disable vendor
                Vend.Disabled := TRUE;
                Vend.MODIFY();
                //pCustVendNo := '';
            END;
        END;
        // TE001 - Maestro de terceros.end
    end;

    local procedure UpdateThirdPartyBankAccounts(pThirdPartyType: Option Customer,Vendor; pThirdPartyNo: Code[20]; pCustVendNo: Code[20]; CompName: Text[30])
    var
        ThirdPartyBankAcc: Record "Third Party Bank Account";
        CustBankAcc: Record "Customer Bank Account";
        VendBankAcc: Record "Vendor Bank Account";
    begin
        // TE001 - Maestro de terceros.begin
        ThirdPartyBankAcc.RESET();
        ThirdPartyBankAcc.SETRANGE("Third Party No.", pThirdPartyNo);
        IF ThirdPartyBankAcc.FINDFIRST() THEN
            REPEAT
                IF pThirdPartyType = pThirdPartyType::Customer THEN BEGIN
                    CustBankAcc.INIT();
                    CustBankAcc.CHANGECOMPANY(CompName);
                    CustBankAcc.TRANSFERFIELDS(ThirdPartyBankAcc);
                    CustBankAcc."Customer No." := pCustVendNo;
                    IF NOT CustBankAcc.INSERT() THEN
                        CustBankAcc.MODIFY();
                END ELSE BEGIN
                    VendBankAcc.INIT();
                    VendBankAcc.CHANGECOMPANY(CompName);
                    VendBankAcc.TRANSFERFIELDS(ThirdPartyBankAcc);
                    VendBankAcc."Vendor No." := pCustVendNo;
                    IF NOT VendBankAcc.INSERT() THEN
                        VendBankAcc.MODIFY();
                END;
            UNTIL ThirdPartyBankAcc.NEXT() = 0;
        // TE001 - Maestro de terceros.end
    end;

    local procedure UpdateThirdPartyDefaultDimension(pThirdPartyType: Option Customer,Vendor; pThirdPartyNo: Code[20]; pCustVendNo: Code[20]; CompName: Text[30])
    var
        rDefaultDimension: Record "Default Dimension";
        rDefaultDimension2: Record "Default Dimension";
    begin
        // TE001 - Maestro de terceros.begin
        rDefaultDimension.RESET();
        rDefaultDimension.SETRANGE("Table ID", DATABASE::"Third Party");
        rDefaultDimension.SETRANGE("No.", pThirdPartyNo);
        IF rDefaultDimension.FINDFIRST() THEN
            REPEAT
                rDefaultDimension2.INIT();
                rDefaultDimension2.CHANGECOMPANY(CompName);
                rDefaultDimension2.TRANSFERFIELDS(rDefaultDimension);
                IF pThirdPartyType = pThirdPartyType::Customer THEN
                    rDefaultDimension2."Table ID" := DATABASE::Customer
                ELSE
                    rDefaultDimension2."Table ID" := DATABASE::Vendor;
                rDefaultDimension2."No." := pCustVendNo;
                IF NOT rDefaultDimension2.INSERT() THEN
                    rDefaultDimension2.MODIFY();
            UNTIL rDefaultDimension.NEXT() = 0;
        // TE001 - Maestro de terceros.end
    end;

    procedure CheckCentralizedThirdPartyMgt()
    var
        GeneralSetup: Record "General Setup";
    begin
        GeneralSetup.GET();
        IF GeneralSetup."Centralized Third Party Mgt." THEN
            ERROR(CentralizedThirdPartyMgtIssueLbl);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, 'OnAfterSetupObjectNoList', '', false, false)]

    procedure OnAfterSetupObjectNoList(var TempAllObjWithCaption: Record AllObjWithCaption temporary)
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        //DimMgt.InsertObject(TempAllObjWithCaption,DATABASE::"Property Development");
        //DimMgt.InsertObject(TempAllObjWithCaption,DATABASE::Property);
        //DimMgt.InsertObject(TempAllObjWithCaption,DATABASE::"Development Phase");
        //DimMgt.InsertObject(TempAllObjWithCaption,DATABASE::"Customer Contract Header");
        //DimMgt.InsertObject(TempAllObjWithCaption,DATABASE::"Contract Category");
        DimMgt.InsertObject(TempAllObjWithCaption, DATABASE::"Third Party");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]

    procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        rlCust: Record Customer;
    begin
        // TE001 - Maestro de terceros.begin
        CustLedgerEntry."Source Company Name" := COMPANYNAME;
        IF rlCust.GET(GenJournalLine."Source No.") THEN
            CustLedgerEntry."Third Party No." := rlCust."Third Party No.";
        //CustLedgerEntry."Customer Contract Group" := GenJournalLine."Customer Contract Group";
        //CustLedgerEntry."Customer Contract No." := GenJournalLine."Customer Contract No.";
        //CustLedgerEntry."Development No." := GenJournalLine."Development No.";
        //CustLedgerEntry."Development Phase Code" := GenJournalLine."Development Phase Code";
        //CustLedgerEntry."Property No." := GenJournalLine."Property No.";
        //CustLedgerEntry."Real Estate Entry Type" := GenJournalLine."Real Estate Entry Type";
        // TE001 - Maestro de terceros.end
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]

    procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        rlVend: Record Vendor;
    begin
        // TE001 - Maestro de terceros.begin
        VendorLedgerEntry."Source Company Name" := COMPANYNAME;
        IF rlVend.GET(GenJournalLine."Source No.") THEN
            VendorLedgerEntry."Third Party No." := rlVend."Third Party No.";
        // TE001 - Maestro de terceros.end
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]

    procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        rlCust: Record Customer;
        rlVend: Record Vendor;
    begin
        // TE001 - Maestro de terceros.begin
        IF GLEntry."Source Type" = GLEntry."Source Type"::Customer THEN BEGIN
            IF rlCust.GET(GLEntry."Source No.") THEN
                GLEntry."Third Party No." := rlCust."Third Party No.";
        END ELSE
            IF GLEntry."Source Type" = GLEntry."Source Type"::Vendor THEN
                IF rlVend.GET(GLEntry."Source No.") THEN
                    GLEntry."Third Party No." := rlVend."Third Party No.";
        // TE001 - Maestro de terceros.end
    end;

    [EventSubscriber(ObjectType::Table, Database::"Third Party", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnDeleteThirdParty(var Rec: Record "Third Party"; RunTrigger: Boolean)
    var
        Company: Record Company;
        TestCompanyPreffix: Label 'ZZ';
        Cust: Record Customer;
        Vend: Record Vendor;
        rlCustLE: Record "Cust. Ledger Entry";
        rlVendLE: Record "Vendor Ledger Entry";
        ctErrorExistLE: Label 'There are entries for the %1: %2 - Company Name %3', Comment = 'ESP="Existen movimientos para %1: %2 - Empresa %3"';
    begin
        // TE001 - Maestro de terceros.begin
        // Mod. S2G (IVC).Begin
        IF (NOT RunTrigger) THEN
            EXIT;
        Company.RESET();
        Company.SETRANGE("Evaluation Company", FALSE);
        IF Company.FINDFIRST() THEN
            REPEAT
                IF UPPERCASE(COPYSTR(Company.Name, 1, 2)) <> TestCompanyPreffix THEN BEGIN
                    Cust.RESET();
                    Cust.CHANGECOMPANY(Company.Name);
                    Cust.SETCURRENTKEY("Third Party No.");
                    Cust.SETRANGE("Third Party No.", Rec."No.");
                    IF Cust.FINDLAST() THEN BEGIN
                        rlCustLE.RESET();
                        rlCustLE.CHANGECOMPANY(Company.Name);
                        rlCustLE.SETCURRENTKEY("Customer No.", "Posting Date", "Currency Code");
                        rlCustLE.SETRANGE("Customer No.", Cust."No.");
                        IF NOT rlCustLE.ISEMPTY THEN
                            ERROR(ctErrorExistLE, Cust.TABLECAPTION, Cust."No.", Company.Name);
                    END;
                    Vend.RESET();
                    Vend.CHANGECOMPANY(Company.Name);
                    Vend.SETCURRENTKEY("Third Party No.");
                    Vend.SETRANGE("Third Party No.", Rec."No.");
                    IF Vend.FINDLAST() THEN BEGIN
                        rlVendLE.RESET();
                        rlVendLE.CHANGECOMPANY(Company.Name);
                        rlVendLE.SETCURRENTKEY("Vendor No.", "Posting Date", "Currency Code");
                        rlVendLE.SETRANGE("Vendor No.", Vend."No.");
                        IF NOT rlVendLE.ISEMPTY THEN
                            ERROR(ctErrorExistLE, Vend.TABLECAPTION, Vend."No.", Company.Name);
                    END;
                END;
            UNTIL Company.NEXT() = 0;
        // Mod. S2G (IVC).End
        // TE001 - Maestro de terceros.end
    end;

    procedure EnableCustVendBasedOnThirdParty(var pThirdParty: Record "Third Party"; pThirdPartyType: Option Customer,Vendor; var pCustVendNo: Code[20]; CompName: Text[30])
    var
        GeneralSetup: Record "General Setup";
        Cust: Record Customer;
        Vend: Record Vendor;
        ConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplateLine: Record "Config. Template Line";
        "Field": Record Field;
        ConfigValidateMgt: Codeunit "Config. Validate Management";
        ConfigTemplates: Page "Config Templates";
        ConfigTemplateHeaderCode: Code[10];
        RecRef: RecordRef;
        FieldRef: FieldRef;
        OptionAsInteger: Integer;
    begin
        //(Varios) S2G (RBM-R) 27-05-19 Modificaciones Interfaz Educamos: No validar CIF/NIF en procesos de interfaz. Inicio
        IF NOT bSkipConfirm THEN BEGIN

            //(CR003) S2G (GRL) 22-04-19: Forzar campo CIF en Terceros. Inicio
            pThirdParty.TESTFIELD("VAT Registration No.");
            pThirdParty.TESTFIELD("Country/Region Code");
            //(CR003) S2G (GRL) 22-04-19: Forzar campo CIF en Terceros. Fin
        END;
        //(Varios) S2G (RBM-R) 27-05-19 Modificaciones Interfaz Educamos: No validar CIF/NIF en procesos de interfaz. Fin

        // TE001 - Maestro de terceros.begin
        IF pThirdPartyType = pThirdPartyType::Customer THEN BEGIN

            // //Mod. S2G (RBM-R) Integración Educamos. Inicio
            IF NOT bSkipConfirm THEN
                //     //Mod. S2G (RBM-R) Integración Educamos. Fin

                IF NOT CONFIRM(STRSUBSTNO(ConfirmCustVendEnabledLbl, Cust.TABLECAPTION, pThirdParty."No.", CompName)) THEN
                    EXIT;

            Cust.RESET();
            Cust.CHANGECOMPANY(CompName);
            Cust.SETCURRENTKEY("Third Party No.");
            Cust.SETRANGE("Third Party No.", pThirdParty."No.");
            IF Cust.FINDLAST() THEN BEGIN

                // Enable customer
                Cust.Disabled := FALSE;
                Cust."VAT Registration No." := pThirdParty."VAT Registration No.";
                Cust.Name := pThirdParty.Name;
                Cust."Name 2" := pThirdParty."Name 2";
                Cust.Address := pThirdParty.Address;
                Cust."Address 2" := pThirdParty."Address 2";
                Cust."Country/Region Code" := pThirdParty."Country/Region Code";
                Cust."Post Code" := pThirdParty."Post Code";
                Cust.County := pThirdParty.County;
                Cust.City := pThirdParty.City;
                Cust.Contact := pThirdParty.Contact;
                Cust."Phone No." := pThirdParty."Phone No.";
                Cust."E-Mail" := pThirdParty."E-Mail";
                Cust."Home Page" := pThirdParty."Home Page";
                Cust.MODIFY();
                pCustVendNo := Cust."No.";

                UpdateThirdPartyBankAccounts(pThirdPartyType, pThirdParty."No.", pCustVendNo, CompName);
                // Mod. S2G (IVC).Begin
                UpdateThirdPartyDefaultDimension(pThirdPartyType, pThirdParty."No.", pCustVendNo, CompName);
                // Mod. S2G (IVC).End
            END ELSE BEGIN

                // Create customer
                GeneralSetup.CHANGECOMPANY(CompName);
                GeneralSetup.GET();
                GeneralSetup.TESTFIELD("Centralized Third Party Mgt.", TRUE);
                GeneralSetup.TESTFIELD("Customer Numbering Preffix");

                // //Mod. S2G (RBM-R) Integración Educamos. Inicio
                IF NOT bSkipConfirm THEN
                    //     //Mod. S2G (RBM-R) Integración Educamos. Fin
                    pThirdParty.TESTFIELD("VAT Registration No.");

                CLEAR(Cust);
                Cust.CHANGECOMPANY(CompName);
                Cust.INIT();
                Cust.TRANSFERFIELDS(pThirdParty);
                Cust."No." := GeneralSetup."Customer Numbering Preffix" + Cust."No.";
                Cust."Third Party No." := pThirdParty."No.";
                Cust.INSERT();

                ConfigTemplateHeader.RESET();
                ConfigTemplateHeader.CHANGECOMPANY(CompName);
                ConfigTemplateHeader.SETRANGE("Table ID", DATABASE::Customer);
                ConfigTemplateHeader.SETRANGE(Enabled, TRUE);
                IF pThirdParty."Customer Template Code" = '' THEN BEGIN
                    COMMIT;
                    ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
                    ConfigTemplates.LOOKUPMODE(TRUE);
                    IF ConfigTemplates.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                        ConfigTemplates.GETRECORD(ConfigTemplateHeader);
                        ConfigTemplateHeaderCode := ConfigTemplateHeader.Code;
                    END;
                END ELSE
                    ConfigTemplateHeaderCode := pThirdParty."Customer Template Code";
                IF ConfigTemplateHeaderCode <> '' THEN BEGIN

                    ConfigTemplateHeader.SETRANGE(Code, ConfigTemplateHeaderCode);
                    ConfigTemplateHeader.FINDLAST;

                    ConfigTemplateLine.CHANGECOMPANY(CompName);
                    ConfigTemplateLine.SETRANGE("Data Template Code", ConfigTemplateHeader.Code);

                    RecRef.GETTABLE(Cust);
                    RecRef.CHANGECOMPANY(CompName);
                    ConfigTemplateLine.SETRANGE("Data Template Code", ConfigTemplateHeader.Code);
                    ConfigTemplateLine.SETRANGE(Type, ConfigTemplateLine.Type::Field);
                    IF ConfigTemplateLine.FINDSET() THEN
                        REPEAT
                            IF ConfigTemplateLine."Field ID" <> 0 THEN BEGIN
                                FieldRef := RecRef.FIELD(ConfigTemplateLine."Field ID");
                                Field.GET(RecRef.NUMBER, FieldRef.NUMBER);

                                IF Field.Class = Field.Class::Normal THEN
                                    IF Field.Type <> Field.Type::Option THEN BEGIN
                                        IF ConfigTemplateLine."Default Value" <> '' THEN
                                            EVALUATE(FieldRef, ConfigTemplateLine."Default Value")
                                    END ELSE BEGIN
                                        OptionAsInteger := ConfigValidateMgt.GetOptionNo(ConfigTemplateLine."Default Value", FieldRef);
                                        IF OptionAsInteger <> -1 THEN
                                            FieldRef.VALUE := OptionAsInteger;
                                    END;
                            END;
                        UNTIL ConfigTemplateLine.NEXT() = 0;

                    RecRef.MODIFY();
                    RecRef.SETTABLE(Cust);
                END;

                pCustVendNo := Cust."No.";
                UpdateThirdPartyBankAccounts(pThirdPartyType, pThirdParty."No.", pCustVendNo, CompName);
                // Mod. S2G (IVC).Begin
                UpdateThirdPartyDefaultDimension(pThirdPartyType, pThirdParty."No.", pCustVendNo, CompName);
                // Mod. S2G (IVC).End
            END;

        END ELSE BEGIN
            IF NOT CONFIRM(STRSUBSTNO(ConfirmCustVendEnabledLbl, Vend.TABLECAPTION, pThirdParty."No.", CompName)) THEN
                EXIT;

            Vend.RESET();
            Vend.CHANGECOMPANY(CompName);
            Vend.SETCURRENTKEY("Third Party No.");
            Vend.SETRANGE("Third Party No.", pThirdParty."No.");
            IF Vend.FINDLAST() THEN BEGIN

                // Enable vendor
                Vend.Disabled := FALSE;
                Vend."VAT Registration No." := pThirdParty."VAT Registration No.";
                Vend.Name := pThirdParty.Name;
                Vend."Name 2" := pThirdParty."Name 2";
                Vend.Address := pThirdParty.Address;
                Vend."Address 2" := pThirdParty."Address 2";
                Vend."Country/Region Code" := pThirdParty."Country/Region Code";
                Vend."Post Code" := pThirdParty."Post Code";
                Vend.County := pThirdParty.County;
                Vend.City := pThirdParty.City;
                Vend.Contact := pThirdParty.Contact;
                Vend."Phone No." := pThirdParty."Phone No.";
                Vend."E-Mail" := pThirdParty."E-Mail";
                Vend."Home Page" := pThirdParty."Home Page";
                Vend.MODIFY();
                pCustVendNo := Vend."No.";
                UpdateThirdPartyBankAccounts(pThirdPartyType, pThirdParty."No.", pCustVendNo, CompName);
                // Mod. S2G (IVC).Begin
                UpdateThirdPartyDefaultDimension(pThirdPartyType, pThirdParty."No.", pCustVendNo, CompName);
                // Mod. S2G (IVC).End
            END ELSE BEGIN

                // Create vendor
                GeneralSetup.CHANGECOMPANY(CompName);
                GeneralSetup.GET();
                GeneralSetup.TESTFIELD("Centralized Third Party Mgt.", TRUE);
                GeneralSetup.TESTFIELD("Vendor Numbering Preffix");

                pThirdParty.TESTFIELD("VAT Registration No.");

                CLEAR(Vend);
                Vend.CHANGECOMPANY(CompName);
                Vend.INIT();
                Vend.TRANSFERFIELDS(pThirdParty);
                Vend."No." := GeneralSetup."Vendor Numbering Preffix" + Vend."No.";
                Vend."Third Party No." := pThirdParty."No.";
                Vend.INSERT();

                ConfigTemplateHeader.RESET();
                ConfigTemplateHeader.CHANGECOMPANY(CompName);
                ConfigTemplateHeader.SETRANGE("Table ID", DATABASE::Vendor);
                ConfigTemplateHeader.SETRANGE(Enabled, TRUE);
                IF pThirdParty."Vendor Template Code" = '' THEN BEGIN
                    COMMIT;
                    ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
                    ConfigTemplates.LOOKUPMODE(TRUE);
                    IF ConfigTemplates.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                        ConfigTemplates.GETRECORD(ConfigTemplateHeader);
                        ConfigTemplateHeaderCode := ConfigTemplateHeader.Code;
                    END;
                END ELSE
                    ConfigTemplateHeaderCode := pThirdParty."Vendor Template Code";
                IF ConfigTemplateHeaderCode <> '' THEN BEGIN

                    ConfigTemplateHeader.SETRANGE(Code, ConfigTemplateHeaderCode);
                    ConfigTemplateHeader.FINDLAST;

                    ConfigTemplateLine.CHANGECOMPANY(CompName);
                    ConfigTemplateLine.SETRANGE("Data Template Code", ConfigTemplateHeader.Code);

                    RecRef.GETTABLE(Vend);
                    RecRef.CHANGECOMPANY(CompName);
                    ConfigTemplateLine.SETRANGE("Data Template Code", ConfigTemplateHeader.Code);
                    ConfigTemplateLine.SETRANGE(Type, ConfigTemplateLine.Type::Field);
                    IF ConfigTemplateLine.FINDSET() THEN
                        REPEAT
                            IF ConfigTemplateLine."Field ID" <> 0 THEN BEGIN
                                FieldRef := RecRef.FIELD(ConfigTemplateLine."Field ID");
                                Field.GET(RecRef.NUMBER, FieldRef.NUMBER);

                                IF Field.Class = Field.Class::Normal THEN
                                    IF Field.Type <> Field.Type::Option THEN BEGIN
                                        IF ConfigTemplateLine."Default Value" <> '' THEN
                                            EVALUATE(FieldRef, ConfigTemplateLine."Default Value")
                                    END ELSE BEGIN
                                        OptionAsInteger := ConfigValidateMgt.GetOptionNo(ConfigTemplateLine."Default Value", FieldRef);
                                        IF OptionAsInteger <> -1 THEN
                                            FieldRef.VALUE := OptionAsInteger;
                                    END;
                            END;
                        UNTIL ConfigTemplateLine.NEXT() = 0;

                    RecRef.MODIFY();
                    RecRef.SETTABLE(Vend);
                END;

                pCustVendNo := Vend."No.";
                UpdateThirdPartyBankAccounts(pThirdPartyType, pThirdParty."No.", pCustVendNo, CompName);
                // Mod. S2G (IVC).Begin
                UpdateThirdPartyDefaultDimension(pThirdPartyType, pThirdParty."No.", pCustVendNo, CompName);
                // Mod. S2G (IVC).End
            END;
        END;
        // TE001 - Maestro de terceros.end
    end;

    local procedure "//SGP Borrar terceros proceso"()
    begin
    end;

    procedure DisableCustVendFromThirdParty2(var pThirdParty: Record "Third Party"; pThirdPartyType: Option Customer,Vendor; CompName: Text[30])
    var
        Cust: Record Customer;
        Vend: Record Vendor;
    begin
        // TE001 - Maestro de terceros.begin
        IF pThirdPartyType = pThirdPartyType::Customer THEN BEGIN
            //IF NOT CONFIRM(STRSUBSTNO(ConfirmCustVendDisabledLbl,Cust.TABLECAPTION,pThirdParty."No.",CompName)) THEN
            //EXIT;

            Cust.RESET();
            Cust.CHANGECOMPANY(CompName);
            Cust.SETCURRENTKEY("Third Party No.");
            Cust.SETRANGE("Third Party No.", pThirdParty."No.");
            IF Cust.FINDLAST() THEN BEGIN
                // Mod. S2G (IVC).Begin
                //Chequeamos que no tenga Saldo
                Cust.CALCFIELDS(Balance);
                Cust.TESTFIELD(Balance, 0);
                //
                // Mod. S2G (IVC).End
                // Disable customer
                Cust.Disabled := TRUE;
                Cust.MODIFY();
                //pCustVendNo := '';
            END;
        END ELSE BEGIN
            //IF NOT CONFIRM(STRSUBSTNO(ConfirmCustVendDisabledLbl,Vend.TABLECAPTION,pThirdParty."No.",CompName)) THEN
            //EXIT;

            Vend.RESET();
            Vend.CHANGECOMPANY(CompName);
            Vend.SETCURRENTKEY("Third Party No.");
            Vend.SETRANGE("Third Party No.", pThirdParty."No.");
            IF Vend.FINDLAST() THEN BEGIN
                // Mod. S2G (IVC).Begin
                //Chequeamos que no tenga Saldo
                Vend.CALCFIELDS(Balance);
                Vend.TESTFIELD(Balance, 0);
                //
                // Mod. S2G (IVC).End
                // Disable vendor
                Vend.Disabled := TRUE;
                Vend.MODIFY();
                //pCustVendNo := '';
            END;
        END;
        // TE001 - Maestro de terceros.end
    end;

    procedure fFromEducamosInterface()
    begin
        //Mod. S2G (RBM-R) Integración Educamos
        bSkipConfirm := TRUE;
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertGLEntryDim(var Rec: Record "G/L Entry"; RunTrigger: Boolean)
    var
        rDimSetEntry: Record "Dimension Set Entry";
        rGLSetup: Record "General Ledger Setup";
        bChange: Boolean;
    begin
        rGLSetup.GET();
        bChange := FALSE;

        IF rGLSetup."Shortcut Dimension 3 Code" <> '' THEN
            IF rDimSetEntry.GET(Rec."Dimension Set ID", rGLSetup."Shortcut Dimension 3 Code") THEN BEGIN
                Rec."Shortcut Dimension 3" := rDimSetEntry."Dimension Value Code";
                bChange := TRUE;
            END;

        IF rGLSetup."Shortcut Dimension 4 Code" <> '' THEN
            IF rDimSetEntry.GET(Rec."Dimension Set ID", rGLSetup."Shortcut Dimension 4 Code") THEN BEGIN
                Rec."Shortcut Dimension 4" := rDimSetEntry."Dimension Value Code";
                bChange := TRUE;
            END;

        IF rGLSetup."Shortcut Dimension 5 Code" <> '' THEN
            IF rDimSetEntry.GET(Rec."Dimension Set ID", rGLSetup."Shortcut Dimension 5 Code") THEN BEGIN
                Rec."Shortcut Dimension 5" := rDimSetEntry."Dimension Value Code";
                bChange := TRUE;
            END;

        IF rGLSetup."Shortcut Dimension 6 Code" <> '' THEN
            IF rDimSetEntry.GET(Rec."Dimension Set ID", rGLSetup."Shortcut Dimension 6 Code") THEN BEGIN
                Rec."Shortcut Dimension 6" := rDimSetEntry."Dimension Value Code";
                bChange := TRUE;
            END;

        IF bChange THEN
            Rec.MODIFY();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertBankAccLE(var Rec: Record "Bank Account Ledger Entry"; RunTrigger: Boolean)
    var
        rDimSetEntry: Record "Dimension Set Entry";
        rGLSetup: Record "General Ledger Setup";
        bChange: Boolean;
    begin
        rGLSetup.GET();
        bChange := FALSE;

        IF rGLSetup."Shortcut Dimension 3 Code" <> '' THEN
            IF rDimSetEntry.GET(Rec."Dimension Set ID", rGLSetup."Shortcut Dimension 3 Code") THEN BEGIN
                Rec."Shortcut Dimension 3" := rDimSetEntry."Dimension Value Code";
                bChange := TRUE;
            END;

        IF rGLSetup."Shortcut Dimension 4 Code" <> '' THEN
            IF rDimSetEntry.GET(Rec."Dimension Set ID", rGLSetup."Shortcut Dimension 4 Code") THEN BEGIN
                Rec."Shortcut Dimension 4" := rDimSetEntry."Dimension Value Code";
                bChange := TRUE;
            END;

        IF rGLSetup."Shortcut Dimension 5 Code" <> '' THEN
            IF rDimSetEntry.GET(Rec."Dimension Set ID", rGLSetup."Shortcut Dimension 5 Code") THEN BEGIN
                Rec."Shortcut Dimension 5" := rDimSetEntry."Dimension Value Code";
                bChange := TRUE;
            END;

        IF rGLSetup."Shortcut Dimension 6 Code" <> '' THEN
            IF rDimSetEntry.GET(Rec."Dimension Set ID", rGLSetup."Shortcut Dimension 6 Code") THEN BEGIN
                Rec."Shortcut Dimension 6" := rDimSetEntry."Dimension Value Code";
                bChange := TRUE;
            END;

        IF bChange THEN
            Rec.MODIFY();
    end;
}
