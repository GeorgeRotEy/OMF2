report 50006 "Export Templ Bud Excel"
{
    // (1.8) S2G (RBM-R) 24-03-20: Modificaciones presupuestos (Plantilla exportación ppto)
    //
    // (OFM-2) (ATP/GRL)14-12-20: Modificaciones presupuesto (excluir cuentas amortizacion, filtros fecha por meses)

    Caption = 'Export Template Budget Excel', Comment = 'ESP="Exportar plantilla presupuesto Excel"';
    ApplicationArea = All;
    DefaultRenderingLayout = BudgetTemplateExcel;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.")
                ORDER(Ascending);

            trigger OnAfterGetRecord()
            begin
                //Colocar cuenta 5505007 en el grupo 7
                rDimCodeBuffer.fCalculateNewFields2("No.", LastYearBudget, LastYearReal, FromDate, ToDate, vAPI);
                IF "No." = '5505007' THEN BEGIN
                    var1 := "No.";
                    var2 := Name;
                    var3 := LastYearBudget;
                    var5 := LastYearReal;
                END;

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
                //15/12/2020 ATD
                IF ((((COPYSTR("No.", 1, 1) = '6')) OR (COPYSTR("No.", 1, 1) = '7')) AND (LastYearBudget = 0) AND (LastYearReal = 0)) OR (COPYSTR("No.", 1, 2) = '68') THEN
                    CurrReport.SKIP;

                //No generar cuenta 5505007 en el grupo 2
                IF "No." = '5505007' THEN
                    CurrReport.SKIP;

                //Informamos los campos y calculamos el Cumpl.% como LastYearReal/LastYearBudget
                // (OFM-02) (ATD/GRL) Modificaciones informe. Begin
                //EnterCell(RowNo,1,"No.",'',ExcelBuf."Cell Type"::Number,vFormatType);
                //EnterCell(RowNo,2,Name,'',ExcelBuf."Cell Type"::Text,vFormatType);
                IF vFormatType <> vFormatType::Group THEN
                    vFormatType := vFormatType::PostingGL;
                EnterCell(RowNo, 1, "No.", '', ExcelBuf."Cell Type"::Text, vFormatType); //Probando para pasar de 2,00 a 2
                IF vFormatType <> vFormatType::Group THEN
                    vFormatType := vFormatType::PostingName;
                EnterCell(RowNo, 2, Name, '', ExcelBuf."Cell Type"::Text, vFormatType);
                IF vFormatType <> vFormatType::Group THEN
                    vFormatType := vFormatType::Normal;
                // (OFM-02) (ATD/GRL) Modificaciones informe. End
                //KPMG-GRL 08/12/2020. Cambiar columna comentario para importar correctamente. Begin
                EnterCell(RowNo, 4, '=IFERROR(E' + FORMAT(RowNo) + '/C' + FORMAT(RowNo) + ',0)', '#,##0.00%', ExcelBuf."Cell Type"::Number, vFormatType);
                EnterCell(RowNo, 6, '=IFERROR(G' + FORMAT(RowNo) + '/E' + FORMAT(RowNo) + '-1,IF(G' + FORMAT(RowNo) + '<>0,1,0))', '#,##0.00%', ExcelBuf."Cell Type"::Number, vFormatType);
                //EnterCell(RowNo,5,'=IFERROR(E'+FORMAT(RowNo)+'/C'+FORMAT(RowNo)+',0)','#,##0.00%',ExcelBuf."Cell Type"::Number,vFormatType);
                //EnterCell(RowNo,7,'=IFERROR(G'+FORMAT(RowNo)+'/E'+FORMAT(RowNo)+'-1,IF(G'+FORMAT(RowNo)+'<>0,1,0))','#,##0.00%',ExcelBuf."Cell Type"::Number,vFormatType);
                //KPMG-GRL 08/12/2020. Cambiar columna comentario para importar correctamente. End

                IF vFormatType = vFormatType::Group THEN BEGIN
                    FinalRowNo[i] := RowNo;
                    i += 1;
                    FOR k := 1 TO 8 DO BEGIN
                        IF ExcelBuf2.GET(ExcelBuf."Row No." - 1, k) THEN BEGIN
                            // ExcelBuf2.fFromTemplate;
                            ExcelBuf2."Double Underline" := TRUE;
                            //ExcelBuf2."BackGround Color" := 5;
                            ExcelBuf2.Bold := TRUE;
                            ExcelBuf2.MODIFY();
                        END;
                    END;
                END ELSE BEGIN
                    //KPMG-GRL 08/12/2020. Cambiar columna comentario para importar correctamente. Begin
                    EnterCell(RowNo, 3, FORMAT(LastYearBudget), '#,##0.00', ExcelBuf."Cell Type"::Number, vFormatType);
                    EnterCell(RowNo, 5, FORMAT(LastYearReal), '#,##0.00', ExcelBuf."Cell Type"::Number, vFormatType);
                    //EnterCell(RowNo,4,FORMAT(LastYearBudget),'#,##0.00',ExcelBuf."Cell Type"::Number,vFormatType);
                    //EnterCell(RowNo,6,FORMAT(LastYearReal),'#,##0.00',ExcelBuf."Cell Type"::Number,vFormatType);
                    //KPMG-GRL 08/12/2020. Cambiar columna comentario para importar correctamente. End
                    /*
                    IF COPYSTR("No.",1,1)='6' THEN
                      EnterCell(RowNo,7,'=E'+FORMAT(RowNo)+'*1.01','#,##0.00',ExcelBuf."Cell Type"::Number,vFormatType)
                    ELSE
                    */
                    //KPMG-GRL 08/12/2020. Filtro fecha. Begin
                    //EnterCell(RowNo,7,GetBudgetAmount("No."),'#,##0.00',ExcelBuf."Cell Type"::Number,vFormatType);
                    //KPMG-GRL 08/12/2020. Cambiar columna comentario para importar correctamente. Begin
                    EnterCell(RowNo, 7, '', '#,##0.00', ExcelBuf."Cell Type"::Number, vFormatType);
                    //EnterCell(RowNo,8,'','#,##0.00',ExcelBuf."Cell Type"::Number,vFormatType);
                    //KPMG-GRL 08/12/2020. Cambiar columna comentario para importar correctamente. End
                    //KPMG-GRL 08/12/2020. Filtro fecha. End
                END;

                //KPMG-GRL 08/12/2020. Cambiar columna comentario para importar correctamente. Begin
                //Comentado para que no salgan los
                //EnterCell(RowNo,8,GetComment("No."),'#,##0.00',ExcelBuf."Cell Type"::Number,vFormatType);
                EnterCell(RowNo, 8, '', '#,##0.00', ExcelBuf."Cell Type"::Number, vFormatType);
                //EnterCell(RowNo,3,GetComment("No."),'#,##0.00',ExcelBuf."Cell Type"::Number,vFormatType);
                //KPMG-GRL 08/12/2020. Cambiar columna comentario para importar correctamente. End

                RowNo += 1;
            end;

            trigger OnPostDataItem()
            var
                Budget: Label 'Plantilla presupuesto ', Comment = 'ESP="Plantilla presupuesto "';
            begin
                //Probando2
                IF ((var3 <> 0) OR (var5 <> 0)) THEN BEGIN
                    EnterCell(RowNo, 1, var1, '', ExcelBuf."Cell Type"::Text, vFormatType::PostingGL);
                    EnterCell(RowNo, 2, var2, '', ExcelBuf."Cell Type"::Text, vFormatType::PostingName);
                    EnterCell(RowNo, 3, FORMAT(var3), '#,##0.00', ExcelBuf."Cell Type"::Number, vFormatType);
                    EnterCell(RowNo, 4, '=IFERROR(E' + FORMAT(RowNo) + '/C' + FORMAT(RowNo) + ',0)', '#,##0.00%', ExcelBuf."Cell Type"::Number, vFormatType);
                    EnterCell(RowNo, 5, FORMAT(var5), '#,##0.00', ExcelBuf."Cell Type"::Number, vFormatType);
                    EnterCell(RowNo, 6, '=IFERROR(G' + FORMAT(RowNo) + '/E' + FORMAT(RowNo) + '-1,IF(G' + FORMAT(RowNo) + '<>0,1,0))', '#,##0.00%', ExcelBuf."Cell Type"::Number, vFormatType);
                    RowNo += 5;
                    //Sumatorios de cuentas de mayor y Tabla resumen
                END ELSE BEGIN
                    RowNo += 4;
                END;
                // (OFM-02) (ATD/GRL) Modificaciones informe. Begin
                /*
                EnterCell(RowNo,1,TextGLAccNo,'',ExcelBuf."Cell Type"::Text,2);
                EnterCell(RowNo,2,TextName,'',ExcelBuf."Cell Type"::Text,2);
                EnterCell(RowNo,3,TextLYBudget,'',ExcelBuf."Cell Type"::Text,2);
                EnterCell(RowNo,4,TextCompl,'',ExcelBuf."Cell Type"::Text,2);
                EnterCell(RowNo,5,TextLYReal,'',ExcelBuf."Cell Type"::Text,2);
                EnterCell(RowNo,6,TextDesv,'',ExcelBuf."Cell Type"::Text,2);
                EnterCell(RowNo,7,FORMAT(RefDate),'',ExcelBuf."Cell Type"::Date,2);
                */
                EnterCell(RowNo, 1, TextGLAccNo, '', ExcelBuf."Cell Type"::Text, 5);
                EnterCell(RowNo, 2, TextName, '', ExcelBuf."Cell Type"::Text, 5);
                EnterCell(RowNo, 3, TextLYBudget, '', ExcelBuf."Cell Type"::Text, 5);
                EnterCell(RowNo, 4, TextCompl, '', ExcelBuf."Cell Type"::Text, 5);
                EnterCell(RowNo, 5, TextLYReal, '', ExcelBuf."Cell Type"::Text, 5);
                EnterCell(RowNo, 6, TextDesv, '', ExcelBuf."Cell Type"::Text, 5);
                EnterCell(RowNo, 7, FORMAT(RefDate), '', ExcelBuf."Cell Type"::Date, 5);
                // (OFM-02) (ATD/GRL) Modificaciones informe. End
                RowNo += 1;
                RowTable := RowNo;

                FOR j := 1 TO i - 2 DO BEGIN
                    EnterCell(FinalRowNo[j], 3, '=SUM(C' + FORMAT(FinalRowNo[j] + 1) + ':C' + FORMAT(FinalRowNo[j + 1] - 1) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 1);
                    EnterCell(FinalRowNo[j], 5, '=SUM(E' + FORMAT(FinalRowNo[j] + 1) + ':E' + FORMAT(FinalRowNo[j + 1] - 1) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 1);
                    EnterCell(FinalRowNo[j], 7, '=SUM(G' + FORMAT(FinalRowNo[j] + 1) + ':G' + FORMAT(FinalRowNo[j + 1] - 1) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 1);
                    // (OFM-02) (ATD/GRL) Modificaciones informe. Begin
                    //EnterCell(RowNo,1,'=A'+FORMAT(FinalRowNo[j]),'#,##0.00',ExcelBuf."Cell Type"::Number,0);
                    //EnterCell(RowNo,2,'=B'+FORMAT(FinalRowNo[j]),'#,##0.00',ExcelBuf."Cell Type"::Number,0);
                    EnterCell(RowNo, 1, '=A' + FORMAT(FinalRowNo[j]), '#,##0.00', ExcelBuf."Cell Type"::Number, 6);
                    EnterCell(RowNo, 2, '=B' + FORMAT(FinalRowNo[j]), '#,##0.00', ExcelBuf."Cell Type"::Number, 7);
                    // (OFM-02) (ATD/GRL) Modificaciones informe. End
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

                // (OFM-02) (ATD/GRL) Modificaciones informe. Begin
                //EnterCell(RowNo,1,'=A'+FORMAT(FinalRowNo[i-1]),'#,##0.00',ExcelBuf."Cell Type"::Number,3);
                //EnterCell(RowNo,2,'=B'+FORMAT(FinalRowNo[i-1]),'#,##0.00',ExcelBuf."Cell Type"::Number,3);
                EnterCell(RowNo, 1, '=A' + FORMAT(FinalRowNo[i - 1]), '#,##0.00', ExcelBuf."Cell Type"::Number, vFormatType::PostingGL);
                EnterCell(RowNo, 2, '=B' + FORMAT(FinalRowNo[i - 1]), '#,##0.00', ExcelBuf."Cell Type"::Number, vFormatType::PostingName);
                // (OFM-02) (ATD/GRL) Modificaciones informe. End
                EnterCell(RowNo, 3, '=C' + FORMAT(FinalRowNo[i - 1]), '#,##0.00', ExcelBuf."Cell Type"::Number, 3);
                EnterCell(RowNo, 4, '=D' + FORMAT(FinalRowNo[i - 1]), '#,##0.00%', ExcelBuf."Cell Type"::Number, 3);
                EnterCell(RowNo, 5, '=E' + FORMAT(FinalRowNo[i - 1]), '#,##0.00', ExcelBuf."Cell Type"::Number, 3);
                EnterCell(RowNo, 6, '=F' + FORMAT(FinalRowNo[i - 1]), '#,##0.00%', ExcelBuf."Cell Type"::Number, 3);
                EnterCell(RowNo, 7, '=G' + FORMAT(FinalRowNo[i - 1]), '#,##0.00', ExcelBuf."Cell Type"::Number, 3);
                RowNo += 1;
                // (OFM-02) (ATD/GRL) Modificaciones informe. Begin
                /*EnterCell(RowNo,1,'','#,##0.00',ExcelBuf."Cell Type"::Text,4);
                EnterCell(RowNo,2,TextResultado,'',ExcelBuf."Cell Type"::Text,4);
                EnterCell(RowNo,3,'=SUM(C'+FORMAT(RowTable)+':C'+FORMAT(RowNo-1)+')','#,##0.00',ExcelBuf."Cell Type"::Number,4);
                EnterCell(RowNo,4,'=IFERROR(E'+FORMAT(RowNo)+'/C'+FORMAT(RowNo)+',0)','#,##0.00%',ExcelBuf."Cell Type"::Number,4);
                EnterCell(RowNo,5,'=SUM(E'+FORMAT(RowTable)+':E'+FORMAT(RowNo-1)+')','#,##0.00',ExcelBuf."Cell Type"::Number,4);
                EnterCell(RowNo,6,'=IFERROR(G'+FORMAT(RowNo)+'/E'+FORMAT(RowNo)+'-1,IF(G'+FORMAT(RowNo)+'<>0,1,0))','#,##0.00%',ExcelBuf."Cell Type"::Number,4);
                EnterCell(RowNo,7,'=SUM(G'+FORMAT(RowTable)+':G'+FORMAT(RowNo-1)+')','#,##0.00',ExcelBuf."Cell Type"::Number,4);
                */
                EnterCell(RowNo, 1, '', '#,##0.00', ExcelBuf."Cell Type"::Text, 8);
                EnterCell(RowNo, 2, TextResultado, '', ExcelBuf."Cell Type"::Text, 8);
                EnterCell(RowNo, 3, '=SUM(C' + FORMAT(RowTable) + ':C' + FORMAT(RowNo - 1) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 8);
                EnterCell(RowNo, 4, '=IFERROR(E' + FORMAT(RowNo) + '/C' + FORMAT(RowNo) + ',0)', '#,##0.00%', ExcelBuf."Cell Type"::Number, 8);
                EnterCell(RowNo, 5, '=SUM(E' + FORMAT(RowTable) + ':E' + FORMAT(RowNo - 1) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 8);
                EnterCell(RowNo, 6, '=IFERROR(G' + FORMAT(RowNo) + '/E' + FORMAT(RowNo) + '-1,IF(G' + FORMAT(RowNo) + '<>0,1,0))', '#,##0.00%', ExcelBuf."Cell Type"::Number, 8);
                EnterCell(RowNo, 7, '=SUM(G' + FORMAT(RowTable) + ':G' + FORMAT(RowNo - 1) + ')', '#,##0.00', ExcelBuf."Cell Type"::Number, 8);
                // (OFM-02) (ATD/GRL) Modificaciones informe. End

                IF NOT vPowerApps THEN
                    EXIT;

                ExcelBuf.CreateNewBook(COPYSTR(COMPANYNAME, 1, 31));
                ExcelBuf.WriteSheet(PADSTR(STRSUBSTNO('%1', BudgetName), 30), COMPANYNAME, USERID);
                SetTemplateColumnWidths();
                ExcelBuf.CloseBook;

                cTempBlob.CreateOutStream(vOutStr);
                ExcelBuf.SaveToStream(vOutStr, false);
                cTempBlob.CreateInStream(vInStr);

                //IGG - Necesario para pasar valor por Base64 para PowerApps
                OnAfterRunReport(vInStr, STRSUBSTNO('%1-%2', BudgetName, Budget + FORMAT(RefYear)));
            end;

            trigger OnPreDataItem()
            var
                CompanyInformation: Record "Company Information";
            begin
                //Probando
                //IF "No." ='5505007' THEN
                //var1 := '5505007';

                //Aplicamos le filtro de las cuentas
                SETFILTER("No.", GLAccountFilter);

                CLEAR(ExcelBuf);
                ExcelBuf.DELETEALL();
                //Informamos la fecha de referencia como el principio del year actual
                EVALUATE(RefDate, '01/01/' + FORMAT(RefYear));

                //Filtro Realizado fecha final
                //(OFM-2) (ATP/GRL)14-12-20. Begin
                IF MonthInteger = 0 THEN
                    CASE Months OF
                        0:
                            MonthInteger := 10;
                        1:
                            MonthInteger := 1;
                        2:
                            MonthInteger := 2;
                        3:
                            MonthInteger := 3;
                        4:
                            MonthInteger := 4;
                        5:
                            MonthInteger := 5;
                        6:
                            MonthInteger := 6;
                        7:
                            MonthInteger := 7;
                        8:
                            MonthInteger := 8;
                        9:
                            MonthInteger := 9;
                        10:
                            MonthInteger := 10;
                        11:
                            MonthInteger := 11;
                        12:
                            MonthInteger := 12;
                    END;

                ToDate := CALCDATE('<CM>', DMY2DATE(1, MonthInteger, RefYear - 1));
                FromDate := CALCDATE('<-1Y+1D>', ToDate);

                GetBudgetTemplateName;
                //(OFM-2) (ATP/GRL)14-12-20. End

                //Le indicamos a la tabla temporal de excel que la estamos llamando desde este plantilla/report
                // ExcelBuf2.fFromTemplate;

                //Anadimos los campos de la cabecera del excel
                RowNo := 1;
                /*
                //EnterCell(RowNo,1,Text001Lbl,'',ExcelBuf."Cell Type"::Text,0);
                EnterCell(RowNo,1,Text001Lbl,'',ExcelBuf."Cell Type"::Text,5);
                EnterCell(RowNo,2,'','',ExcelBuf."Cell Type"::Text,0);
                // (OFM-02) (ATD/GRL) Modificaciones informe. Begin
                */
                CompanyInformation.GET();
                //RowNo += 1;
                EnterCell(RowNo, 1, pName, '', ExcelBuf."Cell Type"::Text, 5);
                EnterCell(RowNo, 2, CompanyInformation.Name, '', ExcelBuf."Cell Type"::Text, 0);
                RowNo += 1;
                EnterCell(RowNo, 1, County, '', ExcelBuf."Cell Type"::Text, 5);
                EnterCell(RowNo, 2, CompanyInformation.City, '', ExcelBuf."Cell Type"::Text, 0);
                // (OFM-02) (ATD/GRL) Modificaciones informe. End
                RowNo += 1;
                //EnterCell(RowNo,1,Text002,'',ExcelBuf."Cell Type"::Text,0);
                EnterCell(RowNo, 1, Text002, '', ExcelBuf."Cell Type"::Text, 5);
                EnterCell(RowNo, 2, BudgetName, '', ExcelBuf."Cell Type"::Text, 0);
                RowNo += 2;

                EnterCell(RowNo, 1, TextGLAccNo, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 2, TextName, '', ExcelBuf."Cell Type"::Text, 2);
                // (OFM-02) (ATD/GRL) Modificaciones informe. Begin
                //EnterCell(RowNo,3,TextLYBudget,'',ExcelBuf."Cell Type"::Text,2);
                //KPMG-GRL 08/12/2020. Cambiar columna comentario para importar correctamente. Begin
                EnterCell(RowNo, 3, TextLYBudget2, '', ExcelBuf."Cell Type"::Text, 2);
                // (OFM-02) (ATD/GRL) Modificaciones informe. End
                EnterCell(RowNo, 4, TextCompl, '', ExcelBuf."Cell Type"::Text, 2);

                // (OFM-02) (ATD/GRL) Modificaciones informe. Begin
                //EnterCell(RowNo,5,TextLYReal,'',ExcelBuf."Cell Type"::Text,2);
                EnterCell(RowNo, 5, TextLYReal2, '', ExcelBuf."Cell Type"::Text, 2);
                // (OFM-02) (ATD/GRL) Modificaciones informe. End
                EnterCell(RowNo, 6, TextDesv, '', ExcelBuf."Cell Type"::Text, 2);
                EnterCell(RowNo, 7, FORMAT(RefDate), '', ExcelBuf."Cell Type"::Date, 2);
                EnterCell(RowNo, 8, TextObs, '', ExcelBuf."Cell Type"::Text, 2);

                /*
                EnterCell(RowNo,4,TextLYBudget2,'',ExcelBuf."Cell Type"::Text,2);
                // (OFM-02) (ATD/GRL) Modificaciones informe. End
                EnterCell(RowNo,5,TextCompl,'',ExcelBuf."Cell Type"::Text,2);

                // (OFM-02) (ATD/GRL) Modificaciones informe. Begin
                //EnterCell(RowNo,5,TextLYReal,'',ExcelBuf."Cell Type"::Text,2);
                EnterCell(RowNo,6,TextLYReal2,'',ExcelBuf."Cell Type"::Text,2);
                // (OFM-02) (ATD/GRL) Modificaciones informe. End
                EnterCell(RowNo,7,TextDesv,'',ExcelBuf."Cell Type"::Text,2);
                EnterCell(RowNo,8,FORMAT(RefDate),'',ExcelBuf."Cell Type"::Date,2);
                EnterCell(RowNo,3,TextObs,'',ExcelBuf."Cell Type"::Text,2);
                */
                //KPMG-GRL 08/12/2020. Cambiar columna comentario para importar correctamente. End
                RowNo += 1;

                CLEAR(FinalRowNo);
                i := 1;
            end;
        }

        dataitem(OutputRow; Integer)
        {
            DataItemTableView = SORTING(Number);

            column(NoCuenta; GetOutputCellValue(Number, 1))
            {
            }
            column(Nombre; GetOutputCellValue(Number, 2))
            {
            }
            column(PptoAnoAnterior; GetOutputCellValue(Number, 3))
            {
            }
            column(CumplPct; GetOutputCellValue(Number, 4))
            {
            }
            column(RealUlt12Meses; GetOutputCellValue(Number, 5))
            {
            }
            column(DesvPct; GetOutputCellValue(Number, 6))
            {
            }
            column(FechaPresupuesto; GetOutputCellValue(Number, 7))
            {
            }
            column(Observaciones; GetOutputCellValue(Number, 8))
            {
            }
            column(RowStyle; GetOutputRowStyle(Number))
            {
            }

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, GetLastOutputRowNo());
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
                    Caption = 'Budget for year', Comment = 'ESP="Presupuesto para el año"';
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
                    Visible = false;
                    ApplicationArea = All;
                }
                field(ToDate; ToDate)
                {
                    Caption = 'To Date', Comment = 'ESP="Fecha hasta"';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Months; Months)
                {
                    Caption = 'Actual End Date', Comment = 'ESP="Fecha fin real"';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    rendering
    {
        layout(BudgetTemplateExcel)
        {
            Type = Excel;
            LayoutFile = 'src/Reports/ExportTemplBudExcel.xlsx';
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
        IF RefYear = 0 THEN
            RefYear := DATE2DMY(WORKDATE, 3) + 1;
    end;

    trigger OnPreReport()
    begin
        ExcelBuf.LOCKTABLE;
    end;

    var
        rDimCodeBuffer: Record "Dimension Code Buffer";
        ExcelBuf: Record "Excel Buffer" temporary;
        ExcelBuf2: Record "Excel Buffer" temporary;
        RefDate: Date;
        vFormatType: Option Normal,Group,Title,Underline,"Table",Definition,PostingGL,PostingName,Total;
        BudgetName: Code[10];
        GLAccountFilter: Text;
        TextGLAccFilter: Label '2|20?????|21?????|6|6??????|7|7??????|5505007', Locked = true, Comment = 'ESP="2|20?????|21?????|6|6??????|7|7??????|5505007"';
        ServerFileName: Text;
        Text001Lbl: Label 'Exportar filtros', Comment = 'ESP="Exportar filtros"';
        Text002: Label 'Nombre ppto.', Comment = 'ESP="Nombre ppto."';
        TextGLAccNo: Label 'Nº cuenta', Comment = 'ESP="Nº cuenta"';
        TextName: Label 'Nombre', Comment = 'ESP="Nombre"';
        TextLYBudget: Label 'Ppto. año anterior', Comment = 'ESP="Ppto. año anterior"';
        TextCompl: Label 'Cumpl. %', Comment = 'ESP="Cumpl. %"';
        TextLYReal: Label 'Real últ. 12 meses', Comment = 'ESP="Real últ. 12 meses"';
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
        Months: Option " ",Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre;
        //"//KPMG": ;
        TextLYBudget2: Label 'Ppto año anterior', Comment = 'ESP="Ppto año anterior"';
        TextLYReal2: Label 'Real últ. 12 meses', Comment = 'ESP="Real últ. 12 meses"';
        MonthInteger: Integer;
        TestMode: Boolean;
        pName: Label 'Nombre', Comment = 'ESP="Nombre"';
        County: Label 'Población', Comment = 'ESP="Población"';
        var1: Text;
        var2: Text;
        var3: Decimal;
        var5: Decimal;
        var6: Text;
        cTempBlob: Codeunit "Temp Blob";
        vOutStr: OutStream;
        vInStr: InStream;
        vPowerApps: Boolean;
        vAPI: Boolean;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; NumberFormat: Text[30]; CellType: Option; FormatType: Option Normal,Group,Title,Underline,"Table",Definition,PostingGL,PostingName,Total)
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
                    //GRL KPMG Modificaciones prepuesto plantilla. Inicio
                    ExcelBuf."Font Color" := 11;
                    ExcelBuf."BackGround Color" := 4;
                    //GRL KPMG Modificaciones prepuesto plantilla. Fin
                END;
            FormatType::Group:
                BEGIN
                    ExcelBuf.Bold := TRUE;
                    ExcelBuf."Double Underline" := TRUE;
                    //GRL KPMG Modificaciones prepuesto plantilla. Inicio
                    //ExcelBuf."Font Color" := 3;
                    ExcelBuf."BackGround Color" := 5;
                    //GRL KPMG Modificaciones prepuesto plantilla. Fin
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
            //GRL KPMG Modificaciones prepuesto plantilla. Inicio
            FormatType::Definition:
                BEGIN
                    ExcelBuf."Font Color" := 11;
                    ExcelBuf.Bold := TRUE;
                    ExcelBuf."BackGround Color" := 4;
                END;
            FormatType::PostingGL:
                BEGIN
                    ExcelBuf."Font Color" := 12;
                    ExcelBuf.Bold := TRUE;
                    ExcelBuf."BackGround Color" := 6;
                END;
            FormatType::PostingName:
                BEGIN
                    ExcelBuf."Font Color" := 13;
                    ExcelBuf.Bold := TRUE;
                    ExcelBuf."BackGround Color" := 7;
                END;
            FormatType::Total:
                BEGIN
                    ExcelBuf."Font Color" := 11;
                    ExcelBuf.Bold := TRUE;
                    ExcelBuf."BackGround Color" := 8;
                END;
        END;
        ExcelBuf.INSERT();
    end;

    local procedure SetTemplateColumnWidths()
    begin
        ExcelBuf.SetColumnWidth('A', 14);
        ExcelBuf.SetColumnWidth('B', 44);
        ExcelBuf.SetColumnWidth('C', 16);
        ExcelBuf.SetColumnWidth('D', 11);
        ExcelBuf.SetColumnWidth('E', 17);
        ExcelBuf.SetColumnWidth('F', 11);
        ExcelBuf.SetColumnWidth('G', 13);
        ExcelBuf.SetColumnWidth('H', 17);
    end;

    local procedure GetLastOutputRowNo(): Integer
    begin
        ExcelBuf.RESET();
        IF ExcelBuf.FINDLAST() THEN
            EXIT(ExcelBuf."Row No.");
    end;

    local procedure GetOutputCellValue(OutputRowNo: Integer; OutputColumnNo: Integer): Text
    begin
        IF NOT ExcelBuf.GET(OutputRowNo, OutputColumnNo) THEN
            EXIT('');

        IF ExcelBuf.Formula <> '' THEN
            EXIT(GetOutputFormulaValue(OutputRowNo, OutputColumnNo, ExcelBuf.Formula));

        EXIT(ExcelBuf."Cell Value as Text");
    end;

    local procedure GetOutputFormulaValue(OutputRowNo: Integer; OutputColumnNo: Integer; OutputFormula: Text): Text
    var
        FormulaRowNo: Integer;
        FormulaColumnNo: Integer;
    begin
        IF OutputColumnNo = 4 THEN
            EXIT(GetOutputPercentageValue(GetOutputRatio(OutputRowNo, 5, 3)));

        IF OutputColumnNo = 6 THEN
            EXIT(GetOutputPercentageValue(GetOutputDeviation(OutputRowNo)));

        IF TryGetOutputCellReference(OutputFormula, FormulaRowNo, FormulaColumnNo) THEN
            EXIT(GetOutputCellValue(FormulaRowNo, FormulaColumnNo));

        IF COPYSTR(OutputFormula, 1, 5) = '=SUM(' THEN
            EXIT(FORMAT(GetOutputFormulaSum(OutputFormula, OutputColumnNo)));

        EXIT(OutputFormula);
    end;

    local procedure GetOutputPercentageValue(PercentageValue: Decimal): Text
    begin
        EXIT(FORMAT(ROUND(PercentageValue * 100, 0.01)) + '%');
    end;

    local procedure GetOutputRatio(OutputRowNo: Integer; NumeratorColumnNo: Integer; DenominatorColumnNo: Integer): Decimal
    var
        DenominatorValue: Decimal;
    begin
        DenominatorValue := GetOutputCellDecimal(OutputRowNo, DenominatorColumnNo);
        IF DenominatorValue = 0 THEN
            EXIT(0);

        EXIT(GetOutputCellDecimal(OutputRowNo, NumeratorColumnNo) / DenominatorValue);
    end;

    local procedure GetOutputDeviation(OutputRowNo: Integer): Decimal
    var
        BudgetValue: Decimal;
        RealValue: Decimal;
    begin
        BudgetValue := GetOutputCellDecimal(OutputRowNo, 7);
        RealValue := GetOutputCellDecimal(OutputRowNo, 5);

        IF RealValue <> 0 THEN
            EXIT((BudgetValue / RealValue) - 1);

        IF BudgetValue <> 0 THEN
            EXIT(1);

        EXIT(0);
    end;

    local procedure GetOutputCellDecimal(OutputRowNo: Integer; OutputColumnNo: Integer): Decimal
    var
        OutputDecimal: Decimal;
    begin
        IF EVALUATE(OutputDecimal, GetOutputCellValue(OutputRowNo, OutputColumnNo)) THEN
            EXIT(OutputDecimal);
    end;

    local procedure GetOutputFormulaSum(OutputFormula: Text; OutputColumnNo: Integer): Decimal
    var
        FormulaSeparatorPos: Integer;
        FormulaEndPos: Integer;
        FormulaRowNo: Integer;
        FormulaStartRowNo: Integer;
        FormulaEndRowNo: Integer;
        OutputSum: Decimal;
    begin
        FormulaSeparatorPos := STRPOS(OutputFormula, ':');
        FormulaEndPos := STRPOS(OutputFormula, ')');
        IF (FormulaSeparatorPos = 0) OR (FormulaEndPos = 0) THEN
            EXIT(0);

        IF NOT EVALUATE(FormulaStartRowNo, COPYSTR(OutputFormula, 7, FormulaSeparatorPos - 7)) THEN
            EXIT(0);

        IF NOT EVALUATE(FormulaEndRowNo, COPYSTR(OutputFormula, FormulaSeparatorPos + 2, FormulaEndPos - FormulaSeparatorPos - 2)) THEN
            EXIT(0);

        FOR FormulaRowNo := FormulaStartRowNo TO FormulaEndRowNo DO
            OutputSum += GetOutputCellDecimal(FormulaRowNo, OutputColumnNo);

        EXIT(OutputSum);
    end;

    local procedure TryGetOutputCellReference(OutputFormula: Text; var FormulaRowNo: Integer; var FormulaColumnNo: Integer): Boolean
    var
        FormulaColumn: Char;
    begin
        IF (COPYSTR(OutputFormula, 1, 1) <> '=') OR (STRPOS(OutputFormula, ':') <> 0) OR (STRPOS(OutputFormula, '(') <> 0) THEN
            EXIT(FALSE);

        FormulaColumn := OutputFormula[2];
        FormulaColumnNo := FormulaColumn - 64;
        IF (FormulaColumnNo < 1) OR (FormulaColumnNo > 8) THEN
            EXIT(FALSE);

        EXIT(EVALUATE(FormulaRowNo, COPYSTR(OutputFormula, 3)));
    end;

    local procedure GetOutputRowStyle(OutputRowNo: Integer): Text
    begin
        IF OutputRowNo IN [1, 2, 3] THEN
            EXIT('HeaderInfo');

        IF OutputRowNo = 5 THEN
            EXIT('TableHeader');

        IF NOT ExcelBuf.GET(OutputRowNo, 1) THEN
            EXIT('Blank');

        CASE ExcelBuf."BackGround Color" OF
            4:
                EXIT('Definition');
            5:
                EXIT('Group');
            6:
                EXIT('Posting');
            8:
                EXIT('Total');
        END;

        EXIT('Normal');
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

    local procedure GetBudgetTemplateName()
    var
        GLBudgetName: Record "G/L Budget Name";
        MissingTemplate: Label 'No Budget Template enable in NAV', Comment = 'ESP="No hay ninguna plantilla de presupuesto habilitada en NAV"';
    begin
        GLBudgetName.SETRANGE(Template, TRUE);
        IF GLBudgetName.FINDLAST() THEN
            BudgetName := GLBudgetName.Name
        ELSE
            BudgetName := MissingTemplate;
    end;

    procedure SetRefYear(pYear: Integer)
    begin
        RefYear := pYear;
    end;

    procedure SetMonth(pMonth: Integer)
    begin
        IF (pMonth > 0) AND (pMonth < 13) THEN
            MonthInteger := pMonth
        ELSE
            //Any other case it's November
            MonthInteger := 10;
    end;

    procedure SetFileNameSilent(NewFileName: Text)
    begin
        ServerFileName := NewFileName;
    end;

    procedure SetTestMode(NewTestMode: Boolean)
    begin
        TestMode := NewTestMode;
    end;

    procedure fSetPowerApps(pPowerApps: Boolean)
    begin
        vPowerApps := pPowerApps;
    end;

    procedure fSetAPI(pAPI: Boolean)
    begin
        vAPI := pAPI;
    end;

    // procedure pruebaColores()
    // var
    //     exBuf: Record "Excel Buffer";
    // begin
    //     exBuf.DeleteAll();

    //     asd(exBuf, 1,1,'test', 'FF0070C0', 'FFFFFFFF',true);
    // end;

    // local procedure asd(var excelbuffer: Record "Excel Buffer" temporary; Rowno: Integer; Colno: Integer; Cellvalue: Text; background: Integer; FontColor: Integer; IsBold: Boolean)
    // begin
    //     excelbuffer.init();
    //     excelbuffer.Validate("Row No.", Rowno);
    //     excelbuffer.Validate("Column No.", Colno);
    //     excelbuffer."Cell Value as Text" := CopyStr(Cellvalue, 1, MaxStrLen(excelbuffer."Cell Value as Text"));
    //     excelbuffer."Cell Type" := excelbuffer."Cell Type"::Text;

    //     if background = 1 then
    //         excelbuffer."BackGround Color" := background;

    //     if FontColor = 1 then
    //         excelbuffer."Font Color" := FontColor;

    //     excelbuffer.Bold := IsBold;

    //     excelbuffer.Insert();

    // end;

    //IGG - Necesario para pasar valor por Base64 para PowerApps
    [IntegrationEvent(true, false)]
    procedure OnAfterRunReport(pInStr: InStream; pName: Text)
    begin
    end;


}
