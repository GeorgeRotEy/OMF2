page 50053 "EDUCAMOS AlumnoConcepto"
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos
    Caption = 'EDUCAMOS Student Concept', Comment = 'ESP="EDUCAMOS AlumnoConcepto"';
    Editable = false;
    PageType = List;
    SourceTable = "EDUCAMOS AlumnoConcepto";
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
                field(nombre_concepto; Rec.nombre_concepto)
                {
                }
                field(reducido_concepto; Rec.reducido_concepto)
                {
                }
                field(cuenta_contable; Rec.cuenta_contable)
                {
                }
                field(tipo_movimiento_contable; Rec.tipo_movimiento_contable)
                {
                }
                field(centro_coste; Rec.centro_coste)
                {
                }
                field(estado_concepto; Rec.estado_concepto)
                {
                }
                field(fecha_pago; Rec.fecha_pago)
                {
                }
                field(importe_neto; Rec.importe_neto)
                {
                }
                field(importe_pdte; Rec.importe_pdte)
                {
                }
                field(importe_pagado; Rec.importe_pagado)
                {
                }
                field(porcentaje_IVA; Rec.porcentaje_IVA)
                {
                }
                field(secuencia; Rec.secuencia)
                {
                }
                field(secuencia_unique; Rec.secuencia_unique)
                {
                }
                field(carga; Rec.carga)
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

    //TODO-MIG: La página 50208 no existe en producción
    // actions
    // {
    //     area(navigation)
    //     {
    //         action("Concepto Descuento")
    //         {
    //             Image = Splitlines;
    //             RunObject = Page 50208;
    //             RunPageLink = Field2 = FIELD(id_unique_recibo),
    //                           Field4 = FIELD(id_unique_alumno),
    //                           Field6 = FIELD(id_unique_concepto);
    //             RunPageView = SORTING(Field2, Field8)
    //                           ORDER(Ascending);
    //         }
    //     }
    // }
}
