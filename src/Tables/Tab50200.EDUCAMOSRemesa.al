table 50200 "EDUCAMOS Remesa Old" //EDUCAMOS
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    fields
    {
        field(1; id_remesa; Text[30])
        {
            Caption = 'Batch ID', Comment = 'ESP="Id remesa"';
        }
        field(2; id_unique_remesa; Text[50])
        {
            Caption = 'Unique Batch ID', Comment = 'ESP="Id único remesa"';
        }
        field(3; id_colegio; Text[30])
        {
            Caption = 'School ID', Comment = 'ESP="Id colegio"';
        }
        field(4; primeraSincroContab; Text[2])
        {
            Caption = 'First Accounting Sync', Comment = 'ESP="Primera sincronización contable"';
        }
        field(5; id_ordenante; Text[30])
        {
            Caption = 'Ordering Party ID', Comment = 'ESP="Id ordenante"';
        }
        field(6; id_unique_ordenante; Text[50])
        {
            Caption = 'Unique Ordering Party ID', Comment = 'ESP="Id único ordenante"';
        }
        field(7; nombre_ordenante; Text[150])
        {
            Caption = 'Ordering Party Name', Comment = 'ESP="Nombre ordenante"';
        }
        field(8; reducido_ordenante; Text[50])
        {
            Caption = 'Ordering Party Short Name', Comment = 'ESP="Nombre reducido ordenante"';
        }
        field(9; cif_ordenante; Text[50])
        {
            Caption = 'Ordering Party Tax ID', Comment = 'ESP="CIF ordenante"';
        }
        field(10; id_presentador; Text[30])
        {
            Caption = 'Presenter ID', Comment = 'ESP="Id presentador"';
        }
        field(11; id_unique_presentador; Text[50])
        {
            Caption = 'Unique Presenter ID', Comment = 'ESP="Id único presentador"';
        }
        field(12; nombre_presentador; Text[100])
        {
            Caption = 'Presenter Name', Comment = 'ESP="Nombre presentador"';
        }
        field(13; nif_presentador; Text[50])
        {
            Caption = 'Presenter Tax ID', Comment = 'ESP="NIF presentador"';
        }
        field(14; cuenta_presentador; Text[20])
        {
            Caption = 'Presenter Account No.', Comment = 'ESP="Cuenta presentador"';
        }
        field(15; cuenta_presentador_IBAN; Text[25])
        {
            Caption = 'Presenter IBAN', Comment = 'ESP="IBAN cuenta presentador"';
        }
        field(16; fecha_creacion; Text[30])
        {
            Caption = 'Creation Date', Comment = 'ESP="Fecha creación"';
        }
        field(17; fecha_emision; Text[30])
        {
            Caption = 'Issue Date', Comment = 'ESP="Fecha emisión"';
        }
        field(18; fecha_cargo; Text[30])
        {
            Caption = 'Charge Date', Comment = 'ESP="Fecha cargo"';
        }
        field(19; accion; Integer)
        {
            Caption = 'Action', Comment = 'ESP="Acción"';
        }
        field(20; calendario; Text[50])
        {
            Caption = 'Calendar', Comment = 'ESP="Calendario"';
        }
        field(30; "Importation DateTime"; DateTime)
        {
            Caption = 'Import Date/Time', Comment = 'ESP="Fecha y hora de importación"';
        }
        field(31; Processed; Boolean)
        {
            Caption = 'Processed', Comment = 'ESP="Procesado"';
        }
    }

    keys
    {
        key(Key1; id_unique_remesa)
        {
            Clustered = true;
        }
        key(Key2; Processed, cif_ordenante, accion)
        {
        }
    }

    fieldgroups
    {
    }
}
