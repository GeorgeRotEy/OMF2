page 50002 Classroom
{
    // //Mód S2G (JGS) 23/02/18 Creacion de la pagina para registro de Aulas en el colegio.
    Caption = 'Classroom', Comment = 'ESP="Aula"';
    PageType = List;
    SourceTable = Classroom;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Curso Escolar"; Rec."Curso Escolar")
                {
                }
                field("Etapa codigo"; Rec."Etapa codigo")
                {
                }
                field("Etapa Nombre"; Rec."Etapa Nombre")
                {
                }
                field("Numero de Aulas"; Rec."Numero de Aulas")
                {
                }
            }
        }
    }

    actions
    {
    }
}
