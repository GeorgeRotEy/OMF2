report 50033 "Main Accounting Book Schools"
{
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
    // (INC) S2G (JDT) 25-11-19: Modificaciones en dimensiones de ArrayTercero.
    // (1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios
    // //(INC) S2G (JDT) 16-03-20: Nuevo filtro por el campo "Source Code Filter".
    DefaultLayout = RDLC;
    RDLCLayout = './MainAccountingBookSchools.rdlc';
    Caption = 'Libro mayor OFM Colegios';
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("Account Type")
                                ORDER(Ascending)
                                WHERE("Account Type" = CONST(Posting),
                                      "No." = FILTER('5*|6*|7*'));
            RequestFilterFields = "No.", "Date Filter", "Source Code Filter";
            column(Filtros; GETFILTERS)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Logo; rCompanyInfo.Picture)
            {
            }
            column(No_GLAccount; "G/L Account"."No.")
            {
            }
            column(Balance; Balance)
            {
            }
            column(SaldoPeriodo; "Net Change")
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No."),
                               "Posting Date" = FIELD("Date Filter");
                DataItemTableView = SORTING("G/L Account No.", "Source Type", "Source No.", "Posting Date")
                                    ORDER(Ascending);
                RequestFilterFields = "Source Type", "Source No.";
                column(Tercero; vTercero)
                {
                }
                column(GLAccountNo_GLEntry; "G/L Entry"."G/L Account No.")
                {
                }
                column(SourceNo_GLEntry; "G/L Entry"."Source No.")
                {
                }
                column(Amount_GLEntry; "G/L Entry".Amount)
                {
                }
                column(Description_GLEntry; "G/L Entry".Description)
                {
                }
                column(DebitAmount_GLEntry; "G/L Entry"."Debit Amount")
                {
                }
                column(CreditAmount_GLEntry; "G/L Entry"."Credit Amount")
                {
                }
                column(BalAccountNo_GLEntry; "G/L Entry"."Bal. Account No.")
                {
                }
                column(PostingDate_GLEntry; "G/L Entry"."Posting Date")
                {
                }
                column(Postingconcept_GLEntry; "G/L Entry"."Posting concept")
                {
                }
                column(DocumentNo_GLEntry; "G/L Entry"."Document No.")
                {
                }
                column(Saldo; vSaldo)
                {
                }
                column(SaldoaFechaCodigos; vSaldoaFechaSinCodOrigen)
                {
                }
                column(SaldoaFecha; vSaldoaFecha)
                {
                }
                column(SaldoAnterior; vSaldoAnterior)
                {
                }
                column(vCodProcedencia; vCodProcedencia)
                {
                }
                column(vNombreProcedencia; vNombreProcedencia)
                {
                }
                column(DimensionActividad; vDimAct)
                {
                }
                column(DocExterno; "G/L Entry"."External Document No.")
                {
                }
                column(DimensionEtapa; vDimEtapa)
                {
                }
                column(vDescripcionLinea; vDescripcionLinea)
                {
                }
                column(NoTercero; vNoTercero)
                {
                }
                column(NombreTercero; vNombreTercero)
                {
                }

                trigger OnAfterGetRecord()
                var
                    rGLacc: Record "G/L Account";
                    rGLEntry: Record "G/L Entry";
                    rlDimSetEntry: Record "Dimension Set Entry";
                begin
                    //(1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios. Inicio
                    vDimAct := '';
                    vDimEtapa := '';
                    IF rGeneralLedgerSetup."Dimension Actividad" <> '' THEN BEGIN
                        IF rlDimSetEntry.GET("G/L Entry"."Dimension Set ID", rGeneralLedgerSetup."Dimension Actividad") THEN
                            vDimAct := rlDimSetEntry."Dimension Value Code";
                    END;

                    IF rGeneralLedgerSetup."Dimension Etapa" <> '' THEN BEGIN
                        IF rlDimSetEntry.GET("G/L Entry"."Dimension Set ID", rGeneralLedgerSetup."Dimension Etapa") THEN
                            vDimEtapa := rlDimSetEntry."Dimension Value Code";
                    END;
                    //(1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios. Fin

                    //(INC) S2G (JDT) 24-02-2020:
                    fDescriptionLine;
                    //(INC) S2G (JDT) 24-02-2020:

                    //vTercero := '';
                    vTercero := "G/L Account".Name;
                    vTerceroII := vTercero;
                    CASE "G/L Entry"."Source Type" OF
                        "G/L Entry"."Source Type"::"Bank Account":
                            BEGIN
                                rBankAccount.GET("G/L Entry"."Source No.");
                                vTercero := "G/L Entry"."Source No." + ' - ' + rBankAccount.Name;
                                //(INC) S2G (JDT) 24-02-2020:
                                vCodProcedencia := "G/L Entry"."Source No.";
                                vNombreProcedencia := rBankAccount.Name;
                                //(INC) S2G (JDT) 24-02-2020:
                            END;
                        "G/L Entry"."Source Type"::Customer:
                            BEGIN
                                rCustomer.GET("G/L Entry"."Source No.");
                                vTercero := "G/L Entry"."Source No." + ' - ' + rCustomer.Name;
                                //(INC) S2G (JDT) 24-02-2020:
                                vCodProcedencia := "G/L Entry"."Source No.";
                                vNombreProcedencia := rCustomer.Name;
                                //(INC) S2G (JDT) 24-02-2020:
                            END;
                        "G/L Entry"."Source Type"::Vendor:
                            BEGIN
                                rVendor.GET("G/L Entry"."Source No.");
                                vTercero := "G/L Entry"."Source No." + ' - ' + rVendor.Name;
                                //(INC) S2G (JDT) 24-02-2020:
                                vCodProcedencia := "G/L Entry"."Source No.";
                                vNombreProcedencia := rVendor.Name;
                                //(INC) S2G (JDT) 24-02-2020:
                            END;
                        "G/L Entry"."Source Type"::"Fixed Asset":
                            BEGIN
                                rFixedAsset.GET("G/L Entry"."Source No.");
                                vTercero := "G/L Entry"."Source No." + ' - ' + rFixedAsset.Description;
                                //(INC) S2G (JDT) 24-02-2020:
                                vCodProcedencia := "G/L Entry"."Source No.";
                                vNombreProcedencia := rFixedAsset.Description;
                                //(INC) S2G (JDT) 24-02-2020:
                            END;
                    END;

                    ////S2G (RBM-R) 27-02-20. Inicio
                    /*
                    //(INC) S2G (JDT) 25-11-19: Modificaciones en dimensiones de ArrayTercero.
                    IF ARRAYLEN(ArrayTercero) = i THEN BEGIN
                      MESSAGE(Text001);
                      CurrReport.BREAK;
                    END ELSE BEGIN
                    // (INC) S2G (JDT) 25-11-19:
                      IF vTerceroII <> vTercero THEN BEGIN
                        i := i + 1;
                        ArrayTercero[i] := "Source No.";
                        rGLacc.GET("G/L Account No.");
                        rGLacc.COPYFILTERS("G/L Account");
                        rGLacc.SETRANGE("Date Filter",0D,CLOSINGDATE(CALCDATE('<-1D>',vStartDate)));
                        rGLacc.SETRANGE("Source Filter","Source No.");
                        rGLacc.CALCFIELDS("Net Change");
                        vSaldoInicial := rGLacc."Net Change";
                        vSaldo := vSaldoInicial;
                        rGLEntry.RESET;
                        rGLEntry.SETRANGE("G/L Account No.","G/L Account"."No.");
                        rGLEntry.SETRANGE("Posting Date",0D,CLOSINGDATE(CALCDATE('<-1D>',vStartDate)));
                        rGLEntry.SETFILTER("Source No.",'=%1',"Source No.");
                        IF rGLEntry.FINDSET THEN BEGIN
                          REPEAT
                            vSaldoAnterior += rGLEntry."Debit Amount" - rGLEntry."Credit Amount";
                          UNTIL rGLEntry.NEXT = 0;
                        END;
                      END;
                    END;
                    */
                    //S2G (RBM-R) 27-02-20. Fin

                    vSaldo += ("Debit Amount" - "Credit Amount");

                    //S2G (RBM-R) 27-02-20. Inicio
                    //vSaldoaFechaSinCodOrigen := vSaldoaFecha - vSaldoAnterior;
                    //S2G (RBM-R) 27-02-20. Fin
                end;

                trigger OnPostDataItem()
                var
                    rGLEntry: Record "G/L Entry";
                begin
                end;

                trigger OnPreDataItem()
                var
                    rGLAcc: Record "G/L Account";
                begin
                    vSaldo := 0;
                    vTercero := '';
                    i := 0;

                    IF vSourceType <> vSourceType::" " THEN
                        SETRANGE("Source Type", vSourceType);
                    IF vSourceNo <> '' THEN
                        SETRANGE("Source No.", vSourceNo);
                    IF vDateFilter <> '' THEN
                        SETFILTER("Posting Date", vDateFilter);
                    //(INC) S2G (JDT) 16-03-20:
                    IF vFiltroSourceCode <> '' THEN
                        SETFILTER("G/L Entry"."Source Code", vFiltroSourceCode);
                    //(INC) S2G (JDT) 16-03-20:

                    //S2G (RBM-R) 27-02-20. Inicio
                    /*
                    rGLAcc.GET("G/L Account"."No.");
                    rGLAcc.COPYFILTERS("G/L Account");
                    rGLAcc.SETRANGE("Date Filter",0D,CLOSINGDATE(CALCDATE('<-1D>',vStartDate)));
                    rGLAcc.CALCFIELDS("Balance at Date");
                    vSaldoaFecha := rGLAcc."Balance at Date";
                    */
                    //S2G (RBM-R) 27-02-20. Fin
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CALCFIELDS(Balance);
            end;

            trigger OnPreDataItem()
            begin
                rCompanyInfo.GET;
                rCompanyInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        vStartDate := "G/L Account".GETRANGEMIN("G/L Account"."Date Filter");
        vFinalDate := "G/L Account".GETRANGEMAX("G/L Account"."Date Filter");
        rGeneralLedgerSetup.GET;

        //(INC) S2G (JDT) 16-03-20:
        vFiltroSourceCode := "G/L Account".GETFILTER("G/L Account"."Source Code Filter");
        //(INC) S2G (JDT) 16-03-20:
    end;

    var
        rCompanyInfo: Record "Company Information";
        rBankAccount: Record "Bank Account";
        rCustomer: Record Customer;
        rVendor: Record Vendor;
        rFixedAsset: Record "Fixed Asset";
        vSaldo: Decimal;
        vTercero: Text;
        vSourceType: Option " ",Customer,Vendor,"Bank Account","Fixed Asset";
        vSourceNo: Code[20];
        vDateFilter: Text;
        vStartDate: Date;
        vFinalDate: Date;
        vSaldoInicial: Decimal;
        vTerceroII: Text;
        vSaldoAnterior: Decimal;
        ArrayTercero: array[600] of Code[20];
        i: Integer;
        TerceroFilter: Text[250];
        k: Integer;
        vSaldoaFechaSinCodOrigen: Decimal;
        vSaldoaFecha: Decimal;
        Text001: Label 'No se ha podido generar el informe, pongese en contacto con el administrador.';
        vCodProcedencia: Code[20];
        vNombreProcedencia: Text[50];
        rGeneralLedgerSetup: Record "General Ledger Setup";
        vDescripcionLinea: Text[50];
        vDimEtapa: Code[20];
        vDimAct: Code[20];
        vNoTercero: Code[20];
        vNombreTercero: Text;
        vFiltroSourceCode: Code[20];

    procedure fSetGLEntryParameters(pSourceType: Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; pSourceNo: Code[20])
    begin
        vSourceType := pSourceType;
        vSourceNo := pSourceNo;
    end;

    procedure fSetGLEntryParameters2(pDateFilter: Text)
    begin
        vDateFilter := pDateFilter;
        IF vDateFilter <> '' THEN
            "G/L Account".SETFILTER("Date Filter", vDateFilter);
    end;

    local procedure fDescriptionLine()
    var
        rlSalesHeader: Record "Sales Invoice Header";
        rlSalesLine: Record "Sales Invoice Line";
        rlPurchaseHeader: Record "Purch. Inv. Header";
        rlPurchaseLine: Record "Purch. Inv. Line";
        rlSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        rlSalesCrMemoLine: Record "Sales Cr.Memo Line";
        rlPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        rlPurchCrMemoLine: Record "Purch. Cr. Memo Line";
    begin
        //(1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios. Inicio
        vNoTercero := '';
        vNombreTercero := '';
        vDescripcionLinea := '';
        //(1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios. Fin

        CASE "G/L Entry"."Source Code" OF
            'VENTAS':
                BEGIN
                    IF "G/L Entry"."Document Type" = "G/L Entry"."Document Type"::Invoice THEN BEGIN
                        rlSalesHeader.SETRANGE(rlSalesHeader."No.", "G/L Entry"."Document No.");
                        IF rlSalesHeader.FINDFIRST THEN BEGIN
                            //(1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios. Inicio
                            vNoTercero := rlSalesHeader."Bill-to Customer No.";
                            vNombreTercero := rlSalesHeader."Bill-to Name";
                            //(1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios. Fin
                            rlSalesLine.SETRANGE(rlSalesLine."Document No.", rlSalesHeader."No.");
                            IF rlSalesLine.FINDFIRST THEN
                                vDescripcionLinea := rlSalesLine.Description;
                        END;
                    END ELSE BEGIN
                        IF "G/L Entry"."Document Type" = "G/L Entry"."Document Type"::"Credit Memo" THEN BEGIN
                            rlSalesCrMemoHeader.SETRANGE(rlSalesCrMemoHeader."No.", "G/L Entry"."Document No.");
                            IF rlSalesCrMemoHeader.FINDFIRST THEN BEGIN
                                //(1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios. Inicio
                                vNoTercero := rlSalesCrMemoHeader."Bill-to Customer No.";
                                vNombreTercero := rlSalesCrMemoHeader."Bill-to Name";
                                //(1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios. Fin
                                rlSalesCrMemoLine.SETRANGE(rlSalesCrMemoLine."Document No.", rlSalesCrMemoHeader."No.");
                                IF rlSalesCrMemoLine.FINDFIRST THEN
                                    vDescripcionLinea := rlSalesCrMemoLine.Description;
                            END;
                        END;
                    END;
                END;
            'COMPRAS':
                BEGIN
                    IF "G/L Entry"."Document Type" = "G/L Entry"."Document Type"::Invoice THEN BEGIN
                        rlPurchaseHeader.SETRANGE(rlPurchaseHeader."No.", "G/L Entry"."Document No.");
                        IF rlPurchaseHeader.FINDFIRST THEN BEGIN
                            //(1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios. Inicio
                            vNoTercero := rlPurchaseHeader."Buy-from Vendor No.";
                            vNombreTercero := rlPurchaseHeader."Buy-from Vendor Name";
                            //(1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios. Fin
                            rlPurchaseLine.SETRANGE(rlPurchaseLine."Document No.", rlPurchaseHeader."No.");
                            IF rlPurchaseLine.FINDFIRST THEN
                                vDescripcionLinea := rlPurchaseLine.Description;
                        END;
                    END ELSE BEGIN
                        IF "G/L Entry"."Document Type" = "G/L Entry"."Document Type"::"Credit Memo" THEN BEGIN
                            rlPurchCrMemoHdr.SETRANGE(rlPurchCrMemoHdr."No.", "G/L Entry"."Document No.");
                            IF rlPurchCrMemoHdr.FINDFIRST THEN BEGIN
                                //(1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios. Inicio
                                vNoTercero := rlPurchCrMemoHdr."Buy-from Vendor No.";
                                vNombreTercero := rlPurchCrMemoHdr."Buy-from Vendor Name";
                                //(1.1) S2G (RBM-R) 03-03-20: Nuevo Libro Mayor Colegios. Fin
                                rlPurchCrMemoLine.SETRANGE(rlPurchCrMemoLine."Document No.", rlPurchCrMemoHdr."No.");
                                IF rlPurchCrMemoLine.FINDFIRST THEN
                                    vDescripcionLinea := rlPurchCrMemoLine.Description;
                            END;
                        END;
                    END;
                END;
        END;
    end;
}
