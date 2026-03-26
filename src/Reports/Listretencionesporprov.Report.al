report 50085 "List. retenciones por prov."
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Listretencionesporprov.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Movs. retenciones"; "Movs. retenciones")
        {
            DataItemTableView = SORTING(Tipo, "Cod. origen", "Grupo registro retención", "Fecha registro")
                                ORDER(Ascending)
                                WHERE(Tipo = CONST(Compra),
                                      "Tipo documento" = FILTER("Fact. Registrada" | "Abono Registrado"));
            RequestFilterFields = "Cod. origen", "Grupo registro retención", "Fecha registro";
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
            column(Movs__IRPF__Cod__Origen_; "Cod. origen")
            {
            }
            column(Movs__IRPF_Importe; Importe)
            {
            }
            column(Movs__IRPF_Base; Base)
            {
            }
            column(Movs__IRPF__N__Documento_; "Nº documento")
            {
            }
            column(Movs__IRPF____IRPF_; "% retención")
            {
            }
            column(Movs__IRPF__Grupo_Registro_IRPF_; "Grupo registro retención")
            {
            }
            column(Movs__IRPF__CIF_NIF_; "CIF/NIF")
            {
            }
            column(Movs__IRPF__Fecha_Emision_Documento_; "Fecha emision documento")
            {
            }
            column(RecProveedor_Name; RecProveedor.Name)
            {
            }
            column(Movs__IRPF_Importe_Control1100024; Importe)
            {
            }
            column(Movs__IRPF_Base_Control1100025; Base)
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
            column(Fecha_MovimientoCaption; Fecha_MovimientoCaptionLbl)
            {
            }
            column(Movs__IRPF__CIF_NIF_Caption; FIELDCAPTION("CIF/NIF"))
            {
            }
            column(Movs__IRPF__Grupo_Registro_IRPF_Caption; FIELDCAPTION("Grupo registro retención"))
            {
            }
            column(Movs__IRPF____IRPF_Caption; FIELDCAPTION("% retención"))
            {
            }
            column(Movs__IRPF__N__Documento_Caption; FIELDCAPTION("Nº documento"))
            {
            }
            column(Movs__IRPF_BaseCaption; FIELDCAPTION(Base))
            {
            }
            column(Movs__IRPF_ImporteCaption; FIELDCAPTION(Importe))
            {
            }
            column(Movs__IRPF__Cod__Origen_Caption; Movs__IRPF__Cod__Origen_CaptionLbl)
            {
            }
            column(Nombre_ProveedorCaption; Nombre_ProveedorCaptionLbl)
            {
            }
            column(Movs__IRPF_N__mov_; "Nº mov.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                RecProveedor.GET("Cod. origen");
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
        RecProveedor: Record Vendor;
    CurrReport_PAGENOCaptionLbl: Label 'Página', Comment = 'ESP="Página"';
    LISTADO_DE_RETENCIONES_POR_PROVEEDORCaptionLbl: Label 'LISTADO DE RETENCIONES POR PROVEEDOR', Comment = 'ESP="LISTADO DE RETENCIONES POR PROVEEDOR"';
    Periodo_CaptionLbl: Label 'Periodo:', Comment = 'ESP="Periodo:"';
    Fecha_MovimientoCaptionLbl: Label 'Fecha Movimiento', Comment = 'ESP="Fecha Movimiento"';
    Movs__IRPF__Cod__Origen_CaptionLbl: Label 'Nº Proveedor', Comment = 'ESP="Nº Proveedor"';
    Nombre_ProveedorCaptionLbl: Label 'Nombre Proveedor', Comment = 'ESP="Nombre Proveedor"';
}
