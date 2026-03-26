codeunit 50005 "Distribution Mngt"
{
    var
        rChartAccount: Record "Schedule of Distrib. Accounts";
        Window: Dialog;
        i: Integer;
        Text004Lbl: Label 'Indent chart of cost types\Number   #1########', Comment = 'ESP="Sangrar plan de tipos de coste\Número   #1########"';
        Text001Lbl: Label 'Indent %1?', Comment = 'ESP="¿Sangrar %1?"';
        Text005Lbl: Label 'End-Total %1 does not belong to the corresponding Begin-Total.', Comment = 'ESP="El Total final %1 no pertenece al Total inicial correspondiente."';

    local procedure fEntryNo(var vNoMov: Integer)
    var
        rlDistributionEntry: Record "Distribution Entry";
    begin
        rlDistributionEntry.RESET();
        rlDistributionEntry.SETCURRENTKEY(rlDistributionEntry."Entry No.");
        IF rlDistributionEntry.FINDLAST() THEN
            vNoMov := rlDistributionEntry."Entry No."
        ELSE
            vNoMov := 0;
    end;

    procedure fPost(pCostJournal: Record "Cost Journal")
    var
        rlCostJournal: Record "Cost Journal";
        rlDistributionEntry: Record "Distribution Entry";
        rlDistributionRegister: Record "Distribution Registers";
        vNoMov: Integer;
        vNoReg: Integer;
    begin
        rlCostJournal := pCostJournal;

        fEntryNo(vNoMov);

        CLEAR(rlDistributionRegister);
        IF rlDistributionRegister.FINDLAST() THEN
            vNoReg := rlDistributionRegister."No.";

        CLEAR(rlDistributionRegister);
        rlDistributionRegister.INIT();
        rlDistributionRegister."No." := vNoReg + 1;
        rlDistributionRegister."From Entry No." := vNoMov;
        rlDistributionRegister."Creation Date" := TODAY;
        rlDistributionRegister."User ID" := USERID();
        rlDistributionRegister.INSERT();

        rlCostJournal.RESET();
        IF rlCostJournal.FINDSET() THEN
            REPEAT
                vNoMov += 1;
                rlDistributionEntry.INIT();
                rlDistributionEntry."Entry No." := vNoMov;
                rlDistributionEntry."Distrib. account no." := rlCostJournal."Distribution Account No.";
                rlDistributionEntry."Posting date" := rlCostJournal."Posting date";
                rlDistributionEntry."Document No." := rlCostJournal."Document No.";
                rlDistributionEntry.Description := rlCostJournal.Description;
                rlDistributionEntry."Debit amount" := rlCostJournal."Debit amount";
                rlDistributionEntry."Credit amount" := rlCostJournal."Credit amount";
                rlDistributionEntry.Amount := rlCostJournal.Amount;
                rlDistributionEntry."Global Dimension 1 Code" := rlCostJournal."Global dimension 1";
                rlDistributionEntry."Global Dimension 2 Code" := rlCostJournal."Global dimension 2";
                rlDistributionEntry."Dimension Set Id" := rlCostJournal."Dimension Set ID";
                rlDistributionEntry."Transaction No." := vNoReg + 1;
                rlDistributionEntry."Business Unit Code" := rlCostJournal."Business Unit Code";
                rlDistributionEntry.INSERT();
            UNTIL rlCostJournal.NEXT() = 0;

        rlDistributionRegister."To Entry No." := rlDistributionEntry."Entry No.";
        rlDistributionRegister.MODIFY();

        pCostJournal.DELETEALL();
    end;

    procedure fDeleteAllocation(pFrom: Integer; pTo: Integer; pDistributionEntry: Integer)
    begin
    end;

    procedure fConfirmIndentCostTypes()
    begin
        IF NOT CONFIRM(Text001Lbl, TRUE, rChartAccount.TABLECAPTION) THEN
            ERROR('');

        fIndentCostTypes(TRUE);
    end;

    procedure fIndentCostTypes(ShowMessage: Boolean)
    var
        CostTypeNo: array[10] of Code[20];
    begin
        i := 0;
        IF ShowMessage THEN
            Window.OPEN(Text004Lbl);

        IF rChartAccount.FIND('-') THEN
            REPEAT
                IF ShowMessage THEN
                    Window.UPDATE(1, rChartAccount."No.");
                IF rChartAccount.Type = rChartAccount.Type::"Total fin" THEN BEGIN
                    IF i < 1 THEN
                        ERROR(Text005Lbl, rChartAccount."No.");
                    rChartAccount.Totaling := CostTypeNo[i] + '..' + rChartAccount."No.";
                    i := i - 1;
                END;
                rChartAccount.Indentation := i;
                rChartAccount.MODIFY();
                IF rChartAccount.Type = rChartAccount.Type::"Total inicio" THEN BEGIN
                    i := i + 1;
                    CostTypeNo[i] := rChartAccount."No.";
                END;
            UNTIL rChartAccount.NEXT() = 0;

        IF ShowMessage THEN
            Window.CLOSE();
    end;
}
