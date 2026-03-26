page 50123 "Observaciones Sublist"
{
    AutoSplitKey = true;
    Caption = 'Observations Sublist', Comment = 'ESP="Observaciones"';
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
