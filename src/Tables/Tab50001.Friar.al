table 50001 Friar
{
    Caption = 'Friar', Comment = 'ESP="Fraile"';

    fields
    {
        field(1; "No. Serie Friar"; Code[20])
        {
            Caption = 'Friar No.', Comment = 'ESP="Número de fraile"';
        }
        field(2; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.', Comment = 'ESP="NIF/CIF"';
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(4; "Imagen fraile"; Media)
        {
            Caption = 'Friar Image', Comment = 'ESP="Imagen del fraile"';
        }
        field(5; Name_Rel; Text[50])
        {
            Caption = 'Religious Name', Comment = 'ESP="Nombre religioso"';
        }
        field(6; Apellidos; Text[50])
        {
            Caption = 'Last Name', Comment = 'ESP="Apellidos"';
        }
        field(7; Fecha_Nac; Date)
        {
            Caption = 'Birth Date', Comment = 'ESP="Fecha de nacimiento"';
            FieldClass = Normal;
        }
        field(8; Num_SS; Text[30])
        {
            Caption = 'Social Security No.', Comment = 'ESP="Número de la Seguridad Social"';
            Editable = false;
            FieldClass = Normal;
        }
        field(9; "Situación Laboral"; Text[30])
        {
            Caption = 'Job Status', Comment = 'ESP="Situación laboral"';
            Editable = false;
            Enabled = false;
        }
        field(10; Reg_Gral_SS; Text[30])
        {
            Caption = 'General SS Reg.', Comment = 'ESP="Régimen General de la Seguridad Social"';
        }
        field(11; Movil; Text[30])
        {
            Caption = 'Mobile Phone', Comment = 'ESP="Teléfono móvil"';
        }
        field(12; Mail; Text[250])
        {
            Caption = 'Email', Comment = 'ESP="Correo electrónico"';
        }
        field(13; Destino_Ciudad; Text[50])
        {
            CalcFormula = Lookup("Friar Ledger Entry".City WHERE("No. Serie Friar" = FIELD("No. Serie Friar"),
                                                              Active = FILTER(true)));
            Caption = 'Destination City', Comment = 'ESP="Ciudad de destino"';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(14; Destino_Dir; Text[50])
        {
            CalcFormula = Lookup("Friar Ledger Entry".Fraternity WHERE("No. Serie Friar" = FIELD("No. Serie Friar"),
                                                                    Active = FILTER(true)));
            Caption = 'Destination Address', Comment = 'ESP="Dirección de destino"';
            Enabled = false;
            FieldClass = FlowField;
        }
        field(15; Destino_Tlf; Text[50])
        {
            CalcFormula = Lookup("Friar Ledger Entry".Fraternity WHERE("No. Serie Friar" = FIELD("No. Serie Friar"),
                                                                    Active = CONST(true)));
            Caption = 'Destination Phone', Comment = 'ESP="Teléfono de destino"';
            FieldClass = FlowField;
        }
        field(16; Destino_Oficio; Text[50])
        {
            CalcFormula = Lookup("Friar Ledger Entry".Job WHERE("No. Serie Friar" = FIELD("No. Serie Friar"),
                                                             Active = FILTER(true)));
            Caption = 'Destination Job', Comment = 'ESP="Oficio de destino"';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(17; Padres; Text[50])
        {
            Caption = 'Parents', Comment = 'ESP="Padres"';
        }
        field(18; Lugar_Nac; Text[50])
        {
            Caption = 'Place of Birth', Comment = 'ESP="Lugar de nacimiento"';
        }
        field(19; Prov_Nac; Text[50])
        {
            Caption = 'Province of Birth', Comment = 'ESP="Provincia de nacimiento"';
        }
        field(20; Pais_Nac; Text[50])
        {
            Caption = 'Country of Birth', Comment = 'ESP="País de nacimiento"';
        }
        field(21; Fecha_Bau; Date)
        {
            Caption = 'Baptism Date', Comment = 'ESP="Fecha de bautizo"';
        }
        field(22; Parroquia_Bau; Text[50])
        {
            Caption = 'Baptism Parish', Comment = 'ESP="Parroquia de bautizo"';
        }
        field(23; Ciudad_Bau; Text[50])
        {
            Caption = 'Baptism City', Comment = 'ESP="Ciudad de bautizo"';
        }
        field(24; Diocesis_Bau; Text[50])
        {
            Caption = 'Baptism Diocese', Comment = 'ESP="Diócesis de bautizo"';
        }
        field(25; Fecha_Conf; Date)
        {
            Caption = 'Confirmation Date', Comment = 'ESP="Fecha de confirmación"';
        }
        field(26; Parroquia_Conf; Text[50])
        {
            Caption = 'Confirmation Parish', Comment = 'ESP="Parroquia de confirmación"';
        }
        field(27; Ciudad_Conf; Text[50])
        {
            Caption = 'Confirmation City', Comment = 'ESP="Ciudad de confirmación"';
        }
        field(28; Diocesis_Conf; Text[50])
        {
            Caption = 'Confirmation Diocese', Comment = 'ESP="Diócesis de confirmación"';
        }
        field(29; Fecha_Sem_Menor; Date)
        {
            Caption = 'Minor Seminary Date', Comment = 'ESP="Fecha de seminario menor"';
        }
        field(30; Fecha_Postul; Date)
        {
            Caption = 'Postulancy Date', Comment = 'ESP="Fecha de postul"';
        }
        field(31; Fecha_Novic; Date)
        {
            Caption = 'Novitiate Date', Comment = 'ESP="Fecha de noviciado"';
        }
        field(32; Fecha_PT; Date)
        {
            Caption = 'Temporary Profession Date', Comment = 'ESP="Fecha de profesión temporal"';
        }
        field(33; Fecha_PS; Date)
        {
            Caption = 'Solemn Profession Date', Comment = 'ESP="Fecha de profesión solemne"';
        }
        field(34; Fecha_Ministerios; Date)
        {
            Caption = 'Lector Ministry Date', Comment = 'ESP="Fecha de ministerio de lector"';
        }
        field(35; Fecha_Diac; Date)
        {
            Caption = 'Diaconate Date', Comment = 'ESP="Fecha de diaconado"';
        }
        field(36; Fecha_Diac_Perm; Date)
        {
            Caption = 'Permanent Diaconate Date', Comment = 'ESP="Fecha de diaconado permanente"';
        }
        field(37; Fecha_Sacer; Date)
        {
            Caption = 'Priestly Ordination Date', Comment = 'ESP="Fecha de ordenación sacerdotal"';
        }
        field(38; Fecha_Episc; Date)
        {
            Caption = 'Episcopal Ordination Date', Comment = 'ESP="Fecha de ordenación episcopal"';
        }
        field(39; Idiomas; Text[50])
        {
            Caption = 'Languages', Comment = 'ESP="Idiomas"';
        }
        field(40; Defunc_Fecha; Date)
        {
            Caption = 'Date of Death', Comment = 'ESP="Fecha de defunción"';
        }
        field(41; Defunc_Lugar; Text[50])
        {
            Caption = 'Place of Death', Comment = 'ESP="Lugar de defunción"';
        }
        field(42; Defunc_Necrol; Text[50])
        {
            Caption = 'Obituary', Comment = 'ESP="Necrológica"';
        }
        field(43; Destinos_Hist; Text[50])
        {
            Caption = 'Historical Destinations', Comment = 'ESP="Destinos históricos"';
        }
        field(44; Estudios_Hist; Text[50])
        {
            Caption = 'Historical Studies', Comment = 'ESP="Estudios históricos"';
        }
        field(45; Oficios_Hist; Text[50])
        {
            Caption = 'Historical Jobs', Comment = 'ESP="Oficios históricos"';
        }
        field(46; Public_Hist; Text[50])
        {
            Caption = 'Historical Publications', Comment = 'ESP="Publicaciones históricas"';
        }
        field(47; Cuentas; Option)
        {
            Caption = 'Accounts', Comment = 'ESP="Cuentas"';
            OptionCaption = ',Jubilación,Servicios Remunerados,Clases Profesores,Parroquias Nominas,Capellanias';
            OptionMembers = ,"Jubilación","Servicios Remunerados","Clases Profesores","Parroquias Nominas",Capellanias;
        }
        field(48; Ingresos; Decimal)
        {
            Caption = 'Income', Comment = 'ESP="Ingresos"';
        }
        field(49; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
            Caption = 'No. Series', Comment = 'ESP="Nº Series"';
        }
        field(50; Fecha_Ministerios_Aco; Date)
        {
            Caption = 'Acolyte Ministry', Comment = 'ESP="Ministerio de acólito"';
        }
        field(51; Estado; Option)
        {
            OptionCaption = ' ,Activo,Fallecido,Exclaustrado,Abandono';
            OptionMembers = " ",Activo,Fallecido,Exclaustrado,Abandono;
        }
        field(52; Fecha_Diac_Tran; Date)
        {
            Caption = 'Transitional Diaconate', Comment = 'ESP="Diaconado transitorio"';
        }
        field(53; "Necrol. Defunción"; Boolean)
        {
            Caption = 'Obituary', Comment = 'ESP="Necrológica de defunción"';
        }
        field(54; Opciones; Option)
        {
            Caption = 'Options', Comment = 'ESP="Opciones"';
            OptionMembers = Oficios,Estudios,Publicaciones,Observaciones;
        }
        field(55; "Fecha Opciones"; Date)
        {
            Caption = 'Options Date', Comment = 'ESP="Fecha de opciones"';
        }
        field(56; Descripcion; Text[250])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(57; "VAT Registration No. Upload"; Media)
        {
            Caption = 'ID Document', Comment = 'ESP="Documento DNI/NIF"';
        }
        field(58; "Acceso Digital"; Option)
        {
            OptionMembers = "Cl@ve Pin ","Certificado Digital",SMS,"DNI Electrónico";
            Caption = 'Digital Access', Comment = 'ESP="Acceso digital"';
        }
        field(59; Activo; Boolean)
        {
            Caption = 'Active', Comment = 'ESP="Activo"';
        }
        field(60; "Régimen General"; Boolean)
        {
            CalcFormula = Exist("Regimen Actual" WHERE("Nº Serie Friar" = FIELD("No. Serie Friar"),
                                                        "Tipo Regimen" = CONST("General Nómina"),
                                                        "Régimen Actual" = CONST(true)));
            Editable = true;
            Enabled = true;
            FieldClass = FlowField;
            Caption = 'General Regime', Comment = 'ESP="Régimen general"';
        }
        field(61; "Régimen Autónomo"; Boolean)
        {
            CalcFormula = Exist("Regimen Actual" WHERE("Nº Serie Friar" = FIELD("No. Serie Friar"),
                                                        "Tipo Regimen" = CONST(Autonomo),
                                                        "Régimen Actual" = CONST(true)));
            FieldClass = FlowField;
            Caption = 'Self-Employed Regime', Comment = 'ESP="Régimen autónomo"';
        }
        field(62; "Diócesis_SL"; Decimal)
        {
            Caption = 'Diocese_SL';
        }
        field(63; Cuota_SL; Decimal)
        {
            Caption = 'Contribution Amount', Comment = 'ESP="Cuota"';
        }
        field(64; Base_SL; Decimal)
        {
            Caption = 'Contribution Base', Comment = 'ESP="Base de cotización"';
        }
        field(65; "Nómina_SL"; Decimal)
        {
            Caption = 'Payroll Amount', Comment = 'ESP="Nómina"';
        }
        field(66; "Oficio/Cargo"; Option)
        {
            OptionMembers = "Párroco","Vicario Parroquial"," Profesor";
            Caption = 'Position', Comment = 'ESP="Oficio / cargo"';
        }
        field(67; Pensionista; Boolean)
        {
            CalcFormula = Exist("Regimen Actual" WHERE("Nº Serie Friar" = FIELD("No. Serie Friar"),
                                                        "Tipo Regimen" = CONST(Pensionista),
                                                        "Régimen Actual" = CONST(true)));
            FieldClass = FlowField;
            Caption = 'Pensioner', Comment = 'ESP="Pensionista"';

            trigger OnValidate()
            begin
                IF NOT Pensionista THEN BEGIN
                    "Tipo Pensionista" := "Tipo Pensionista"::" ";
                    "Pensionista Precio" := 0;
                END;
            end;
        }
        field(68; "Tipo Pensionista"; Option)
        {
            Editable = true;
            FieldClass = Normal;
            OptionMembers = " ",Contributiva,"No Contributiva";
            Caption = 'Pensioner Type', Comment = 'ESP="Tipo de pensionista"';

            trigger OnValidate()
            begin
                IF "Tipo Pensionista" <> "Tipo Pensionista"::" " THEN
                    TESTFIELD(Pensionista, TRUE);
            end;
        }
        field(69; "Pensionista Precio"; Decimal)
        {
            Caption = 'Pensioner Amount', Comment = 'ESP="Importe pensionista"';
        }
        field(70; "Vida Laboral"; Boolean)
        {
            Caption = 'Employment History', Comment = 'ESP="Vida laboral"';
        }
        field(71; "Seguro Médico"; Boolean)
        {
            Caption = 'Medical Insurance', Comment = 'ESP="Seguro médico"';
            CalcFormula = Exist("Regimen Actual" WHERE("Nº Serie Friar" = FIELD("No. Serie Friar"),
                                                        "Tipo Regimen" = CONST("Seguro Médico"),
                                                        "Régimen Actual" = CONST(true)));
            FieldClass = FlowField;
        }
        field(72; "Compañía SM"; Option)
        {
            Editable = false;
            FieldClass = Normal;
            OptionCaption = ' ,No,Sanitas,Sanitas VOCARE,Asisa General,Asisa Misionero';
            OptionMembers = " ","No ",Sanitas,"Sanitas VOCARE","Asisa General","Asisa Misionero";
            Caption = 'MI Company', Comment = 'ESP="Compañía del seguro médico"';
        }
        field(73; "Importe SM"; Decimal)
        {
            CalcFormula = Lookup("Regimen Actual"."Importe Seguro Médico" WHERE("Nº Serie Friar" = FIELD("No. Serie Friar"),
                                                                                 "Tipo Regimen" = CONST("Seguro Médico"),
                                                                                 "Régimen Actual" = CONST(true)));
            FieldClass = FlowField;
            Caption = 'MI Amount', Comment = 'ESP="Importe seguro médico"';
        }
        field(74; "Importe Pensionista"; Decimal)
        {
            Caption = 'Pensioner Amount', Comment = 'ESP="Importe pensionista"';
            CalcFormula = Lookup("Regimen Actual"."Importe Pensionista" WHERE("Nº Serie Friar" = FIELD("No. Serie Friar"),
                                                                               "Tipo Regimen" = CONST(Pensionista),
                                                                               "Régimen Actual" = CONST(true)));
            FieldClass = FlowField;
        }
        field(75; "Entry No. Document"; Integer)
        {
            Caption = 'Document Entry No.', Comment = 'ESP="Nº movimiento documento"';
        }
        field(76; "Importe Nómina Diócesis"; Decimal)
        {
            Caption = 'Diocese Payroll Amount', Comment = 'ESP="Importe nómina diócesis"';
            CalcFormula = Lookup("Regimen Actual".Base WHERE("Nº Serie Friar" = FIELD("No. Serie Friar"),
                                                              "Tipo Regimen" = CONST("General Diócesis"),
                                                              "Régimen Actual" = CONST(true)));
            FieldClass = FlowField;
        }
        field(77; "Importe Otras Nóminas"; Decimal)
        {
            CalcFormula = Lookup("Regimen Actual".Base WHERE("Nº Serie Friar" = FIELD("No. Serie Friar"),
                                                              "Tipo Regimen" = CONST("General Nómina"),
                                                              "Régimen Actual" = CONST(true)));
            FieldClass = FlowField;
            Caption = 'Other Payroll Amount', Comment = 'ESP="Importe otras nóminas"';
        }
        field(78; "Importe Cuota"; Decimal)
        {
            CalcFormula = Lookup("Regimen Actual"."Importe/Base" WHERE("Nº Serie Friar" = FIELD("No. Serie Friar"),
                                                                      "Tipo Regimen" = CONST(Autonomo),
                                                                      "Régimen Actual" = CONST(true)));
            FieldClass = FlowField;
            Caption = 'Contribution Amount', Comment = 'ESP="Importe cuota"';
        }
        field(79; "Importe Base"; Decimal)
        {
            Caption = 'Base Amount', Comment = 'ESP="Importe base"';
            CalcFormula = Lookup("Regimen Actual".Base WHERE("Nº Serie Friar" = FIELD("No. Serie Friar"),
                                                              "Tipo Regimen" = CONST(Autonomo),
                                                              "Régimen Actual" = CONST(true)));
            FieldClass = FlowField;
        }
        field(80; "DNI Doc"; BLOB)
        {
            Caption = 'ID Document File', Comment = 'ESP="Documento DNI"';
        }
        field(81; "Vida Laboral Doc"; BLOB)
        {
            Caption = 'Employment History File', Comment = 'ESP="Documento vida laboral"';
        }
        field(82; "DNI File Name"; Text[100])
        {
            Caption = 'ID File Name', Comment = 'ESP="Nombre archivo DNI"';
        }
        field(83; "Vida Laboral File Name"; Text[100])
        {
            Caption = 'Employment History File Name', Comment = 'ESP="Nombre archivo vida laboral"';
        }
        field(84; "Necrol.Defuncion Doc"; BLOB)
        {
            Caption = 'Obituary File', Comment = 'ESP="Documento necrológica"';
        }
        field(85; "Necrol.Defuncion Name"; Text[100])
        {
            Caption = 'Obituary File Name', Comment = 'ESP="Nombre archivo necrológica"';
        }
        field(86; "Fecha Validez"; Date)
        {
            Caption = 'Validity Date', Comment = 'ESP="Fecha de validez"';
        }
        field(87; "Publicaciones Doc"; BLOB)
        {
            Caption = 'Publications File', Comment = 'ESP="Documento publicaciones"';
        }
        field(88; "Publicaciones File Name"; Text[100])
        {
            Caption = 'Publications File Name', Comment = 'ESP="Nombre archivo publicaciones"';
        }
        field(89; "Guardián Check"; Boolean)
        {
            Editable = false;
            Caption = 'Guardian', Comment = 'ESP="Guardián"';
        }
        field(90; "Vicario Local Check"; Boolean)
        {
            Editable = false;
            Caption = 'Local Vicar', Comment = 'ESP="Vicario local"';
        }
        field(91; "Ecónomo Check"; Boolean)
        {
            Editable = false;
            Caption = 'Bursar', Comment = 'ESP="Ecónomo"';
        }
        field(92; "Capellán Check"; Boolean)
        {
            Editable = false;
            Caption = 'Chaplain', Comment = 'ESP="Capellán"';
        }
        field(93; "Párroco Check"; Boolean)
        {
            Editable = false;
            Caption = 'Parish Priest', Comment = 'ESP="Párroco"';
        }
        field(94; "Vicario Parroquial Check"; Boolean)
        {
            Editable = false;
            Caption = 'Parochial Vicar', Comment = 'ESP="Vicario parroquial"';
        }
        field(97; "Salario Adecuado"; Decimal)
        {
            Caption = 'Adequate Salary', Comment = 'ESP="Salario adecuado"';
            CalcFormula = Lookup("Regimen Actual"."Salario Adecuado" WHERE("Nº Serie Friar" = FIELD("No. Serie Friar"),
                                                                            "Tipo Regimen" = CONST("Salario Adecuado"),
                                                                            "Régimen Actual" = CONST(true)));
            FieldClass = FlowField;
        }
        field(98; "Publicaciones check"; Boolean)
        {
            Caption = 'Publications', Comment = 'ESP="Publicaciones"';
        }
        field(99; "Destino Fraternidad"; Text[50])
        {
            FieldClass = Normal;
            Caption = 'Destination Fraternity', Comment = 'ESP="Fraternidad de destino"';
        }
        field(100; "Población"; Text[50])
        {
            FieldClass = Normal;
            Caption = 'City', Comment = 'ESP="Población"';
        }
        field(101; "Post Code"; Code[20])
        {
            CalcFormula = Lookup("Friar Ledger Entry"."Post Code" WHERE("No. Serie Friar" = FIELD("No. Serie Friar")));
            FieldClass = FlowField;
            Caption = 'Post Code', Comment = 'ESP="Código postal"';
        }
        field(102; "Destino Fraternidad Nav"; Code[50])
        {
            Caption = 'Destination Fraternity', Comment = 'ESP="Fraternidad destino"';
        }
    }

    keys
    {
        key(Key1; "No. Serie Friar")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DeleteSM();
    end;

    trigger OnInsert()
    begin
        // Mod S2G (JMP) 21/06/18 BEGIN
        IF "No. Serie Friar" = '' THEN BEGIN
            rResourceSETUP.GET;
            rResourceSETUP.TESTFIELD("No serie Friar");
            NoSeriesMgt.AreRelated(rResourceSETUP."No serie Friar", "No. Series");
        END;
        // Mod S2G (JMP) 21/06/18 END
        AddSM();
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        rResourceSETUP: Record "Human Resources Setup";
        rlRegimenActual: Record "Regimen Actual";

    procedure AddSM()
    begin
        //TEMS-267
        rlRegimenActual.RESET();
        rlRegimenActual.SETRANGE("Nº Serie Friar", Rec."No. Serie Friar");
        rlRegimenActual.SETRANGE("Tipo Regimen", rlRegimenActual."Tipo Regimen"::"Seguro Médico");
        IF rlRegimenActual.FINDSET THEN BEGIN

        END ELSE BEGIN

            rlRegimenActual.INIT();
            rlRegimenActual."Nº Serie Friar" := Rec."No. Serie Friar";
            rlRegimenActual.VALIDATE("Tipo Regimen", rlRegimenActual."Tipo Regimen"::"Seguro Médico");
            rlRegimenActual.INSERT(TRUE);
        END
    end;

    procedure DeleteSM()
    begin

        rlRegimenActual.RESET();
        rlRegimenActual.SETRANGE("Nº Serie Friar", Rec."No. Serie Friar");
        rlRegimenActual.SETRANGE("Tipo Regimen", rlRegimenActual."Tipo Regimen"::"Seguro Médico");
        IF rlRegimenActual.FINDSET THEN BEGIN
            rlRegimenActual.DELETE(TRUE);
        END
    end;
}
