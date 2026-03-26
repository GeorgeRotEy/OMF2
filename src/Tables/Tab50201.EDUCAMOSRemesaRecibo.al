table 50201 "EDUCAMOS RemesaRecibo" //EDUCAMOS
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
        field(3; id_recibo; Text[30])
        {
            Caption = 'Receipt ID', Comment = 'ESP="Id recibo"';
        }
        field(4; id_unique_recibo; Text[50])
        {
            Caption = 'Unique Receipt ID', Comment = 'ESP="Id único recibo"';
        }
        field(5; numero_recibo; Text[50])
        {
            Caption = 'Receipt No.', Comment = 'ESP="Número recibo"';
        }
        field(6; estado_recibo; Integer)
        {
            Caption = 'Receipt Status', Comment = 'ESP="Estado recibo"';
        }
        field(7; tipo_recibo; Integer)
        {
            Caption = 'Receipt Type', Comment = 'ESP="Tipo recibo"';
        }
        field(8; id_pagador; Text[30])
        {
            Caption = 'Payer ID', Comment = 'ESP="Id pagador"';
        }
        field(9; id_unique_pagador; Text[50])
        {
            Caption = 'Unique Payer ID', Comment = 'ESP="Id único pagador"';
        }
        field(10; nombre_pagador; Text[250])
        {
            Caption = 'Payer Name', Comment = 'ESP="Nombre pagador"';
        }
        field(11; apellidos_pagador; Text[250])
        {
            Caption = 'Payer Surnames', Comment = 'ESP="Apellidos pagador"';
        }
        field(12; nif_pagador; Text[50])
        {
            Caption = 'Payer Tax ID', Comment = 'ESP="NIF pagador"';
        }
        field(13; direccion_pagador; Text[250])
        {
            Caption = 'Payer Address', Comment = 'ESP="Dirección pagador"';
        }
        field(14; localidad_pagador; Text[250])
        {
            Caption = 'Payer City', Comment = 'ESP="Localidad pagador"';
        }
        field(15; cp_pagador; Text[100])
        {
            Caption = 'Payer Post Code', Comment = 'ESP="Código postal pagador"';
        }
        field(16; provincia_pagador; Text[100])
        {
            Caption = 'Payer Province', Comment = 'ESP="Provincia pagador"';
        }
        field(17; cuenta_pagador; Text[50])
        {
            Caption = 'Payer Account No.', Comment = 'ESP="Cuenta pagador"';
        }
        field(18; cuenta_pagador_IBAN; Text[50])
        {
            Caption = 'Payer IBAN', Comment = 'ESP="IBAN pagador"';
        }
        field(19; fecha_cambio_estado; Text[30])
        {
            Caption = 'Status Change Date', Comment = 'ESP="Fecha cambio estado"';
        }
        field(20; estado_actual; Integer)
        {
            Caption = 'Current Status', Comment = 'ESP="Estado actual"';
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
        key(Key1; id_unique_remesa, id_unique_recibo)
        {
            Clustered = true;
        }
        key(Key2; Processed, id_unique_remesa)
        {
        }
    }

    fieldgroups
    {
    }
}
