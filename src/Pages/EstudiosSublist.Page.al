page 50120 "Estudios Sublist"
{
    AutoSplitKey = true;
    Caption = 'Studies Sublist', Comment = 'ESP="Sublista estudios"';
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

    trigger OnOpenPage()
    begin
        //SETRANGE(Opciones,Rec.Opciones::Estudios);
    end;
}
