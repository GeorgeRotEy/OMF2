page 50013 "Oficio Hermano"
{
    Editable = true;
    Caption = 'Friar Occupation', Comment = 'ESP="Oficio Hermano"';
    PageType = List;
    SourceTable = "Friar Ledger Entry";
    SourceTableView = SORTING("No. Mov")
                      ORDER(Ascending)
                      WHERE(Type = CONST(oficio));
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
                field(Id_job; Rec.Id_job)
                {
                }
                field(Job; Rec.Job)
                {
                    Editable = true;
                }
                field("Job type"; Rec."Job type")
                {
                    Editable = true;
                }
                field(Category; Rec.Category)
                {
                    Editable = true;
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
        Rec.Type := Rec.Type::oficio;
    end;
}
