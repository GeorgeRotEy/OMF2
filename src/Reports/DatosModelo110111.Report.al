report 50086 "Datos Modelo 110/111"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/DatosModelo110111.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Movs. retenciones"; "Movs. retenciones")
        {
            DataItemTableView = SORTING(Tipo, "Tipo retención", "Tipo documento", "Cod. origen", "Fecha registro")
                                ORDER(Ascending)
                                WHERE(Tipo = CONST(Compra),
                                      "Tipo documento" = FILTER("Fact. Registrada" | "Abono Registrado"));
            RequestFilterFields = "Fecha registro";
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(GETFILTER__Fecha_Registro__; GETFILTER("Fecha registro"))
            {
            }
            column(ImportePercepcion; ImportePercepcion)
            {
            }
            column(ImporteRetencion; ImporteRetencion)
            {
            }
            column(NumPerceptores; NumPerceptores)
            {
            }
            column(Movs__IRPF__Tipo_IRPF_; "Tipo retención")
            {
            }
            column(ImporteTotalRetencion; ImporteTotalRetencion)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(LISTADO_DE_RETENCIONES_POR_PROVEEDORCaption; LISTADO_DE_RETENCIONES_POR_PROVEEDORCaptionLbl)
            {
            }
            column(Periodo_Caption; Periodo_CaptionLbl)
            {
            }
            column(ImportePercepcionCaption; ImportePercepcionCaptionLbl)
            {
            }
            column(Importe_de_las_recepcionesCaption; Importe_de_las_recepcionesCaptionLbl)
            {
            }
            column(N__de_perceptoresCaption; N__de_perceptoresCaptionLbl)
            {
            }
            column(Movs__IRPF_N__mov_; "Nº mov.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                SETRANGE("Tipo retención", "Tipo retención");
                CALCSUMS(Base, Importe);
                ImportePercepcion := Base;
                ImporteRetencion := Importe;

                SETRANGE("Cod. origen", "Cod. origen");
                NumPerceptores += 1;

                FINDLAST;
                SETRANGE("Cod. origen");
                SETRANGE("Tipo retención");

                ImporteTotalRetencion += ImporteRetencion;
            end;

            trigger OnPostDataItem()
            begin
                NumPerceptores := 0;
                ImportePercepcion := 0;
                ImporteRetencion := 0;
            end;

            trigger OnPreDataItem()
            begin
                NumPerceptores := 0;
                ImporteTotalRetencion := 0;
                ImportePercepcion := 0;
                ImporteRetencion := 0;
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
        NumPerceptores: Integer;
        ImportePercepcion: Decimal;
        ImporteRetencion: Decimal;
        ImporteTotalRetencion: Decimal;
        CurrReport_PAGENOCaptionLbl: Label 'Página', Comment = 'ESP="Página"';
        LISTADO_DE_RETENCIONES_POR_PROVEEDORCaptionLbl: Label 'LISTADO DE RETENCIONES POR PROVEEDOR', Comment = 'ESP="LISTADO DE RETENCIONES POR PROVEEDOR"';
        Periodo_CaptionLbl: Label 'Periodo:', Comment = 'ESP="Periodo:"';
        ImportePercepcionCaptionLbl: Label 'Importe de las percepciones', Comment = 'ESP="Importe de las percepciones"';
        Importe_de_las_recepcionesCaptionLbl: Label 'Importe de las recepciones', Comment = 'ESP="Importe de las recepciones"';
        N__de_perceptoresCaptionLbl: Label 'Nº de perceptores', Comment = 'ESP="Nº de perceptores"';
}
