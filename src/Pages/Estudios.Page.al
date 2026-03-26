page 50012 Estudios
{
    PageType = List;
    Caption = 'Studies', Comment = 'ESP="Estudios"';
    SourceTable = "Friar Ledger Entry";
    SourceTableView = SORTING("No. Mov")
                      ORDER(Ascending)
                      WHERE(Type = CONST(estudio));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Serie Friar"; Rec."No. Serie Friar")
                {
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field("Date start"; Rec."Date start")
                {
                }
                field("Date end"; Rec."Date end")
                {
                }
                field(Comments; Rec.Comments)
                {
                }
                field(Active; Rec.Active)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::estudio;
    end;
}
