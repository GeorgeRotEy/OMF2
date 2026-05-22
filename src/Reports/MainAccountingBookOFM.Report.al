report 50009 "Main Accounting Book OFM"
{
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
    // (INC) S2G (JDT) 25-11-19: Modificaciones en dimensiones de ArrayTercero.
    // //(INC) S2G (JDT) 16-03-20: Nuevo filtro por el campo "Source Code Filter".
    // OFM006 KPMG (DPM) 28/09/21: Añadimos columna con saldo de banco
    //
    // KPMG ATS OMF030 08-03-2022.
    //   Mod function:
    //     G/L Entry - OnAfterGetRecord()
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/MainAccountingBookOFM.rdlc';
    Caption = 'Main Accounting Book OFM', Comment = 'ESP="Libro mayor OFM"';
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            CalcFields = "Balance at Date";
            DataItemTableView = SORTING("Account Type")
                                ORDER(Ascending)
                                WHERE("Account Type" = CONST(Posting),
                                      "No." = FILTER('1..5999999'));
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
            column(NombreCuenta; "G/L Account".Name)
            {
            }
            column(Saldo; "G/L Account"."Balance at Date")
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No."),
                               "Posting Date" = FIELD("Date Filter"),
                               "Source Code" = FIELD("Source Code Filter");
                //The property 'DataItemTableView' shouldn't have an empty value.
                //DataItemTableView = '';
                RequestFilterFields = "Source Type", "Source No.";
                column(Tercero; vTercero)
                {
                }
                column(vSaldoBanco; vSaldoBanco)
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
                column(AmountAcumulate; AmountAcumulate)
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
                column(Saldo_old; vSaldo)
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
                column(Visibility; vVisibility)
                {
                }
                column(SaldoAnteriorLayout; vSaldoAnteriorLayout)
                {
                }
                column(SaldoInicial; vSaldoInicial)
                {
                }

                trigger OnAfterGetRecord()
                var
                    rGLacc: Record "G/L Account";
                    rGLEntry: Record "G/L Entry";
                begin
                    vVisibility := 1;

                    //vTercero := '';
                    vTerceroII := vTercero;
                    CASE "G/L Entry"."Source Type" OF
                        "G/L Entry"."Source Type"::"Bank Account":
                            BEGIN
                                rBankAccount.GET("G/L Entry"."Source No.");
                                vTercero := "G/L Entry"."Source No." + ' - ' + rBankAccount.Name;
                                //--OFM006 KPMG (DPM) 28/09/21
                                IF vTercero <> vTerceroII THEN
                                    AmountAcumulate := 0;

                                rBankAccount.RESET();
                                rBankAccount.SETRANGE("No.", "G/L Entry"."Source No.");
                                //KPMG ATS OMF030 08-03-2022. BEGIN
                                //comentado:
                                /*
                                rBankAccount.SETFILTER("Date Filter",'%1..%2',0D,vStartDate);
                                */
                                //Obtener el último día del mes anterior de la fecha de inicio indicada.
                                vLastMDate := 0D;
                                vLastDayLastMDate := 0D;
                                vLastMDate := CALCDATE('-1M', vStartDate);
                                if vAPI then
                                    vLastDayLastMDate := CALCDATE('<CM>', vLastMDate)
                                else
                                    vLastDayLastMDate := CALCDATE('<CM>', vLastMDate);

                                rBankAccount.SETFILTER("Date Filter", '%1..%2', 0D, vLastDayLastMDate);
                                //KPMG ATS OMF030 08-03-2022. END

                                rBankAccount.CALCFIELDS("Net Change");
                                vSaldoBanco := rBankAccount."Net Change";
                                AmountAcumulate += "G/L Entry".Amount;
                                //++OFM006 KPMG (DPM) 28/09/21
                            END;
                        "G/L Entry"."Source Type"::Customer:
                            BEGIN
                                rCustomer.GET("G/L Entry"."Source No.");
                                vTercero := "G/L Entry"."Source No." + ' - ' + rCustomer.Name;
                            END;
                        "G/L Entry"."Source Type"::Vendor:
                            BEGIN
                                rVendor.GET("G/L Entry"."Source No.");
                                vTercero := "G/L Entry"."Source No." + ' - ' + rVendor.Name;
                            END;
                        "G/L Entry"."Source Type"::"Fixed Asset":
                            BEGIN
                                rFixedAsset.GET("G/L Entry"."Source No.");
                                vTercero := "G/L Entry"."Source No." + ' - ' + rFixedAsset.Description
                            END;
                    END;

                    //(INC) S2G (JDT) 25-11-19: Modificaciones en dimensiones de ArrayTercero.
                    IF ARRAYLEN(ArrayTercero) = i THEN BEGIN
                        MESSAGE(Text001Lbl);
                        CurrReport.BREAK;
                    END ELSE
                        // (INC) S2G (JDT) 25-11-19:
                        IF vTerceroII <> vTercero THEN BEGIN
                            i := i + 1;
                            ArrayTercero[i] := "Source No.";
                            rGLacc.GET("G/L Account No.");
                            rGLacc.COPYFILTERS("G/L Account");
                            rGLacc.SETRANGE("Date Filter", 0D, CLOSINGDATE(CALCDATE('<-1D>', vStartDate)));
                            //(INC) S2G (JDT) 16-03-20:
                            IF vFiltroSourceCode <> '' THEN
                                rGLacc.SETRANGE("Source Code Filter", vFiltroSourceCode);
                            //(INC) S2G (JDT) 16-03-20:
                            rGLacc.SETRANGE("Source Filter", "Source No.");
                            rGLacc.CALCFIELDS("Net Change");
                            vSaldoInicial := rGLacc."Net Change";
                            //vVisibility := TRUE;

                            //S2G (RBM-R) 15-07-20. Inicio || KPMG ATD 07/01/2020
                            //vSaldo := vSaldoInicial;
                            //S2G (RBM-R) 15-07-20. Inicio || KPMG ATD 07/01/2020

                            rGLEntry.RESET();
                            rGLEntry.SETRANGE("G/L Account No.", "G/L Account"."No.");
                            rGLEntry.SETRANGE("Posting Date", 0D, CLOSINGDATE(CALCDATE('<-1D>', vStartDate)));
                            //rGLEntry.SETFILTER("Source No.",'=%1',"Source No.");
                            //(INC) S2G (JDT) 16-03-20:
                            IF vFiltroSourceCode <> '' THEN
                                rGLEntry.SETFILTER("Source Code", vFiltroSourceCode);
                            //(INC) S2G (JDT) 16-03-20:
                            IF rGLEntry.FINDSET() THEN
                                REPEAT
                                //vSaldoAnterior += rGLEntry."Debit Amount" - rGLEntry."Credit Amount";
                                ///vSaldoAnteriorLayout += rGLEntry."Debit Amount" - rGLEntry."Credit Amount";
                                UNTIL rGLEntry.NEXT() = 0;
                            //vSaldo := vSaldoInicial + vSaldoAnterior;
                            //CLEAR(vSaldoAnterior);
                        END
                        ELSE
                            vVisibility := 0;

                    //S2G (RBM-R) 15-07-20. Inicio || KPMG ATD 07/01/2020 modificaciones
                    //vSaldo = vSaldo + ("Debit Amount" - "Credit Amount") + vSaldoAnterior;
                    vSaldo := vSaldo + ("Debit Amount" - "Credit Amount");
                    //S2G (RBM-R) 15-07-20. Fin || KPMG ATD 07/01/2020 modificaciones

                    vSaldoaFechaSinCodOrigen := vSaldoaFecha - vSaldoAnterior;
                end;

                trigger OnPreDataItem()
                var
                    rGLAcc: Record "G/L Account";
                begin
                    vSaldo := 0;
                    vTercero := '';
                    i := 0;
                    //-OFM006
                    vSaldoBanco := 0;
                    AmountAcumulate := 0;
                    //++OFM006

                    IF vSourceType <> vSourceType::" " THEN
                        SETRANGE("Source Type", vSourceType);
                    IF vSourceNo <> '' THEN
                        SETRANGE("Source No.", vSourceNo);
                    IF vDateFilter <> '' THEN
                        SETFILTER("Posting Date", vDateFilter);

                    rGLAcc.GET("G/L Account"."No.");
                    rGLAcc.COPYFILTERS("G/L Account");
                    rGLAcc.SETRANGE("Date Filter", 0D, CLOSINGDATE(CALCDATE('<-1D>', vStartDate)));
                    //EVALUATE(datetest,'31/12/18');
                    //(INC) S2G (JDT) 16-03-20:
                    IF vFiltroSourceCode <> '' THEN
                        rGLAcc.SETRANGE("Source Code Filter", vFiltroSourceCode);
                    //(INC) S2G (JDT) 16-03-20:
                    rGLAcc.CALCFIELDS("Balance at Date");
                    vSaldoaFecha := rGLAcc."Balance at Date";
                    //12-01-2021 GRL: Incluir código para ordenar registros.Begin
                    vSaldo := vSaldoaFecha;
                    //12-01-2021 GRL: Incluir código para ordenar registros.End

                    // 23-12-2020 ATD: Incluir código para ordenar registros.
                    IF (("G/L Account"."No." = '4000001') OR ("G/L Account"."No." = '4100001') OR ("G/L Account"."No." = '4300001')
                      OR ("G/L Account"."No." = '5700001') OR ("G/L Account"."No." = '5720001'))
                      THEN
                        "G/L Entry".SETCURRENTKEY("G/L Account No.", "Source Type", "Source No.", "Posting Date")
                    ELSE
                        "G/L Entry".SETCURRENTKEY("Posting Date");
                    // 23-12-2020 ATD: Fin incluir código para ordenar registros.
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CALCFIELDS(Balance);
            end;

            trigger OnPreDataItem()
            begin
                rCompanyInfo.GET();
                rCompanyInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
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
        //(INC) S2G (JDT) 16-03-20:
        vFiltroSourceCode := "G/L Account".GETFILTER("Source Code Filter");
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
        vSourceType: Option " ","Customer","Vendor","Bank Account","Fixed Asset";
        vSourceNo: Code[20];
        vDateFilter: Text;
        vStartDate: Date;
        vFinalDate: Date;
        vSaldoInicial: Decimal;
        vTerceroII: Text;
        vSaldoAnterior: Decimal;
        ArrayTercero: array[600] of Code[20];
        i: Integer;
        vSaldoaFechaSinCodOrigen: Decimal;
        vSaldoaFecha: Decimal;
        Text001Lbl: Label 'No se ha podido generar el informe, pongese en contacto con el administrador.', Comment = 'ESP="No se ha podido generar el informe, pongese en contacto con el administrador."';
        vFiltroSourceCode: Code[20];
        vVisibility: Integer;
        vSaldoAnteriorLayout: Decimal;
        vSaldoBanco: Decimal;
        AmountAcumulate: Decimal;
        vLastDayLastMDate: Date;
        vLastMDate: Date;
        vAPI: Boolean;
        vThirdPartyType: Option " ","Customer","Vendor","Bank Account","Fixed Asset";
        vThirdPartyNo: Code[20];

    procedure fSetGLEntryParameters(pSourceType: Option " ","Customer","Vendor","Bank Account","Fixed Asset"; pSourceNo: Code[20])
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

    procedure fSetAPI(pAPI: Boolean)
    begin
        vAPI := pAPI;
    end;
}
