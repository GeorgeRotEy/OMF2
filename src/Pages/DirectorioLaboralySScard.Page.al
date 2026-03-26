page 50125 "Directorio Laboral y SS card"
{
    Caption = 'Employment and SS Directory Card', Comment = 'ESP="Ficha Directorio Laboral y SS"';
    PageType = Card;
    SourceTable = Friar;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Información Laboral General")
            {
                Caption = 'Información Laboral General';
                field("No. Serie Friar"; Rec."No. Serie Friar")
                {
                    Editable = false;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                }
                field("Fecha Validez"; Rec."Fecha Validez")
                {
                }
                field(Num_SS; Rec.Num_SS)
                {
                    Editable = true;
                }
                field("Acceso Digital"; Rec."Acceso Digital")
                {
                }
                group("Activo:")
                {
                    field(Activo; Rec.Activo)
                    {
                    }
                }
                group("Regimen General")
                {
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    field("Régimen General"; Rec."Régimen General")
                    {
                    }
                    field("Importe Nómina Diócesis"; Rec."Importe Nómina Diócesis")
                    {
                    }
                    field("Importe Otras Nóminas"; Rec."Importe Otras Nóminas")
                    {
                    }
                }
                group("Regimen Autónomo")
                {
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    field("Régimen Autónomo"; Rec."Régimen Autónomo")
                    {
                    }
                    field("Importe Base"; Rec."Importe Base")
                    {
                    }
                    field("Importe Cuota"; Rec."Importe Cuota")
                    {
                    }
                }
                group("Salario Adecuado")
                {
                }
                group("Pensionista:")
                {
                    field(Pensionista; Rec.Pensionista)
                    {
                    }
                    field("Importe Pensionista"; Rec."Importe Pensionista")
                    {
                    }
                    field("Tipo Pensionista"; Rec."Tipo Pensionista")
                    {
                        Editable = false;
                        Enabled = true;
                        Visible = true;
                    }
                }
                group("Vida laboral:")
                {
                    field("Vida Laboral"; Rec."Vida Laboral")
                    {
                        Editable = false;
                    }
                }
                group("Seguro Medico")
                {
                    field("Seguro Médico"; Rec."Seguro Médico")
                    {
                    }
                    field("Compañía SM"; Rec."Compañía SM")
                    {
                    }
                    field("Importe SM"; Rec."Importe SM")
                    {
                    }
                }
            }
            part(Regimen; "Regimen Sublist")
            {
                Caption = 'Regimen';
                SubPageLink = "Nº Serie Friar" = FIELD("No. Serie Friar");
                UpdatePropagation = Both;
            }
            part("Oficios/Cargos"; "Oficios Sublist")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Oficios';
                SubPageLink = "Nº Serie Friar" = FIELD("No. Serie Friar"),
                              "Data Friar Type" = CONST(Oficios);
            }
            part(Observaciones; "Observaciones Sublist")
            {
                Caption = 'Observaciones';
                SubPageLink = "Nº Serie Friar" = FIELD("No. Serie Friar"),
                              "Data Friar Type" = CONST(Observaciones);
            }
        }
        area(factboxes)
        {
            part("Adjuntar Vida Laboral"; "Vida Laboral Doc")
            {
                Caption = 'Adjuntar Vida Laboral';
                ShowFilter = false;
                Visible = true;
            }
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
            }
        }
    }

    actions
    {
    }
}
