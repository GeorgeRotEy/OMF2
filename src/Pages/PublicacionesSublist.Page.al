page 50121 "Publicaciones Sublist"
{
    AutoSplitKey = true;
    Caption = 'Publications Sublist', Comment = 'ESP="Sublista publicaciones"';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Friar Options";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fecha Inicio"; Rec."Fecha Inicio")
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
