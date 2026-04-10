report 50088 "Liquidación IRPF_2"
{
    Caption = 'Liquidación IRPF', Comment = 'ESP="Liquidación IRPF"';
    Permissions = TableData "Movs. retenciones" = rm;
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1100220001; 2000000026)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin

                rTempMovRet.RESET();
                IF rTempMovRet.FINDSET() THEN BEGIN
                    CLEAR(vline);
                    vline := fBuscarNumeroLinea(rGenJournalLine);
                    REPEAT
                        CLEAR(rGenJournalLine);
                        rGenJournalLine.INIT();
                        rGenJournalLine.VALIDATE("Journal Template Name", rPurchasesPayablesSetup."Retention Jnl. Template");
                        rGenJournalLine.VALIDATE("Journal Batch Name", rPurchasesPayablesSetup."Retention Jnl. Batch");
                        rGenJournalLine.VALIDATE("Line No.", vline);
                        rGenJournalLine.VALIDATE("Posting Date", vFechaRegistro);
                        rGenJournalLine.VALIDATE("Document No.", vNumDoc);
                        rGenJournalLine.VALIDATE("Account Type", rGenJournalLine."Account Type"::"G/L Account");
                        rGenJournalLine.VALIDATE("Account No.", rTempMovRet."Cuenta retención");
                        /*    //
                            IF rTempMovRet."Tipo tercero" IN [rTempMovRet."Tipo tercero"::"0",rTempMovRet."Tipo tercero"::"2"] THEN
                              rGenJournalLine.VALIDATE(Amount,rTempMovRet.Cuota)
                            ELSE
                              rGenJournalLine.VALIDATE(Amount,-rTempMovRet.Importe);
                        */    //

                        rGenJournalLine.VALIDATE(Amount, rTempMovRet.Importe);

                        rGenJournalLine.VALIDATE("Gen. Posting Type", 0);
                        rGenJournalLine.VALIDATE("Gen. Bus. Posting Group", '');
                        rGenJournalLine.VALIDATE("Gen. Prod. Posting Group", '');
                        rGenJournalLine.VALIDATE("Movimiento IRPF liquidado", rTempMovRet."No. mov. original");
                        rGenJournalLine."Source Code" := rSourceCodeSetup."Retention Application";
                        rGenJournalLine."Skip Retention Entry" := TRUE;
                        IF rTempMovRet."Global Dimension 1 Code" <> '' THEN
                            rGenJournalLine."Shortcut Dimension 1 Code" := rTempMovRet."Global Dimension 1 Code";
                        IF rTempMovRet."Global Dimension 2 Code" <> '' THEN
                            rGenJournalLine."Shortcut Dimension 2 Code" := rTempMovRet."Global Dimension 2 Code";
                        rGenJournalLine."Dimension Set ID" := rTempMovRet."Dimension Set ID";
                        // CSM-20dic2016 begin
                        //se usan las mismas dimensiones del movimiento contable.
                        IF (rTempMovRet."No. mov. contabilidad" <> 0) THEN BEGIN
                            GLEntry.GET(rTempMovRet."No. mov. contabilidad");
                            rGenJournalLine."Dimension Set ID" := GLEntry."Dimension Set ID";
                            GrupoDim := GLEntry."Dimension Set ID";
                        END;
                        // CSM-20dic2016 end

                        rGenJournalLine.INSERT(TRUE);

                        vline := vline + 10000;
                        vImporteTotal += rGenJournalLine.Amount;
                    UNTIL rTempMovRet.NEXT() = 0;
                END;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field(vFechaRegistro; vFechaRegistro)
                {
                    Caption = 'Posting Date *', Comment = 'ESP="Fecha registro *"';
                    ApplicationArea = All;
                }
                field(vTipoLiquidacion; vTipoLiquidacion)
                {
                    Caption = 'Application Type *', Comment = 'ESP="Tipo liquidación *"';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        vCuentaLiquidacion := '';
                    end;
                }
                field(vCuentaLiquidacion; vCuentaLiquidacion)
                {
                    Caption = 'Application G/L/Bank Acc. *', Comment = 'ESP="Cta. contable/banco liquidación *"';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CLEAR(rGLAccount);
                        CLEAR(rBankAccount);
                        IF vTipoLiquidacion = vTipoLiquidacion::Cuenta THEN BEGIN
                            CLEAR(fGLaccountList);
                            //CSM-20dic2016 begin
                            rGLAccount.FILTERGROUP(0);
                            rGLAccount.SETFILTER(rGLAccount."Account Type", '%1', rGLAccount."Account Type"::Posting);
                            //CSM-20dic2016 end
                            fGLaccountList.SETTABLEVIEW(rGLAccount);
                            fGLaccountList.LOOKUPMODE(TRUE);
                            IF fGLaccountList.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                                fGLaccountList.GETRECORD(rGLAccount);
                                vCuentaLiquidacion := rGLAccount."No.";
                            END;
                        END
                        ELSE BEGIN
                            CLEAR(fBankAccountList);
                            fBankAccountList.SETTABLEVIEW(rBankAccount);
                            fBankAccountList.LOOKUPMODE(TRUE);
                            IF fBankAccountList.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                                fBankAccountList.GETRECORD(rBankAccount);
                                vCuentaLiquidacion := rBankAccount."No.";
                            END;
                        END;
                    end;
                }
                field(MandatoryFieldsText; MandatoryFieldsText)
                {
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        rlMovRet: Record "Movs. retenciones";
    begin

        IF vImporteTotal <> 0 THEN BEGIN
            CLEAR(rGenJournalLine);
            rGenJournalLine.INIT();
            vline := vline + 10000;
            rGenJournalLine.VALIDATE("Journal Template Name", rPurchasesPayablesSetup."Retention Jnl. Template");
            rGenJournalLine.VALIDATE("Journal Batch Name", rPurchasesPayablesSetup."Retention Jnl. Batch");
            rGenJournalLine.VALIDATE("Line No.", fBuscarNumeroLinea(rGenJournalLine));
            rGenJournalLine.VALIDATE("Line No.", vline);
            rGenJournalLine.VALIDATE("Posting Date", vFechaRegistro);
            rGenJournalLine.VALIDATE("Document No.", vNumDoc);
            IF vTipoLiquidacion = vTipoLiquidacion::Cuenta THEN
                rGenJournalLine.VALIDATE("Account Type", rGenJournalLine."Account Type"::"G/L Account")
            ELSE
                rGenJournalLine.VALIDATE("Account Type", rGenJournalLine."Account Type"::"Bank Account");
            rGenJournalLine.VALIDATE("Account No.", vCuentaLiquidacion);
            rGenJournalLine.VALIDATE(Amount, -vImporteTotal);

            rGenJournalLine.VALIDATE("Gen. Posting Type", 0);
            rGenJournalLine.VALIDATE("Gen. Bus. Posting Group", '');
            rGenJournalLine.VALIDATE("Gen. Prod. Posting Group", '');
            rGenJournalLine."Source Code" := rSourceCodeSetup."Retention Application";
            rGenJournalLine."Skip Retention Entry" := TRUE;
            // CSM-20dic2016 begin
            rGenJournalLine."Dimension Set ID" := GrupoDim;
            // CSM-20dic2016 end
            rGenJournalLine.INSERT(TRUE);

            CLEAR(rGenJournalLine);
            rGenJournalLine.SETRANGE("Journal Template Name", rPurchasesPayablesSetup."Retention Jnl. Template");
            rGenJournalLine.SETRANGE("Journal Batch Name", rPurchasesPayablesSetup."Retention Jnl. Batch");
            IF rGenJournalLine.FINDFIRST() THEN
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", rGenJournalLine);

            //Actualizar registros
            rTempMovRet.RESET();
            IF rTempMovRet.FINDSET() THEN
                REPEAT
                    rlMovRet.RESET();
                    rlMovRet.GET(rTempMovRet."No. mov. original");
                    rlMovRet.Declarado := TRUE;
                    rlMovRet.MODIFY();
                UNTIL rTempMovRet.NEXT() = 0;
            //
            MESSAGE(Text50002, vNumDoc);
            vPostYes := TRUE;
        END ELSE
            MESSAGE(Text50003);

        CLEAR(rGenJournalLine);
        rGenJournalLine.RESET();
        rGenJournalLine.SETRANGE("Journal Template Name", rPurchasesPayablesSetup."Retention Jnl. Template");
        rGenJournalLine.SETRANGE("Journal Batch Name", rPurchasesPayablesSetup."Retention Jnl. Batch");
        rGenJournalLine.DELETEALL();
    end;

    trigger OnPreReport()
    begin

        CLEAR(vPostYes);

        IF (vFechaRegistro = 0D) THEN
            ERROR(Text50000);

        IF vCuentaLiquidacion = '' THEN
            ERROR(Text50000);

        rPurchasesPayablesSetup.RESET();
        rPurchasesPayablesSetup.GET();
        rPurchasesPayablesSetup.TESTFIELD(rPurchasesPayablesSetup."Retention Jnl. Template");
        rPurchasesPayablesSetup.TESTFIELD(rPurchasesPayablesSetup."Retention Jnl. Batch");
        rPurchasesPayablesSetup.TESTFIELD("Número serie Liquidación IRPF");

        rSourceCodeSetup.RESET();
        rSourceCodeSetup.GET();
        rSourceCodeSetup.TESTFIELD("Retention Application");

        CLEAR(rGenJournalLine);
        rGenJournalLine.SETRANGE("Journal Template Name", rPurchasesPayablesSetup."Retention Jnl. Template");
        rGenJournalLine.SETRANGE("Journal Batch Name", rPurchasesPayablesSetup."Retention Jnl. Batch");
        IF rGenJournalLine.FINDFIRST() THEN
            ERROR(Text50001, rPurchasesPayablesSetup."Retention Jnl. Template", rPurchasesPayablesSetup."Retention Jnl. Batch");

        vImporteTotal := 0;

        // Nº DOC
        CLEAR(vNumDoc);
        vNumDoc := NoSeriesMgt.GetNextNo(rPurchasesPayablesSetup."Número serie Liquidación IRPF", vFechaRegistro, TRUE);
    end;

    var
        rPurchasesPayablesSetup: Record "Purchases & Payables Setup";
        rGenJournalLine: Record "Gen. Journal Line";
        rGLAccount: Record "G/L Account";
        NoSeriesMgt: Codeunit "No. Series";
        rBankAccount: Record "Bank Account";
        fGLaccountList: Page "G/L Account List";
        fBankAccountList: Page "Bank Account List";
        vTipoLiquidacion: Option Cuenta,Banco;
        vCuentaLiquidacion: Code[20];
        vFechaRegistro: Date;
        vImporteTotal: Decimal;
        vNumDoc: Code[20];
        MandatoryFieldsText: Label '(*) Mandatory Data', Comment = 'ESP="(*) Datos obligatorios"';
        Text50000: Label 'Debe rellenar todos los campos obligatorios.', Comment = 'ESP="Debe rellenar todos los campos obligatorios."';
        Text50001: Label 'Ya existen líneas en el diario seleccionado.', Comment = 'ESP="Ya existen líneas en el diario seleccionado."';
        Text50002: Label 'Se han liquidado correctamente las retenciones de IRPF con número de documento %1.', Comment = 'ESP="Se han liquidado correctamente las retenciones de IRPF con número de documento %1."';
        Text50003: Label 'No es necesario realizar ninguna liquidación.', Comment = 'ESP="No es necesario realizar ninguna liquidación."';
        rSourceCodeSetup: Record "Source Code Setup";
        rTempMovRet: Record "Movs. retenciones" temporary;
        vline: Integer;
        vPostYes: Boolean;
        GLEntry: Record "G/L Entry";
        GrupoDim: Integer;

    procedure fBuscarNumeroLinea(pGenJournalLine: Record "Gen. Journal Line"): Integer
    var
        rlGenJournalLine: Record "Gen. Journal Line";
        vlNumeroLinea: Integer;
    begin
        CLEAR(rlGenJournalLine);
        rlGenJournalLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Line No.");
        rlGenJournalLine.SETRANGE("Journal Template Name", rPurchasesPayablesSetup."Retention Jnl. Template");
        rlGenJournalLine.SETRANGE("Journal Batch Name", rPurchasesPayablesSetup."Retention Jnl. Batch");
        rlGenJournalLine.SETRANGE("Line No.");
        IF rlGenJournalLine.FINDLAST() THEN
            vlNumeroLinea := rlGenJournalLine."Line No." + 10000
        ELSE
            vlNumeroLinea := 10000;

        EXIT(vlNumeroLinea);
    end;

    procedure fSetRecord(var rlMovRet: Record "Movs. retenciones" temporary)
    begin

        IF rlMovRet.FINDSET() THEN
            REPEAT
                IF rlMovRet."No. mov. original" <> 0 THEN BEGIN
                    rlMovRet.TESTFIELD(rlMovRet.Declarado, FALSE);
                    rTempMovRet.INIT();
                    rTempMovRet := rlMovRet;
                    rTempMovRet.INSERT();
                END;
            UNTIL rlMovRet.NEXT() = 0;
    end;

    procedure fGetProcess(): Boolean
    begin
        EXIT(vPostYes);
    end;
}
