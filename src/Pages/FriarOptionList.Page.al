page 50146 "Friar Option List"
{
    Caption = 'Friar Option List', Comment = 'ESP="Opciones Hermano"';
    PageType = List;
    SourceTable = "Friar Options";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Nº Serie Friar"; Rec."Nº Serie Friar")
                {
                }
                field("Data Friar Type"; Rec."Data Friar Type")
                {
                }
                field("Nombre Hermano"; Rec."Nombre Hermano")
                {
                }
                field("Apellido Hermano"; Rec."Apellido Hermano")
                {
                }
                field(Descripcion; Rec.Descripcion)
                {
                }
            }
        }
    }

    actions
    {
    }
}
