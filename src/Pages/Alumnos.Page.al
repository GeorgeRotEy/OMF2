page 50122 Alumnos
{
    Caption = 'Students', Comment = 'ESP="Alumnos"';
    PageType = List;
    SourceTable = Alumnos;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID Alumno"; Rec."ID Alumno")
                {
                }
                field("ID Colegio"; Rec."ID Colegio")
                {
                }
                field("Etapa educativa"; Rec."Etapa educativa")
                {
                }
            }
        }
    }

    actions
    {
    }

    //EDUCAMOS
    // trigger OnOpenPage()
    // begin
    //     Rec.DELETEALL();
    //     EDUCAMOSEtapaEducativa.RESET();
    //     EDUCAMOSEtapaEducativa.CHANGECOMPANY('PRO-PROVINCIA INMACULADA');
    //     IF EDUCAMOSEtapaEducativa.FINDSET() THEN
    //         REPEAT
    //             Rec.INIT();
    //             Rec."ID Alumno" := EDUCAMOSEtapaEducativa."ID Alumno";
    //             Rec."ID Colegio" := EDUCAMOSEtapaEducativa."ID Colegio";
    //             Rec."Etapa educativa" := EDUCAMOSEtapaEducativa."Etapa educativa";
    //             Rec.INSERT();
    //         UNTIL EDUCAMOSEtapaEducativa.NEXT() = 0;
    // end;

    // var
    //     Companies: Record Company;
    //     EDUCAMOSEtapaEducativa: Record "EDUCAMOS EtapaEducativa Old";
}
