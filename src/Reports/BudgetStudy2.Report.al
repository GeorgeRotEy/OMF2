report 50035 "Budget Study2"
{
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
    // (CJ09) S2G (JDT) 24-10-19: Modificaciones líneas de totales por grupo.
    // (INC) S2G (JDT) 13-12-19: Agrupación y totalización por grupo contable.
    // (1.5) S2G (RBM-R) 09-03-20: Modificaciones presupuestos
    //
    // KPMG (DRM) 12-01-21 //K018: Deshabilitar resta de año cuando la opción va sobre la lectura de presupuesto año anterior.
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/BudgetStudy2.rdlc';
    Caption = 'Estudio del presupuesto', Comment = 'ESP="Estudio del presupuesto"';
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            CalcFields = "Net Change";
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE("No." = FILTER('20*|21*|6*|7*|5505007'),
                                      "Account Type" = CONST(Posting));
            column(filtros; GETFILTERS)
            {
            }
            column(Companyname; COMPANYNAME)
            {
            }
            column("Año"; AnoOriginal)
            {
            }
            column(MesIni; MesIni)
            {
            }
            column(MesFin; MesFin)
            {
            }
            column(TotalReal; vTotalReal)
            {
            }
            column(NoAcc; NoAcc)
            {
            }
            column(No_GLAccount; "G/L Account"."No.")
            {
            }
            column(Name_GLAccount; "G/L Account".Name)
            {
            }
            column(NetChange_GLAccount; "G/L Account"."Net Change")
            {
            }
            column(Amount_GLBudgetEntry; rGLBudgetEntry.Amount)
            {
            }
            column(Ppto; vPpto)
            {
            }
            column(Cumpl; vCumpl)
            {
            }
            column(TotalPpto2; TotalPpto2)
            {
            }
            column(TotalPpto6; TotalPpto6)
            {
            }
            column(TotalPpto7; TotalPpto7)
            {
            }
            column(TotalReal2; TotalReal2)
            {
            }
            column(TotalReal6; TotalReal6)
            {
            }
            column(TotalReal7; TotalReal7)
            {
            }
            column(PctGrupo2; PctGrupo2)
            {
            }
            column(PctGrupo6; PctGrupo6)
            {
            }
            column(PctGrupo7; PctGrupo7)
            {
            }
            column(PctGrupo; PctGrupo)
            {
            }
            column(PctTotal; PctTotal)
            {
            }
            column(TextDesc; TextDesc)
            {
            }
            column(CuentaCinco; CuentaCinco)
            {
            }
            column(Orden; Orden)
            {
            }
            column(CriterioOrden; CriterioOrden)
            {
            }

            trigger OnAfterGetRecord()
            begin
                vPpto := 0;
                vTotalReal += "G/L Account"."Net Change";

                // (INC) S2G (JDT) 13-12-19:
                NoAcc := COPYSTR("G/L Account"."No.", 1, 1);

                // ATD (KPMG) 24-02-2021
                CuentaCinco := '';
                Orden := 0;
                CriterioOrden := 0;
                IF ("G/L Account"."No." = '5505007') THEN BEGIN
                    CuentaCinco := "G/L Account"."No.";
                END;
                // ATD (KPMG) 24-02-2021 END

                // (INC) S2G (JDT) 13-12-19:

                // (CJ09) S2G (JDT) 24-10-19: Modificaciones líneas de totales por grupo.
                CASE COPYSTR("G/L Account"."No.", 1, 1) OF
                    '2':
                        TotalReal2 += "G/L Account"."Net Change";
                    '6':
                        TotalReal6 += "G/L Account"."Net Change";
                    '7':
                        TotalReal7 += "G/L Account"."Net Change";
                END;

                // ATD (KPMG) 24-02-2021
                IF ("G/L Account"."No." = '5505007') THEN BEGIN
                    TotalReal7 += "G/L Account"."Net Change";
                END;
                // ATD (KPMG) 24-02-2021 end

                // (CJ09) S2G (JDT) 24-10-19:

                rGLBudgetEntry.RESET();
                rGLBudgetEntry.SETCURRENTKEY("Budget Name", "G/L Account No.", Date);
                rGLBudgetEntry.SETRANGE("Budget Name", vBudgetName);
                rGLBudgetEntry.SETRANGE("G/L Account No.", "G/L Account"."No.");
                //rGLBudgetEntry.SETFILTER(Date, '%1..%2', vStartDate, vEndDate);

                //(1.5) S2G (RBM-R) 09-03-20: Modificaciones presupuestos. Inicio
                //EVALUATE(vStartYear, '01/01/' + FORMAT(DATE2DMY(TODAY, 3)));
                //EVALUATE(vEndYear, '31/12/' + FORMAT(DATE2DMY(TODAY, 3)));
                //rGLBudgetEntry.SETFILTER(Date, '%1..%2', vStartYear, vEndYear);
                rGLBudgetEntry.SETFILTER(Date, '%1..%2', vStartDate, vEndDate);
                //(1.5) S2G (RBM-R) 09-03-20: Modificaciones presupuestos. Fin

                IF rGLBudgetEntry.FINDSET() THEN
                    REPEAT
                        vPpto += rGLBudgetEntry.Amount;
                        // (CJ09) S2G (JDT) 24-10-19: Modificaciones líneas de totales por grupo.
                        vTotalPto += rGLBudgetEntry.Amount;
                        CASE COPYSTR(rGLBudgetEntry."G/L Account No.", 1, 1) OF
                            '2':
                                TotalPpto2 += rGLBudgetEntry.Amount;
                            '6':
                                TotalPpto6 += rGLBudgetEntry.Amount;
                            '7':
                                TotalPpto7 += rGLBudgetEntry.Amount;
                        END;

                        // ATD (KPMG) 24-02-2021
                        IF ("G/L Account"."No." = '5505007') THEN BEGIN
                            TotalPpto7 += rGLBudgetEntry.Amount;
                        END;
                    // ATD (KPMG) 24-02-2021 END

                    // (CJ09) S2G (JDT) 24-10-19:
                    UNTIL rGLBudgetEntry.NEXT() = 0;

                vCumpl := 0;
                IF vPpto <> 0 THEN
                    vCumpl := "Net Change" / vPpto;

                // (CJ09) S2G (JDT) 28-10-19: Modificaciones líneas de totales por grupo.
                CASE COPYSTR("G/L Account"."No.", 1, 1) OF
                    '2':
                        IF TotalPpto2 <> 0 THEN
                            PctGrupo2 := TotalReal2 / TotalPpto2;
                    '6':
                        IF TotalPpto6 <> 0 THEN
                            PctGrupo6 := TotalReal6 / TotalPpto6;
                    '7':
                        IF TotalPpto7 <> 0 THEN
                            PctGrupo7 := TotalReal7 / TotalPpto7;
                END;

                // ATD (KPMG) 24-02-2021
                IF ("G/L Account"."No." = '5505007') THEN BEGIN
                    IF TotalPpto7 <> 0 THEN BEGIN
                        PctGrupo7 := TotalReal7 / TotalPpto7;
                    END;
                END;
                // ATD (KPMG) 24-02-2021 END

                // (CJ09) S2G (JDT) 28-10-19:

                // (INC) S2G (JDT) 13-12-19:
                IF ((NoAcc = '2') AND (CuentaCinco = '')) THEN BEGIN
                    Orden := 1;
                    CriterioOrden := 2;
                    PctGrupo := PctGrupo2;
                    TextDesc := 'TOTAL INVERSIONES';
                END;
                IF ((NoAcc = '6') AND (CuentaCinco = '')) THEN BEGIN
                    Orden := 2;
                    CriterioOrden := 2;
                    PctGrupo := PctGrupo6;
                    TextDesc := 'TOTAL GASTOS';
                END;
                IF ((NoAcc = '7') OR (CuentaCinco = '5505007')) THEN BEGIN
                    Orden := 3;

                    IF ((NoAcc = '7') AND (CuentaCinco = '')) THEN BEGIN
                        CriterioOrden := 3;
                    END;

                    IF (CuentaCinco = '5505007') THEN BEGIN
                        CriterioOrden := 4;
                    END;

                    PctGrupo := PctGrupo7;
                    TextDesc := 'TOTAL INGRESOS';
                END;

                IF vTotalPto <> 0 THEN
                    PctTotal := vTotalReal / vTotalPto
                // (INC) S2G (JDT) 13-12-19:
            end;

            trigger OnPreDataItem()
            begin
                vTotalReal := 0;

                //(1.5) S2G (RBM-R) 09-03-20: Modificaciones presupuestos. Inicio
                AnoOriginal := Ano;
                IF Ano + 2018 = DATE2DMY(TODAY, 3) - 1 THEN BEGIN
                    rGLBudgetName.RESET();
                    rGLBudgetName.SETRANGE("Last Year Budget", TRUE);
                    IF rGLBudgetName.FINDFIRST() THEN BEGIN //solo hay uno activo, se controla
                        vBudgetName := rGLBudgetName.Name;
                        //K018   Ano := Ano - 1;
                    END;
                END ELSE BEGIN
                    IF Ano + 2018 = DATE2DMY(TODAY, 3) THEN BEGIN
                        //(1.5) S2G (RBM-R) 09-03-20: Modificaciones presupuestos. Fin

                        rGLBudgetName.RESET();
                        rGLBudgetName.SETCURRENTKEY(Active);
                        rGLBudgetName.SETRANGE(Active, TRUE);
                        IF rGLBudgetName.FINDFIRST() THEN  //solo hay uno activo, se controla
                            vBudgetName := rGLBudgetName.Name;

                        //(1.5) S2G (RBM-R) 09-03-20: Modificaciones presupuestos. Inicio
                    END ELSE
                        CurrReport.BREAK;
                END;
                //(1.5) S2G (RBM-R) 09-03-20: Modificaciones presupuestos. Fin

                //EVALUATE(vStartDate, '01/' + FORMAT(MesIni + 1) + '/' + FORMAT(Ano + 2018));
                //EVALUATE(vEndDate, '01/' + FORMAT(MesFin + 1) + '/' + FORMAT(Ano + 2018));
                vStartDate := DMY2Date(1, MesIni.AsInteger(), Ano + 2018);
                vEndDate := DMY2Date(1, MesFin.AsInteger(), Ano + 2018);
                vEndDate := CALCDATE('+1M-1D', vEndDate);

                SETFILTER("Date Filter", '%1..%2', vStartDate, vEndDate);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field(Ano; Ano)
                {
                    ApplicationArea = All;
                }
                field(MesIni; MesIni)
                {
                    ApplicationArea = All;
                }
                field(MesFin; MesFin)
                {
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

    trigger OnInitReport()
    begin
        Ano := DATE2DMY(TODAY, 3) - 2018;
        // (CJ09) S2G (JDT) 24-10-19: Modificaciones líneas de totales por grupo.
        CLEAR(TotalReal2);
        CLEAR(TotalReal6);
        CLEAR(TotalReal7);
        CLEAR(TotalPpto2);
        CLEAR(TotalPpto6);
        CLEAR(TotalPpto7);
        CLEAR(PctGrupo);
        CLEAR(PctTotal);
        CLEAR(vTotalPto);
        CLEAR(Orden);
        CLEAR(CriterioOrden);
        // (CJ09) S2G (JDT) 24-10-19:
    end;

    var
        rGLBudgetName: Record "G/L Budget Name";
        rGLBudgetEntry: Record "G/L Budget Entry";
        Ano: Enum Years;
        MesIni: Enum Months;
        MesFin: Enum Months;
        vStartDate: Date;
        vEndDate: Date;
        vStartYear: Date;
        vEndYear: Date;
        vTotalReal: Decimal;
        vPpto: Decimal;
        vCumpl: Decimal;
        vBudgetName: Code[10];
        TotalPpto2: Decimal;
        TotalPpto6: Decimal;
        TotalPpto7: Decimal;
        TotalReal2: Decimal;
        TotalReal6: Decimal;
        TotalReal7: Decimal;
        PctGrupo2: Decimal;
        PctGrupo6: Decimal;
        PctGrupo7: Decimal;
        NoAcc: Text[10];
        PctGrupo: Decimal;
        PctTotal: Decimal;
        vTotalPto: Decimal;
        TextDesc: Text[20];
        AnoOriginal: Option "2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033";
        CuentaCinco: Text;
        Orden: Integer;
        CriterioOrden: Integer;
        VariableTEST: Integer;

    procedure fSetParameters(pAno: Text; pMesIni: Text; pMesFin: Text)
    begin
        EVALUATE(Ano, pAno);
        EVALUATE(MesIni, pMesIni);
        EVALUATE(MesFin, pMesFin);
        //MesIni := MesIni - 1;
        //MesFin := MesFin - 1;
    end;
}
