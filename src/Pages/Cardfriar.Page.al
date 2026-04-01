page 50008 "Card friar"
{
    Caption = 'Friar Card', Comment = 'ESP="Ficha Hermano"';
    PageType = Document;
    SourceTable = Friar;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';

                field("No. Serie Friar"; Rec."No. Serie Friar")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Name_Rel; Rec.Name_Rel)
                {
                }
                field(Apellidos; Rec.Apellidos)
                {
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                }
                field(Padres; Rec.Padres)
                {
                }
                field(Idiomas; Rec.Idiomas)
                {
                }
                group(Contacto)
                {
                    Caption = 'Contact', Comment = 'ESP="Contacto"';

                    field(Movil; Rec.Movil)
                    {
                    }
                    field(Mail; Rec.Mail)
                    {
                    }
                }
                group(Fraternidad)
                {
                    Caption = 'Fraternity', Comment = 'ESP="Fraternidad"';

                    field("Ultimo Destino"; UltimoDestino)
                    {
                        Caption = 'Last Destination', Comment = 'ESP="Último destino"';
                        Editable = true;
                    }
                    field("Población"; PoblacionDestinoHermano)
                    {
                        Editable = true;
                    }
                    field("Extra Domum"; Extradomum)
                    {
                        Caption = 'Extra Domum', Comment = 'ESP="Extra Domum"';
                        Editable = false;
                    }
                }
                group("Cargo/Oficio")
                {
                    Caption = 'Role/Office', Comment = 'ESP="Cargo/Oficio"';

                    field("Guardián Check"; Rec."Guardián Check")
                    {
                        Caption = 'Guardian', Comment = 'ESP="Guardián"';
                    }
                    field("Vicario Local Check"; Rec."Vicario Local Check")
                    {
                        Caption = 'Local Vicar', Comment = 'ESP="Vicario Local"';
                    }
                    field("Ecónomo Check"; Rec."Ecónomo Check")
                    {
                        Caption = 'Bursar', Comment = 'ESP="Ecónomo"';
                    }
                    field("Capellán Check"; Rec."Capellán Check")
                    {
                        Caption = 'Chaplain', Comment = 'ESP="Capellán"';
                    }
                    field("Párroco Check"; Rec."Párroco Check")
                    {
                        Caption = 'Parish Priest', Comment = 'ESP="Párroco"';
                    }
                    field("Vicario Parroquial Check"; Rec."Vicario Parroquial Check")
                    {
                        Caption = 'Parochial Vicar', Comment = 'ESP="Vicario Parroquial"';
                    }
                }
                group("Publicaciones:")
                {
                    Caption = 'Publications', Comment = 'ESP="Publicaciones"';

                    field("Publicaciones check"; Rec."Publicaciones check")
                    {
                        Caption = 'Publications', Comment = 'ESP="Publicaciones"';
                        Editable = false;
                    }
                }
            }
            group("Información Personal")
            {
                Caption = 'Personal Information', Comment = 'ESP="Información personal"';

                group(Nacimiento)
                {
                    Caption = 'Birth', Comment = 'ESP="Nacimiento"';

                    field(Fecha_Nac; Rec.Fecha_Nac)
                    {
                    }
                    field(Lugar_Nac; Rec.Lugar_Nac)
                    {
                    }
                    field(Prov_Nac; Rec.Prov_Nac)
                    {
                    }
                    field(Pais_Nac; Rec.Pais_Nac)
                    {
                    }
                    field(Estado; Rec.Estado)
                    {
                    }
                }
                group("Defunción")
                {
                    Caption = 'Death', Comment = 'ESP="Defunción"';

                    field(Defunc_Fecha; Rec.Defunc_Fecha)
                    {
                    }
                    field(Defunc_Lugar; Rec.Defunc_Lugar)
                    {
                    }
                    field("Necrol. Defunción"; Rec."Necrol. Defunción")
                    {
                        Editable = false;
                    }
                    field(Opciones; Rec.Opciones)
                    {
                        Enabled = true;
                        Visible = false;
                    }
                }
            }
            group("Registros sacramentales")
            {
                Caption = 'Sacramental Records', Comment = 'ESP="Registros sacramentales"';

                group(Bautismo)
                {
                    Caption = 'Baptism', Comment = 'ESP="Bautismo"';

                    field(Fecha_Bau; Rec.Fecha_Bau)
                    {
                    }
                    field(Parroquia_Bau; Rec.Parroquia_Bau)
                    {
                    }
                    field(Ciudad_Bau; Rec.Ciudad_Bau)
                    {
                    }
                    field(Diocesis_Bau; Rec.Diocesis_Bau)
                    {
                    }
                }
                group("Confirmación")
                {
                    Caption = 'Confirmation', Comment = 'ESP="Confirmación"';

                    field(Fecha_Conf; Rec.Fecha_Conf)
                    {
                    }
                    field(Parroquia_Conf; Rec.Parroquia_Conf)
                    {
                    }
                    field(Ciudad_Conf; Rec.Ciudad_Conf)
                    {
                    }
                    field(Diocesis_Conf; Rec.Diocesis_Conf)
                    {
                    }
                }
            }
            group("Evolución de la Orden")
            {
                Caption = 'Order Progress', Comment = 'ESP="Evolución de la Orden"';

                group(Fecha)
                {
                    Caption = 'Dates', Comment = 'ESP="Fechas"';

                    field(Fecha_Sem_Menor; Rec.Fecha_Sem_Menor)
                    {
                    }
                    field(Fecha_Postul; Rec.Fecha_Postul)
                    {
                    }
                    field(Fecha_Novic; Rec.Fecha_Novic)
                    {
                    }
                }
                group("<Profesión>")
                {
                    Caption = 'Profession', Comment = 'ESP="Profesión"';

                    field(Fecha_PT; Rec.Fecha_PT)
                    {
                        Caption = 'Temporary Profession', Comment = 'ESP="Profesión temporal"';
                    }
                    field(Fecha_PS; Rec.Fecha_PS)
                    {
                    }
                }
                group(Diaconado)
                {
                    Caption = 'Diaconate', Comment = 'ESP="Diaconado"';

                    field(Fecha_Diac_Tran; Rec.Fecha_Diac_Tran)
                    {
                        Caption = 'Transitional Diaconate', Comment = 'ESP="Diaconado transitorio"';
                    }
                    field(Fecha_Diac_Perm; Rec.Fecha_Diac_Perm)
                    {
                        Caption = 'Permanent Diaconate', Comment = 'ESP="Diaconado permanente"';
                    }
                }
                group("Ordenación")
                {
                    Caption = 'Ordination', Comment = 'ESP="Ordenación"';

                    field(Fecha_Sacer; Rec.Fecha_Sacer)
                    {
                    }
                    field(Fecha_Episc; Rec.Fecha_Episc)
                    {
                    }
                }
            }
            part(Estudios; "Estudios Sublist")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Studies', Comment = 'ESP="Estudios"';
                SubPageLink = "Nº Serie Friar" = FIELD("No. Serie Friar"),
                              "Data Friar Type" = CONST(Estudios);
            }
            part(Publicaciones; "Publicaciones Sublist")
            {
                Caption = 'Publications', Comment = 'ESP="Publicaciones"';
                SubPageLink = "Nº Serie Friar" = FIELD("No. Serie Friar"),
                              "Data Friar Type" = CONST(Publicaciones);
            }
            part("Oficios/Cargos"; "Oficios Sublist")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Offices/Roles', Comment = 'ESP="Oficios/Cargos"';
                SubPageLink = "Nº Serie Friar" = FIELD("No. Serie Friar"),
                              "Data Friar Type" = CONST(Oficios);
                UpdatePropagation = Both;
            }
            group("Información Laboral General")
            {
                Caption = 'General Employment Information', Comment = 'ESP="Información laboral general"';

                group("Información Laboral")
                {
                    Caption = 'Employment Information', Comment = 'ESP="Información laboral"';

                    field("DNI/NIF"; Rec."VAT Registration No.")
                    {
                    }
                    field(Num_SS; Rec.Num_SS)
                    {
                        Editable = true;
                    }
                    field("Acceso Digital"; Rec."Acceso Digital")
                    {
                    }
                }
                group("Activo:")
                {
                    Caption = 'Active', Comment = 'ESP="Activo"';

                    field(Activo; Rec.Activo)
                    {
                    }
                }
                group("Regimen General")
                {
                    Caption = 'General Regime', Comment = 'ESP="Régimen general"';

                    field("Régimen General"; Rec."Régimen General")
                    {
                        Editable = false;
                    }
                    field("Importe Nómina Diócesis"; Rec."Importe Nómina Diócesis")
                    {
                        Editable = false;
                    }
                    field("Importe Otras Nóminas"; Rec."Importe Otras Nóminas")
                    {
                        Editable = false;
                    }
                }
                group("Régimen Autonomo")
                {
                    Caption = 'Self-Employed Regime', Comment = 'ESP="Régimen autónomo"';

                    field("Régimen Autónomo"; Rec."Régimen Autónomo")
                    {
                        Editable = false;
                    }
                    field("Importe Base"; Rec."Importe Base")
                    {
                        Editable = false;
                    }
                    field("Importe Cuota"; Rec."Importe Cuota")
                    {
                        Editable = false;
                    }
                    field("Salario Adecuado"; Rec."Salario Adecuado")
                    {
                        Editable = false;
                    }
                }
                group("Pensionista:")
                {
                    Caption = 'Pensioner', Comment = 'ESP="Pensionista"';

                    field(Pensionista; Rec.Pensionista)
                    {
                        Editable = false;
                    }
                    field("Importe Pensionista"; Rec."Importe Pensionista")
                    {
                        Editable = false;
                    }
                    field("Tipo Pensionista"; Rec."Tipo Pensionista")
                    {
                        Editable = true;
                        Enabled = true;
                    }
                }
                group("Vida Laboral:")
                {
                    Caption = 'Employment History', Comment = 'ESP="Vida laboral"';

                    field("Vida Laboral"; Rec."Vida Laboral")
                    {
                    }
                }
                group("Seguro Medico")
                {
                    Caption = 'Health Insurance', Comment = 'ESP="Seguro médico"';

                    field("Seguro Médico"; Rec."Seguro Médico")
                    {
                        Editable = false;
                    }
                    field("Compañía SM"; Rec."Compañía SM")
                    {
                        Editable = true;
                        Enabled = true;
                        OptionCaption = ' ,No,Sanitas,Sanitas VOCARE,Asisa General,Asisa Misionero';
                    }
                    field("Importe SM"; Rec."Importe SM")
                    {
                        Editable = false;
                    }
                }
            }
            part("<Régimen>"; "Regimen Sublist")
            {
                Caption = 'Regime', Comment = 'ESP="Régimen"';
                SubPageLink = "Nº Serie Friar" = FIELD("No. Serie Friar");
                UpdatePropagation = Both;
            }
            part(Observaciones; "Observaciones Sublist")
            {
                Caption = 'Observations', Comment = 'ESP="Observaciones"';
                SubPageLink = "Nº Serie Friar" = FIELD("No. Serie Friar"),
                              "Data Friar Type" = CONST(Observaciones);
            }
        }
        area(factboxes)
        {
            part("Imagen Fraile"; "imagen fraile")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Friar Image', Comment = 'ESP="Imagen del fraile"';
                SubPageLink = "No. Serie Friar" = FIELD("No. Serie Friar");
                Visible = NOT IsOfficeAddin;
            }
            part("Adjuntar DNI"; "DNI Doc")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Attach ID Document', Comment = 'ESP="Adjuntar documento DNI"';
                ShowFilter = false;
                SubPageLink = "No. Serie Friar" = FIELD("No. Serie Friar");
                Visible = true;
            }
            part("Necrol.Difuncion"; "Necrol.Defuncion Doc")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Necrology Document', Comment = 'ESP="Documento necrológico"';
                SubPageLink = "No. Serie Friar" = FIELD("No. Serie Friar");
                Visible = NOT IsOfficeAddin;
            }
            systempart(Links; Links)
            {
                Visible = false;
            }
            part("Adjuntar Vida Laboral"; "Vida Laboral Doc")
            {
                ShowFilter = false;
                Caption = 'Attach Employment History', Comment = 'ESP="Adjuntar informe de vida laboral"';
                SubPageLink = "No. Serie Friar" = FIELD("No. Serie Friar");
            }
            systempart(Recordlinks; Links)
            {
            }
            part("Publicaciones Doc"; "Publicaciones Doc")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Publications Documents', Comment = 'ESP="Documentos de publicaciones"';
                ShowFilter = true;
                SubPageLink = "No. Serie Friar" = FIELD("No. Serie Friar");
                Visible = NOT IsOfficeAddin;
            }
            systempart(Notes; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Destino Hermano")
            {
                Image = Indent;
                Caption = 'Friar Destination', Comment = 'ESP="Abrir destino del hermano"';

                trigger OnAction()
                var
                    PageDestinoHermanos: Page "Destino Hermano";
                    RecordDestinosHermanos: Record "Friar Ledger Entry";
                begin
                    RecordDestinosHermanos.RESET();
                    RecordDestinosHermanos.SETRANGE("No. Serie Friar", Rec."No. Serie Friar");
                    PageDestinoHermanos.SETTABLEVIEW(RecordDestinosHermanos);
                    PageDestinoHermanos.setFriarCode(Rec."No. Serie Friar");
                    PageDestinoHermanos.RUN();
                    //RecordDestinosHermanos.El campo por EL que filtramos del Rec.
                    //RecordDestinosHermanos.Type --> filtramos por Destino :: tipo option :: para sacar valor
                    //PageDestinoHermanos.SETTABLEVIEW(Record)
                    //PageDestinoHermanos.RUN();
                end;
            }
            action(IncomingDocCard)
            {
                Caption = 'View Incoming Document', Comment = 'ESP="Ver documento entrante"';
                Enabled = true;
                Image = ViewOrder;
                ToolTip = 'View any incoming document records and file attachments that exist for the entry or document.', Comment = 'ESP="Ver cualquier registro de documento entrante y archivos adjuntos que existan para el asiento o documento."';

                trigger OnAction()
                var
                    IncomingDocument: Record "Incoming Document";
                begin
                    IncomingDocument.ShowCardFromEntryNo(Rec."Entry No. Document");
                end;
            }
            action(SelectIncomingDoc)
            {
                AccessByPermission = TableData "Incoming Document" = R;
                Caption = 'Select Incoming Document', Comment = 'ESP="Seleccionar documento entrante"';
                Image = SelectLineToApply;
                ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.', Comment = 'ESP="Seleccionar un registro de documento entrante y un archivo adjunto que desee vincular al asiento o documento."';

                trigger OnAction()
                var
                    IncomingDocument: Record "Incoming Document";
                begin
                    Rec."Entry No. Document" := IncomingDocument.SelectIncomingDocument(Rec."Entry No. Document", Rec.RECORDID);
                    Rec.MODIFY();
                end;
            }
            action(IncomingDocAttachFile)
            {
                Caption = 'Create Incoming Document from File', Comment = 'ESP="Crear documento entrante desde archivo"';
                Ellipsis = true;
                Image = Attach;
                ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.', Comment = 'ESP="Crear un registro de documento entrante seleccionando un archivo para adjuntar y luego vincular el registro del documento entrante al asiento o documento."';

                trigger OnAction()
                var
                    IncomingDocumentAttachment: Record "Incoming Document Attachment";
                begin
                    IncomingDocumentAttachment.NewAttachmentFromDocument(Rec."Entry No. Document", 50001, 0, Rec."No. Serie Friar");
                    Rec.MODIFY();
                end;
            }
        }
        area(Promoted)
        {
            group(Process)
            {
                Caption = 'Process', Comment = 'ESP="Procesar"';

                actionref(FriarDestination_Promoted; "Destino Hermano")
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        FriarLedgeEntry: Record "Friar Ledger Entry";
    begin
        //--TEMS-68
        RegimenActual.RESET();
        RegimenActual.SETRANGE("Nº Serie Friar", Rec."No. Serie Friar");

        RegimenActual.SETRANGE("Seguro Médico", RegimenActual."Seguro Médico"::" ");
        IF RegimenActual.FINDSET() THEN
            Rec."Compañía SM" := RegimenActual."Seguro Médico";
        RegimenActual.SETRANGE("Seguro Médico", RegimenActual."Seguro Médico"::"Sanitas VOCARE");
        IF RegimenActual.FINDSET() THEN
            Rec."Compañía SM" := RegimenActual."Seguro Médico";
        RegimenActual.SETRANGE("Seguro Médico", RegimenActual."Seguro Médico"::"Asisa General");
        IF RegimenActual.FINDSET() THEN
            Rec."Compañía SM" := RegimenActual."Seguro Médico";
        RegimenActual.SETRANGE("Seguro Médico", RegimenActual."Seguro Médico"::No);
        IF RegimenActual.FINDSET() THEN
            Rec."Compañía SM" := RegimenActual."Seguro Médico";
        RegimenActual.SETRANGE("Seguro Médico", RegimenActual."Seguro Médico"::Sanitas);
        IF RegimenActual.FINDSET() THEN
            Rec."Compañía SM" := RegimenActual."Seguro Médico";
        RegimenActual.SETRANGE("Seguro Médico", RegimenActual."Seguro Médico"::"Asisa Misionero");
        IF RegimenActual.FINDSET() THEN
            Rec."Compañía SM" := RegimenActual."Seguro Médico";

        RegimenActual.RESET();
        RegimenActual.SETRANGE("Nº Serie Friar", Rec."No. Serie Friar");

        RegimenActual.SETRANGE("Tipo Pensionista", RegimenActual."Tipo Pensionista"::" ");
        IF RegimenActual.FINDSET() THEN
            Rec."Tipo Pensionista" := RegimenActual."Tipo Pensionista";
        RegimenActual.SETRANGE("Tipo Pensionista", RegimenActual."Tipo Pensionista"::"No Contributiva");
        IF RegimenActual.FINDSET() THEN
            Rec."Tipo Pensionista" := RegimenActual."Tipo Pensionista";
        RegimenActual.SETRANGE("Tipo Pensionista", RegimenActual."Tipo Pensionista"::Contributiva);
        IF RegimenActual.FINDSET() THEN
            Rec."Tipo Pensionista" := RegimenActual."Tipo Pensionista";

        FriarLedgeEntry.RESET();

        FriarLedgeEntry.SETCURRENTKEY("Date start");
        FriarLedgeEntry.SETASCENDING("Date start", FALSE);
        FriarLedgeEntry.SETRANGE("No. Serie Friar", Rec."No. Serie Friar");
        FriarLedgeEntry.SETRANGE(Active, TRUE);
        FriarLedgeEntry.SETAUTOCALCFIELDS(City);
        IF FriarLedgeEntry.FINDFIRST() THEN BEGIN
            PoblacionDestinoHermano := FriarLedgeEntry.City;
            UltimoDestino := FriarLedgeEntry.Fraternity;
            Extradomum := FriarLedgeEntry."Extra Domum";
        END;
        //++TEMS-68
        FriarOption.RESET();
        FriarOption.SETRANGE(Actual, TRUE);
        FriarOption.SETRANGE("Nº Serie Friar", Rec."No. Serie Friar");
        FriarOption.SETRANGE("Oficios/Cargos", FriarOption."Oficios/Cargos"::Guardián);
        IF FriarOption.FINDSET() THEN
            Rec."Guardián Check" := TRUE
        ELSE
            Rec."Guardián Check" := FALSE;

        FriarOption.SETRANGE("Oficios/Cargos", FriarOption."Oficios/Cargos"::"Vicario Local");
        IF FriarOption.FINDSET() THEN
            Rec."Vicario Local Check" := TRUE
        ELSE
            Rec."Vicario Local Check" := FALSE;

        FriarOption.SETRANGE("Oficios/Cargos", FriarOption."Oficios/Cargos"::Ecónomo);
        IF FriarOption.FINDSET() THEN
            Rec."Ecónomo Check" := TRUE
        ELSE
            Rec."Ecónomo Check" := FALSE;

        FriarOption.SETRANGE("Oficios/Cargos", FriarOption."Oficios/Cargos"::Capellán);
        IF FriarOption.FINDSET() THEN
            Rec."Capellán Check" := TRUE
        ELSE
            Rec."Capellán Check" := FALSE;

        FriarOption.SETRANGE("Oficios/Cargos", FriarOption."Oficios/Cargos"::Párroco);
        IF FriarOption.FINDSET() THEN
            Rec."Párroco Check" := TRUE
        ELSE
            Rec."Párroco Check" := FALSE;

        FriarOption.SETRANGE("Oficios/Cargos", FriarOption."Oficios/Cargos"::"Vicario Parroquial");
        IF FriarOption.FINDSET() THEN
            Rec."Vicario Parroquial Check" := TRUE
        ELSE
            Rec."Vicario Parroquial Check" := FALSE;
    end;

    var
        IsOfficeAddin: Boolean;
        UltimoDestino: Text;
        Extradomum: Boolean;
        PoblacionDestinoHermano: Text;
        FriarOption: Record "Friar Options";
        RegimenActual: Record "Regimen Actual";
}