page 50052 "EDUCAMOS ReciboAlumno"
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos
    Caption = 'EDUCAMOS Student Receipt', Comment = 'ESP="EDUCAMOS ReciboAlumno"';
    Editable = false;
    PageType = List;
    SourceTable = "EDUCAMOS ReciboAlumno";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id_recibo; Rec.id_recibo)
                {
                }
                field(id_unique_recibo; Rec.id_unique_recibo)
                {
                }
                field(id_alumno; Rec.id_alumno)
                {
                }
                field(id_unique_alumno; Rec.id_unique_alumno)
                {
                }
                field(nombre_alumno; Rec.nombre_alumno)
                {
                }
                field(ape1_alumno; Rec.ape1_alumno)
                {
                }
                field(ape2_alumno; Rec.ape2_alumno)
                {
                }
                field(nif_alumno; Rec.nif_alumno)
                {
                }
                field("Importation DateTime"; Rec."Importation DateTime")
                {
                }
                field(Processed; Rec.Processed)
                {
                }
            }
        }
    }

    actions
    {
    }
}
