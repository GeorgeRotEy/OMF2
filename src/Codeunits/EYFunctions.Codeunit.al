codeunit 50015 "EY Functions"
{
    procedure GetSelectionFilterForSourceCode(VAR SourceCode: Record "Source Code"): Text
    var
        RecRef: RecordRef;
    begin
        // (FCO) S2G (CSM) 07/04/2020 : begin
        RecRef.GETTABLE(SourceCode);
        EXIT(cSelectionFilterManagement.GetSelectionFilter(RecRef, SourceCode.FIELDNO(Code)));
        // (FCO) S2G (CSM) 07/04/2020 : end
    end;

    //Intercompany
    // PROCEDURE fExistIntercompanyTransactionLines(pGenJnlLine: Record "Gen. Journal Line"): Boolean;
    // VAR
    //     rlICTransactionLine: Record "Intercompany Transaction Line";
    // BEGIN
    //     // MOD. S2G (JMP) 16/04/2018 GF008
    //     rlICTransactionLine.RESET();
    //     rlICTransactionLine.SETRANGE("Table ID", DATABASE::"Gen. Journal Line");
    //     rlICTransactionLine.SETRANGE("Source Doc. No.", pGenJnlLine."Journal Template Name");
    //     rlICTransactionLine.SETRANGE("Source Doc. Subtype", pGenJnlLine."Journal Batch Name");
    //     rlICTransactionLine.SETRANGE("Source Doc. Line No.", pGenJnlLine."Line No.");
    //     EXIT(NOT rlICTransactionLine.ISEMPTY);
    //     // MOD. S2G (JMP) 16/04/2018 GF008
    // END;

    PROCEDURE fLogThirdParty(pThirdParty: Record "Third Party");
    VAR
        VATRegistrationLog: Record "VAT Registration Log";
        CountryCode: Code[10];
    BEGIN
        //(CR002) S2G (RBM-R) 29-08-18: Validaci�n de CIF en Terceros
        CountryCode := GetCountryCode(pThirdParty."Country/Region Code");
        IF NOT IsEUCountry(CountryCode) THEN
            EXIT;

        InsertVATRegistrationLog(
          pThirdParty."VAT Registration No.", CountryCode, VATRegistrationLog."Account Type"::"Third Party", pThirdParty."No.");
    END;

    PROCEDURE fLogCheckAltaTerceros(pAltaTerceros: Record "Alta Terceros");
    VAR
        VATRegistrationLog: Record "VAT Registration Log";
        CountryCode: Code[10];
    BEGIN
        //(CJ02) S2G (JDT) 25-10-19: Validaci�n de CIF en Alta Terceros
        CountryCode := GetCountryCode(pAltaTerceros."Country/Region Code");
        IF NOT IsEUCountry(CountryCode) THEN
            EXIT;

        InsertVATRegistrationLog(
          pAltaTerceros."VAT Registration No.", CountryCode, VATRegistrationLog."Account Type"::PostThirdParty, pAltaTerceros."No.");
    END;

    LOCAL PROCEDURE GetCountryCode(CountryCode: Code[10]): Code[10];
    VAR
        CompanyInformation: Record "Company Information";
    BEGIN
        IF CountryCode <> '' THEN
            EXIT(CountryCode);

        CompanyInformation.GET();
        EXIT(CompanyInformation."Country/Region Code");
    END;

    local procedure IsEUCountry(CountryCode: Code[10]): Boolean
    var
        CountryRegion: Record "Country/Region";
        CompanyInformation: Record "Company Information";
    begin
        if (CountryCode = '') and CompanyInformation.Get() then
            CountryCode := CompanyInformation."Country/Region Code";

        if CountryCode <> '' then
            if CountryRegion.Get(CountryCode) then
                exit(CountryRegion."EU Country/Region Code" <> '');

        exit(false);
    end;

    local procedure InsertVATRegistrationLog(VATRegNo: Text[20]; CountryCode: Code[10]; AccountType: Enum "VAT Registration Log Account Type"; AccountNo: Code[20])
    var
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        VATRegistrationLog.Init();
        VATRegistrationLog."VAT Registration No." := VATRegNo;
        VATRegistrationLog."Country/Region Code" := CountryCode;
        VATRegistrationLog."Account Type" := AccountType;
        VATRegistrationLog."Account No." := AccountNo;
        VATRegistrationLog."User ID" := CopyStr(UserId(), 1, MaxStrLen(VATRegistrationLog."User ID"));
        VATRegistrationLog.Insert(true);
    end;

    PROCEDURE GetDistribEntries(VAR AnalysisViewEntry: Record "Analysis View Entry"; VAR TempDistribEntry: Record "Distribution Entry");
    VAR
        DistribEntry: Record "Distribution Entry";
        AnalysisViewFilter: Record "Analysis View Filter";
        AnalysisView: Record "Analysis View";
        GLSetup: Record "General Ledger Setup";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        clAnalysisViewEntryToFLEntries: Codeunit AnalysisViewEntryToGLEntries;
        StartDate: Date;
        EndDate: Date;
        GlobalDimValue: Code[20];
    BEGIN
        AnalysisView.GET(AnalysisViewEntry."Analysis View Code");

        IF AnalysisView."Date Compression" = AnalysisView."Date Compression"::None THEN BEGIN
            IF DistribEntry.GET(AnalysisViewEntry."Entry No.") THEN BEGIN
                TempDistribEntry := DistribEntry;
                TempDistribEntry.INSERT();
            END;
            EXIT;
        END;

        GLSetup.GET();

        StartDate := AnalysisViewEntry."Posting Date";
        EndDate := StartDate;

        IF StartDate < AnalysisView."Starting Date" THEN
            StartDate := 0D
        ELSE
            IF (AnalysisViewEntry."Posting Date" = NORMALDATE(AnalysisViewEntry."Posting Date")) AND
               NOT (AnalysisView."Date Compression" IN [AnalysisView."Date Compression"::None, AnalysisView."Date Compression"::Day])
            THEN
                EndDate := CalculateEndDate(AnalysisView."Date Compression", AnalysisViewEntry);

        DistribEntry.SETCURRENTKEY("Distrib. account no.", "Posting date");
        DistribEntry.SETRANGE("Distrib. account no.", AnalysisViewEntry."Account No.");
        DistribEntry.SETRANGE("Posting date", StartDate, EndDate);
        DistribEntry.SETRANGE("Entry No.", 0, AnalysisView."Last Entry No.");

        IF clAnalysisViewEntryToFLEntries.GetGlobalDimValue(GLSetup."Global Dimension 1 Code", AnalysisViewEntry, GlobalDimValue) THEN
            DistribEntry.SETRANGE("Global Dimension 1 Code", GlobalDimValue)
        ELSE
            IF AnalysisViewFilter.GET(AnalysisViewEntry."Analysis View Code", GLSetup."Global Dimension 1 Code")
            THEN
                DistribEntry.SETFILTER("Global Dimension 1 Code", AnalysisViewFilter."Dimension Value Filter");

        IF clAnalysisViewEntryToFLEntries.GetGlobalDimValue(GLSetup."Global Dimension 2 Code", AnalysisViewEntry, GlobalDimValue) THEN
            DistribEntry.SETRANGE("Global Dimension 2 Code", GlobalDimValue)
        ELSE
            IF AnalysisViewFilter.GET(AnalysisViewEntry."Analysis View Code", GLSetup."Global Dimension 2 Code")
            THEN
                DistribEntry.SETFILTER("Global Dimension 2 Code", AnalysisViewFilter."Dimension Value Filter");

        IF DistribEntry.FIND('-') THEN
            REPEAT
                IF clAnalysisViewEntryToFLEntries.DimEntryOK(DistribEntry."Dimension Set Id", AnalysisView."Dimension 1 Code", AnalysisViewEntry."Dimension 1 Value Code") AND
                   clAnalysisViewEntryToFLEntries.DimEntryOK(DistribEntry."Dimension Set Id", AnalysisView."Dimension 2 Code", AnalysisViewEntry."Dimension 2 Value Code") AND
                   clAnalysisViewEntryToFLEntries.DimEntryOK(DistribEntry."Dimension Set Id", AnalysisView."Dimension 3 Code", AnalysisViewEntry."Dimension 3 Value Code") AND
                   clAnalysisViewEntryToFLEntries.DimEntryOK(DistribEntry."Dimension Set Id", AnalysisView."Dimension 4 Code", AnalysisViewEntry."Dimension 4 Value Code") AND
                   UpdateAnalysisView.DimSetIDInFilter(DistribEntry."Dimension Set Id", AnalysisView)
                THEN BEGIN
                    TempDistribEntry := DistribEntry;
                    IF TempDistribEntry.INSERT() THEN;
                END;
            UNTIL DistribEntry.NEXT() = 0;
    END;

    local procedure CalculateEndDate(DateCompression: Integer; AnalysisViewEntry: Record "Analysis View Entry"): Date
    var
        AnalysisView2: Record "Analysis View";
        AccountingPeriod: Record "Accounting Period";
    begin
        case DateCompression of
            AnalysisView2."Date Compression"::Week:
                exit(CalcDate('<+6D>', AnalysisViewEntry."Posting Date"));
            AnalysisView2."Date Compression"::Month:
                exit(CalcDate('<+1M-1D>', AnalysisViewEntry."Posting Date"));
            AnalysisView2."Date Compression"::Quarter:
                exit(CalcDate('<+3M-1D>', AnalysisViewEntry."Posting Date"));
            AnalysisView2."Date Compression"::Year:
                exit(CalcDate('<+1Y-1D>', AnalysisViewEntry."Posting Date"));
            AnalysisView2."Date Compression"::Period:
                begin
                    AccountingPeriod."Starting Date" := AnalysisViewEntry."Posting Date";
                    if AccountingPeriod.Next() <> 0 then
                        exit(CalcDate('<-1D>', AccountingPeriod."Starting Date"));

                    exit(DMY2Date(31, 12, 9999));
                end;
        end;
    end;

    PROCEDURE GetSelectionFilterForDistribution(VAR TempDistribution: Record "Schedule of Distrib. Accounts" temporary): Text;
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(TempDistribution);
        EXIT(cSelectionFilterManagement.GetSelectionFilter(RecRef, TempDistribution.FIELDNO("No.")));
    END;

    procedure CalcDistributionAcc(var DistributionAcc: Record "Schedule of Distrib. Accounts"; var AccSchedLine: Record "Acc. Schedule Line"; var ColumnLayout: Record "Column Layout") ColValue: Decimal
    var
        DistributionEntry: Record "Distribution Entry";
        AnalysisViewEntry: Record "Analysis View Entry";
        UseBusUnitFilter: Boolean;
        AmountType: Enum "Account Schedule Amount Type";
        TestBalance: Boolean;
        Balance: Decimal;
        UseDimFilter: Boolean;
    begin
        ColValue := 0;
        UseDimFilter := FALSE;
        AccSchedName.GET(AccSchedLine."Schedule Name");

        IF cAccScheduleMgt.ConflictAmountType(AccSchedLine, ColumnLayout."Amount Type", AmountType) THEN
            EXIT(0);
        TestBalance :=
          AccSchedLine.Show IN [AccSchedLine.Show::"When Positive Balance", AccSchedLine.Show::"When Negative Balance"];
        IF ColumnLayout."Column Type" <> ColumnLayout."Column Type"::Formula THEN BEGIN
            UseBusUnitFilter := (AccSchedLine.GETFILTER("Business Unit Filter") <> '') OR (ColumnLayout."Business Unit Totaling" <> '');
            UseDimFilter := cAccScheduleMgt.HasDimFilter(AccSchedLine, ColumnLayout);
            IF AccSchedName."Analysis View Name" = '' THEN BEGIN
                IF UseBusUnitFilter THEN
                    IF UseDimFilter THEN
                        DistributionEntry.SETCURRENTKEY("Distrib. account no.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code")
                    ELSE
                        DistributionEntry.SETCURRENTKEY("Document No.", "Business Unit Code", "Posting date")
                ELSE
                    IF UseDimFilter THEN
                        DistributionEntry.SETCURRENTKEY("Distrib. account no.", "Global Dimension 1 Code", "Global Dimension 2 Code")
                    ELSE
                        DistributionEntry.SETCURRENTKEY("Distrib. account no.", "Posting date");
                IF DistributionAcc.Totaling = '' THEN
                    DistributionEntry.SETRANGE("Distrib. account no.", DistributionAcc."No.")
                ELSE
                    DistributionEntry.SETFILTER("Distrib. account no.", DistributionAcc.Totaling);
                DistributionAcc.COPYFILTER("Date Filter", DistributionEntry."Posting date");
                AccSchedLine.COPYFILTER("Business Unit Filter", DistributionEntry."Business Unit Code");
                AccSchedLine.COPYFILTER("Dimension 1 Filter", DistributionEntry."Global Dimension 1 Code");
                AccSchedLine.COPYFILTER("Dimension 2 Filter", DistributionEntry."Global Dimension 2 Code");
                DistributionEntry.FILTERGROUP(2);
                DistributionEntry.SETFILTER("Global Dimension 1 Code", cAccScheduleMgt.GetDimTotalingFilter(1, AccSchedLine."Dimension 1 Totaling"));
                DistributionEntry.SETFILTER("Global Dimension 2 Code", cAccScheduleMgt.GetDimTotalingFilter(2, AccSchedLine."Dimension 2 Totaling"));
                DistributionEntry.FILTERGROUP(8);
                DistributionEntry.SETFILTER("Global Dimension 1 Code", cAccScheduleMgt.GetDimTotalingFilter(1, ColumnLayout."Dimension 1 Totaling"));
                DistributionEntry.SETFILTER("Global Dimension 2 Code", cAccScheduleMgt.GetDimTotalingFilter(2, ColumnLayout."Dimension 2 Totaling"));
                DistributionEntry.SETFILTER("Business Unit Code", ColumnLayout."Business Unit Totaling");
                DistributionEntry.FILTERGROUP(0);
                CASE AmountType OF
                    AmountType::"Net Amount":
                        BEGIN
                            DistributionEntry.CALCSUMS(Amount);
                            ColValue := DistributionEntry.Amount;
                            Balance := ColValue;
                        END;
                    AmountType::"Debit Amount":
                        BEGIN
                            IF TestBalance THEN BEGIN
                                DistributionEntry.CALCSUMS("Debit amount", Amount);
                                Balance := DistributionEntry.Amount;
                            END ELSE
                                DistributionEntry.CALCSUMS("Debit amount");
                            ColValue := DistributionEntry."Debit amount";
                        END;
                    AmountType::"Credit Amount":
                        BEGIN
                            IF TestBalance THEN BEGIN
                                DistributionEntry.CALCSUMS("Credit amount", Amount);
                                Balance := DistributionEntry.Amount;
                            END ELSE
                                DistributionEntry.CALCSUMS("Credit amount");
                            ColValue := DistributionEntry."Credit amount";
                        END;
                END;
            END
            ELSE BEGIN
                AnalysisViewEntry.SETRANGE("Analysis View Code", AccSchedName."Analysis View Name");
                //Mod. S2G (AAS) 20/12/2017: modificación, no mostraba los importes en el panoroma.inicio
                //SETRANGE("Account Source","Account Source"::"G/L Account"); //OLD
                AnalysisViewEntry.SETRANGE("Account Source", AnalysisViewEntry."Account Source"::"Distribution Account");
                //Mod. S2G (AAS) 20/12/2017: modificación, no mostraba los importes en el panoroma.fin
                IF DistributionAcc.Totaling = '' THEN
                    AnalysisViewEntry.SETRANGE("Account No.", DistributionAcc."No.")
                ELSE
                    AnalysisViewEntry.SETFILTER("Account No.", DistributionAcc.Totaling);
                DistributionAcc.COPYFILTER("Date Filter", AnalysisViewEntry."Posting Date");
                AccSchedLine.COPYFILTER("Business Unit Filter", AnalysisViewEntry."Business Unit Code");
                AnalysisViewEntry.CopyDimFilters(AccSchedLine);
                AnalysisViewEntry.FILTERGROUP(2);
                AnalysisViewEntry.SetDimFilters(
                  cAccScheduleMgt.GetDimTotalingFilter(1, AccSchedLine."Dimension 1 Totaling"),
                  cAccScheduleMgt.GetDimTotalingFilter(2, AccSchedLine."Dimension 2 Totaling"),
                  cAccScheduleMgt.GetDimTotalingFilter(3, AccSchedLine."Dimension 3 Totaling"),
                  cAccScheduleMgt.GetDimTotalingFilter(4, AccSchedLine."Dimension 4 Totaling"));
                AnalysisViewEntry.FILTERGROUP(8);
                AnalysisViewEntry.SetDimFilters(
                  cAccScheduleMgt.GetDimTotalingFilter(1, ColumnLayout."Dimension 1 Totaling"),
                  cAccScheduleMgt.GetDimTotalingFilter(2, ColumnLayout."Dimension 2 Totaling"),
                  cAccScheduleMgt.GetDimTotalingFilter(3, ColumnLayout."Dimension 3 Totaling"),
                  cAccScheduleMgt.GetDimTotalingFilter(4, ColumnLayout."Dimension 4 Totaling"));
                AnalysisViewEntry.SETFILTER("Business Unit Code", ColumnLayout."Business Unit Totaling");
                AnalysisViewEntry.FILTERGROUP(0);

                CASE AmountType OF
                    AmountType::"Net Amount":
                        BEGIN
                            AnalysisViewEntry.CALCSUMS(Amount);
                            ColValue := AnalysisViewEntry.Amount;
                            Balance := ColValue;
                        END;
                    AmountType::"Debit Amount":
                        BEGIN
                            IF TestBalance THEN BEGIN
                                AnalysisViewEntry.CALCSUMS("Debit Amount", Amount);
                                Balance := AnalysisViewEntry.Amount;
                            END ELSE
                                AnalysisViewEntry.CALCSUMS("Debit Amount");
                            ColValue := AnalysisViewEntry."Debit Amount";
                        END;
                    AmountType::"Credit Amount":
                        BEGIN
                            IF TestBalance THEN BEGIN
                                AnalysisViewEntry.CALCSUMS("Credit Amount", Amount);
                                Balance := AnalysisViewEntry.Amount;
                            END ELSE
                                AnalysisViewEntry.CALCSUMS("Credit Amount");
                            ColValue := AnalysisViewEntry."Credit Amount";
                        END;
                END;
            END;
            IF TestBalance THEN BEGIN
                IF AccSchedLine.Show = AccSchedLine.Show::"When Positive Balance" THEN
                    IF Balance < 0 THEN
                        EXIT(0);
                IF AccSchedLine.Show = AccSchedLine.Show::"When Negative Balance" THEN
                    IF Balance > 0 THEN
                        EXIT(0);
            END;
        END;
        EXIT(ColValue);
    end;

    procedure SetDistrAccRowFilters(var DistrAcc: Record "Schedule of Distrib. Accounts"; var AccSchedLine2: Record "Acc. Schedule Line")
    begin
        CASE AccSchedLine2."Totaling Type" OF
            AccSchedLine2."Totaling Type"::"Posting Accounts":
                BEGIN
                    DistrAcc.SETFILTER("No.", AccSchedLine2.Totaling);
                    //DistrAcc.SETRANGE("Account Type",DistrAcc."Account Type"::Posting);
                    DistrAcc.SETRANGE(Type, DistrAcc.Type::"Tipo coste");
                END;
            AccSchedLine2."Totaling Type"::"Total Accounts":
                BEGIN
                    DistrAcc.SETFILTER("No.", AccSchedLine2.Totaling);
                    //DistrAcc.SETFILTER("Account Type",'<>%1',DistrAcc."Account Type"::Posting);
                    DistrAcc.SETFILTER(Type, '<>%1', DistrAcc.Type::"Tipo coste");
                END;
            AccSchedLine2."Totaling Type"::"Distribution Entry":
                BEGIN
                    DistrAcc.SETFILTER("No.", AccSchedLine2.Totaling);
                    DistrAcc.SETRANGE(Type, DistrAcc.Type::"Tipo coste");
                END;
        END;
    end;

    procedure SetDistrAccColumnFilters(var DistrAcc: Record "Schedule of Distrib. Accounts"; AccSchedLine2: Record "Acc. Schedule Line"; var ColumnLayout: Record "Column Layout")
    var
        FromDate: Date;
        ToDate: Date;
        FiscalStartDate2: Date;
    begin
        //Mod S2G (CPA) 06/06/2018. Migración Dsitribución analítica a OFM.Begin
        //CalcColumnDates("Comparison Date Formula","Comparison Period Formula",FromDate,ToDate,FiscalStartDate2);
        cAccScheduleMgt.CalcColumnDates(ColumnLayout, FromDate, ToDate, FiscalStartDate2);
        //Mod S2G (CPA) 06/06/2018. Migración Dsitribución analítica a OFM.End

        CASE ColumnLayout."Column Type" OF
            ColumnLayout."Column Type"::"Net Change":
                CASE AccSchedLine2."Row Type" OF
                    AccSchedLine2."Row Type"::"Net Change":
                        DistrAcc.SETRANGE("Date Filter", FromDate, ToDate);
                    AccSchedLine2."Row Type"::"Beginning Balance":
                        DistrAcc.SETFILTER("Date Filter", '..%1', CLOSINGDATE(FromDate - 1)); // always includes closing date
                    AccSchedLine2."Row Type"::"Balance at Date":
                        DistrAcc.SETRANGE("Date Filter", 0D, ToDate);
                END;
            ColumnLayout."Column Type"::"Balance at Date":
                IF AccSchedLine2."Row Type" = AccSchedLine2."Row Type"::"Beginning Balance" THEN
                    DistrAcc.SETRANGE("Date Filter", 0D) // Force a zero return
                ELSE
                    DistrAcc.SETRANGE("Date Filter", 0D, ToDate);
            ColumnLayout."Column Type"::"Beginning Balance":
                IF AccSchedLine2."Row Type" = AccSchedLine2."Row Type"::"Balance at Date" THEN
                    DistrAcc.SETRANGE("Date Filter", 0D) // Force a zero return
                ELSE
                    DistrAcc.SETRANGE(
                      "Date Filter", 0D, CLOSINGDATE(FromDate - 1));
            ColumnLayout."Column Type"::"Year to Date":
                CASE AccSchedLine2."Row Type" OF
                    AccSchedLine2."Row Type"::"Net Change":
                        DistrAcc.SETRANGE("Date Filter", FiscalStartDate2, ToDate);
                    AccSchedLine2."Row Type"::"Beginning Balance":
                        DistrAcc.SETFILTER("Date Filter", '..%1', CLOSINGDATE(FiscalStartDate2 - 1)); // always includes closing date
                    AccSchedLine2."Row Type"::"Balance at Date":
                        DistrAcc.SETRANGE("Date Filter", 0D, ToDate);
                END;
            ColumnLayout."Column Type"::"Rest of Fiscal Year":
                CASE AccSchedLine2."Row Type" OF
                    AccSchedLine2."Row Type"::"Net Change":
                        DistrAcc.SETRANGE(
                          "Date Filter", CALCDATE('<+1D>', ToDate), AccountingPeriodMgt.FindEndOfFiscalYear(FiscalStartDate2));
                    AccSchedLine2."Row Type"::"Beginning Balance":
                        DistrAcc.SETRANGE("Date Filter", 0D, ToDate);
                    AccSchedLine2."Row Type"::"Balance at Date":
                        DistrAcc.SETRANGE("Date Filter", 0D, AccountingPeriodMgt.FindEndOfFiscalYear(ToDate));
                END;
            ColumnLayout."Column Type"::"Entire Fiscal Year":
                CASE AccSchedLine2."Row Type" OF
                    AccSchedLine2."Row Type"::"Net Change":
                        DistrAcc.SETRANGE(
                          "Date Filter",
                          FiscalStartDate2,
                          AccountingPeriodMgt.FindEndOfFiscalYear(FiscalStartDate2));
                    AccSchedLine2."Row Type"::"Beginning Balance":
                        DistrAcc.SETFILTER("Date Filter", '..%1', CLOSINGDATE(FiscalStartDate2 - 1)); // always includes closing date
                    AccSchedLine2."Row Type"::"Balance at Date":
                        DistrAcc.SETRANGE("Date Filter", 0D, AccountingPeriodMgt.FindEndOfFiscalYear(ToDate));
                END;
        END;
    end;

    procedure DrillDownOnDistributionAccount(TempColumnLayout: Record "Column Layout" temporary; var AccScheduleLine: Record "Acc. Schedule Line")
    var
        GLAccAnalysisView: Record "G/L Account (Analysis View)";
        DistribAcc: Record "Schedule of Distrib. Accounts";
        ChartOfAccsAnalysisView: Page "Chart of Accs. (Analysis View)";
    begin
        //Mod. S2G (CPA) 22/11/2017 <ANA001> Plan de cuentas de reparto.Begin
        AccScheduleLine.COPYFILTER("Business Unit Filter", DistribAcc."Business Unit Filter");
        //COPYFILTER("G/L Budget Filter",DistribAcc."Budget Filter");
        SetDistrAccRowFilters(DistribAcc, AccScheduleLine);
        SetDistrAccColumnFilters(DistribAcc, AccScheduleLine, TempColumnLayout);
        AccSchedName.GET(AccScheduleLine."Schedule Name");
        IF AccSchedName."Analysis View Name" = '' THEN BEGIN
            AccScheduleLine.COPYFILTER("Dimension 1 Filter", DistribAcc."Dimension filter 1");
            AccScheduleLine.COPYFILTER("Dimension 2 Filter", DistribAcc."Dimension filter 2");
            AccScheduleLine.COPYFILTER("Business Unit Filter", DistribAcc."Business Unit Filter");
            DistribAcc.FILTERGROUP(2);
            DistribAcc.SETFILTER("Dimension filter 1", cAccScheduleMgt.GetDimTotalingFilter(1, AccScheduleLine."Dimension 1 Totaling"));
            DistribAcc.SETFILTER("Dimension filter 2", cAccScheduleMgt.GetDimTotalingFilter(2, AccScheduleLine."Dimension 2 Totaling"));
            DistribAcc.FILTERGROUP(8);

            DistribAcc.SETFILTER("Business Unit Filter", TempColumnLayout."Business Unit Totaling");
            DistribAcc.SETFILTER("Dimension filter 1", cAccScheduleMgt.GetDimTotalingFilter(1, TempColumnLayout."Dimension 1 Totaling"));
            DistribAcc.SETFILTER("Dimension filter 2", cAccScheduleMgt.GetDimTotalingFilter(2, TempColumnLayout."Dimension 2 Totaling"));
            DistribAcc.FILTERGROUP(0);
            PAGE.RUN(PAGE::"Chart of schedule List", DistribAcc)
        END ELSE BEGIN
            DistribAcc.COPYFILTER("Date Filter", GLAccAnalysisView."Date Filter");
            //DistribAcc.COPYFILTER("Budget Filter",DistribAccAnalysisView."Budget Filter");
            DistribAcc.COPYFILTER("Business Unit Filter", GLAccAnalysisView."Business Unit Filter");
            GLAccAnalysisView.SETRANGE("Analysis View Filter", AccSchedName."Analysis View Name");
            GLAccAnalysisView.CopyDimFilters(AccScheduleLine);
            GLAccAnalysisView.FILTERGROUP(2);
            GLAccAnalysisView.SetDimFilters(
              cAccScheduleMgt.GetDimTotalingFilter(1, AccScheduleLine."Dimension 1 Totaling"), cAccScheduleMgt.GetDimTotalingFilter(2, AccScheduleLine."Dimension 2 Totaling"),
              cAccScheduleMgt.GetDimTotalingFilter(3, AccScheduleLine."Dimension 3 Totaling"), cAccScheduleMgt.GetDimTotalingFilter(4, AccScheduleLine."Dimension 4 Totaling"));
            GLAccAnalysisView.FILTERGROUP(8);
            GLAccAnalysisView.SetDimFilters(
              cAccScheduleMgt.GetDimTotalingFilter(1, TempColumnLayout."Dimension 1 Totaling"),
              cAccScheduleMgt.GetDimTotalingFilter(2, TempColumnLayout."Dimension 2 Totaling"),
              cAccScheduleMgt.GetDimTotalingFilter(3, TempColumnLayout."Dimension 3 Totaling"),
              cAccScheduleMgt.GetDimTotalingFilter(4, TempColumnLayout."Dimension 4 Totaling"));
            GLAccAnalysisView.SETFILTER("Business Unit Filter", TempColumnLayout."Business Unit Totaling");
            GLAccAnalysisView.FILTERGROUP(0);
            CLEAR(ChartOfAccsAnalysisView);
            ChartOfAccsAnalysisView.InsertTempDistrAccAnalysisViews(DistribAcc);
            ChartOfAccsAnalysisView.SETTABLEVIEW(GLAccAnalysisView);
            ChartOfAccsAnalysisView.RUN();
        END;
        //Mod. S2G (CPA) 22/11/2017 <ANA001> Plan de cuentas de reparto.End
    end;

    procedure HasSourceCodeFilter(var AccSchedLine: Record "Acc. Schedule Line"): Boolean
    begin
        // (FCO) S2G (CSM) 07/04/2020 : begin
        EXIT(AccSchedLine.GETFILTER("Source Code Filter") <> '');
        // (FCO) S2G (CSM) 07/04/2020 : end
    end;

    procedure RetrieveInvoiceTrackingSpecificationIfExists(PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; var TrackingSpecificationExists: Boolean)
    var
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
    begin
        if PurchaseHeader.Invoice then
            if PurchaseLine."Qty. to Invoice" = 0 then
                TrackingSpecificationExists := false
            else
                TrackingSpecificationExists :=
                  PurchLineReserve.RetrieveInvoiceSpecification(PurchaseLine, TempTrackingSpecification);
    end;

    procedure SaveInvoiceSpecification(var TempInvoicingSpecification: Record "Tracking Specification" temporary)
    var
        TempTrackingSpecification: Record "Tracking Specification" temporary;
    begin
        TempInvoicingSpecification.Reset();
        if TempInvoicingSpecification.FindSet() then begin
            repeat
                TempInvoicingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Quantity actual Handled (Base)";
                TempInvoicingSpecification."Quantity actual Handled (Base)" := 0;
                TempTrackingSpecification := TempInvoicingSpecification;
                TempTrackingSpecification."Buffer Status" := TempTrackingSpecification."Buffer Status"::MODIFY;
                if not TempTrackingSpecification.Insert() then begin
                    TempTrackingSpecification.Get(TempInvoicingSpecification."Entry No.");
                    TempTrackingSpecification."Qty. to Invoice (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
                    TempTrackingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
                    TempTrackingSpecification."Qty. to Invoice" += TempInvoicingSpecification."Qty. to Invoice";
                    TempTrackingSpecification.Modify();
                end;
            until TempInvoicingSpecification.Next() = 0;
            TempInvoicingSpecification.DeleteAll();
        end;
    end;

    PROCEDURE LookupUserID(VAR UserName: Code[50]);
    VAR
        SID: GUID;
    BEGIN
        LookupUser(UserName, SID);
    END;

    PROCEDURE LookupUser(VAR UserName: Code[50]; VAR SID: GUID): Boolean;
    VAR
        User: Record User;
    BEGIN
        User.RESET();
        User.SETCURRENTKEY("User Name");
        User."User Name" := UserName;
        IF User.FIND('=><') THEN;
        IF PAGE.RUNMODAL(PAGE::Users, User) = ACTION::LookupOK THEN BEGIN
            UserName := User."User Name";
            SID := User."User Security ID";
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    PROCEDURE ValidateUserID(UserName: Code[50]);
    VAR
        User: Record User;
        Text000Lbl: Label 'The user name %1 does not exist.', Comment = 'ESP="El nombre de usuario %1 no existe"';
    BEGIN
        IF UserName <> '' THEN BEGIN
            User.SETCURRENTKEY("User Name");
            User.SETRANGE("User Name", UserName);
            IF NOT User.FINDFIRST() THEN BEGIN
                User.RESET();
                IF NOT User.ISEMPTY THEN
                    ERROR(Text000Lbl, UserName);
            END;
        END;
    END;

    PROCEDURE NewCustomerFromTemplate(VAR Customer: Record Customer): Boolean;
    VAR
        ConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplates: Page "Config. Template List";
    BEGIN
        ConfigTemplateHeader.SETRANGE("Table ID", DATABASE::Customer);
        ConfigTemplateHeader.SETRANGE(Enabled, TRUE);

        IF ConfigTemplateHeader.COUNT = 1 THEN BEGIN
            ConfigTemplateHeader.FINDFIRST();
            InsertCustomerFromTemplate(ConfigTemplateHeader, Customer);
            EXIT(TRUE);
        END;

        IF (ConfigTemplateHeader.COUNT > 1) AND GUIALLOWED() THEN BEGIN
            ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
            ConfigTemplates.LOOKUPMODE(TRUE);
            IF ConfigTemplates.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                ConfigTemplates.GETRECORD(ConfigTemplateHeader);
                InsertCustomerFromTemplate(ConfigTemplateHeader, Customer);
                EXIT(TRUE);
            END;
        END;

        EXIT(FALSE);
    END;

    PROCEDURE InsertCustomerFromTemplate(ConfigTemplateHeader: Record "Config. Template Header"; VAR Customer: Record Customer);
    VAR
        DimensionsTemplate: Record "Dimensions Template";
        ConfigTemplateMgt: Codeunit "Config. Template Management";
        RecRef: RecordRef;
    BEGIN
        Customer.SetInsertFromTemplate(TRUE);
        InitCustomerNo(Customer, ConfigTemplateHeader);
        Customer.INSERT(TRUE);
        RecRef.GETTABLE(Customer);
        ConfigTemplateMgt.UpdateRecord(ConfigTemplateHeader, RecRef);
        RecRef.SETTABLE(Customer);

        DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Customer."No.", DATABASE::Customer);
    END;

    LOCAL PROCEDURE InitCustomerNo(VAR Customer: Record Customer; ConfigTemplateHeader: Record "Config. Template Header");
    VAR
        NoSeriesMgt: Codeunit "No. Series";
    BEGIN
        IF ConfigTemplateHeader."Instance No. Series" = '' THEN
            EXIT;
        NoSeriesMgt.AreRelated(ConfigTemplateHeader."Instance No. Series", Customer."No. Series");
    END;

    procedure MarkCustomersWithSimilarName(var Customer: Record Customer; CustomerText: Text)
    var
        TypeHelper: Codeunit "Type Helper";
        CustomerCount: Integer;
        CustomerTextLength: Integer;
        Treshold: Integer;
    begin
        if CustomerText = '' then
            exit;
        if StrLen(CustomerText) > MaxStrLen(Customer.Name) then
            exit;
        CustomerTextLength := StrLen(CustomerText);
        Treshold := CustomerTextLength div 5;
        if Treshold = 0 then
            exit;

        Customer.Reset();
        Customer.Ascending(false); // most likely to search for newest customers
        if Customer.FindSet() then
            repeat
                CustomerCount += 1;
                if Abs(CustomerTextLength - StrLen(Customer.Name)) <= Treshold then
                    if TypeHelper.TextDistance(UpperCase(CustomerText), UpperCase(Customer.Name)) <= Treshold then
                        Customer.Mark(true);
            until Customer.Mark() or (Customer.Next() = 0) or (CustomerCount > 1000);
        Customer.MarkedOnly(true);
    end;

    procedure PickCustomer(var Customer: Record Customer; NoFiltersApplied: Boolean): Code[20]
    var
        CustomerList: Page "Customer List";
    begin
        if not NoFiltersApplied then
            MarkCustomersByFilters(Customer);

        CustomerList.SetTableView(Customer);
        CustomerList.SetRecord(Customer);
        CustomerList.LookupMode := true;
        if CustomerList.RunModal() = ACTION::LookupOK then
            CustomerList.GetRecord(Customer)
        else
            Clear(Customer);

        exit(Customer."No.");
    end;

    local procedure MarkCustomersByFilters(var Customer: Record Customer)
    begin
        if Customer.FindSet() then
            repeat
                Customer.Mark(true);
            until Customer.Next() = 0;
        if Customer.FindFirst() then;
        Customer.MarkedOnly := true;
    end;

    procedure MarkVendorsWithSimilarName(var Vendor: Record Vendor; VendorText: Text)
    var
        TypeHelper: Codeunit "Type Helper";
        VendorCount: Integer;
        VendorTextLenght: Integer;
        Treshold: Integer;
    begin
        if VendorText = '' then
            exit;
        if StrLen(VendorText) > MaxStrLen(Vendor.Name) then
            exit;
        VendorTextLenght := StrLen(VendorText);
        Treshold := VendorTextLenght div 5;
        if Treshold = 0 then
            exit;
        Vendor.Reset();
        Vendor.Ascending(false); // most likely to search for newest Vendors
        if Vendor.FindSet() then
            repeat
                VendorCount += 1;
                if Abs(VendorTextLenght - StrLen(Vendor.Name)) <= Treshold then
                    if TypeHelper.TextDistance(UpperCase(VendorText), UpperCase(Vendor.Name)) <= Treshold then
                        Vendor.Mark(true);
            until Vendor.Mark() or (Vendor.Next() = 0) or (VendorCount > 1000);
        Vendor.MarkedOnly(true);
    end;

    procedure PickVendor(var Vendor: Record Vendor; NoFiltersApplied: Boolean): Code[20]
    var
        VendorList: Page "Vendor List";
    begin
        if not NoFiltersApplied then
            MarkVendorsByFilters(Vendor);

        VendorList.SetTableView(Vendor);
        VendorList.SetRecord(Vendor);
        VendorList.LookupMode := true;
        if VendorList.RunModal() = ACTION::LookupOK then
            VendorList.GetRecord(Vendor)
        else
            Clear(Vendor);

        exit(Vendor."No.");
    end;

    local procedure MarkVendorsByFilters(var Vendor: Record Vendor)
    begin
        if Vendor.FindSet() then
            repeat
                Vendor.Mark(true);
            until Vendor.Next() = 0;
        if Vendor.FindFirst() then;
        Vendor.MarkedOnly := true;
    end;

    [TryFunction]
    procedure lfTryRevertirMovimientoContable(pGlEntryNo: Integer; var pVendorEntryFound: Boolean; var pVendorUnapplied: Boolean)
    var
        rlGlEntry: Record "G/L Entry";
    begin
        rlGlEntry.Get(pGlEntryNo);
        rlGlEntry.TestField("Transaction No.");

        lfDesliquidarProveedor(rlGlEntry."Transaction No.", pVendorEntryFound, pVendorUnapplied);
        lfRevertirTransaccion(rlGlEntry."Transaction No.");
    end;

    procedure lfDesliquidarProveedor(pTransactionNo: Integer; var PvendorEntryFound: Boolean; var pVendorUnapplied: Boolean)
    var
        rlVendLedgEntry: Record "Vendor Ledger Entry";
        rlDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        rlApplyUnapplyParameters: Record "Apply Unapply Parameters";
        clVendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
        vlApplicationEntryNo: Integer;
        vbRetry: Boolean;
    begin
        REPEAT
            vbRetry := FALSE;
            vlApplicationEntryNo := 0;

            rlVendLedgEntry.RESET();
            rlVendLedgEntry.SETRANGE("Transaction No.", pTransactionNo);
            IF rlVendLedgEntry.FINDSET() THEN
                REPEAT
                    pVendorEntryFound := TRUE;
                    vlApplicationEntryNo := clVendEntryApplyPostedEntries.FindLastApplEntry(rlVendLedgEntry."Entry No.");
                    IF vlApplicationEntryNo <> 0 THEN BEGIN
                        rlDtldVendLedgEntry.GET(vlApplicationEntryNo);
                        CLEAR(rlApplyUnapplyParameters);
                        rlApplyUnapplyParameters."Document No." := rlDtldVendLedgEntry."Document No.";
                        rlApplyUnapplyParameters."Posting Date" := rlDtldVendLedgEntry."Posting Date";
                        clVendEntryApplyPostedEntries.PostUnApplyVendor(rlDtldVendLedgEntry, rlApplyUnapplyParameters);
                        pVendorUnapplied := TRUE;
                        vbRetry := TRUE;
                    END;
                UNTIL (rlVendLedgEntry.NEXT() = 0) OR vbRetry;
        UNTIL NOT vbRetry;
    end;

    procedure lfRevertirTransaccion(pTransactionNo: Integer)
    var
        rlReversalEntry: Record "Reversal Entry";
    begin
        CLEAR(rlReversalEntry);
        rlReversalEntry.SetHideWarningDialogs();
        rlReversalEntry.ReverseTransaction(pTransactionNo);
    end;

    internal procedure lfGetReversionMessage(pVendorEntryFound: Boolean; pVendorUnapplied: Boolean): Text
    begin
        IF pVendorUnapplied THEN
            EXIT(TextWSReversionWithVendorUnapplyLbl);

        IF pVendorEntryFound THEN
            EXIT(TextWSReversionWithVendorLbl);

        EXIT(TextWSReversionLbl);
    end;

    var
        AccSchedName: Record "Acc. Schedule Name";
        cSelectionFilterManagement: Codeunit SelectionFilterManagement;
        cAccScheduleMgt: Codeunit AccSchedManagement;
        AccountingPeriodMgt: Codeunit "Accounting Period Mgt.";
        TextWSReversionLbl: Label 'La transaccion se ha revertido correctamente.';
        TextWSReversionWithVendorLbl: Label 'La transaccion se ha revertido correctamente. Se han detectado movimientos de proveedor sin necesidad de desaplicacion.';
        TextWSReversionWithVendorUnapplyLbl: Label 'Se ha desaplicado el movimiento de proveedor y se ha revertido la transaccion correctamente.';
}
