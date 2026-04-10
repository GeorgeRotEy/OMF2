report 50003 "Copy GL Entry to Distribution"
{
    Caption = 'Copy GL Entry to Distribution', Comment = 'ESP="Copiar mov. contable a distribución"';
    ProcessingOnly = true;
    UseRequestPage = false;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Entry No.");

            trigger OnAfterGetRecord()
            begin
                Window.UPDATE(1, indice);
                indice += 1;

                rGLAccount.GET("G/L Entry"."G/L Account No.");
                IF rGLAccount."Income/Balance" <> rGLAccount."Income/Balance"::"Income Statement" THEN CurrReport.SKIP;

                fINSERT();
            end;

            trigger OnPostDataItem()
            begin
                UpdateDistributionRegister();

                Window.CLOSE();

                IF DistribRegister."No." = 0 THEN
                    MESSAGE(Text_NadaQueactualizar)
                ELSE
                    MESSAGE(Text_ProcesoFinalizado);
            end;

            trigger OnPreDataItem()
            begin
                rAnalyticalDistributionSetup.GET();
                rAnalyticalDistributionSetup.TESTFIELD("Transfer start date");

                rSourceSetup.GET();
                rSourceSetup.TESTFIELD("Close Income Statement");

                vNoMovCon := 0;
                CLEAR(rDistributionEntry);
                rDistributionEntry.SETCURRENTKEY("G/L Entry No.");
                IF NOT rDistributionEntry.ISEMPTY THEN
                    IF rDistributionEntry.FINDLAST() THEN
                        vNoMovCon := rDistributionEntry."G/L Entry No.";

                rDistributionEntryInsert.RESET();
                IF rDistributionEntryInsert.FINDLAST() THEN
                    vNoMov := rDistributionEntryInsert."Entry No.";

                SETFILTER("Posting Date", '%1..', rAnalyticalDistributionSetup."Transfer start date");
                SETFILTER("Entry No.", '>%1', vNoMovCon);
                SETFILTER("Source Code", '<>%1', rSourceSetup."Close Income Statement");

                Window.OPEN(Text_Actualizando + Text_Procesados);
                Window.UPDATE(2, COUNT);
                indice := 1;
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
        IF NOT CONFIRM(Text_Advertencia) THEN
            ERROR(Text_ProcessCancelled);
    end;

    var
        rAnalyticalDistributionSetup: Record "Analytical Distribution Setup";
        rDistributionEntry: Record "Distribution Entry";
        rGLAccount: Record "G/L Account";
        rSourceSetup: Record "Source Code Setup";
        vNoMovCon: Integer;
        rDistributionEntryInsert: Record "Distribution Entry";
        vNoMov: Integer;
        vPrimerMov: Integer;
        vUltimoMov: Integer;
        TransactionNo: Integer;
        DistribRegister: Record "Distribution Registers";
        Text_Actualizando: Label 'Copying G/L Entries...\', Comment = 'ESP="Copiando movimientos de G/L...\\"';
        Text_Procesados: Label 'Procesed #1##### of #2#####', Comment = 'ESP="Procesados #1##### de #2#####"';
        Window: Dialog;
        indice: Integer;
        Text_ProcesoFinalizado: Label 'Process finished', Comment = 'ESP="Proceso finalizado"';
        Text_NadaQueactualizar: Label 'All entries are synchronizeed. \There''s nothing to update', Comment = 'ESP="Todos los movimientos están sincronizados. \No hay nada que actualizar"';
        Text_Advertencia: Label 'This process copies the G/L Entries not updatred before. Do you want to continue?', Comment = 'ESP="Este proceso copia los movimientos de G/L no actualizados previamente. ¿Desea continuar?"';
        Text_ProcessCancelled: Label 'Process cancelled by the user', Comment = 'ESP="Proceso cancelado por el usuario"';

    local procedure fInsert()
    begin
        vNoMov += 1;

        IF (vPrimerMov = 0) OR (vNoMov < vPrimerMov) THEN vPrimerMov := vNoMov;
        IF (vUltimoMov = 0) OR (vNoMov > vUltimoMov) THEN vUltimoMov := vNoMov;

        IF (TransactionNo = 0) THEN CreateDistributionRegister();

        rDistributionEntryInsert.INIT();
        rDistributionEntryInsert."Entry No." := vNoMov;
        rDistributionEntryInsert."Document No." := "G/L Entry"."Document No.";
        rDistributionEntryInsert."Posting date" := "G/L Entry"."Posting Date";
        rDistributionEntryInsert.Description := "G/L Entry".Description;

        IF "G/L Entry"."Debit Amount" <> 0 THEN rDistributionEntryInsert.VALIDATE("Debit amount", "G/L Entry"."Debit Amount");
        IF "G/L Entry"."Credit Amount" <> 0 THEN rDistributionEntryInsert.VALIDATE("Credit amount", "G/L Entry"."Credit Amount");

        rDistributionEntryInsert."G/L Account" := "G/L Entry"."G/L Account No.";
        rDistributionEntryInsert."Distrib. account no." := fGetCuentaReparto("G/L Entry"."G/L Account No.");

        rDistributionEntryInsert."G/L Entry No." := "G/L Entry"."Entry No.";
        rDistributionEntryInsert."Source code" := "G/L Entry"."Source Code";
        rDistributionEntryInsert."Global Dimension 1 Code" := "G/L Entry"."Global Dimension 1 Code";
        rDistributionEntryInsert."Global Dimension 2 Code" := "G/L Entry"."Global Dimension 2 Code";
        rDistributionEntryInsert."Dimension Set Id" := "G/L Entry"."Dimension Set ID";
        rDistributionEntryInsert."Transaction No." := DistribRegister."No.";
        rDistributionEntryInsert."User Id." := USERID();
        rDistributionEntryInsert."Source Entry No." := vNoMov;
        rDistributionEntryInsert."Business Unit Code" := "G/L Entry"."Business Unit Code";
        rDistributionEntryInsert.INSERT(TRUE);
    end;

    local procedure CreateDistributionRegister()
    begin
        DistribRegister.RESET();

        TransactionNo := 1;
        IF DistribRegister.FINDLAST() THEN
            TransactionNo += DistribRegister."No.";

        DistribRegister.INIT();
        DistribRegister."No." := TransactionNo;
        DistribRegister."From Entry No." := vPrimerMov;
        DistribRegister."Creation Date" := TODAY;
        DistribRegister."Source Code" := rSourceSetup."Distribution Allocation";
        DistribRegister."User ID" := USERID();
        DistribRegister.INSERT();
    end;

    local procedure UpdateDistributionRegister()
    begin
        IF DistribRegister."No." = 0 THEN EXIT;

        DistribRegister."To Entry No." := vUltimoMov;
        DistribRegister.MODIFY();
    end;

    local procedure fGetCuentaReparto(GL_AccountNo: Code[20]): Code[20]
    var
        CuentasReparto: Record "Schedule of Distrib. Accounts";
    begin
        CuentasReparto.RESET();
        CuentasReparto.SETRANGE("Interval of GC accounts", GL_AccountNo);
        IF CuentasReparto.FINDFIRST() THEN
            EXIT(CuentasReparto."No.");
    end;
}
