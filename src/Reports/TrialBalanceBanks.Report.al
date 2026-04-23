report 50030 "Trial Balance (Banks)"
{
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
    // (INC) S2G (JDT) 28-11-19: Modificación Layout para que muestre valores negativos.
    // (INC) S2G (JDT) 05-03-20: Modificaciónes: Desgolse de bancos por cuenta auxiliar.
    // //(INC) S2G (JDT) 16-03-20: Nuevo filtro por el campo "Source Code Filter".
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/TrialBalanceBanks.rdlc';
    Caption = 'Trial Balance (Banks)', Comment = 'ESP="Balance de sumas y saldos (Bancos)"';
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Source Code Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(WorkDateFormatted; FORMAT(WORKDATE, 0, 4))
            {
            }
            column(PeriodText1; Text1100003 + PeriodText)
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(IncludeEntries; IncludeEntries)
            {
            }
            column(GLFilter_GLAccount; "G/L Account".TABLECAPTION + ': ' + "G/L Account".GETFILTERS)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(AcumBalance; AcumBalance)
            {
            }
            column(TotalDebitAmtAtEnd; TotalDebitAmtAtEnd)
            {
            }
            column(TotalCreditAmtAtEnd; TotalCreditAmtAtEnd)
            {
            }
            column(TotalBalanceAtEnd; TotalBalanceAtEnd)
            {
            }
            column(TotalPeriodDebitAmt; TotalPeriodDebitAmt)
            {
            }
            column(TotalPeriodCreditAmt; TotalPeriodCreditAmt)
            {
            }
            column(No1_GLAccount; "No.")
            {
            }
            column(TrialBalanceCaption; TrialBalanceCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(AccinPeriodCaption; AccinPeriodCaptionLbl)
            {
            }
            column(AccPeriodatDateCaption; AccPeriodatDateCaptionLbl)
            {
            }
            column(AccountCaption; AccountCaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(BalanceatDateCaption; BalanceatDateCaptionLbl)
            {
            }
            column(AcumBalanceatDateCaption; AcumBalanceatDateCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(DifferenceCaption; DifferenceCaptionLbl)
            {
            }
            column(DebitDifference; vDebitDifference)
            {
            }
            column(BalanceatPeriodCaption; BalanceatPeriodCaptionLbl)
            {
            }
            column(CreditDifference; vCreditDifference)
            {
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(No_GLAccount; "G/L Account"."No.")
                {
                }
                column(IndentName_GLAccount; PADSTR('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(DebitAmount_GLAccount; "G/L Account"."Debit Amount" + OpenDebitAmt + CloseDebitAmt)
                {
                }
                column(CreditAmount_GLAccount; "G/L Account"."Credit Amount" + OpenCreditAmt + CloseCreditAmt)
                {
                }
                column(DebitAmount2_GLAccount; GLAcc2."Debit Amount" + OpenDebitAmtEnd + CloseDebitAmt)
                {
                }
                column(CreditAmount2_GLAccount; GLAcc2."Credit Amount" + OpenCreditAmtEnd + CloseCreditAmt)
                {
                }
                column(BalanceType; BalanceType)
                {
                }
                column(CreditAmount3_GLAccount; GLAcc2."Add.-Currency Credit Amount" + OpenCreditAmtEnd + CloseCreditAmt)
                {
                }
                column(DebitAmount3_GLAccount; GLAcc2."Add.-Currency Debit Amount" + OpenDebitAmtEnd + CloseDebitAmt)
                {
                }
                column(CreditAmount4_GLAccount; "G/L Account"."Add.-Currency Credit Amount" + OpenCreditAmt + CloseCreditAmt)
                {
                }
                column(DebitAmount4_GLAccount; "G/L Account"."Add.-Currency Debit Amount" + OpenDebitAmt + CloseDebitAmt)
                {
                }
                column(AccountType_GLAccount; FORMAT("G/L Account"."Account Type", 0, 2))
                {
                }
                column(GLFilterOption; FORMAT(GLFilterOption, 0, 2))
                {
                }
                column(NoofBlankLines_GLAccount; "G/L Account"."No. of Blank Lines")
                {
                }
                column(PrintAmountsInAddCurrency; PrintAmountsInAddCurrency)
                {
                }
                column(PageGroupNo; PageGroupNo)
                {
                }
                column(AccountType_GLAcc; "G/L Account"."Account Type")
                {
                }
                column(CreditAmountT_GLAccount; "G/L Account"."Credit Amount" + FinalCreditApertura)
                {
                }
                column(DebitAmountT_GLAccount; "G/L Account"."Debit Amount" + FinalDebitApertura)
                {
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemTableView = SORTING("G/L Account No.", "Posting Date")
                                        WHERE("G/L Account No." = FILTER('57*'));
                    column(GLAccount_GLEntry; "G/L Entry"."G/L Account No.")
                    {
                    }
                    column(CodProcedencia_GLEntry; "G/L Entry"."Source No.")
                    {
                    }
                    column(DescProcedencia_GLEntry; "G/L Entry"."Source Description")
                    {
                    }
                    column(Importe_GLEntry; "G/L Entry".Amount)
                    {
                    }
                    column(Debe_GLEntry; "G/L Entry"."Debit Amount")
                    {
                    }
                    column(Haber_GLEntry; "G/L Entry"."Credit Amount")
                    {
                    }
                    column(BankAccount; rBankAccountLedgerEntry."Bank Account No.")
                    {
                    }
                    column(vAcumuladoPeriodo; vAcumuladoPeriodo)
                    {
                    }
                    column(vAcumuladoDebe; vAcumuladoDebe)
                    {
                    }
                    column(vAcumuladoHaber; vAcumuladoHaber)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        //(INC) S2G (JDT) 13-03-20: Modificaciónes: Desgolse de bancos por cuenta auxiliar.
                        //BlankLineNo := "G/L Account"."No. of Blank Lines" + 1;

                        CLEAR(vAcumuladoPeriodo);
                        rGLAccount.SETRANGE(rGLAccount."No.", "G/L Entry"."G/L Account No.");
                        rGLAccount.SETFILTER(rGLAccount."Date Filter", '..%1', "G/L Entry".GETRANGEMAX("Posting Date"));
                        rGLAccount.SETFILTER(rGLAccount."Source Filter", "G/L Entry"."Source No.");
                        IF rGLAccount.FINDSET() THEN BEGIN
                            rGLAccount.CALCFIELDS(rGLAccount."Balance at Date", rGLAccount."Debit Amount", rGLAccount."Credit Amount");
                            vAcumuladoPeriodo := rGLAccount."Balance at Date";
                            vAcumuladoDebe := rGLAccount."Debit Amount";
                            vAcumuladoHaber := rGLAccount."Credit Amount";
                        END;
                        //(INC) S2G (JDT) 13-03-20: Modificaciónes: Desgolse de bancos por cuenta auxiliar.
                    end;

                    trigger OnPreDataItem()
                    begin
                        //(INC) S2G (JDT) 05-03-20: Modificaciónes: Desgolse de bancos por cuenta auxiliar.
                        "G/L Entry".SETRANGE("G/L Entry"."G/L Account No.", "G/L Account"."No.");
                        "G/L Entry".SETFILTER("G/L Entry"."Posting Date", '%1..%2', "G/L Account".GETRANGEMIN("Date Filter"), "G/L Account".GETRANGEMAX("Date Filter"));
                        "G/L Entry".SETRANGE("G/L Entry"."Source Type", "G/L Entry"."Source Type"::"Bank Account");
                        //(INC) S2G (JDT) 05-03-20: Modificaciónes: Desgolse de bancos por cuenta auxiliar.
                    end;
                }
                dataitem(BlankLineRepeater; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    column(BlankLineNo; BlankLineNo)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF BlankLineNo = 0 THEN
                            CurrReport.BREAK;

                        BlankLineNo -= 1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    BlankLineNo := "G/L Account"."No. of Blank Lines" + 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Accumulate := FALSE;
                CALCFIELDS("Debit Amount", "Credit Amount", "Balance at Date", "Add.-Currency Debit Amount",
                           "Add.-Currency Credit Amount", "Add.-Currency Balance at Date", "Net Change", "Balance at Date");
                GLAcc2 := "G/L Account";
                SetGLAccDateFilter;
                IF GlobalDim1 <> '' THEN
                    "G/L Account".COPYFILTER("G/L Account"."Global Dimension 1 Filter", GLAcc2."Global Dimension 1 Filter");
                IF GlobalDim2 <> '' THEN
                    "G/L Account".COPYFILTER("G/L Account"."Global Dimension 2 Filter", GLAcc2."Global Dimension 2 Filter");
                GLAcc2.CALCFIELDS("Additional-Currency Net Change", "Net Change", "Debit Amount", "Credit Amount",
                                  "Add.-Currency Debit Amount", "Add.-Currency Credit Amount", "Balance at Date");
                IF PrintAmountsInAddCurrency THEN BEGIN
                    PreviousBalance := GLAcc2."Additional-Currency Net Change";
                    BalanceType := GLAcc2."Additional-Currency Net Change";
                    IF AcumBalance THEN
                        BalanceType := GLAcc2."Add.-Currency Balance at Date";
                END ELSE BEGIN
                    PreviousBalance := GLAcc2."Net Change";
                    BalanceType := GLAcc2."Net Change";
                    IF AcumBalance THEN
                        BalanceType := GLAcc2."Balance at Date";
                END;
                OpenCreditAmt := 0;
                OpenDebitAmt := 0;
                OpenCreditAmtEnd := 0;
                OpenDebitAmtEnd := 0;
                //--IAP 16/06/21: Invocación de la nueva función que muestra los nuevo debe y haber acumulados del periodo solicitado
                CalcSaldApertura;
                //++IAP
                IF OpenEntries THEN BEGIN
                    IF "Account Type" = "Account Type"::Heading THEN
                        CalcOpenEntriesHeading
                    ELSE
                        CalcOpenEntries;
                    IF NOT AcumBalance THEN
                        BalanceType := BalanceType + OpenDebitAmtEnd - OpenCreditAmtEnd;
                END;
                CloseDebitAmt := 0;
                CloseCreditAmt := 0;
                IF CloseEntries THEN BEGIN
                    IF "Account Type" = "Account Type"::Heading THEN
                        CalcCloseEntriesHeading
                    ELSE
                        CalcCloseEntries;
                    IF NOT AcumBalance THEN
                        BalanceType := BalanceType + CloseDebitAmt - CloseCreditAmt
                    ELSE
                        BalanceType := GLAcc2."Net Change" - BalanceType;
                END;

                IF AcumBalance AND (NOT OpenEntries) AND (NOT CloseEntries) THEN
                    BalanceType := GLAcc2."Net Change";

                PreviousDebit := 0;
                PreviousCredit := 0;
                IF PreviousBalance > 0 THEN
                    PreviousDebit := PreviousBalance
                ELSE
                    PreviousCredit := ABS(PreviousBalance);
                GLAcc.SETRANGE("Date Filter", FromFec, ToFec);
                IF GlobalDim1 <> '' THEN
                    "G/L Account".COPYFILTER("G/L Account"."Global Dimension 1 Filter", GLAcc2."Global Dimension 1 Filter");
                IF GlobalDim2 <> '' THEN
                    "G/L Account".COPYFILTER("G/L Account"."Global Dimension 2 Filter", GLAcc2."Global Dimension 2 Filter");
                GLAcc.CALCFIELDS("Debit Amount", "Credit Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount",
                  "Net Change", "Balance at Date");
                IF NOT PrintAmountsInAddCurrency THEN BEGIN
                    PeriodDebitAmt := GLAcc."Debit Amount";
                    PeriodCreditAmt := GLAcc."Credit Amount";
                    BalanceAtEnd := BalanceAtEnd + PreviousBalance;
                    DebitAmtAtEnd := GLAcc2."Debit Amount";
                    CreditAmtAtEnd := GLAcc2."Credit Amount";
                    I := I + 1;
                    IF I = 1 THEN
                        FixedLevel := STRLEN("No.");
                    IF (COPYSTR("No.", 1, 1) <> PrevAccount) AND (STRLEN("No.") >= FixedLevel) THEN BEGIN
                        Accumulate := TRUE;
                        FirstLevel := STRLEN("No.");
                    END ELSE
                        IF (STRLEN("No.") <= PreviousLevel) AND (STRLEN("No.") <= FirstLevel) AND (STRLEN("No.") >= FixedLevel) THEN
                            Accumulate := TRUE
                        ELSE
                            Accumulate := FALSE;
                    IF Accumulate OR (GLFilterOption = GLFilterOption::Posting) THEN BEGIN
                        TotalPeriodDebitAmt := TotalPeriodDebitAmt + "Debit Amount" + CloseDebitAmt;
                        TotalPeriodCreditAmt := TotalPeriodCreditAmt + "Credit Amount" + CloseCreditAmt;
                        IF IsOpenDate THEN BEGIN
                            TotalPeriodDebitAmt := TotalPeriodDebitAmt + OpenDebitAmt;
                            TotalPeriodCreditAmt := TotalPeriodCreditAmt + OpenCreditAmt;
                        END;
                        TotalDebitAmtAtEnd := TotalDebitAmtAtEnd + DebitAmtAtEnd + OpenDebitAmtEnd + CloseDebitAmt;
                        TotalCreditAmtAtEnd := TotalCreditAmtAtEnd + CreditAmtAtEnd + OpenCreditAmtEnd + CloseCreditAmt;
                        IF OpenEntries OR CloseEntries THEN
                            TotalBalanceAtEnd := TotalBalanceAtEnd + BalanceType
                        ELSE
                            TotalBalanceAtEnd := TotalBalanceAtEnd + BalanceAtEnd;
                    END;
                END ELSE BEGIN
                    PeriodDebitAmt := GLAcc."Add.-Currency Debit Amount";
                    PeriodCreditAmt := GLAcc."Add.-Currency Credit Amount";
                    BalanceAtEnd := BalanceAtEnd + PreviousBalance;
                    DebitAmtAtEnd := GLAcc2."Add.-Currency Debit Amount";
                    CreditAmtAtEnd := GLAcc2."Add.-Currency Credit Amount";
                    IF COPYSTR("No.", 1, 1) <> PrevAccount THEN BEGIN
                        Accumulate := TRUE;
                        FirstLevel := STRLEN("No.");
                    END ELSE
                        IF (STRLEN("No.") <= PreviousLevel) AND (STRLEN("No.") <= FirstLevel) THEN
                            Accumulate := TRUE
                        ELSE
                            Accumulate := FALSE;
                    IF Accumulate OR (GLFilterOption = GLFilterOption::Posting) THEN BEGIN
                        TotalPeriodDebitAmt := TotalPeriodDebitAmt + "Add.-Currency Debit Amount" + CloseDebitAmt;
                        TotalPeriodCreditAmt := TotalPeriodCreditAmt + "Add.-Currency Credit Amount" + CloseCreditAmt;
                        IF IsOpenDate THEN BEGIN
                            TotalPeriodDebitAmt := TotalPeriodDebitAmt + OpenDebitAmt;
                            TotalPeriodCreditAmt := TotalPeriodCreditAmt + OpenCreditAmt;
                        END;
                        TotalDebitAmtAtEnd := TotalDebitAmtAtEnd + DebitAmtAtEnd + OpenDebitAmtEnd + CloseDebitAmt;
                        TotalCreditAmtAtEnd := TotalCreditAmtAtEnd + CreditAmtAtEnd + OpenCreditAmtEnd + CloseCreditAmt;
                        IF OpenEntries OR CloseEntries THEN
                            TotalBalanceAtEnd := TotalBalanceAtEnd + BalanceType
                        ELSE
                            TotalBalanceAtEnd := TotalBalanceAtEnd + BalanceAtEnd;
                    END;
                END;

                IF (STRLEN("No.") >= FixedLevel) THEN BEGIN
                    PreviousLevel := STRLEN("No.");
                    PrevAccount := COPYSTR("No.", 1, 1);
                END;

                IF PrintAllHavingBal AND ("Balance at Date" = 0) AND ("Debit Amount" = 0) AND ("Credit Amount" = 0) THEN
                    CurrReport.SKIP;

                IF GlobalNo < 1 THEN BEGIN
                    GLSetup.GET();
                    IF PrintAmountsInAddCurrency THEN
                        HeaderText := STRSUBSTNO(Text1100004, GLSetup."Additional Reporting Currency")
                    ELSE BEGIN
                        GLSetup.TESTFIELD("LCY Code");
                        HeaderText := STRSUBSTNO(Text1100004, GLSetup."LCY Code");
                    END;
                    IF OpenEntries AND NOT CloseEntries THEN
                        IncludeEntries := Text1100005;
                    IF CloseEntries AND NOT OpenEntries THEN
                        IncludeEntries := Text1100006;
                    IF CloseEntries AND OpenEntries THEN
                        IncludeEntries := Text1100007;
                    GlobalNo := GlobalNo + 1;
                END;

                PageGroupNo := NextPageGroupNo;
                IF "New Page" THEN
                    NextPageGroupNo := PageGroupNo + 1;

                //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
                vDebitDifference := 0.1;
                vCreditDifference := 0.2;
                IF TotalPeriodDebitAmt - TotalPeriodCreditAmt >= 0 THEN
                    vDebitDifference := ABS(TotalPeriodDebitAmt - TotalPeriodCreditAmt)
                ELSE
                    vCreditDifference := ABS(TotalPeriodDebitAmt - TotalPeriodCreditAmt);
                //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin
            end;

            trigger OnPostDataItem()
            begin
                "G/L Account".SETRANGE("Date Filter");
                "G/L Account".SETRANGE("Global Dimension 1 Filter");
                "G/L Account".SETRANGE("Global Dimension 2 Filter");
                /*CurrReport.SHOWOUTPUT(Cuenta.GETFILTERS = '');*/
            end;

            trigger OnPreDataItem()
            begin
                SetDefaultAccountType();
                FromFec := 0D;
                IF GETFILTER("Date Filter") = '' THEN
                    ToFec := 99991231D
                ELSE BEGIN
                    FromFec := GETRANGEMIN("Date Filter");
                    ToFec := GETRANGEMAX("Date Filter");
                END;
                CurrReport.CREATETOTALS(PeriodDebitAmt, PeriodCreditAmt, DebitAmtAtEnd, CreditAmtAtEnd, BalanceAtEnd);
                GLFilter := "G/L Account".GETFILTER("G/L Account"."Account Type");
                IF GLFilter <> '' THEN BEGIN
                    // Only accept single account type filter, to display both 2 types user should leave this filter blank.
                    GLFilterOption := GETRANGEMIN("Account Type");
                    SETRANGE("Account Type", GLFilterOption);
                END ELSE
                    GLFilterOption := -1;

                IF CloseEntries THEN
                    IF ToFec <> NORMALDATE(ToFec) THEN
                        IsClosingDate(ToFec)
                    ELSE
                        ERROR(Text1100002, ToFec);
                IF OpenEntries THEN
                    IsOpenDate := IsOpeningDate(FromFec);
                I := 0;

                PageGroupNo := 1;
                NextPageGroupNo := 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESP="Opciones"';
                    field(OnlyGLAccountsWithBalanceAtDate; PrintAllHavingBal)
                    {
                        Caption = 'Only G/L accounts with Balance at Date', Comment = 'ESP="Solo cuentas contables con saldo a fecha"';
                        MultiLine = true;
                        ApplicationArea = All;
                    }
                    field(ShowAmountsInAddCurrency; PrintAmountsInAddCurrency)
                    {
                        Caption = 'Show Amounts in Add. Currency', Comment = 'ESP="Mostrar importes en divisa adicional"';
                        ApplicationArea = All;
                    }
                    field(AcumBalanceAtDate; AcumBalance)
                    {
                        Caption = 'Acum. Balance at date', Comment = 'ESP="Saldo acum. a fecha"';
                        ApplicationArea = All;
                    }
                    field(IncludeOpeningEntries; OpenEntries)
                    {
                        Caption = 'Include Opening Entries', Comment = 'ESP="Incluir movimientos de apertura"';
                        ApplicationArea = All;
                    }
                    field(IncludeClosingEntries; CloseEntries)
                    {
                        Caption = 'Include Closing Entries', Comment = 'ESP="Incluir movimientos de cierre"';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            //PrintAllHavingBal := TRUE;
            SetDefaultRequestOptions();
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin

        SetDefaultRequestOptions();
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin
    end;

    trigger OnPreReport()
    begin
        PeriodText := "G/L Account".GETFILTER("Date Filter");
        GlobalDim1 := "G/L Account".GETFILTER("G/L Account"."Global Dimension 1 Filter");
        GlobalDim2 := "G/L Account".GETFILTER("G/L Account"."Global Dimension 2 Filter");
    end;

    var
        Text1100002: Label 'The date %1 is not a Closing Date', Comment = 'ESP="La fecha %1 no es una fecha de cierre"';
        Text1100003: Label 'Period: ', Comment = 'ESP="Periodo: "';
        Text1100004: Label 'All Amounts in %1', Comment = 'ESP="Todos los importes en %1"';
        Text1100005: Label 'Include Opening Entries', Comment = 'ESP="Incluir movimientos de apertura"';
        Text1100006: Label 'Include Closing Entries', Comment = 'ESP="Incluir movimientos de cierre"';
        Text1100007: Label 'Include Closing/Opening Entries', Comment = 'ESP="Incluir movimientos de cierre/apertura"';
        Text1100008: Label 'The fiscal year does not exist', Comment = 'ESP="El ejercicio fiscal no existe"';
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        GLAcc2: Record "G/L Account";
        HeaderText: Text[30];
        PeriodText: Text[30];
        FromFec: Date;
        ToFec: Date;
        PrintAllHavingBal: Boolean;
        IncludeEntries: Text[40];
        GLFilter: Text[30];
        GLFilterOption: Option Posting,Heading;
        PreviousBalance: Decimal;
        PreviousDebit: Decimal;
        PreviousCredit: Decimal;
        IsOpenDate: Boolean;
        PrintAmountsInAddCurrency: Boolean;
        PeriodDebitAmt: Decimal;
        PeriodCreditAmt: Decimal;
        BalanceAtEnd: Decimal;
        DebitAmtAtEnd: Decimal;
        CreditAmtAtEnd: Decimal;
        TotalPeriodDebitAmt: Decimal;
        TotalPeriodCreditAmt: Decimal;
        TotalBalanceAtEnd: Decimal;
        TotalDebitAmtAtEnd: Decimal;
        TotalCreditAmtAtEnd: Decimal;
        BalanceType: Decimal;
        AcumBalance: Boolean;
        CloseEntries: Boolean;
        OpenEntries: Boolean;
        OpenCreditAmt: Decimal;
        OpenDebitAmt: Decimal;
        CloseCreditAmt: Decimal;
        CloseDebitAmt: Decimal;
        OpenCreditAmtEnd: Decimal;
        OpenDebitAmtEnd: Decimal;
        PreviousLevel: Integer;
        PrevAccount: Code[1];
        FirstLevel: Integer;
        Accumulate: Boolean;
        GlobalDim1: Text[30];
        GlobalDim2: Text[30];
        I: Integer;
        FixedLevel: Integer;
        GlobalNo: Integer;
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        TrialBalanceCaptionLbl: Label 'Trial Balance', Comment = 'ESP="Balance de sumas y saldos"';
        PageCaptionLbl: Label 'Page', Comment = 'ESP="Página"';
        AccinPeriodCaptionLbl: Label 'Acc. in Period', Comment = 'ESP="Movs. en periodo"';
        AccPeriodatDateCaptionLbl: Label 'Acc. Period at Date', Comment = 'ESP="Movs. periodo a fecha"';
        AccountCaptionLbl: Label 'Account', Comment = 'ESP="Cuenta"';
        NameCaptionLbl: Label 'Name', Comment = 'ESP="Nombre"';
        DebitCaptionLbl: Label 'Debit', Comment = 'ESP="Debe"';
        CreditCaptionLbl: Label 'Credit', Comment = 'ESP="Haber"';
        BalanceatDateCaptionLbl: Label 'Balance at Date', Comment = 'ESP="Saldo a fecha"';
        BalanceatPeriodCaptionLbl: Label 'Balance at Period', Comment = 'ESP="Saldo en periodo"';
        AcumBalanceatDateCaptionLbl: Label 'Acum. Balance at Date', Comment = 'ESP="Saldo acum. a fecha"';
        TotalCaptionLbl: Label 'Total. . . . . . . . ', Comment = 'ESP="Total. . . . . . . . "';
        BlankLineNo: Integer;
        DifferenceCaptionLbl: Label 'Diferencia . . . .', Comment = 'ESP="Diferencia . . . ."';
        vDebitDifference: Decimal;
        vCreditDifference: Decimal;
        TempGLEntry: Record "G/L Entry" temporary;
        vImporte: Decimal;
        vDebitAcumulado: Decimal;
        vCreditAcumulado: Decimal;
        rBankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        rGLEntry: Record "G/L Entry";
        rGLAccount: Record "G/L Account";
        vAcumuladoPeriodo: Decimal;
        vAcumuladoDebe: Decimal;
        vAcumuladoHaber: Decimal;
        FinalDebitApertura: Decimal;
        FinalCreditApertura: Decimal;
        DebitApertura: Decimal;
        CreditApertura: Decimal;

    local procedure SetDefaultRequestOptions()
    begin
        PrintAllHavingBal := true;
        AcumBalance := true;
        if "G/L Account".GetFilter("Account Type") = '' then
            "G/L Account".SetRange("Account Type", "G/L Account"."Account Type"::Posting);
    end;

    local procedure SetDefaultAccountType()
    begin
        if "G/L Account".GetFilter("Account Type") = '' then
            "G/L Account".SetRange("Account Type", "G/L Account"."Account Type"::Posting);
    end;

    procedure StartingPeriod(Date: Date): Date
    var
        AccPeriod: Record "Accounting Period";
    begin
        AccPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccPeriod.SETFILTER("Starting Date", '<= %1', Date);
        IF AccPeriod.FIND('+') THEN
            EXIT(AccPeriod."Starting Date")
        ELSE
            ERROR(Text1100008);
    end;

    procedure IsOpeningDate(Date: Date): Boolean
    var
        AccPeriod5: Record "Accounting Period";
    begin
        AccPeriod5.SETRANGE(AccPeriod5."New Fiscal Year", TRUE);
        AccPeriod5.SETRANGE(AccPeriod5."Starting Date", Date);
        IF AccPeriod5.FIND('-') THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    procedure IsClosingDate(ToFec: Date)
    var
        AccPeriod2: Record "Accounting Period";
    begin
        AccPeriod2.SETRANGE(AccPeriod2."New Fiscal Year", TRUE);
        IF AccPeriod2.GET(NORMALDATE(ToFec) + 1) THEN
            EXIT
        ELSE
            ERROR(Text1100002, ToFec);
    end;

    procedure CalcOpenEntries()
    var
        GlAccount3: Record "G/L Account";
        AccPeriod3: Record "Accounting Period";
    begin
        AccPeriod3.SETRANGE(AccPeriod3."New Fiscal Year", TRUE);
        AccPeriod3.SETFILTER(AccPeriod3."Starting Date", '<= %1', FromFec);
        IF AccPeriod3.FIND('+') THEN BEGIN
            GlAccount3.GET("G/L Account"."No.");
            GlAccount3.SETRANGE(GlAccount3."Date Filter", 0D, CLOSINGDATE((AccPeriod3."Starting Date" - 1)));
            IF GlobalDim1 <> '' THEN
                GlAccount3.SETFILTER("Global Dimension 1 Filter", GlobalDim1);
            IF GlobalDim2 <> '' THEN
                GlAccount3.SETFILTER("Global Dimension 2 Filter", GlobalDim2);
            GlAccount3.CALCFIELDS("Additional-Currency Net Change", "Net Change");
            IF PrintAmountsInAddCurrency THEN BEGIN
                IF GlAccount3."Additional-Currency Net Change" > 0 THEN
                    OpenDebitAmtEnd := GlAccount3."Additional-Currency Net Change"
                ELSE
                    OpenCreditAmtEnd := ABS(GlAccount3."Additional-Currency Net Change");
            END ELSE BEGIN
                IF GlAccount3."Net Change" > 0 THEN
                    OpenDebitAmtEnd := GlAccount3."Net Change"
                ELSE
                    OpenCreditAmtEnd := ABS(GlAccount3."Net Change");
            END;
            IF IsOpenDate THEN BEGIN
                OpenDebitAmt := OpenDebitAmtEnd;
                OpenCreditAmt := OpenCreditAmtEnd;
            END;
        END;
    end;

    procedure CalcCloseEntries()
    var
        GlAccount4: Record "G/L Account";
        AccPeriod4: Record "Accounting Period";
    begin
        AccPeriod4.SETRANGE(AccPeriod4."New Fiscal Year", TRUE);
        AccPeriod4.GET((NORMALDATE(ToFec) + 1));
        GlAccount4.GET("G/L Account"."No.");
        GlAccount4.SETRANGE(GlAccount4."Date Filter", 0D, ToFec);
        IF GlobalDim1 <> '' THEN
            GlAccount4.SETFILTER("Global Dimension 1 Filter", GlobalDim1);
        IF GlobalDim2 <> '' THEN
            GlAccount4.SETFILTER("Global Dimension 2 Filter", GlobalDim2);
        GlAccount4.CALCFIELDS("Additional-Currency Net Change", "Net Change");
        IF PrintAmountsInAddCurrency THEN BEGIN
            IF GlAccount4."Additional-Currency Net Change" > 0 THEN
                CloseCreditAmt := ABS(GlAccount4."Additional-Currency Net Change")
            ELSE
                CloseDebitAmt := ABS(GlAccount4."Additional-Currency Net Change");
        END ELSE BEGIN
            IF GlAccount4."Net Change" > 0 THEN
                CloseCreditAmt := ABS(GlAccount4."Net Change")
            ELSE
                CloseDebitAmt := ABS(GlAccount4."Net Change");
        END;
    end;

    procedure CalcCloseEntriesHeading()
    var
        GLAcc: Record "G/L Account";
        long: Integer;
    begin
        GLAcc.SETRANGE("Date Filter", 0D, ToFec);
        GLAcc.SETFILTER("No.", "G/L Account".Totaling);
        GLAcc.SETRANGE("Account Type", GLAcc."Account Type"::Posting);
        IF GlobalDim1 <> '' THEN
            GLAcc.SETFILTER("Global Dimension 1 Filter", GlobalDim1);
        IF GlobalDim2 <> '' THEN
            GLAcc.SETFILTER("Global Dimension 2 Filter", GlobalDim2);

        IF GLAcc.FIND('-') THEN BEGIN
            REPEAT
                GLAcc.CALCFIELDS("Additional-Currency Net Change", "Net Change");
                IF PrintAmountsInAddCurrency THEN BEGIN
                    IF GLAcc."Additional-Currency Net Change" > 0 THEN
                        CloseCreditAmt := CloseCreditAmt + ABS(GLAcc."Additional-Currency Net Change")
                    ELSE
                        CloseDebitAmt := CloseDebitAmt + ABS(GLAcc."Additional-Currency Net Change");
                END ELSE BEGIN
                    IF GLAcc."Net Change" > 0 THEN
                        CloseCreditAmt := CloseCreditAmt + ABS(GLAcc."Net Change")
                    ELSE
                        CloseDebitAmt := CloseDebitAmt + ABS(GLAcc."Net Change");
                END;
            UNTIL GLAcc.NEXT() = 0;
        END;
    end;

    procedure CalcOpenEntriesHeading()
    var
        GLAcc: Record "G/L Account";
        long: Integer;
        AccPeriod3: Record "Accounting Period";
    begin
        AccPeriod3.SETRANGE(AccPeriod3."New Fiscal Year", TRUE);
        AccPeriod3.SETFILTER(AccPeriod3."Starting Date", '<= %1', FromFec);
        IF AccPeriod3.FIND('+') THEN BEGIN
            GLAcc.SETRANGE("Date Filter", 0D, CLOSINGDATE((AccPeriod3."Starting Date" - 1)));
            GLAcc.SETFILTER("No.", "G/L Account".Totaling);
            GLAcc.SETRANGE("Account Type", GLAcc."Account Type"::Posting);
            IF GlobalDim1 <> '' THEN
                GLAcc.SETFILTER("Global Dimension 1 Filter", GlobalDim1);
            IF GlobalDim2 <> '' THEN
                GLAcc.SETFILTER("Global Dimension 2 Filter", GlobalDim2);
            IF GLAcc.FIND('-') THEN BEGIN
                REPEAT
                    GLAcc.CALCFIELDS("Additional-Currency Net Change", "Net Change");
                    IF PrintAmountsInAddCurrency THEN BEGIN
                        IF GLAcc."Additional-Currency Net Change" > 0 THEN
                            OpenDebitAmtEnd := OpenDebitAmtEnd + ABS(GLAcc."Additional-Currency Net Change")
                        ELSE
                            OpenCreditAmtEnd := OpenCreditAmtEnd + ABS(GLAcc."Additional-Currency Net Change");
                    END ELSE BEGIN
                        IF GLAcc."Net Change" > 0 THEN
                            OpenDebitAmtEnd := OpenDebitAmtEnd + ABS(GLAcc."Net Change")
                        ELSE
                            OpenCreditAmtEnd := OpenCreditAmtEnd + ABS(GLAcc."Net Change");
                    END;
                UNTIL GLAcc.NEXT() = 0;
            END;
            IF IsOpenDate THEN BEGIN
                OpenDebitAmt := OpenDebitAmtEnd;
                OpenCreditAmt := OpenCreditAmtEnd;
            END;
        END;
    end;

    local procedure SetGLAccDateFilter()
    begin
        IF AcumBalance THEN
            GLAcc2.SETRANGE("Date Filter", 0D, ToFec)
        ELSE
            GLAcc2.SETRANGE("Date Filter", StartingPeriod(FromFec), ToFec);

        //--IAP 16/06/21: Nueva función CalcSaldApertura para que se incluya en el debe y haber acumulado del periodo solicitado, el
        //saldo acumulado de apertura del día anterior a este periodo
    end;

    procedure CalcSaldApertura()
    var
        GlAccount3: Record "G/L Account";
        AccPeriod3: Record "Accounting Period";
    begin
        FinalDebitApertura := 0;
        FinalCreditApertura := 0;
        AccPeriod3.SETRANGE(AccPeriod3."New Fiscal Year", TRUE);
        AccPeriod3.SETFILTER(AccPeriod3."Starting Date", '<= %1', FromFec);
        IF AccPeriod3.FIND('+') THEN BEGIN
            GlAccount3.GET("G/L Account"."No.");
            GlAccount3.SETRANGE(GlAccount3."Date Filter", 0D, CLOSINGDATE((AccPeriod3."Starting Date" - 1)));
            IF GlobalDim1 <> '' THEN
                GlAccount3.SETFILTER("Global Dimension 1 Filter", GlobalDim1);
            IF GlobalDim2 <> '' THEN
                GlAccount3.SETFILTER("Global Dimension 2 Filter", GlobalDim2);
            GlAccount3.CALCFIELDS("Additional-Currency Net Change", "Net Change");
            IF GlAccount3."Additional-Currency Net Change" > 0 THEN
                FinalDebitApertura := GlAccount3."Additional-Currency Net Change"
            ELSE
                FinalCreditApertura := ABS(GlAccount3."Additional-Currency Net Change");

            IF GlAccount3."Net Change" > 0 THEN
                FinalDebitApertura := GlAccount3."Net Change"
            ELSE
                FinalCreditApertura := ABS(GlAccount3."Net Change");

            IF IsOpenDate THEN BEGIN
                DebitApertura := FinalDebitApertura;
                CreditApertura := FinalCreditApertura;
            END;
        END;
        //++IAP
    end;
}
