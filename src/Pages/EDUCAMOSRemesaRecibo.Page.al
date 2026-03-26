page 50051 "EDUCAMOS RemesaRecibo"
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos
    Caption = 'EDUCAMOS Remittance Receipt', Comment = 'ESP="EDUCAMOS RemesaRecibo"';
    Editable = false;
    PageType = List;
    SourceTable = "EDUCAMOS RemesaRecibo";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id_remesa; Rec.id_remesa)
                {
                }
                field(id_unique_remesa; Rec.id_unique_remesa)
                {
                }
                field(id_recibo; Rec.id_recibo)
                {
                }
                field(id_unique_recibo; Rec.id_unique_recibo)
                {
                }
                field(numero_recibo; Rec.numero_recibo)
                {
                }
                field(estado_recibo; Rec.estado_recibo)
                {
                }
                field(tipo_recibo; Rec.tipo_recibo)
                {
                }
                field(id_pagador; Rec.id_pagador)
                {
                }
                field(id_unique_pagador; Rec.id_unique_pagador)
                {
                }
                field(nombre_pagador; Rec.nombre_pagador)
                {
                }
                field(apellidos_pagador; Rec.apellidos_pagador)
                {
                }
                field(nif_pagador; Rec.nif_pagador)
                {
                }
                field(direccion_pagador; Rec.direccion_pagador)
                {
                }
                field(localidad_pagador; Rec.localidad_pagador)
                {
                }
                field(cp_pagador; Rec.cp_pagador)
                {
                }
                field(provincia_pagador; Rec.provincia_pagador)
                {
                }
                field(cuenta_pagador; Rec.cuenta_pagador)
                {
                }
                field(cuenta_pagador_IBAN; Rec.cuenta_pagador_IBAN)
                {
                }
                field(fecha_cambio_estado; Rec.fecha_cambio_estado)
                {
                }
                field(estado_actual; Rec.estado_actual)
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

    //TODO-MIG: No existen las páginas 50202 ni 50203 en producción
    // actions
    // {
    //     area(navigation)
    //     {
    //         action("Recibo Alumno")
    //         {
    //             Image = Splitlines;
    //             RunObject = Page 50202;
    //             RunPageLink = Field2 = FIELD(id_unique_recibo);
    //             RunPageView = SORTING(Field2, Field4)
    //                           ORDER(Ascending);
    //         }
    //         action("Alumno Concepto")
    //         {
    //             Image = Splitlines;
    //             RunObject = Page 50203;
    //             RunPageLink = Field2 = FIELD(id_unique_recibo);
    //             RunPageView = SORTING(Field2, Field4, Field6)
    //                           ORDER(Ascending);
    //         }
    //     }
    // }
}
