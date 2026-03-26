table 50350 "Friar Options"
{
    fields
    {
        field(1; "Nº Serie Friar"; Code[10])
        {
            Caption = 'Friar Series No.', Comment = 'ESP="Nº Serie Hermano"';
            TableRelation = Friar."No. Serie Friar";
        }
        field(2; "Data Friar Type"; Option)
        {
            Caption = 'Friar Data Type', Comment = 'ESP="Tipo de dato del Hermano"';
            OptionCaption = 'Oficios,Estudios,Publicaciones,Observaciones';
            OptionMembers = Oficios,Estudios,Publicaciones,Observaciones;
        }
        field(3; "Fecha Inicio"; Date)
        {
            Caption = 'Start Date', Comment = 'ESP="Fecha inicio"';
        }
        field(4; Descripcion; Text[250])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(5; ID; Integer)
        {
            Caption = 'ID', Comment = 'ESP="ID"';
            AutoIncrement = true;
        }
        field(7; Importe; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(8; "Nombre Hermano"; Text[50])
        {
            CalcFormula = Lookup(Friar.Name WHERE("No. Serie Friar" = FIELD("Nº Serie Friar")));
            Caption = 'Friar Name', Comment = 'ESP="Nombre Hermano"';
            FieldClass = FlowField;
        }
        field(9; "Apellido Hermano"; Text[50])
        {
            CalcFormula = Lookup(Friar.Apellidos WHERE("No. Serie Friar" = FIELD("Nº Serie Friar")));
            Caption = 'Friar Surname', Comment = 'ESP="Apellido Hermano"';
            FieldClass = FlowField;
        }
        field(10; "Oficios/Cargos"; Option)
        {
            Caption = 'Roles/Positions', Comment = 'ESP="Oficios/Cargos"';
            Editable = true;
            OptionMembers = " ","Ministro Provincial","Vicario Provincial","Definidor Provincial","Secretario Provincial","Économo Provincial","Secretario para la formación y estudios","Maestro de Postulantes","Maestro de Novicios","Maestro de Profesos Simples","Comisiario de Tierra Santa","Asistente de la OFS","Archivero Provincial","Bibliotecario Provincial","Guardián","Vicario Local","Ecónomo"," Director Titular Colegio","Director Académico Colegio","Director ITM","Director Colegio Mayor C.C.","Director de Revista","Capellán","Párroco","Vicario Parroquial";
        }
        field(11; Actual; Boolean)
        {
            Caption = 'Current', Comment = 'ESP="Actual"';
        }
        field(12; "Fecha fin"; Date)
        {
            Caption = 'End Date', Comment = 'ESP="Fecha fin"';
        }
    }

    keys
    {
        key(Key1; "Nº Serie Friar", "Data Friar Type", ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
