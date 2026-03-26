table 50210 "EDUCAMOS IngresoCuenta" //EDUCAMOS
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    fields
    {
        field(1; id_ingreso; Text[50])
        {
            Caption = 'Income Id', Comment = 'ESP="Id ingreso"';
        }
        field(2; id_unique_ingreso; Text[50])
        {
            Caption = 'Unique Income Id', Comment = 'ESP="Id único ingreso"';
        }
        field(3; id_colegio; Text[50])
        {
            Caption = 'School Id', Comment = 'ESP="Id colegio"';
        }
        field(4; id_pagador; Text[50])
        {
            Caption = 'Payer Id', Comment = 'ESP="Id pagador"';
        }
        field(5; id_unique_pagador; Text[50])
        {
            Caption = 'Unique Payer Id', Comment = 'ESP="Id único pagador"';
        }
        field(6; nombre_pagador; Text[50])
        {
            Caption = 'Payer Name', Comment = 'ESP="Nombre pagador"';
        }
        field(7; apellidos_pagador; Text[50])
        {
            Caption = 'Payer Surnames', Comment = 'ESP="Apellidos pagador"';
        }
        field(8; nif_pagador; Text[50])
        {
            Caption = 'Payer Tax Id', Comment = 'ESP="NIF pagador"';
        }
        field(9; cuenta_pagador; Text[50])
        {
            Caption = 'Payer Account', Comment = 'ESP="Cuenta pagador"';
        }
        field(10; cuenta_pagador_IBAN; Text[50])
        {
            Caption = 'Payer IBAN', Comment = 'ESP="IBAN cuenta pagador"';
        }
        field(11; cantidad; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Cantidad"';
        }
        field(12; cuenta_contable; Text[50])
        {
            Caption = 'G/L Account', Comment = 'ESP="Cuenta contable"';
        }
        field(13; fecha_creacion; Text[50])
        {
            Caption = 'Creation Date', Comment = 'ESP="Fecha creación"';
        }
        field(14; fecha_valor; Text[50])
        {
            Caption = 'Value Date', Comment = 'ESP="Fecha valor"';
        }
        field(15; id_alumno; Text[50])
        {
            Caption = 'Student Id', Comment = 'ESP="Id alumno"';
        }
        field(16; id_unique_alumno; Text[50])
        {
            Caption = 'Unique Student Id', Comment = 'ESP="Id único alumno"';
        }
        field(17; nombre_alumno; Text[50])
        {
            Caption = 'Student Name', Comment = 'ESP="Nombre alumno"';
        }
        field(18; ape1_alumno; Text[50])
        {
            Caption = 'Student First Surname', Comment = 'ESP="Primer apellido alumno"';
        }
        field(19; ape2_alumno; Text[50])
        {
            Caption = 'Student Second Surname', Comment = 'ESP="Segundo apellido alumno"';
        }
        field(20; clase_alumno; Text[50])
        {
            Caption = 'Student Class', Comment = 'ESP="Clase alumno"';
        }
        field(21; primera_sincronizacion; Text[50])
        {
            Caption = 'First Synchronization', Comment = 'ESP="Primera sincronización"';
        }
        field(22; "Importation DateTime"; DateTime)
        {
            Caption = 'Importation DateTime', Comment = 'ESP="FechaHora importación"';
        }
        field(23; Processed; Boolean)
        {
            Caption = 'Processed', Comment = 'ESP="Procesado"';
        }
    }

    keys
    {
        key(Key1; id_unique_ingreso)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
