report 50092 "Proceso cuentas68"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Procesocuentas68.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(TablaMovContabilidad; TablaMovContabilidad)
        {
            trigger OnAfterGetRecord()
            begin
                IF TablaMovContabilidad."Entidad Codigo" = '' THEN BEGIN
                    TablaMovContabilidad."Entidad Codigo" := '10000';
                    TablaMovContabilidad.MODIFY();
                END;
            end;

            trigger OnPreDataItem()
            begin
                CLEAR(TablaMovContabilidad);
                TablaMovContabilidad.SETFILTER(Empresa, '%1', 'COL*');
                TablaMovContabilidad.SETFILTER("Nº Cuenta", '%1', '68*');
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
}
