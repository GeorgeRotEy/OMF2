report 50000 "CFG INICIAL RSIM"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Company; Company)
        {
            dataitem("Source Code"; "Source Code")
            {
                DataItemTableView = SORTING(Code)
                                    ORDER(Ascending);

                trigger OnPreDataItem()
                begin
                    "Source Code".INIT();
                    "Source Code".Code := 'DSIM';
                    "Source Code".Description := 'Registro simplificado';
                    IF "Source Code".INSERT() THEN;
                end;
            }
            dataitem("Source Code Setup"; "Source Code Setup")
            {
                DataItemTableView = SORTING("Primary Key")
                                    ORDER(Ascending);

                trigger OnAfterGetRecord()
                begin
                    "Source Code Setup"."Easy Register Journal" := 'RSIM';
                    "Source Code Setup".MODIFY();
                end;
            }
            dataitem("Gen. Journal Template"; "Gen. Journal Template")
            {
                DataItemTableView = SORTING(Name)
                                    ORDER(Ascending);

                trigger OnPreDataItem()
                begin
                    "Gen. Journal Template".INIT();
                    "Gen. Journal Template".Name := 'RSIM';
                    "Gen. Journal Template".Description := 'Libro diario registro simple';
                    "Gen. Journal Template".Type := "Gen. Journal Template".Type::EasyRegister;
                    "Gen. Journal Template"."Source Code" := 'RSIM';
                    IF "Gen. Journal Template".INSERT() THEN;
                end;
            }
            dataitem("Gen. Journal Batch"; "Gen. Journal Batch")
            {
                DataItemTableView = SORTING("Journal Template Name", Name)
                                    ORDER(Ascending);

                trigger OnPostDataItem()
                begin
                    SLEEP(1000);
                end;

                trigger OnPreDataItem()
                begin
                    "Gen. Journal Batch".INIT();
                    "Gen. Journal Batch"."Journal Template Name" := 'RSIM';
                    "Gen. Journal Batch".Name := 'PREDET';
                    "Gen. Journal Batch".Description := 'Predeterminada';
                    IF "Gen. Journal Batch".INSERT() THEN;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                vWindow.OPEN(STRSUBSTNO(ctConfEmpresa, Company.Name));
            end;

            trigger OnPostDataItem()
            begin
                vWindow.CLOSE();
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

    trigger OnPostReport()
    begin
        MESSAGE('Fin de la configuración de empresas');
    end;

    var
        vWindow: Dialog;
        ctConfEmpresa: Label 'Configurando empresa %1', Comment = 'ESP="Configurando empresa %1"';
}
