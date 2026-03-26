page 50050 "EDUCAMOS Remesa"
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    Editable = false;
    Caption = 'EDUCAMOS Remittance', Comment = 'ESP="EDUCAMOS Remesa"';
    PageType = List;
    SourceTable = "EDUCAMOS Remesa";
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
                field(id_colegio; Rec.id_colegio)
                {
                }
                field(primeraSincroContab; Rec.primeraSincroContab)
                {
                }
                field(id_ordenante; Rec.id_ordenante)
                {
                }
                field(id_unique_ordenante; Rec.id_unique_ordenante)
                {
                }
                field(nombre_ordenante; Rec.nombre_ordenante)
                {
                }
                field(reducido_ordenante; Rec.reducido_ordenante)
                {
                }
                field(cif_ordenante; Rec.cif_ordenante)
                {
                }
                field(id_presentador; Rec.id_presentador)
                {
                }
                field(id_unique_presentador; Rec.id_unique_presentador)
                {
                }
                field(nombre_presentador; Rec.nombre_presentador)
                {
                }
                field(nif_presentador; Rec.nif_presentador)
                {
                }
                field(cuenta_presentador; Rec.cuenta_presentador)
                {
                }
                field(cuenta_presentador_IBAN; Rec.cuenta_presentador_IBAN)
                {
                }
                field(fecha_creacion; Rec.fecha_creacion)
                {
                }
                field(fecha_emision; Rec.fecha_emision)
                {
                }
                field(fecha_cargo; Rec.fecha_cargo)
                {
                }
                field(accion; Rec.accion)
                {
                }
                field(calendario; Rec.calendario)
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

    //TODO-MIG: no existe la página 50201 en producción
    // actions
    // {
    //     area(navigation)
    //     {
    //         action("Remesas Recibo")
    //         {
    //             Image = Splitlines;
    //             RunObject = Page 50201;
    //             RunPageLink = Field2 = FIELD(id_unique_remesa);
    //             RunPageView = SORTING(Field2, Field4)
    //                           ORDER(Ascending);
    //         }
    //     }
    // }
}
