page 50058 "EDUCAMOS ConceptoDescuento"
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    Editable = false;
    Caption = 'EDUCAMOS Discount Concept', Comment = 'ESP="EDUCAMOS ConceptoDescuento"';
    PageType = List;
    SourceTable = "EDUCAMOS ConceptoDescuento";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id_recibo; Rec.id_recibo)
                {
                }
                field(id_unique_recibo; Rec.id_unique_recibo)
                {
                }
                field(id_alumno; Rec.id_alumno)
                {
                }
                field(id_unique_alumno; Rec.id_unique_alumno)
                {
                }
                field(id_concepto; Rec.id_concepto)
                {
                }
                field(id_unique_concepto; Rec.id_unique_concepto)
                {
                }
                field(id_descuento; Rec.id_descuento)
                {
                }
                field(id_unique_descuento; Rec.id_unique_descuento)
                {
                }
                field(nombre_descuento; Rec.nombre_descuento)
                {
                }
                field(reducido_descuento; Rec.reducido_descuento)
                {
                }
                field(cantidad_descuento; Rec.cantidad_descuento)
                {
                }
                field(cuenta_contable; Rec.cuenta_contable)
                {
                }
                field(tipo_movimiento_contable; Rec.tipo_movimiento_contable)
                {
                }
                field("Importation DateTime"; Rec."Importation DateTime")
                {
                }
                field(Processed; Rec.Processed)
                {
                }
            }
        }
    }

    actions
    {
    }
}
