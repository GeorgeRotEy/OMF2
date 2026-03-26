report 50007 "Budget Study"
{
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
    // (CJ09) S2G (JDT) 24-10-19: Modificaciones líneas de totales por grupo.
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/BudgetStudy.rdlc';
    Caption = 'Estudio del presupuesto', Comment = 'ESP="Estudio del presupuesto"';
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            CalcFields = "Net Change";
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE("No." = FILTER('20*|21*|6*|7*'),
                                      "Account Type" = CONST(Posting));
            column(filtros; GETFILTERS)
            {
            }
            column(Companyname; COMPANYNAME)
            {
            }
            column("Año"; Ano)
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

            trigger OnAfterGetRecord()
            begin
                vPpto := 0;
                vTotalReal += "G/L Account"."Net Change";
                // (CJ09) S2G (JDT) 24-10-19: Modificaciones líneas de totales por grupo.
                CASE COPYSTR("G/L Account"."No.", 1, 1) OF
                    '2':
                        TotalReal2 += "G/L Account"."Net Change";
                    '6':
                        TotalReal6 += "G/L Account"."Net Change";
                    '7':
                        TotalReal7 += "G/L Account"."Net Change";
                END;
                // (CJ09) S2G (JDT) 24-10-19:

                rGLBudgetEntry.RESET();
                rGLBudgetEntry.SETCURRENTKEY("Budget Name", "G/L Account No.", Date);
                rGLBudgetEntry.SETRANGE("Budget Name", vBudgetName);
                rGLBudgetEntry.SETRANGE("G/L Account No.", "G/L Account"."No.");
                //rGLBudgetEntry.SETFILTER(Date, '%1..%2', vStartDate, vEndDate);
                EVALUATE(vStartYear, '01/01/' + FORMAT(DATE2DMY(TODAY, 3)));
                EVALUATE(vEndYear, '31/12/' + FORMAT(DATE2DMY(TODAY, 3)));
                rGLBudgetEntry.SETFILTER(Date, '%1..%2', vStartYear, vEndYear);

                IF rGLBudgetEntry.FINDSET() THEN
                    REPEAT
                        vPpto += rGLBudgetEntry.Amount;
                        // (CJ09) S2G (JDT) 24-10-19: Modificaciones líneas de totales por grupo.
                        CASE COPYSTR(rGLBudgetEntry."G/L Account No.", 1, 1) OF
                            '2':
                                TotalPpto2 += rGLBudgetEntry.Amount;
                            '6':
                                TotalPpto6 += rGLBudgetEntry.Amount;
                            '7':
                                TotalPpto7 += rGLBudgetEntry.Amount;
                        END;
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
                // (CJ09) S2G (JDT) 28-10-19:
            end;

            trigger OnPreDataItem()
            begin
                vTotalReal := 0;

                EVALUATE(vStartDate, '01/' + FORMAT(MesIni + 1) + '/' + FORMAT(Ano + 2018));
                EVALUATE(vEndDate, '01/' + FORMAT(MesFin + 1) + '/' + FORMAT(Ano + 2018));
                vEndDate := CALCDATE('+1M-1D', vEndDate);

                SETFILTER("Date Filter", '%1..%2', vStartDate, vEndDate);

                rGLBudgetName.RESET();
                rGLBudgetName.SETCURRENTKEY(Active);
                rGLBudgetName.SETRANGE(Active, TRUE);
                IF rGLBudgetName.FINDFIRST() THEN  //solo hay uno activo, se controla
                    vBudgetName := rGLBudgetName.Name;
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
        // (CJ09) S2G (JDT) 24-10-19:
    end;

    var
        rGLBudgetName: Record "G/L Budget Name";
        rGLBudgetEntry: Record "G/L Budget Entry";
        Ano: Option "2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033";
        MesIni: Option Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre;
        MesFin: Option Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre;
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

    procedure fSetParameters(pAno: Text; pMesIni: Text; pMesFin: Text)
    begin
        EVALUATE(Ano, pAno);
        EVALUATE(MesIni, pMesIni);
        EVALUATE(MesFin, pMesFin);
        MesIni := MesIni - 1;
        MesFin := MesFin - 1;
    end;
}
