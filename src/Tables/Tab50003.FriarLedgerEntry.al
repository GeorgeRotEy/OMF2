table 50003 "Friar Ledger Entry"
{
    Caption = 'Friar Name', Comment = 'ESP="Nombre Hermano"';

    fields
    {
        field(1; "No. Mov"; Integer)
        {
            AutoIncrement = true;
            Caption = 'Movement No.', Comment = 'ESP="Número de movimiento"';
        }
        field(2; "No. Serie Friar"; Code[10])
        {
            Caption = 'Friar Series No.', Comment = 'ESP="Nº Serie Hermano"';
            TableRelation = Friar."No. Serie Friar";
        }
        field(3; Type; Option)
        {
            Caption = 'Movement Type', Comment = 'ESP="Tipo de movimiento"';
            OptionCaption = ',Location,Job,Study,Job status';
            OptionMembers = ,destino,oficio,estudio,"situación laboral";
        }
        field(4; "Date start"; Date)
        {
            Caption = 'Start Date', Comment = 'ESP="Fecha inicio"';

            trigger OnValidate()
            begin
                IF ("Date end" <> 0D) AND ("Date end" < "Date start") THEN
                    ERROR(Error001, FIELDCAPTION("Date end"), "Date start");
            end;
        }
        field(5; "Date end"; Date)
        {
            Caption = 'End Date', Comment = 'ESP="Fecha fin"';

            trigger OnValidate()
            begin
                IF "Date end" = 0D THEN
                    EXIT;

                IF "Date start" = 0D THEN
                    ERROR(Error001, FIELDCAPTION("Date start"), 0);

                IF ("Date end" <> 0D) AND ("Date end" < "Date start") THEN
                    ERROR(Error001, FIELDCAPTION("Date end"), "Date start");
            end;
        }
        field(6; "Self employee"; Option)
        {
            Caption = 'Employment Regime', Comment = 'ESP="Autónomo / Régimen General / Seras"';
            OptionCaption = ' ,SS Regimen General, SS Autonomos, Seras';
            OptionMembers = " ","SS Regimen General"," SS Autonomos"," Seras";
        }
        field(7; Job; Text[50])
        {
            CalcFormula = Lookup("Values Friar".Job WHERE(Id_job = FIELD(Id_job)));
            Caption = 'Job', Comment = 'ESP="Oficio"';
            FieldClass = FlowField;
        }
        field(8; Fraternity; Text[50])
        {
            Caption = 'Destination Fraternity', Comment = 'ESP="Destino fraternidad"';

            trigger OnLookup()
            var
                lPostCode: Record "Post Code";
                pPostCodes: Page "Post Codes";
            begin
                CLEAR(pPostCodes);
                lPostCode.RESET;
                lPostCode.SETFILTER(Fraternity, '<>%1', '');
                pPostCodes.SETTABLEVIEW(lPostCode);
                pPostCodes.LOOKUPMODE(TRUE);
                IF pPostCodes.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    pPostCodes.GETRECORD(lPostCode);
                    Fraternity := lPostCode.Fraternity;
                    //--APA
                    "Post Code" := lPostCode.Code;
                    City := lPostCode.City;
                    //++APA
                END;
            end;

            trigger OnValidate()
            var
                lPostCode: Record "Post Code";
            begin
                //IF xRec.Fraternity <> Rec.Fraternity THEN BEGIN
                //  lPostCode.RESET;
                //  lPostCode.SETRANGE(Fraternity,xRec.Fraternity);
                //  lPostCode.SETRANGE(Code,xRec."Post Code");
                //END;

                //IF lPostCode.FINDFIRST THEN BEGIN
                //  xRec."Post Code" := lPostCode.Code;
                //  xRec.City := lPostCode.City;
                //END;
            end;
        }
        field(9; "Job type"; Option)
        {
            CalcFormula = Lookup("Values Friar"."Job type" WHERE(Id_job = FIELD(Id_job)));
            Caption = 'Job Type', Comment = 'ESP="Tipo de oficio"';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,Curia title,Fraternity title,Activity title,Economy title,Secretary for missions and evangelization,Secretary for education, Other ';
            OptionMembers = " ","Cargo provincial","Cargo de las casas","Cargo de las actividades","Cargo asuntos enconómicos","Secretaria para las misiones y evangelización","Secretaria para la formación y los estudios","Otras comisiones";
        }
        field(10; Comments; Text[250])
        {
            Caption = 'Comments', Comment = 'ESP="Comentarios"';
        }
        field(11; "No Seguridad Social"; Text[30])
        {
            Caption = 'Social Security No.', Comment = 'ESP="Nº Seguridad Social"';
        }
        field(12; Active; Boolean)
        {
            Caption = 'Active', Comment = 'ESP="Activo"';
        }
        field(14; Study; Text[50])
        {
            Caption = 'Studies', Comment = 'ESP="Estudios"';
        }
        field(16; "Post Code"; Code[20])
        {
            Caption = 'Post Code', Comment = 'ESP="Código postal"';
            Editable = false;
            FieldClass = Normal;
        }
        field(17; City; Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE(Code = FIELD("Post Code")));
            Caption = 'City', Comment = 'ESP="Ciudad"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; Category; Text[30])
        {
            CalcFormula = Lookup("Values Friar".Category WHERE(Id_job = FIELD(Id_job)));
            Caption = 'Category', Comment = 'ESP="Categoría"';
            Editable = true;
            FieldClass = FlowField;
        }
        field(19; Id_job; Code[10])
        {
            Caption = 'Job ID', Comment = 'ESP="Id_job"';
            TableRelation = "Values Friar".Id_job;
        }
        field(20; Trienio; Text[10])
        {
            Caption = 'Three-Year Period', Comment = 'ESP="Trienio"';
        }
        field(21; "Extra Domum"; Boolean)
        {
            Caption = 'Extra Domum', Comment = 'ESP="Extra domum"';
        }
        field(22; "Apellidos Hermano"; Text[50])
        {
            Caption = 'Friar Last Name', Comment = 'ESP="Apellidos hermano"';
            CalcFormula = Lookup(Friar.Apellidos WHERE("No. Serie Friar" = FIELD("No. Serie Friar")));
            FieldClass = FlowField;
        }
        field(23; "Nombre Hermano"; Text[50])
        {
            Caption = 'Friar Name', Comment = 'ESP="Nombre hermano"';
            CalcFormula = Lookup(Friar.Name_Rel WHERE("No. Serie Friar" = FIELD("No. Serie Friar")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No. Mov")
        {
            Clustered = true;
        }
        key(Key2; "Date start")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label '%1 %2 already exists.';
        Error001: Label 'Se debe indicar un %1 mayor a %2';
}
