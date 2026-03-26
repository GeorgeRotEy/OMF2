table 50208 "EDUCAMOS ConceptoDescuento" //EDUCAMOS
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    fields
    {
        field(1; id_recibo; Text[30])
        {
            Caption = 'Receipt ID', Comment = 'ESP="id_recibo"';
        }
        field(2; id_unique_recibo; Text[50])
        {
            Caption = 'Unique Receipt ID', Comment = 'ESP="id_unique_recibo"';
        }
        field(3; id_alumno; Text[30])
        {
            Caption = 'Student ID', Comment = 'ESP="id_alumno"';
        }
        field(4; id_unique_alumno; Text[50])
        {
            Caption = 'Unique Student ID', Comment = 'ESP="id_unique_alumno"';
        }
        field(5; id_concepto; Text[30])
        {
            Caption = 'Concept ID', Comment = 'ESP="id_concepto"';
        }
        field(6; id_unique_concepto; Text[50])
        {
            Caption = 'Unique Concept ID', Comment = 'ESP="id_unique_concepto"';
        }
        field(7; id_descuento; Text[30])
        {
            Caption = 'Discount ID', Comment = 'ESP="id_descuento"';
        }
        field(8; id_unique_descuento; Text[50])
        {
            Caption = 'Unique Discount ID', Comment = 'ESP="id_unique_descuento"';
        }
        field(9; nombre_descuento; Text[50])
        {
            Caption = 'Discount Name', Comment = 'ESP="nombre_descuento"';
        }
        field(10; reducido_descuento; Text[50])
        {
            Caption = 'Discount Short Name', Comment = 'ESP="reducido_descuento"';
        }
        field(11; cantidad_descuento; Decimal)
        {
            Caption = 'Discount Amount', Comment = 'ESP="cantidad_descuento"';
        }
        field(12; cuenta_contable; Text[50])
        {
            Caption = 'G/L Account', Comment = 'ESP="cuenta_contable"';
        }
        field(13; tipo_movimiento_contable; Integer)
        {
            Caption = 'Accounting Movement Type', Comment = 'ESP="tipo_movimiento_contable"';
        }
        field(30; "Importation DateTime"; DateTime)
        {
            Caption = 'Import DateTime', Comment = 'ESP="FechaHora importación"';
        }
        field(31; Processed; Boolean)
        {
            Caption = 'Processed', Comment = 'ESP="Procesado"';
        }
    }

    keys
    {
        key(Key1; id_unique_recibo, id_unique_concepto, id_unique_descuento)
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
