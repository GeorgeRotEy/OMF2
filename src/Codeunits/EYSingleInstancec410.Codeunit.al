namespace OFM.OFM;
using Microsoft.Finance.Analysis;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.CashFlow.Forecast;
using Microsoft.Purchases.History;

codeunit 50004 "EY Single Instance c410"
{
    SingleInstance = true;

    local procedure UpdateEntries(AnalysisView: Record "Analysis View")
    var
        UpdAnalysisViewEntryBuffer: Record "Upd Analysis View Entry Buffer";
    begin
        GLSetup.Get();
        // FilterIsInitialized := false;
        case AnalysisView."Account Source" of
            AnalysisView."Account Source"::"G/L Account":
                UpdateEntriesForGLAccount(AnalysisView);
            AnalysisView."Account Source"::"Cash Flow Account":
                UpdateEntriesForCFAccount(AnalysisView);
        end;

        UpdAnalysisViewEntryBuffer.Reset();
        if UpdAnalysisViewEntryBuffer.FindSet() then
            repeat
                cUpdAnalysisView.UpdateAnalysisViewEntry(UpdAnalysisViewEntryBuffer);
            until UpdAnalysisViewEntryBuffer.Next() = 0;

        cUpdAnalysisView.FlushAnalysisViewEntry();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Update Analysis View", OnBeforeUpdateEntriesForGLAccount, '', false, false)]
    local procedure es_c410_OnBeforeUpdateEntriesForGLAccount(var TempAnalysisViewEntry: Record "Analysis View Entry" temporary; AnalysisView: Record "Analysis View"; LastGLEntryNo: Integer; var NoOfEntries: Integer; var IsHandled: Boolean; ShowProgressWindow: Boolean)
    begin
        vShowProgressWindow := ShowProgressWindow;
        vLastGLEntryNo := LastGLEntryNo;
    end;

    procedure UpdateEntriesForGLAccount(AnalysisView: Record "Analysis View")
    var
        AnalysisViewGLQry: Query "Analysis View Source OFM";
        EntryNo: Integer;
    begin
        if AnalysisView."Date Compression" = AnalysisView."Date Compression"::None then begin
            UpdateEntriesForGLAccountDetailed(AnalysisView);
            exit;
        end;

        AnalysisViewGLQry.SetRange(AnalysisViewCode, AnalysisView.Code);
        AnalysisViewGLQry.SetRange(EntryNo, AnalysisView."Last Entry No." + 1, vLastGLEntryNo);
        if AnalysisView."Account Filter" = '' then
            AnalysisViewGLQry.SetFilter(GLAccNo, '>%1', '')
        else
            AnalysisViewGLQry.SetFilter(GLAccNo, AnalysisView."Account Filter");
        if AnalysisView."Business Unit Filter" <> '' then
            AnalysisViewGLQry.SetFilter(BusinessUnitCode, AnalysisView."Business Unit Filter");

        AnalysisViewGLQry.Open();
        while AnalysisViewGLQry.Read() do begin
            if cUpdAnalysisView.DimSetIDInFilter(AnalysisViewGLQry.DimensionSetID, AnalysisView) then
                cUpdAnalysisView.UpdateAnalysisViewEntry(
                  AnalysisViewGLQry.GLAccNo,
                  AnalysisViewGLQry.BusinessUnitCode,
                  '',
                  AnalysisViewGLQry.DimVal1,
                  AnalysisViewGLQry.DimVal2,
                  AnalysisViewGLQry.DimVal3,
                  AnalysisViewGLQry.DimVal4,
                  AnalysisViewGLQry.PostingDate,
                  AnalysisViewGLQry.Amount,
                  AnalysisViewGLQry.DebitAmount,
                  AnalysisViewGLQry.CreditAmount,
                  AnalysisViewGLQry.AmountACY,
                  AnalysisViewGLQry.DebitAmountACY,
                  AnalysisViewGLQry.CreditAmountACY,
                  0);

            // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n. begin
            vSourceCode := AnalysisViewGLQry.SourceCode;
            // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n. end
            EntryNo := EntryNo + 1;
            if vShowProgressWindow then
                cUpdAnalysisView.UpdateWindowCounter(EntryNo);
        end;
        AnalysisViewGLQry.Close();
    end;

    procedure UpdateEntriesForGLAccountDetailed(AnalysisView: Record "Analysis View")
    var
        GLEntry: Record "G/L Entry";
        EntryNo: Integer;
        LastGLEntryNo: Integer;
    begin
        LastGLEntryNo := GLEntry.GetLastEntryNo();

        GLEntry.SetRange("Entry No.", AnalysisView."Last Entry No." + 1, LastGLEntryNo);
        if AnalysisView."Account Filter" <> '' then
            GLEntry.SetFilter("G/L Account No.", AnalysisView."Account Filter");
        if AnalysisView."Business Unit Filter" <> '' then
            GLEntry.SetFilter("Business Unit Code", AnalysisView."Business Unit Filter");

        // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n. begin
        IF AnalysisView."Source Code Filter" <> '' THEN
            GLEntry.SETFILTER("Source Code", AnalysisView."Source Code Filter");
        // (FCO) S2G (CSM) 07/04/2020 : end

        if GLEntry.FindSet() then
            repeat
                if cUpdAnalysisView.DimSetIDInFilter(GLEntry."Dimension Set ID", AnalysisView) then
                    cUpdAnalysisView.UpdateAnalysisViewEntry(
                      GLEntry."G/L Account No.", GLEntry."Business Unit Code", '',
                      cUpdAnalysisView.GetDimVal(AnalysisView."Dimension 1 Code", GLEntry."Dimension Set ID"),
                      cUpdAnalysisView.GetDimVal(AnalysisView."Dimension 2 Code", GLEntry."Dimension Set ID"),
                      cUpdAnalysisView.GetDimVal(AnalysisView."Dimension 3 Code", GLEntry."Dimension Set ID"),
                      cUpdAnalysisView.GetDimVal(AnalysisView."Dimension 4 Code", GLEntry."Dimension Set ID"),
                      GLEntry."Posting Date", GLEntry.Amount, GLEntry."Debit Amount", GLEntry."Credit Amount",
                       GLEntry."Additional-Currency Amount", GLEntry."Add.-Currency Debit Amount", GLEntry."Add.-Currency Credit Amount", GLEntry."Entry No.");

                // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n.
                vSourceCode := GLEntry."Source Code";
                // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n.

                EntryNo := EntryNo + 1;
                if vShowProgressWindow then
                    cUpdAnalysisView.UpdateWindowCounter(EntryNo);
            until GLEntry.Next() = 0;
    end;

    PROCEDURE UpdateEntriesForDistribccount(AnalysisView: Record "Analysis View")
    VAR
        AnalysisViewGLQry: Query "Distrib. Analysis View Source";
        EntryNo: Integer;
    BEGIN
        IF AnalysisView."Date Compression" = AnalysisView."Date Compression"::None THEN BEGIN
            UpdateEntriesForDistribAccountDetailed(AnalysisView);
            EXIT;
        END;

        AnalysisViewGLQry.SETRANGE(AnalysisViewCode, AnalysisView.Code);
        AnalysisViewGLQry.SETRANGE(EntryNo, AnalysisView."Last Entry No." + 1, vLastDistrEntryNo);
        IF AnalysisView."Account Filter" = '' THEN
            AnalysisViewGLQry.SETFILTER(DistrbAccNo, '>%1', '')
        ELSE
            AnalysisViewGLQry.SETFILTER(DistrbAccNo, AnalysisView."Account Filter");
        IF AnalysisView."Business Unit Filter" <> '' THEN
            AnalysisViewGLQry.SETFILTER(BusinessUnitCode, AnalysisView."Business Unit Filter");

        AnalysisViewGLQry.OPEN();
        WHILE AnalysisViewGLQry.READ() DO BEGIN
            IF cUpdAnalysisView.DimSetIDInFilter(AnalysisViewGLQry.DimensionSetID, AnalysisView) THEN
                cUpdAnalysisView.UpdateAnalysisViewEntry(
                  AnalysisViewGLQry.DistrbAccNo,
                  AnalysisViewGLQry.BusinessUnitCode,
                  '',
                  AnalysisViewGLQry.DimVal1,
                  AnalysisViewGLQry.DimVal2,
                  AnalysisViewGLQry.DimVal3,
                  AnalysisViewGLQry.DimVal4,
                  AnalysisViewGLQry.PostingDate,
                  AnalysisViewGLQry.Amount,
                  AnalysisViewGLQry.DebitAmount,
                  AnalysisViewGLQry.CreditAmount,
                  AnalysisViewGLQry.Amount,
                  AnalysisViewGLQry.DebitAmount,
                  AnalysisViewGLQry.CreditAmount,
                  0);
            // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n.
            vSourceCode := '';
            // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n.
            EntryNo := EntryNo + 1;
            IF vShowProgressWindow THEN
                cUpdAnalysisView.UpdateWindowCounter(EntryNo);
        END;
        AnalysisViewGLQry.CLOSE();
    END;

    PROCEDURE UpdateEntriesForDistribAccountDetailed(AnalysisView: Record "Analysis View")
    VAR
        EntryNo: Integer;
    BEGIN
        rDistrEntry.SETRANGE("Entry No.", AnalysisView."Last Entry No." + 1, vLastGLEntryNo);
        IF AnalysisView."Account Filter" <> '' THEN
            rDistrEntry.SETFILTER("Distrib. account no.", AnalysisView."Account Filter");
        IF AnalysisView."Business Unit Filter" <> '' THEN
            rDistrEntry.SETFILTER("Business Unit Code", AnalysisView."Business Unit Filter");

        IF rDistrEntry.FINDSET() THEN
            REPEAT
                IF cUpdAnalysisView.DimSetIDInFilter(rDistrEntry."Dimension Set Id", AnalysisView) THEN
                    cUpdAnalysisView.UpdateAnalysisViewEntry(
                      rDistrEntry."Distrib. account no.", rDistrEntry."Business Unit Code", '',
                      cUpdAnalysisView.GetDimVal(AnalysisView."Dimension 1 Code", rDistrEntry."Dimension Set Id"),
                      cUpdAnalysisView.GetDimVal(AnalysisView."Dimension 2 Code", rDistrEntry."Dimension Set Id"),
                      cUpdAnalysisView.GetDimVal(AnalysisView."Dimension 3 Code", rDistrEntry."Dimension Set Id"),
                      cUpdAnalysisView.GetDimVal(AnalysisView."Dimension 4 Code", rDistrEntry."Dimension Set Id"),
                      rDistrEntry."Posting date", rDistrEntry.Amount, rDistrEntry."Debit amount", rDistrEntry."Credit amount",
                      rDistrEntry.Amount, rDistrEntry."Debit amount", rDistrEntry."Credit amount", rDistrEntry."Entry No.");
                // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n.
                vSourceCode := rDistrEntry."Source code";
                // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n.
                EntryNo := EntryNo + 1;
                IF vShowProgressWindow THEN
                    cUpdAnalysisView.UpdateWindowCounter(EntryNo);
            UNTIL rDistrEntry.NEXT() = 0;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Update Analysis View", OnUpdateAnalysisViewEntryOnAfterTempAnalysisViewEntryAssignment, '', false, false)]
    local procedure es_c410_OnUpdateAnalysisViewEntryOnAfterTempAnalysisViewEntryAssignment(var TempAnalysisViewEntry: Record "Analysis View Entry" temporary; var AnalysisView: Record "Analysis View"; var GLEntry: Record "G/L Entry"; var UpdAnalysisViewEntryBuffer: Record "Upd Analysis View Entry Buffer")
    begin
        TempAnalysisViewEntry."Source Code" := vSourceCode;
    end;

    local procedure UpdateEntriesForCFAccount(AnalysisView: Record "Analysis View")
    var
        AnalysisViewEntry: Record "Analysis View Entry";
        CFForecastEntry: Record "Cash Flow Forecast Entry";
        AnalysisViewFilter: Record "Analysis View Filter";
    begin
        GLSetup.Get();

        AnalysisViewEntry.SetRange("Analysis View Code", AnalysisView.Code);
        AnalysisViewEntry.DeleteAll();
        AnalysisViewEntry.Reset();
        CFForecastEntry.FilterGroup(2);
        CFForecastEntry.SetFilter("Cash Flow Account No.", '<>%1', '');
        CFForecastEntry.FilterGroup(0);
        if AnalysisView."Account Filter" <> '' then
            CFForecastEntry.SetFilter("Cash Flow Account No.", AnalysisView."Account Filter");

        if GLSetup."Global Dimension 1 Code" <> '' then
            if AnalysisViewFilter.Get(AnalysisView.Code, GLSetup."Global Dimension 1 Code") then
                if AnalysisViewFilter."Dimension Value Filter" <> '' then
                    CFForecastEntry.SetFilter("Global Dimension 1 Code", AnalysisViewFilter."Dimension Value Filter");
        if GLSetup."Global Dimension 2 Code" <> '' then
            if AnalysisViewFilter.Get(AnalysisView.Code, GLSetup."Global Dimension 2 Code") then
                if AnalysisViewFilter."Dimension Value Filter" <> '' then
                    CFForecastEntry.SetFilter("Global Dimension 2 Code", AnalysisViewFilter."Dimension Value Filter");

        if not CFForecastEntry.Find('-') then
            exit;

        repeat
            if cUpdAnalysisView.DimSetIDInFilter(CFForecastEntry."Dimension Set ID", AnalysisView) then
                cUpdAnalysisView.UpdateAnalysisViewEntry(
                  CFForecastEntry."Cash Flow Account No.",
                  '',
                  CFForecastEntry."Cash Flow Forecast No.",
                  cUpdAnalysisView.GetDimVal(AnalysisView."Dimension 1 Code", CFForecastEntry."Dimension Set ID"),
                  cUpdAnalysisView.GetDimVal(AnalysisView."Dimension 2 Code", CFForecastEntry."Dimension Set ID"),
                  cUpdAnalysisView.GetDimVal(AnalysisView."Dimension 3 Code", CFForecastEntry."Dimension Set ID"),
                  cUpdAnalysisView.GetDimVal(AnalysisView."Dimension 4 Code", CFForecastEntry."Dimension Set ID"),
                  CFForecastEntry."Cash Flow Date",
                  CFForecastEntry."Amount (LCY)",
                  0, 0, 0, 0, 0,
                  CFForecastEntry."Entry No.");

            // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n.
            vSourceCode := '';
            // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n.

            if vShowProgressWindow then
                cUpdAnalysisView.UpdateWindowCounter(CFForecastEntry."Entry No.");
        until CFForecastEntry.Next() = 0;
        if vShowProgressWindow then
            cUpdAnalysisView.UpdateWindowCounter(CFForecastEntry."Entry No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Update Analysis View", OnAfterInitLastEntryNo, '', false, false)]
    local procedure es_c410_OnAfterInitLastEntryNo(var LastGLEntryNo: Integer)
    begin
        //Mod. S2G (CPA) <ANA001> Reparto anal�tico.BEGIN
        rDistrEntry.RESET();
        IF rDistrEntry.FINDLAST() THEN
            vLastDistrEntryNo := rDistrEntry."Entry No.";
        //Mod. S2G (CPA) <ANA001> Reparto anal�tico.END
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Update Analysis View", OnUpdateOneOnBeforeUpdateEntries, '', false, false)]
    local procedure es_410_OnUpdateOneOnBeforeUpdateEntries(var AnalysisView: Record "Analysis View"; Which: Option "Ledger Entries","Budget Entries",Both,"Distribution Entries"; LastGLEntryNo: Integer)
    begin
        vWhich := Which;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Update Analysis View", OnUpdateOneOnBeforeUpdateAnalysisView, '', false, false)]
    local procedure es_c410_OnUpdateOneOnBeforeUpdateAnalysisView(var AnalysisView: Record "Analysis View"; var TempAnalysisViewEntry: Record "Analysis View Entry" temporary; var Updated: Boolean; ShowProgressWindow: Boolean)
    begin
        IF AnalysisView."Account Source" = AnalysisView."Account Source"::"Analytic Distribution Account" THEN
            IF vWhich IN [vWhich::"Distribution Entries", vWhich::Both] THEN
                IF vLastDistrEntryNo > AnalysisView."Last Entry No." THEN BEGIN
                    IF ShowProgressWindow THEN
                        cUpdAnalysisView.UpdateWindowHeader(DATABASE::"Analysis View Entry", rDistrEntry."Entry No.");
                    UpdateEntries(AnalysisView);
                    AnalysisView."Last Entry No." := vLastDistrEntryNo;
                    Updated := TRUE;
                END;
        //Mod. S2G (CPA) <ANA001> Reparto anal�tico.END
    end;

    var
        GLSetup: Record "General Ledger Setup";
        rDistrEntry: Record "Distribution Entry";
        cUpdAnalysisView: Codeunit "Update Analysis View";
        vSourceCode: Code[10];
        vLastDistrEntryNo: Integer;
        vShowProgressWindow: Boolean;
        vLastGLEntryNo: Integer;
        vWhich: Option "Ledger Entries","Budget Entries",Both,"Distribution Entries";
}
