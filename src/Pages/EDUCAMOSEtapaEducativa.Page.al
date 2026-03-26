page 50057 "EDUCAMOS EtapaEducativa"
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    Caption = 'Educational Stage', Comment = 'ESP="Etapa Educativa"';
    PageType = List;
    SourceTable = "EDUCAMOS EtapaEducativa";
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
}
