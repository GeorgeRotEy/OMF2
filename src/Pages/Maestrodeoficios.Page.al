page 50016 "Maestro de oficios"
{
    PageType = List;
    Caption = 'Occupation Master', Comment = 'ESP="Maestro de oficios"';
    SourceTable = "Values Friar";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id_job; Rec.Id_job)
                {
                }
                field("Job type"; Rec."Job type")
                {
                }
                field(Job; Rec.Job)
                {
                }
                field(Category; Rec.Category)
                {
                }
            }
        }
    }

    actions
    {
    }
}
