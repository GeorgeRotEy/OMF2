table 50203 "EDUCAMOS AlumnoConcepto" //EDUCAMOS
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    fields
    {
        field(1; id_recibo; Text[30])
        {
            Caption = 'Receipt ID', Comment = 'ESP="Id recibo"';
        }
        field(2; id_unique_recibo; Text[50])
        {
            Caption = 'Unique Receipt ID', Comment = 'ESP="Id único recibo"';
        }
        field(3; id_alumno; Text[30])
        {
            Caption = 'Student ID', Comment = 'ESP="Id alumno"';
        }
        field(4; id_unique_alumno; Text[50])
        {
            Caption = 'Unique Student ID', Comment = 'ESP="Id único alumno"';
        }
        field(5; id_concepto; Text[30])
        {
            Caption = 'Concept ID', Comment = 'ESP="Id concepto"';
        }
        field(6; id_unique_concepto; Text[50])
        {
            Caption = 'Unique Concept ID', Comment = 'ESP="Id único concepto"';
        }
        field(7; nombre_concepto; Text[100])
        {
            Caption = 'Concept Name', Comment = 'ESP="Nombre concepto"';
        }
        field(8; reducido_concepto; Text[50])
        {
            Caption = 'Concept Short Name', Comment = 'ESP="Nombre reducido concepto"';
        }
        field(9; cuenta_contable; Text[50])
        {
            Caption = 'G/L Account', Comment = 'ESP="Cuenta contable"';
        }
        field(10; tipo_movimiento_contable; Integer)
        {
            Caption = 'Accounting Movement Type', Comment = 'ESP="Tipo movimiento contable"';
        }
        field(11; centro_coste; Text[50])
        {
            Caption = 'Cost Center', Comment = 'ESP="Centro de coste"';
        }
        field(12; estado_concepto; Integer)
        {
            Caption = 'Concept Status', Comment = 'ESP="Estado concepto"';
        }
        field(13; fecha_pago; Text[30])
        {
            Caption = 'Payment Date', Comment = 'ESP="Fecha de pago"';
        }
        field(14; importe_neto; Decimal)
        {
            Caption = 'Net Amount', Comment = 'ESP="Importe neto"';
        }
        field(15; importe_pdte; Decimal)
        {
            Caption = 'Pending Amount', Comment = 'ESP="Importe pendiente"';
        }
        field(16; importe_pagado; Decimal)
        {
            Caption = 'Paid Amount', Comment = 'ESP="Importe pagado"';
        }
        field(17; porcentaje_IVA; Decimal)
        {
            Caption = 'VAT Percentage', Comment = 'ESP="Porcentaje IVA"';
        }
        field(18; secuencia; Integer)
        {
            Caption = 'Sequence', Comment = 'ESP="Secuencia"';
        }
        field(19; secuencia_unique; Text[250])
        {
            Caption = 'Unique Sequence', Comment = 'ESP="Secuencia única"';
        }
        field(20; carga; Integer)
        {
            Caption = 'Load', Comment = 'ESP="Carga"';
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
        key(Key1; id_unique_recibo, id_unique_alumno, id_unique_concepto)
        {
            Clustered = true;
        }
        key(Key2; Processed, id_unique_recibo)
        {
        }
    }

    fieldgroups
    {
    }
}
