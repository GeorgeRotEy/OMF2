report 50100 "Configura repoarto analitico"
{
    Caption = 'Configure analytic distribution', Comment = 'ESP="Configurar reparto analítico"';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Company; Company)
        {
            DataItemTableView = SORTING(Name);
            RequestFilterFields = Name;

            trigger OnAfterGetRecord()
            var
                NoSeries: Record "No. Series";
                NoSeriesLine: Record "No. Series Line";
                AnalyticSetup: Record "Analytical Distribution Setup";
                SerieAsignacion: Code[10];
                SerieReparto: Code[10];
                SourceCodeSetup: Record "Source Code Setup";
                SourceCode: Record "Source Code";
                porcentaje: Integer;
                EmpresasConf: Record "Empresas configuradas";
            begin
                i += 1;
                porcentaje := ROUND(10000 * i / COUNT, 1, '=');
                Window.UPDATE(1, porcentaje);

                IF EmpresasConf.GET(Company.Name) THEN CurrReport.SKIP;

                SerieAsignacion := 'ASIGN_REP';
                NoSeries.RESET();
                NoSeries.CHANGECOMPANY(Company.Name);
                IF NoSeries.GET(SerieAsignacion) THEN BEGIN
                    //ERROR(ErrorSerie, SerieAsignacion, Company.Name)
                    NoSeries.Description := 'Asignación de reparto';
                    NoSeries."Default Nos." := TRUE;
                    NoSeries.MODIFY();
                END ELSE BEGIN
                    NoSeries.INIT();
                    NoSeries.Code := SerieAsignacion;
                    NoSeries.Description := 'Asignación de reparto';
                    NoSeries."Default Nos." := TRUE;
                    NoSeries.INSERT();
                END;
                NoSeriesLine.RESET();
                NoSeriesLine.CHANGECOMPANY(Company.Name);
                NoSeriesLine.SETRANGE("Series Code", SerieAsignacion);
                IF NoSeriesLine.FINDFIRST() THEN BEGIN
                    //ERROR(ErrorLinSerie, SerieAsignacion, Company.Name)
                    NoSeriesLine."Starting Date" := DMY2DATE(1, 1, DATE2DMY(TODAY, 3));
                    NoSeriesLine."Starting No." := 'ASIG' + FORMAT(DATE2DMY(TODAY, 3)) + '/00000';
                    NoSeriesLine."Ending No." := 'ASIG' + FORMAT(DATE2DMY(TODAY, 3)) + '/99999';
                    NoSeriesLine.Open := TRUE;
                    NoSeriesLine.MODIFY();
                END ELSE BEGIN
                    NoSeriesLine.INIT();
                    NoSeriesLine."Series Code" := SerieAsignacion;
                    NoSeriesLine."Line No." := 10000;
                    NoSeriesLine."Starting Date" := DMY2DATE(1, 1, DATE2DMY(TODAY, 3));
                    NoSeriesLine."Starting No." := 'ASIG' + FORMAT(DATE2DMY(TODAY, 3)) + '/00000';
                    NoSeriesLine."Ending No." := 'ASIG' + FORMAT(DATE2DMY(TODAY, 3)) + '/99999';
                    NoSeriesLine.Open := TRUE;
                    NoSeriesLine.INSERT();
                END;
                //END;

                SerieReparto := 'REPARTO';
                NoSeries.SETRANGE(NoSeries.Code, SerieReparto);
                IF NoSeries.FINDFIRST() THEN BEGIN
                    //ERROR(ErrorSerie, SerieReparto, Company.Name)
                    NoSeries.Description := 'Reparto analítico';
                    NoSeries."Default Nos." := TRUE;
                    NoSeries.MODIFY();
                END ELSE BEGIN
                    NoSeries.INIT();
                    NoSeries.Code := SerieReparto;
                    NoSeries.Description := 'Reparto analítico';
                    NoSeries."Default Nos." := TRUE;
                    NoSeries.INSERT();
                END;

                NoSeriesLine.RESET();
                NoSeriesLine.CHANGECOMPANY(Company.Name);
                NoSeriesLine.SETRANGE("Series Code", SerieReparto);
                IF NoSeriesLine.FINDFIRST() THEN BEGIN
                    //ERROR(ErrorLinSerie, SerieReparto, Company.Name)
                    NoSeriesLine."Starting Date" := DMY2DATE(1, 1, DATE2DMY(TODAY, 3));
                    NoSeriesLine."Starting No." := 'REP' + FORMAT(DATE2DMY(TODAY, 3)) + '/00000';
                    NoSeriesLine."Ending No." := 'REP' + FORMAT(DATE2DMY(TODAY, 3)) + '/99999';
                    NoSeriesLine.Open := TRUE;
                    NoSeriesLine.MODIFY();
                END ELSE BEGIN
                    NoSeriesLine.INIT();
                    NoSeriesLine."Series Code" := SerieReparto;
                    NoSeriesLine."Line No." := 10000;
                    NoSeriesLine."Starting Date" := DMY2DATE(1, 1, DATE2DMY(TODAY, 3));
                    NoSeriesLine."Starting No." := 'REP' + FORMAT(DATE2DMY(TODAY, 3)) + '/00000';
                    NoSeriesLine."Ending No." := 'REP' + FORMAT(DATE2DMY(TODAY, 3)) + '/99999';
                    NoSeriesLine.Open := TRUE;
                    NoSeriesLine.INSERT();
                END;
                //END;

                AnalyticSetup.RESET();
                AnalyticSetup.CHANGECOMPANY(Company.Name);
                IF NOT AnalyticSetup.GET THEN BEGIN
                    AnalyticSetup.INIT();
                    AnalyticSetup."No Series Assignment" := SerieAsignacion;
                    AnalyticSetup."No Series Distribution" := SerieReparto;
                    AnalyticSetup."Transfer start date" := DMY2DATE(1, 1, DATE2DMY(TODAY, 3));
                    AnalyticSetup.INSERT();
                END ELSE BEGIN
                    AnalyticSetup."No Series Assignment" := SerieAsignacion;
                    AnalyticSetup."No Series Distribution" := SerieReparto;
                    AnalyticSetup."Transfer start date" := DMY2DATE(1, 1, DATE2DMY(TODAY, 3));
                    AnalyticSetup.MODIFY();
                END;

                SourceCode.RESET();
                SourceCode.CHANGECOMPANY(Company.Name);
                IF SourceCode.GET('ASIGN_REP') THEN
                    ERROR(ErrorCodOrigen, 'ASIGN_REP', Company.Name)
                ELSE BEGIN
                    SourceCode.INIT();
                    SourceCode.Code := 'ASIGN_REP';
                    SourceCode.Description := 'Asignación de reparto';
                    SourceCode.INSERT();
                END;

                IF SourceCode.GET('DISTR_ANA') THEN
                    ERROR(ErrorCodOrigen, 'DISTR_ANA', Company.Name)
                ELSE BEGIN
                    SourceCode.INIT();
                    SourceCode.Code := 'DISTR_ANA';
                    SourceCode.Description := 'Distribución analítica';
                    SourceCode.INSERT();
                END;

                SourceCodeSetup.RESET();
                SourceCodeSetup.CHANGECOMPANY(Company.Name);
                SourceCodeSetup.GET();
                SourceCodeSetup."Analytic Distribution" := 'DISTR_ANA';
                SourceCodeSetup."Distribution Allocation" := 'ASIGN_REP';
                SourceCodeSetup.MODIFY();

                EmpresasConf.INIT();
                EmpresasConf."Company Name" := Company.Name;
                EmpresasConf."Set up" := TRUE;
                EmpresasConf.INSERT();
            end;

            trigger OnPostDataItem()
            begin
                Window.CLOSE();
            end;

            trigger OnPreDataItem()
            begin
                Window.OPEN('Configurando empresas\' +
                            '@1@@@@@@@@@@@@@@@@@@@@');

                i := 0;
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

    var
    ErrorCodOrigen: Label 'Ya existe el código de origen %1 en la empresa %2', Comment = 'ESP="Ya existe el código de origen %1 en la empresa %2"';
        Window: Dialog;
        i: Integer;
}
