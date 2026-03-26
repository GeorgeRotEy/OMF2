report 50005 "Analitic G/L Allocation"
{
    // // Mod. S2G 19/10/2017 (CPA) : CUNEF Reparto analítico.

    Caption = 'Cost Allocation', Comment = 'ESP="Distribución de costes"';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(AnalyticDistHeader; 50028)
        {
            DataItemTableView = SORTING(Level, Blocked)
                                WHERE(Blocked = FILTER(false));
            dataitem(MovimientoAsignacion; 50031)
            {
                DataItemTableView = SORTING("Assignment Document No.", "G/L Account", "Posting date")
                                    WHERE(Assigned = FILTER(false));
                dataitem(AnalyticDistLines; 50029)
                {
                    CalcFields = "Destinati dimension code", "Source dimension code";
                    DataItemTableView = SORTING("Document No.", "Line No.");

                    trigger OnAfterGetRecord()
                    var
                        DimensionSetID: Integer;
                        SourceDimCode: Code[20];
                        SourceDimValue: Code[20];
                        DestDimCode: Code[20];
                        DestDimValue: Code[20];
                    begin
                        DimensionSetID := MovimientoAsignacion."Dimension Set Id";

                        SourceDimCode := "Source dimension code";
                        SourceDimValue := "Source dimension value";

                        DestDimCode := "Destinati dimension code";
                        DestDimValue := "Destination dimension value";

                        IF (AssignedAmount = 0) THEN
                            BalAccDescription += ' '
                        ELSE
                            BalAccDescription += ', ';

                        BalAccDescription += "Destination dimension value";

                        AssignedAmount += PostNewDistribution(MovimientoAsignacion, "Source dimension code", "Source dimension value", "Destinati dimension code", "Destination dimension value", "Distribution percentage rate");
                    end;

                    trigger OnPostDataItem()
                    var
                        UltimoMovAsignado: Record "Distribution Entry";
                        MovimientoOrigen: Record "Distribution Entry";
                    begin
                        //Si hubiera un descuadre por redondeo, asignamos el importe de la diferencia al último movimiento insertado
                        IF UltimoNumMovReparto <> 0 THEN BEGIN
                            UltimoMovAsignado.GET(UltimoNumMovReparto);
                            MovimientoOrigen.GET(NumMovRepartoOrigen);

                            IF (AssignedAmount <> ImporteMovOrigen) THEN BEGIN
                                UltimoMovAsignado.VALIDATE(Amount, UltimoMovAsignado.Amount + ImporteMovOrigen - AssignedAmount);
                                UltimoMovAsignado.MODIFY(TRUE);
                            END;

                            //Metemos el último Nº Movimiento en el registro de movimientos.
                            UpdateDistributionRegister();

                            //Creamos el movimiento de contrapartida con signo contrario
                            NumMovReparto += 1;
                            UltimoNumMovReparto := NumMovReparto;

                            Movimientos2.INIT();
                            Movimientos2.TRANSFERFIELDS(MovimientoAsignacion);
                            Movimientos2."Entry No." := NumMovReparto;
                            Movimientos2.VALIDATE(Amount, -ImporteMovOrigen);
                            Movimientos2.Assigned := TRUE;
                            Movimientos2."Assignment Document No." := AnalyticDistHeader."Document No.";
                            Movimientos2."Distribution Id." := IdDistribucion;
                            Movimientos2."Distribution Id. No. Series" := AnalyticalDistSetup."No Series Distribution";

                            Movimientos2."Description of assignment" := COPYSTR(BalAccDescription, 1, MAXSTRLEN(Movimientos2."Description of assignment"));
                            Movimientos2."Transaction No." := TransactionNo;
                            Movimientos2."Source Entry No." := NumMovRepartoOrigen;
                            Movimientos2."Source code" := SourceCodeSetup."Distribution Allocation";
                            Movimientos2."Global Dimension 1 Code" := MovimientoOrigen."Global Dimension 1 Code";
                            Movimientos2."Global Dimension 2 Code" := MovimientoOrigen."Global Dimension 2 Code";
                            Movimientos2."Dimension Set Id" := MovimientoOrigen."Dimension Set Id";
                            Movimientos2.INSERT(TRUE);

                            //Marcamos el movimiento origen como asignado
                            Movimientos2.GET(NumMovRepartoOrigen);
                            Movimientos2.Assigned := TRUE;
                            Movimientos2."Assignment Document No." := AnalyticDistHeader."Document No.";
                            Movimientos2."Distribution Id." := IdDistribucion;
                            Movimientos2."Distribution Id. No. Series" := AnalyticalDistSetup."No Series Distribution";
                            Movimientos2."User Id." := USERID();
                            Movimientos2.MODIFY(TRUE);
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Document No.", AnalyticDistHeader."Document No.");

                        AssignedAmount := 0;
                        BalAccDescription := STRSUBSTNO(BalAccAssignationDescription, AnalyticDistHeader."Destination dimension code");
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    DimensionSetID: Integer;
                    SourceDimCode: Code[20];
                    DestDimCode: Code[20];
                    SkipEntryAssignement: Boolean;
                    AnaliticDistrLinesCheck: Record "Anaylitical Distrib. Lines";
                begin
                    cuentaMovimientos += 1;
                    Window.UPDATE(2, cuentaMovimientos);

                    NumMovRepartoOrigen := "Entry No.";
                    ImporteMovOrigen := Amount;

                    PrimerNumMovReparto := 0;
                    UltimoNumMovReparto := 0;

                    DimensionSetID := "Dimension Set Id";
                    SourceDimCode := AnalyticDistHeader."Source dimension code";
                    DestDimCode := AnalyticDistHeader."Destination dimension code";
                    IF NOT DimSetIdContainsDimCode(DimensionSetID, SourceDimCode) THEN
                        SkipEntryAssignement := TRUE
                    ELSE BEGIN
                        ;
                        CASE AnalyticDistHeader."Dest. Dimension processing" OF
                            AnalyticDistHeader."Dest. Dimension processing"::"Ignore if filled":
                                IF DimSetIdContainsDimCode(DimensionSetID, DestDimCode) THEN
                                    SkipEntryAssignement := TRUE;
                            AnalyticDistHeader."Dest. Dimension processing"::"Ignore if blank":
                                IF NOT DimSetIdContainsDimCode(DimensionSetID, DestDimCode) THEN
                                    SkipEntryAssignement := TRUE;
                        END;

                        IF NOT SkipEntryAssignement THEN BEGIN
                            AnaliticDistrLinesCheck.RESET();
                            AnaliticDistrLinesCheck.SETCURRENTKEY("Document No.", "Line No.");
                            AnaliticDistrLinesCheck.SETRANGE("Document No.", AnalyticDistHeader."Document No.");
                            IF AnaliticDistrLinesCheck.FINDSET() THEN
                                REPEAT
                                    IF NOT DimSetIdContainsDimValue(DimensionSetID, SourceDimCode, AnaliticDistrLinesCheck."Source dimension value") THEN SkipEntryAssignement := TRUE;
                                UNTIL (AnaliticDistrLinesCheck.NEXT() = 0) OR SkipEntryAssignement;
                        END;
                    END;

                    IF (SkipEntryAssignement) THEN CurrReport.SKIP;
                end;

                trigger OnPreDataItem()
                var
                    MovimientoComprobacion: Record "Distribution Entry";
                begin
                    MovimientoComprobacion.RESET();
                    //MovimientoComprobacion.SETCURRENTKEY("Assignment Document No.","G/L Account","Posting date");

                    MovimientoComprobacion.SETFILTER("Assignment Document No.", '<>%1', AnalyticDistHeader."Document No.");

                    IF AnalyticDistHeader."Account interval" <> '' THEN
                        MovimientoComprobacion.SETFILTER("G/L Account", AnalyticDistHeader."Account interval");

                    CASE TRUE OF
                        (AnalyticDistHeader."From Posting Date" <> 0D) AND (AnalyticDistHeader."To Posting Date" <> 0D):
                            MovimientoComprobacion.SETRANGE("Posting date", AnalyticDistHeader."From Posting Date", AnalyticDistHeader."To Posting Date");
                        (AnalyticDistHeader."From Posting Date" <> 0D) AND (AnalyticDistHeader."To Posting Date" = 0D):
                            MovimientoComprobacion.SETFILTER("Posting date", '%1..', AnalyticDistHeader."From Posting Date");
                        (AnalyticDistHeader."From Posting Date" = 0D) AND (AnalyticDistHeader."To Posting Date" <> 0D):
                            MovimientoComprobacion.SETFILTER("Posting date", '..%1', AnalyticDistHeader."To Posting Date");
                    END;

                    IF MovimientoComprobacion.FINDLAST() THEN
                        MovimientoComprobacion.SETFILTER("Entry No.", '..%1', MovimientoComprobacion."Entry No.");

                    Window.UPDATE(3, MovimientoComprobacion.COUNT);
                    cuentaMovimientos := 0;

                    //MovimientoAsignacion.RESET();
                    //MovimientoAsignacion.SETCURRENTKEY("Assignment Document No.","G/L Account","Posting date");
                    MovimientoAsignacion.COPYFILTERS(MovimientoComprobacion);
                end;
            }

            trigger OnAfterGetRecord()
            var
                Dimension: Record Dimension;
            begin
                NumEtapa += 1;
                Window.UPDATE(4, NumEtapa);

                Window.UPDATE(1, AnalyticDistHeader."Document No.");

                Dimension.GET("Source dimension code");
                IF Dimension."Do not split if assigned" THEN CurrReport.SKIP;
                Dimension.TESTFIELD(Blocked, FALSE);

                Dimension.GET("Destination dimension code");
                IF Dimension."Do not split if assigned" THEN CurrReport.SKIP;
                Dimension.TESTFIELD(Blocked, FALSE);
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE(Level, FromLevel, ToLevel);
                SETFILTER("Valid from date", '%1|..%2', 0D, AllocDate);
                SETFILTER("Valid to date", '%1|%2..', 0D, AllocDate);
                SETRANGE(Blocked, FALSE);

                Window.OPEN(Text_Progreso);

                TotalEtapas := AnalyticDistHeader.COUNT;
                NumEtapa := 0;
                Window.UPDATE(5, TotalEtapas);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESP="Opciones"';
                    field("From Alloc. Level"; FromLevel)
                    {
                        Caption = 'From Alloc. Level', Comment = 'ESP="Desde nivel distribución"';
                        MaxValue = 99;
                        MinValue = 1;
                        ApplicationArea = All;
                    }
                    field("To Alloc. Level"; ToLevel)
                    {
                        Caption = 'To Alloc. Level', Comment = 'ESP="Hasta nivel distribución"';
                        MaxValue = 99;
                        MinValue = 1;
                        ApplicationArea = All;
                    }
                    field("Allocation Date"; AllocDate)
                    {
                        Caption = 'Allocation Date', Comment = 'ESP="Fecha distribución"';
                        ApplicationArea = All;
                    }
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

    trigger OnInitReport()
    begin
        InitializeRequest(1, 99, WORKDATE);
    end;

    trigger OnPostReport()
    begin
        Window.CLOSE();
        MESSAGE(Text_Fin);
    end;

    trigger OnPreReport()
    begin
        fGetGLSetup();
        fGetSourceCodeSetup();
        fGetAnalytitcalDistrSetup();

        NumMovReparto := 0;

        Movimientos2.LOCKTABLE();
        Movimientos2.RESET();
        IF Movimientos2.FINDLAST() THEN NumMovReparto := Movimientos2."Entry No.";
    end;

    var
        Movimientos2: Record "Distribution Entry";
        NumMovReparto: Integer;
        DimMgmt: Codeunit DimensionManagement;
        GLSetup: Record "General Ledger Setup";
        AnalyticalDistSetup: Record "Analytical Distribution Setup";
        SourceCodeSetup: Record "Source Code Setup";
        NoseriesMgt: Codeunit "No. Series";
        AssignedAmount: Decimal;
        BalAccDescription: Text[250];
        AllocDate: Date;
    AssignationDescription: Label 'Source Assignation = %1 (%2)', Comment = 'ESP="Asignación origen = %1 (%2)"';
        FromLevel: Integer;
        ToLevel: Integer;
    BalAccAssignationDescription: Label 'Source Assignation = %1 (%2)', Comment = 'ESP="Asignación origen = %1 (%2)"';
        IdDistribucion: Code[20];
        PrimerNumMovReparto: Integer;
        UltimoNumMovReparto: Integer;
        DistribRegister: Record "Distribution Registers";
        TransactionNo: Integer;
        NumMovRepartoOrigen: Integer;
        ImporteMovOrigen: Decimal;
    Text_Progreso: Label 'Cost allocation\Level                      #1####### \Source ID                  #2####### \Sum source entries         #3####### \Write allocation entries   #4####### ', Comment = 'ESP="Reparto de costes\Nivel                      #1####### \ID origen                  #2####### \Suma movs. origen         #3####### \Escribir movs. reparto   #4####### "';
        Window: Dialog;
        cuentaMovimientos: Integer;
    Text_Fin: Label 'Proceso finalizado', Comment = 'ESP="Proceso finalizado"';
        NumEtapa: Integer;
        TotalEtapas: Integer;

    procedure InitializeRequest(NewFromLevel: Integer; NewToLevel: Integer; NewAllocDate: Date)
    begin
        FromLevel := NewFromLevel;
        ToLevel := NewToLevel;
        AllocDate := NewAllocDate;
    end;

    local procedure DimSetIdContainsDimCode(DimensionSetID: Integer; DimensionCode: Code[20]): Boolean
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        DimensionSetEntry.RESET();
        EXIT(DimensionSetEntry.GET(DimensionSetID, DimensionCode));
    end;

    local procedure DimSetIdContainsDimValue(DimensionSetID: Integer; DimensionCode: Code[20]; DimensionValue: Code[20]): Boolean
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        DimensionSetEntry.RESET();
        IF NOT DimensionSetEntry.GET(DimensionSetID, DimensionCode) THEN
            EXIT(FALSE)
        ELSE
            EXIT(DimensionSetEntry."Dimension Value Code" = DimensionValue);
    end;

    local procedure PostNewDistribution(var OriginalEntry: Record "Distribution Entry"; OldDimensionCode: Code[20]; OldDimensionValueCode: Code[20]; NewDimensionCode: Code[20]; NewDimensionValueCode: Code[20]; AssignedPercentage: Decimal): Decimal
    var
        NewDimensionSetEntry: Record "Dimension Set Entry" temporary;
    begin
        NumMovReparto += 1;

        //Creamos el registro de movimientos antes de insertar el primer movimiento y así generamos el Nº de transacción
        IF PrimerNumMovReparto = 0 THEN CreateDistributionRegister();

        IF (PrimerNumMovReparto = 0) OR (PrimerNumMovReparto > NumMovReparto) THEN PrimerNumMovReparto := NumMovReparto;
        IF (UltimoNumMovReparto = 0) OR (UltimoNumMovReparto < NumMovReparto) THEN UltimoNumMovReparto := NumMovReparto;

        Movimientos2.INIT();
        Movimientos2.TRANSFERFIELDS(OriginalEntry);

        Movimientos2."Entry No." := NumMovReparto;

        Movimientos2."Description of assignment" := STRSUBSTNO(AssignationDescription, OldDimensionCode, OldDimensionValueCode);

        DimMgmt.GetDimensionSet(NewDimensionSetEntry, OriginalEntry."Dimension Set Id");

        //Si repartimos de una dimensión a otra dimension distinta, el valor de la antigua dimensión se conserva
        //pero si repartimos de un valor dimensión a otro valor de la misma dimension, eliminamos el registro y se crea el nuevo (un valor por otro)
        IF (OldDimensionCode = NewDimensionCode) THEN BEGIN
            NewDimensionSetEntry.GET(OriginalEntry."Dimension Set Id", OldDimensionCode);
            NewDimensionSetEntry.DELETE();
        END;

        IF NewDimensionSetEntry.GET(OriginalEntry."Dimension Set Id", NewDimensionCode) THEN
            NewDimensionSetEntry.DELETE();

        NewDimensionSetEntry.INIT();
        NewDimensionSetEntry.VALIDATE("Dimension Set ID", OriginalEntry."Dimension Set Id");
        NewDimensionSetEntry.VALIDATE("Dimension Code", NewDimensionCode);
        NewDimensionSetEntry.VALIDATE("Dimension Value Code", NewDimensionValueCode);
        NewDimensionSetEntry.INSERT(TRUE);

        Movimientos2."Dimension Set Id" := DimMgmt.GetDimensionSetID(NewDimensionSetEntry);

        IF NewDimensionCode = GLSetup."Global Dimension 1 Code" THEN Movimientos2."Global Dimension 1 Code" := NewDimensionValueCode;
        IF NewDimensionCode = GLSetup."Global Dimension 2 Code" THEN Movimientos2."Global Dimension 2 Code" := NewDimensionValueCode;

        Movimientos2.VALIDATE(Amount, ROUND(Movimientos2.Amount * AssignedPercentage * 0.01, GLSetup."Amount Rounding Precision", '='));
        AssignedAmount += Movimientos2.Amount;

        Movimientos2.Assigned := FALSE;

        IF IdDistribucion = '' THEN BEGIN
            NoseriesMgt.AreRelated(AnalyticalDistSetup."No Series Distribution", Movimientos2."Distribution Id. No. Series");
            IdDistribucion := Movimientos2."Distribution Id.";
        END ELSE BEGIN
            Movimientos2."Distribution Id." := IdDistribucion;
            Movimientos2."Distribution Id. No. Series" := AnalyticalDistSetup."No Series Distribution";
        END;

        Movimientos2."User Id." := USERID();
        Movimientos2."Assignment Document No." := AnalyticDistHeader."Document No.";
        Movimientos2."Source code" := SourceCodeSetup."Distribution Allocation";
        Movimientos2."Transaction No." := TransactionNo;
        Movimientos2."Source Entry No." := NumMovRepartoOrigen;
        Movimientos2.INSERT();

        EXIT(Movimientos2.Amount);
    end;

    local procedure CreateDistributionRegister()
    begin
        fGetSourceCodeSetup();

        DistribRegister.RESET();

        TransactionNo := 1;
        IF DistribRegister.FINDLAST() THEN
            TransactionNo += DistribRegister."No.";

        DistribRegister.INIT();
        DistribRegister."No." := TransactionNo;
        DistribRegister."From Entry No." := NumMovReparto;
        DistribRegister."Creation Date" := TODAY;
        DistribRegister."Source Code" := SourceCodeSetup."Distribution Allocation";
        DistribRegister."User ID" := USERID();
        DistribRegister.INSERT();
    end;

    local procedure UpdateDistributionRegister()
    begin
        IF (DistribRegister."No." = 0) THEN EXIT;
        DistribRegister."To Entry No." := UltimoNumMovReparto;
        DistribRegister.MODIFY();
    end;

    local procedure fGetSourceCodeSetup()
    begin
        SourceCodeSetup.GET();
        SourceCodeSetup.TESTFIELD("Distribution Allocation");
    end;

    local procedure fGetAnalytitcalDistrSetup()
    begin
        AnalyticalDistSetup.GET();
        AnalyticalDistSetup.TESTFIELD("No Series Distribution");
    end;

    local procedure fGetGLSetup()
    begin
        GLSetup.GET();
    end;

    procedure GetDimensionSet(var TempDimSetEntry: Record "Dimension Set Entry" temporary; DimSetID: Integer)
    var
        DimSetEntry2: Record "Dimension Set Entry";
    begin
        TempDimSetEntry.DELETEALL();
        DimSetEntry2.SETRANGE("Dimension Set ID", DimSetID);

        IF DimSetEntry2.FINDSET() THEN
            REPEAT
                TempDimSetEntry := DimSetEntry2;
                TempDimSetEntry.INSERT();
            UNTIL DimSetEntry2.NEXT() = 0;
    end;
}
