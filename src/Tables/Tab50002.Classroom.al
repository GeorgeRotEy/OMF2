table 50002 Classroom
{
    // //Mód S2G (JGS) 23/02/18 Creacion de la tabla para registro de Aulas en el colegio.

    fields
    {
        field(1; "Noº Mov"; Integer)
        {
            AutoIncrement = true;
            Caption = 'Movement No.', Comment = 'ESP="Número de movimiento"';
        }
        field(2; "Curso Escolar"; Option)
        {
            Caption = 'School Year', Comment = 'ESP="Curso escolar"';
            OptionMembers = "2017-2018","2018-2019";
        }
        field(3; "Etapa codigo"; Code[20])
        {
            Caption = 'Stage Code', Comment = 'ESP="Código de etapa"';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('ETAPA'));
        }
        field(4; "Numero de Aulas"; Decimal)
        {
            Caption = 'Number of Classrooms', Comment = 'ESP="Número de aulas"';
        }
        field(5; "Registro interno"; Date)
        {
            Caption = 'System Log Date', Comment = 'ESP="Registro interno del sistema"';
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID', Comment = 'ESP="Identificador de usuario"';
        }
        field(7; "Etapa Nombre"; Text[50])
        {
            Caption = 'Stage Name', Comment = 'ESP="Nombre de la etapa"';
            CalcFormula = Lookup("Dimension Value".Name WHERE(Code = FIELD("Etapa codigo")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Noº Mov")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
