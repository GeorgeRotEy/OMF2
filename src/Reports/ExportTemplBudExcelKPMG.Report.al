report 50014 "Export Templ Bud Excel KPMG"
{
    // (1.8) S2G (RBM-R) 24-03-20: Modificaciones presupuestos (Plantilla exportación ppto)

    Caption = 'Export Template Budget Excel', Comment = 'ESP="Exportar plantilla presupuesto Excel"';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1100220000; 15)
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);

            trigger OnAfterGetRecord()
            begin
                //Vamos cuenta a cuenta

                //Si es una cuenta de mayor lo informamos en una variable para luego cambiar el estilo de la misma
                vFormatType := vFormatType::Normal;
                IF "Account Type" = "Account Type"::Heading THEN
                    vFormatType := vFormatType::Group;

                CLEAR(rDimCodeBuffer);
                //KPMG-GRL 08/12/2020. Filtro fecha. Begin
                //Calculamos para esta cuenta el presupuesto y el realizado
                //Para calcular el presupuesto encuentra el ultimo presupuesto del year y filtra movs de presupuesto por el ano fiscal y por el presupuesto. Los recorre para calcular el sumatorio
                //Para calcular el realizado usa como fecha inicio el primer dia del mes actual del year anterior y usa como fecha final un ano menos un dia despues respecto de la fecha inicio.
                //Introducimos la posibilidad de elegir el filtro.
                //rDimCodeBuffer.fCalculateNewFields("No.", LastYearBudget, LastYearReal);

                //Si no se han informado los filtros fecha, las variables valdr'an 0D y no se tendran en cuenta y se utilizara el comportamiento anterior
                rDimCodeBuffer.fCalculateNewFields2("No.", LastYearBudget, LastYearReal, FromDate, ToDate, vAPI);
                //KPMG-GRL 08/12/2020. Filtro fecha. End

                //Saltamos la cuenta si las cantidades son nulas
                IF ((COPYSTR("No.", 1, 1) = '6') OR (COPYSTR("No.", 1, 1) = '7')) AND (LastYearBudget = 0) AND (LastYearReal = 0) THEN
                    CurrReport.SKIP;

                //Informamos los campos y calculamos el Cumpl.% como LastYearReal/LastYearBudget
                EnterCell(RowNo, 1, "No.", '', ExcelBuf."Cell Type"::Number, vFormatType);
                EnterCell(RowNo, 2, Name, '', ExcelBuf."Cell Type"::Text, vFormatType);
                EnterCell(RowNo, 4, '=IFERROR(E' + FORMAT(RowNo) + '/C' + FORMAT(RowNo) + ',0)', '#,##0.00%', ExcelBuf."Cell Type"::Number, vFormatType);
                //EnterCell(RowNo,6,'=IFERROR(G'+FORMAT(RowNo)+'/E'+FORMAT(RowNo)+'-1,IF(G'+FORMAT(RowNo)+'<>0,1,0))','#,##0.00%',ExcelBuf."Cell Type"::Number,vFormatType);
                EnterCell(RowNo, 6, '=IFERROR(E' + FORMAT(RowNo) + '/G' + FORMAT(RowNo) + '-1,IF(G' + FORMAT(RowNo) + '<>0,1,0))', '#,##0.00%', ExcelBuf."Cell Type"::Number, vFormatType);

                IF vFormatType = vFormatType::Group THEN BEGIN
                    FinalRowNo[i] := RowNo;
                    i += 1;
                    FOR k := 1 TO 8 DO BEGIN
                        IF ExcelBuf2.GET(ExcelBuf."Row No." - 1, k) THEN BEGIN
                            ExcelBuf2."Double Underline" := TRUE;
                            ExcelBuf2.MODIFY();
                        END;
                    END;
                END ELSE BEGIN
                    EnterCell(RowNo, 3, FORMAT(LastYearBudget), '#,##0.00', ExcelBuf."Cell Type"::Number, vFormatType);
                    EnterCell(RowNo, 5, FORMAT(LastYearReal), '#,##0.00', ExcelBuf."Cell Type"::Number, vFormatType);
                    /*
                    IF COPYSTR("No.",1,1)='6' THEN
                      EnterCell(RowNo,7,'=E'+FORMAT(RowNo)+'*1.01','#,##0.00',ExcelBuf."Cell Type"::Number,vFormatType)
                    ELSE
                    */
                    EnterCell(RowNo, 7, GetBudgetAmount("No."), '#,##0.00', ExcelBuf."Cell Type"::Number, vFormatType);
                END;

                EnterCell(RowNo, 8, GetComment("No."), '#,##0.00', ExcelBuf."Cell Type"::Number, vFormatType);

                RowNo += 1;
            end;

            trigger OnPostDataItem()
            begin
                //Sumatorios de cuentas de mayor y Tabla resumen
                RowNo += 4;
                EnterCell(RowNo, 1, TextGLAccNo, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 2, TextName, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 3, TextLYBudget, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 4, TextCompl, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 5, TextLYReal, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 6, TextDesv, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 7, FORMAT(RefDate), '', ExcelBuf."Cell Type"::Date, 2);
                RowNo += 1;
                RowTable := RowNo;

                FOR j := 1 TO i - 2 DO BEGIN
                    EnterCell(FinalRowNo[j], 3, '=SUM(C' + FORMAT(FinalRowNo[j] + 1) + ':C' + FORMAT(FinalRowNo[j + 1] - 1) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 1);
                    EnterCell(FinalRowNo[j], 5, '=SUM(E' + FORMAT(FinalRowNo[j] + 1) + ':E' + FORMAT(FinalRowNo[j + 1] - 1) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 1);
                    EnterCell(FinalRowNo[j], 7, '=SUM(G' + FORMAT(FinalRowNo[j] + 1) + ':G' + FORMAT(FinalRowNo[j + 1] - 1) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 1);
                    EnterCell(RowNo, 1, '=A' + FORMAT(FinalRowNo[j]), '#,##0.00', ExcelBuf."Cell Type"::Number, 0);
                    EnterCell(RowNo, 2, '=B' + FORMAT(FinalRowNo[j]), '#,##0.00', ExcelBuf."Cell Type"::Number, 0);
                    EnterCell(RowNo, 3, '=C' + FORMAT(FinalRowNo[j]), '#,##0.00', ExcelBuf."Cell Type"::Number, 0);
                    EnterCell(RowNo, 4, '=D' + FORMAT(FinalRowNo[j]), '#,##0.00%', ExcelBuf."Cell Type"::Number, 0);
                    EnterCell(RowNo, 5, '=E' + FORMAT(FinalRowNo[j]), '#,##0.00', ExcelBuf."Cell Type"::Number, 0);
                    EnterCell(RowNo, 6, '=F' + FORMAT(FinalRowNo[j]), '#,##0.00%', ExcelBuf."Cell Type"::Number, 0);
                    EnterCell(RowNo, 7, '=G' + FORMAT(FinalRowNo[j]), '#,##0.00', ExcelBuf."Cell Type"::Number, 0);
                    RowNo += 1;
                END;

                EnterCell(FinalRowNo[i - 1], 3, '=SUM(C' + FORMAT(FinalRowNo[i - 1] + 1) + ':C' + FORMAT(RowTable - 6) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 1);
                EnterCell(FinalRowNo[i - 1], 5, '=SUM(E' + FORMAT(FinalRowNo[i - 1] + 1) + ':E' + FORMAT(RowTable - 6) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 1);
                EnterCell(FinalRowNo[i - 1], 7, '=SUM(G' + FORMAT(FinalRowNo[i - 1] + 1) + ':G' + FORMAT(RowTable - 6) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 1);

                EnterCell(RowNo, 1, '=A' + FORMAT(FinalRowNo[i - 1]), '#,##0.00', ExcelBuf."Cell Type"::Number, 3);
                EnterCell(RowNo, 2, '=B' + FORMAT(FinalRowNo[i - 1]), '#,##0.00', ExcelBuf."Cell Type"::Number, 3);
                EnterCell(RowNo, 3, '=C' + FORMAT(FinalRowNo[i - 1]), '#,##0.00', ExcelBuf."Cell Type"::Number, 3);
                EnterCell(RowNo, 4, '=D' + FORMAT(FinalRowNo[i - 1]), '#,##0.00%', ExcelBuf."Cell Type"::Number, 3);
                EnterCell(RowNo, 5, '=E' + FORMAT(FinalRowNo[i - 1]), '#,##0.00', ExcelBuf."Cell Type"::Number, 3);
                EnterCell(RowNo, 6, '=F' + FORMAT(FinalRowNo[i - 1]), '#,##0.00%', ExcelBuf."Cell Type"::Number, 3);
                EnterCell(RowNo, 7, '=G' + FORMAT(FinalRowNo[i - 1]), '#,##0.00', ExcelBuf."Cell Type"::Number, 3);
                RowNo += 1;
                EnterCell(RowNo, 1, '', '#,##0.00', ExcelBuf."Cell Type"::Text, 4);
                EnterCell(RowNo, 2, TextResultado, '', ExcelBuf."Cell Type"::Text, 4);
                EnterCell(RowNo, 3, '=SUM(C' + FORMAT(RowTable) + ':C' + FORMAT(RowNo - 1) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 4);
                EnterCell(RowNo, 4, '=IFERROR(E' + FORMAT(RowNo) + '/C' + FORMAT(RowNo) + ',0)', '#,##0.00%', ExcelBuf."Cell Type"::Number, 4);
                EnterCell(RowNo, 5, '=SUM(E' + FORMAT(RowTable) + ':E' + FORMAT(RowNo - 1) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 4);
                EnterCell(RowNo, 6, '=IFERROR(G' + FORMAT(RowNo) + '/E' + FORMAT(RowNo) + '-1,IF(G' + FORMAT(RowNo) + '<>0,1,0))', '#,##0.00%', ExcelBuf."Cell Type"::Number, 4);
                EnterCell(RowNo, 7, '=SUM(G' + FORMAT(RowTable) + ':G' + FORMAT(RowNo - 1) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 4);

                ExcelBuf.CreateNewBook(COPYSTR(COMPANYNAME, 1, 31));
                ExcelBuf.WriteSheet(PADSTR(STRSUBSTNO('%1', BudgetName), 30), COMPANYNAME, USERID);
                ExcelBuf.CloseBook;
                ExcelBuf.SetFriendlyFilename(STRSUBSTNO('%1 %2', TextTemplate, BudgetName));
                ExcelBuf.OpenExcel;
            end;

            trigger OnPreDataItem()
            begin
                //Aplicamos le filtro de las cuentas
                SETFILTER("No.", GLAccountFilter);

                CLEAR(ExcelBuf);
                ExcelBuf.DELETEALL();
                //Informamos la fecha de referencia como el principio del year actual
                EVALUATE(RefDate, '01/01/' + FORMAT(RefYear));

                //Le indicamos a la tabla temporal de excel que la estamos llamando desde este plantilla/report
                // ExcelBuf.fFromTemplate;

                //Anadimos los campos de la cabecera del excel
                RowNo := 1;
                EnterCell(RowNo, 1, Text001Lbl, '', ExcelBuf."Cell Type"::Text, 0);
                EnterCell(RowNo, 2, '', '', ExcelBuf."Cell Type"::Text, 0);
                RowNo += 1;
                EnterCell(RowNo, 1, Text002, '', ExcelBuf."Cell Type"::Text, 0);
                EnterCell(RowNo, 2, BudgetName, '', ExcelBuf."Cell Type"::Text, 0);
                RowNo += 2;
                EnterCell(RowNo, 1, TextGLAccNo, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 2, TextName, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 3, TextLYBudget, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 4, TextCompl, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 5, TextLYReal, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 6, TextDesv, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 7, FORMAT(RefDate), '', ExcelBuf."Cell Type"::Date, 2);
                EnterCell(RowNo, 8, TextObs, '', ExcelBuf."Cell Type"::Text, 2);
                RowNo += 1;

                CLEAR(FinalRowNo);
                i := 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field("Reference year"; RefYear)
                {
                    Caption = 'Año de referencia', Comment = 'ESP="Año de referencia"';
                    ApplicationArea = All;
                }
                field("Budget Name"; BudgetName)
                {
                    Caption = 'Nombre ppto.', Comment = 'ESP="Nombre ppto."';
                    TableRelation = "G/L Budget Name".Name;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("G/L Accounts filter"; GLAccountFilter)
                {
                    Caption = 'Filtro cuentas', Comment = 'ESP="Filtro cuentas"';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(FromDate; FromDate)
                {
                    Caption = 'From Date', Comment = 'ESP="Fecha desde"';
                    ApplicationArea = All;
                }
                field(ToDate; ToDate)
                {
                    Caption = 'To Date', Comment = 'ESP="Fecha hasta"';
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
        //Creamos el filtro texto para las cuentas. Grupo 2 (20 y 21) 6 y 7
        GLAccountFilter := TextGLAccFilter;
        //Guradamos el year actual como el de referencia
        RefYear := DATE2DMY(WORKDATE, 3);
    end;

    trigger OnPreReport()
    begin
        ExcelBuf.LOCKTABLE;
    end;

    var
        rDimCodeBuffer: Record "Dimension Code Buffer";
        ExcelBuf: Record "Excel Buffer";
        ExcelBuf2: Record "Excel Buffer";
        RefDate: Date;
        vFormatType: Option Normal,Group,Title,Underline,"Table";
        BudgetName: Code[10];
        GLAccountFilter: Text;
        TextGLAccFilter: Label '2|20?????|21?????|6|6??????|7|7??????', Comment = 'ESP="2|20?????|21?????|6|6??????|7|7??????"';
        ServerFileName: Text;
        Text001Lbl: Label 'Exportar filtros', Comment = 'ESP="Exportar filtros"';
        Text002: Label 'Nombre ppto.', Comment = 'ESP="Nombre ppto."';
        TextGLAccNo: Label 'Nº cuenta', Comment = 'ESP="Nº cuenta"';
        TextName: Label 'Nombre', Comment = 'ESP="Nombre"';
        TextLYBudget: Label 'Ppto. últ. año', Comment = 'ESP="Ppto. últ. año"';
        TextCompl: Label 'Cumpl. %', Comment = 'ESP="Cumpl. %"';
        TextLYReal: Label 'Real últ. año', Comment = 'ESP="Real últ. año"';
        TextDesv: Label 'Desv. %', Comment = 'ESP="Desv. %"';
        TextObs: Label 'Observaciones', Comment = 'ESP="Observaciones"';
        TextTemplate: Label 'Template', Comment = 'ESP="Plantilla"';
        LastYearBudget: Decimal;
        LastYearReal: Decimal;
        RefYear: Integer;
        RowNo: Integer;
        Text1A: Label '+1Y', Comment = 'ESP="+1A"';
        FinalRowNo: array[10] of Integer;
        i: Integer;
        j: Integer;
        k: Integer;
        TextResultado: Label 'RESULTADO', Comment = 'ESP="RESULTADO"';
        RowTable: Integer;
        "//GRL-KPMG": Integer;
        FromDate: Date;
        ToDate: Date;
        vAPI: Boolean;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; NumberFormat: Text[30]; CellType: Option; FormatType: Option Normal,Group,Title,Underline,"Table")
    begin
        ExcelBuf.INIT();
        ExcelBuf.VALIDATE("Row No.", RowNo);
        ExcelBuf.VALIDATE("Column No.", ColumnNo);
        IF STRPOS(CellValue, '=') = 1 THEN
            ExcelBuf.SetFormula(CellValue)
        ELSE
            ExcelBuf."Cell Value as Text" := CellValue;
        //ExcelBuf.Formula := '';
        ExcelBuf.NumberFormat := NumberFormat;
        ExcelBuf."Cell Type" := CellType;
        CASE FormatType OF
            FormatType::Title:
                BEGIN
                    ExcelBuf.Bold := TRUE;
                    ExcelBuf."Double Underline" := TRUE;
                END;
            FormatType::Group:
                BEGIN
                    ExcelBuf.Bold := TRUE;
                    ExcelBuf."Double Underline" := TRUE;
                    ExcelBuf."Font Color" := 3;
                END;
            FormatType::Underline:
                BEGIN
                    ExcelBuf.Underline := TRUE;
                END;
            FormatType::Table:
                BEGIN
                    ExcelBuf.Underline := TRUE;
                    ExcelBuf.Bold := TRUE;
                END;
        END;
        ExcelBuf.INSERT();
    end;

    local procedure GetBudgetAmount(pGLAcc: Code[20]): Text
    var
        rlGLBudgetEntry: Record "G/L Budget Entry";
        dlEndDate: Date;
        rlGLBudgetName: Record "G/L Budget Name";
    begin
        dlEndDate := CALCDATE(Text1A, RefDate);

        rlGLBudgetEntry.SETCURRENTKEY("Budget Name", "G/L Account No.", Date);

        IF BudgetName <> '' THEN
            rlGLBudgetEntry.SETRANGE("Budget Name", BudgetName)
        ELSE BEGIN
            rlGLBudgetName.RESET();
            rlGLBudgetName.SETRANGE("Last Year Budget", TRUE);
            IF rlGLBudgetName.FINDFIRST() THEN
                rlGLBudgetEntry.SETRANGE("Budget Name", rlGLBudgetName.Name);
        END;
        rlGLBudgetEntry.SETRANGE("G/L Account No.", pGLAcc);
        rlGLBudgetEntry.SETFILTER(Date, '%1..%2', RefDate, dlEndDate);
        rlGLBudgetEntry.CALCSUMS(Amount);

        EXIT(FORMAT(rlGLBudgetEntry.Amount));
    end;

    procedure SetBudgetName(pBudgetName: Code[10])
    begin
        BudgetName := pBudgetName;
    end;

    local procedure GetComment(pGLAccNo: Code[20]) BudgCom: Text
    var
        rlGLBudgetEntry: Record "G/L Budget Entry";
    begin
        BudgCom := '';
        rlGLBudgetEntry.RESET();
        rlGLBudgetEntry.SETCURRENTKEY("Budget Name", "G/L Account No.", Date);
        rlGLBudgetEntry.SETRANGE("Budget Name", BudgetName);
        rlGLBudgetEntry.SETRANGE("G/L Account No.", pGLAccNo);
        rlGLBudgetEntry.SETFILTER("Budget Comment", '<>%1', '');
        IF rlGLBudgetEntry.FINDSET() THEN
            REPEAT
                BudgCom += rlGLBudgetEntry."Budget Comment" + ' ';
            UNTIL rlGLBudgetEntry.NEXT() = 0;
    end;

    procedure SetGLEntryDateFilter(pFromDate: Text; pToDate: Text)
    begin
        EVALUATE(FromDate, pFromDate);
        EVALUATE(ToDate, pToDate);
    end;

    procedure fSetAPI(pAPI: Boolean)
    begin
        vAPI := pAPI;
    end;
}
