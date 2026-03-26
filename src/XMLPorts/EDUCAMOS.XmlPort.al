xmlport 50006 EDUCAMOS
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    schema
    {
        textelement(root)
        {
            textelement(root2)
            {
                XmlName = 'root';
                tableelement("EDUCAMOS IngresoCuenta"; "EDUCAMOS IngresoCuenta")
                {
                    MinOccurs = Zero;
                    XmlName = 'IngresoCuenta';
                    fieldelement(id_ingreso; "EDUCAMOS IngresoCuenta".id_ingreso)
                    {
                    }
                    fieldelement(id_unique_ingreso; "EDUCAMOS IngresoCuenta".id_unique_ingreso)
                    {
                    }
                    fieldelement(id_colegio; "EDUCAMOS IngresoCuenta".id_colegio)
                    {
                    }
                    fieldelement(id_pagador; "EDUCAMOS IngresoCuenta".id_pagador)
                    {
                    }
                    fieldelement(id_unique_pagador; "EDUCAMOS IngresoCuenta".id_unique_pagador)
                    {
                    }
                    fieldelement(nombre_pagador; "EDUCAMOS IngresoCuenta".nombre_pagador)
                    {
                    }
                    fieldelement(apellidos_pagador; "EDUCAMOS IngresoCuenta".apellidos_pagador)
                    {
                    }
                    fieldelement(nif_pagador; "EDUCAMOS IngresoCuenta".nif_pagador)
                    {
                    }
                    fieldelement(cuenta_pagador; "EDUCAMOS IngresoCuenta".cuenta_pagador)
                    {
                    }
                    fieldelement(cuenta_pagador_IBAN; "EDUCAMOS IngresoCuenta".cuenta_pagador_IBAN)
                    {
                    }
                    fieldelement(cantidad; "EDUCAMOS IngresoCuenta".cantidad)
                    {
                    }
                    fieldelement(cuenta_contable; "EDUCAMOS IngresoCuenta".cuenta_contable)
                    {
                    }
                    fieldelement(fecha_creacion; "EDUCAMOS IngresoCuenta".fecha_creacion)
                    {
                    }
                    fieldelement(fecha_valor; "EDUCAMOS IngresoCuenta".fecha_valor)
                    {
                    }
                    fieldelement(id_alumno; "EDUCAMOS IngresoCuenta".id_alumno)
                    {
                    }
                    fieldelement(id_unique_alumno; "EDUCAMOS IngresoCuenta".id_unique_alumno)
                    {
                    }
                    fieldelement(nombre_alumno; "EDUCAMOS IngresoCuenta".nombre_alumno)
                    {
                    }
                    fieldelement(ape1_alumno; "EDUCAMOS IngresoCuenta".ape1_alumno)
                    {
                    }
                    fieldelement(ape2_alumno; "EDUCAMOS IngresoCuenta".ape2_alumno)
                    {
                    }
                    fieldelement(clase_alumno; "EDUCAMOS IngresoCuenta".clase_alumno)
                    {
                    }
                    fieldelement(primera_sincronizacion; "EDUCAMOS IngresoCuenta".primera_sincronizacion)
                    {
                    }

                    trigger OnAfterInsertRecord()
                    begin
                        "EDUCAMOS IngresoCuenta"."Importation DateTime" := CURRENTDATETIME;
                        "EDUCAMOS IngresoCuenta".Processed := FALSE;
                        "EDUCAMOS IngresoCuenta".MODIFY;
                    end;

                    trigger OnAfterModifyRecord()
                    begin
                        "EDUCAMOS IngresoCuenta"."Importation DateTime" := CURRENTDATETIME;
                        "EDUCAMOS IngresoCuenta".Processed := FALSE;
                        "EDUCAMOS IngresoCuenta".MODIFY;
                    end;
                }
                tableelement("EDUCAMOS Remesa"; "EDUCAMOS Remesa")
                {
                    AutoReplace = true;
                    XmlName = 'Remesa';
                    fieldelement(id_remesa; "EDUCAMOS Remesa".id_remesa)
                    {
                    }
                    fieldelement(id_unique_remesa; "EDUCAMOS Remesa".id_unique_remesa)
                    {
                    }
                    fieldelement(id_colegio; "EDUCAMOS Remesa".id_colegio)
                    {
                    }
                    fieldelement(primeraSincroContab; "EDUCAMOS Remesa".primeraSincroContab)
                    {
                    }
                    fieldelement(id_ordenante; "EDUCAMOS Remesa".id_ordenante)
                    {
                    }
                    fieldelement(id_unique_ordenante; "EDUCAMOS Remesa".id_unique_ordenante)
                    {
                    }
                    fieldelement(nombre_ordenante; "EDUCAMOS Remesa".nombre_ordenante)
                    {
                    }
                    fieldelement(reducido_ordenante; "EDUCAMOS Remesa".reducido_ordenante)
                    {
                    }
                    fieldelement(cif_ordenante; "EDUCAMOS Remesa".cif_ordenante)
                    {
                    }
                    fieldelement(id_presentador; "EDUCAMOS Remesa".id_presentador)
                    {
                    }
                    fieldelement(id_unique_presentador; "EDUCAMOS Remesa".id_unique_presentador)
                    {
                    }
                    fieldelement(nombre_presentador; "EDUCAMOS Remesa".nombre_presentador)
                    {
                    }
                    fieldelement(nif_presentador; "EDUCAMOS Remesa".nif_presentador)
                    {
                    }
                    fieldelement(cuenta_presentador; "EDUCAMOS Remesa".cuenta_presentador)
                    {
                    }
                    fieldelement(cuenta_presentador_IBAN; "EDUCAMOS Remesa".cuenta_presentador_IBAN)
                    {
                    }
                    fieldelement(fecha_creacion; "EDUCAMOS Remesa".fecha_creacion)
                    {
                    }
                    fieldelement(fecha_emision; "EDUCAMOS Remesa".fecha_emision)
                    {
                    }
                    fieldelement(fecha_cargo; "EDUCAMOS Remesa".fecha_cargo)
                    {
                    }
                    fieldelement(accion; "EDUCAMOS Remesa".accion)
                    {
                    }
                    fieldelement(calendario; "EDUCAMOS Remesa".calendario)
                    {
                    }

                    trigger OnAfterInsertRecord()
                    begin
                        "EDUCAMOS Remesa"."Importation DateTime" := CURRENTDATETIME;
                        "EDUCAMOS Remesa".Processed := FALSE;
                        "EDUCAMOS Remesa".MODIFY;
                    end;

                    trigger OnAfterModifyRecord()
                    begin
                        "EDUCAMOS Remesa"."Importation DateTime" := CURRENTDATETIME;
                        "EDUCAMOS Remesa".Processed := FALSE;
                        "EDUCAMOS Remesa".MODIFY;
                    end;
                }
                tableelement("EDUCAMOS RemesaRecibo"; "EDUCAMOS RemesaRecibo")
                {
                    AutoReplace = true;
                    XmlName = 'RemesaRecibo';
                    fieldelement(id_remesa; "EDUCAMOS RemesaRecibo".id_remesa)
                    {
                    }
                    fieldelement(id_unique_remesa; "EDUCAMOS RemesaRecibo".id_unique_remesa)
                    {
                    }
                    fieldelement(id_recibo; "EDUCAMOS RemesaRecibo".id_recibo)
                    {
                    }
                    fieldelement(id_unique_recibo; "EDUCAMOS RemesaRecibo".id_unique_recibo)
                    {
                    }
                    fieldelement(numero_recibo; "EDUCAMOS RemesaRecibo".numero_recibo)
                    {
                    }
                    fieldelement(estado_recibo; "EDUCAMOS RemesaRecibo".estado_recibo)
                    {
                    }
                    fieldelement(tipo_recibo; "EDUCAMOS RemesaRecibo".tipo_recibo)
                    {
                    }
                    fieldelement(id_pagador; "EDUCAMOS RemesaRecibo".id_pagador)
                    {
                    }
                    fieldelement(id_unique_pagador; "EDUCAMOS RemesaRecibo".id_unique_pagador)
                    {
                    }
                    fieldelement(nombre_pagador; "EDUCAMOS RemesaRecibo".nombre_pagador)
                    {
                    }
                    fieldelement(apellidos_pagador; "EDUCAMOS RemesaRecibo".apellidos_pagador)
                    {
                    }
                    fieldelement(nif_pagador; "EDUCAMOS RemesaRecibo".nif_pagador)
                    {
                    }
                    fieldelement(direccion_pagador; "EDUCAMOS RemesaRecibo".direccion_pagador)
                    {
                    }
                    fieldelement(localidad_pagador; "EDUCAMOS RemesaRecibo".localidad_pagador)
                    {
                    }
                    fieldelement(cp_pagador; "EDUCAMOS RemesaRecibo".cp_pagador)
                    {
                    }
                    fieldelement(provincia_pagador; "EDUCAMOS RemesaRecibo".provincia_pagador)
                    {
                    }
                    fieldelement(cuenta_pagador; "EDUCAMOS RemesaRecibo".cuenta_pagador)
                    {
                    }
                    fieldelement(cuenta_pagador_IBAN; "EDUCAMOS RemesaRecibo".cuenta_pagador_IBAN)
                    {
                    }
                    fieldelement(fecha_cambio_estado; "EDUCAMOS RemesaRecibo".fecha_cambio_estado)
                    {
                    }
                    fieldelement(estado_actual; "EDUCAMOS RemesaRecibo".estado_actual)
                    {
                    }

                    trigger OnAfterInsertRecord()
                    begin
                        "EDUCAMOS RemesaRecibo"."Importation DateTime" := CURRENTDATETIME;
                        "EDUCAMOS RemesaRecibo".Processed := FALSE;
                        "EDUCAMOS RemesaRecibo".MODIFY;
                    end;

                    trigger OnAfterModifyRecord()
                    begin
                        "EDUCAMOS RemesaRecibo"."Importation DateTime" := CURRENTDATETIME;
                        "EDUCAMOS RemesaRecibo".Processed := FALSE;
                        "EDUCAMOS RemesaRecibo".MODIFY;
                    end;
                }
                tableelement("EDUCAMOS ReciboAlumno"; "EDUCAMOS ReciboAlumno")
                {
                    AutoReplace = true;
                    XmlName = 'ReciboAlumno';
                    fieldelement(id_recibo; "EDUCAMOS ReciboAlumno".id_recibo)
                    {
                    }
                    fieldelement(id_unique_recibo; "EDUCAMOS ReciboAlumno".id_unique_recibo)
                    {
                    }
                    fieldelement(id_alumno; "EDUCAMOS ReciboAlumno".id_alumno)
                    {
                    }
                    fieldelement(id_unique_alumno; "EDUCAMOS ReciboAlumno".id_unique_alumno)
                    {
                    }
                    fieldelement(nombre_alumno; "EDUCAMOS ReciboAlumno".nombre_alumno)
                    {
                    }
                    fieldelement(ape1_alumno; "EDUCAMOS ReciboAlumno".ape1_alumno)
                    {
                    }
                    fieldelement(ape2_alumno; "EDUCAMOS ReciboAlumno".ape2_alumno)
                    {
                    }
                    fieldelement(nif_alumno; "EDUCAMOS ReciboAlumno".nif_alumno)
                    {
                    }

                    trigger OnAfterInsertRecord()
                    begin
                        "EDUCAMOS ReciboAlumno"."Importation DateTime" := CURRENTDATETIME;
                        "EDUCAMOS ReciboAlumno".Processed := FALSE;
                        "EDUCAMOS ReciboAlumno".MODIFY;
                    end;

                    trigger OnAfterModifyRecord()
                    begin
                        "EDUCAMOS ReciboAlumno"."Importation DateTime" := CURRENTDATETIME;
                        "EDUCAMOS ReciboAlumno".Processed := FALSE;
                        "EDUCAMOS ReciboAlumno".MODIFY;
                    end;
                }
                tableelement("EDUCAMOS AlumnoConcepto"; "EDUCAMOS AlumnoConcepto")
                {
                    AutoReplace = true;
                    XmlName = 'AlumnoConcepto';
                    fieldelement(id_recibo; "EDUCAMOS AlumnoConcepto".id_recibo)
                    {
                    }
                    fieldelement(id_unique_recibo; "EDUCAMOS AlumnoConcepto".id_unique_recibo)
                    {
                    }
                    fieldelement(id_alumno; "EDUCAMOS AlumnoConcepto".id_alumno)
                    {
                    }
                    fieldelement(id_unique_alumno; "EDUCAMOS AlumnoConcepto".id_unique_alumno)
                    {
                    }
                    fieldelement(id_concepto; "EDUCAMOS AlumnoConcepto".id_concepto)
                    {
                    }
                    fieldelement(id_unique_concepto; "EDUCAMOS AlumnoConcepto".id_unique_concepto)
                    {
                    }
                    fieldelement(nombre_concepto; "EDUCAMOS AlumnoConcepto".nombre_concepto)
                    {
                    }
                    fieldelement(reducido_concepto; "EDUCAMOS AlumnoConcepto".reducido_concepto)
                    {
                    }
                    fieldelement(cuenta_contable; "EDUCAMOS AlumnoConcepto".cuenta_contable)
                    {
                    }
                    fieldelement(tipo_movimiento_contable; "EDUCAMOS AlumnoConcepto".tipo_movimiento_contable)
                    {
                    }
                    fieldelement(centro_coste; "EDUCAMOS AlumnoConcepto".centro_coste)
                    {
                    }
                    fieldelement(estado_concepto; "EDUCAMOS AlumnoConcepto".estado_concepto)
                    {
                    }
                    fieldelement(fecha_pago; "EDUCAMOS AlumnoConcepto".fecha_pago)
                    {
                    }
                    textelement(importe_neto)
                    {
                    }
                    textelement(importe_pdte)
                    {
                    }
                    textelement(importe_pagado)
                    {
                    }
                    fieldelement(porcentaje_IVA; "EDUCAMOS AlumnoConcepto".porcentaje_IVA)
                    {
                    }
                    fieldelement(secuencia; "EDUCAMOS AlumnoConcepto".secuencia)
                    {
                    }
                    fieldelement(secuencia_unique; "EDUCAMOS AlumnoConcepto".secuencia_unique)
                    {
                    }
                    fieldelement(carga; "EDUCAMOS AlumnoConcepto".carga)
                    {
                    }

                    trigger OnAfterInsertRecord()
                    begin
                        "EDUCAMOS AlumnoConcepto"."Importation DateTime" := CURRENTDATETIME;
                        EVALUATE("EDUCAMOS AlumnoConcepto".importe_neto, CONVERTSTR(importe_neto, '.', ','));
                        EVALUATE("EDUCAMOS AlumnoConcepto".importe_pagado, CONVERTSTR(importe_pagado, '.', ','));
                        EVALUATE("EDUCAMOS AlumnoConcepto".importe_pdte, CONVERTSTR(importe_pdte, '.', ','));
                        "EDUCAMOS AlumnoConcepto".Processed := FALSE;

                        "EDUCAMOS AlumnoConcepto".MODIFY;
                    end;

                    trigger OnAfterModifyRecord()
                    begin
                        "EDUCAMOS AlumnoConcepto"."Importation DateTime" := CURRENTDATETIME;
                        EVALUATE("EDUCAMOS AlumnoConcepto".importe_neto, CONVERTSTR(importe_neto, '.', ','));
                        EVALUATE("EDUCAMOS AlumnoConcepto".importe_pagado, CONVERTSTR(importe_pagado, '.', ','));
                        EVALUATE("EDUCAMOS AlumnoConcepto".importe_pdte, CONVERTSTR(importe_pdte, '.', ','));
                        "EDUCAMOS AlumnoConcepto".Processed := FALSE;

                        "EDUCAMOS AlumnoConcepto".MODIFY;
                    end;
                }
                tableelement("EDUCAMOS ConceptoDescuento"; "EDUCAMOS ConceptoDescuento")
                {
                    AutoReplace = true;
                    MinOccurs = Zero;
                    XmlName = 'ConceptoDescuento';
                    fieldelement(id_recibo; "EDUCAMOS ConceptoDescuento".id_recibo)
                    {
                    }
                    fieldelement(id_unique_recibo; "EDUCAMOS ConceptoDescuento".id_unique_recibo)
                    {
                    }
                    fieldelement(id_alumno; "EDUCAMOS ConceptoDescuento".id_alumno)
                    {
                    }
                    fieldelement(id_unique_alumno; "EDUCAMOS ConceptoDescuento".id_unique_alumno)
                    {
                    }
                    fieldelement(id_concepto; "EDUCAMOS ConceptoDescuento".id_concepto)
                    {
                    }
                    fieldelement(id_unique_concepto; "EDUCAMOS ConceptoDescuento".id_unique_concepto)
                    {
                    }
                    fieldelement(id_descuento; "EDUCAMOS ConceptoDescuento".id_descuento)
                    {
                    }
                    fieldelement(id_unique_descuento; "EDUCAMOS ConceptoDescuento".id_unique_descuento)
                    {
                    }
                    fieldelement(nombre_descuento; "EDUCAMOS ConceptoDescuento".nombre_descuento)
                    {
                    }
                    fieldelement(reducido_descuento; "EDUCAMOS ConceptoDescuento".reducido_descuento)
                    {
                    }
                    textelement(cantidad_descuento)
                    {
                    }
                    fieldelement(cuenta_contable; "EDUCAMOS ConceptoDescuento".cuenta_contable)
                    {
                    }
                    fieldelement(tipo_movimiento_contable; "EDUCAMOS ConceptoDescuento".tipo_movimiento_contable)
                    {
                    }

                    trigger OnAfterInsertRecord()
                    begin
                        "EDUCAMOS ConceptoDescuento"."Importation DateTime" := CURRENTDATETIME;
                        EVALUATE("EDUCAMOS ConceptoDescuento".cantidad_descuento, CONVERTSTR(cantidad_descuento, '.', ','));
                        "EDUCAMOS ConceptoDescuento".Processed := FALSE;

                        "EDUCAMOS ConceptoDescuento".MODIFY;
                    end;

                    trigger OnAfterModifyRecord()
                    begin
                        "EDUCAMOS ConceptoDescuento"."Importation DateTime" := CURRENTDATETIME;
                        EVALUATE("EDUCAMOS ConceptoDescuento".cantidad_descuento, CONVERTSTR(cantidad_descuento, '.', ','));
                        "EDUCAMOS ConceptoDescuento".Processed := FALSE;

                        "EDUCAMOS ConceptoDescuento".MODIFY;
                    end;
                }
            }
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
}
