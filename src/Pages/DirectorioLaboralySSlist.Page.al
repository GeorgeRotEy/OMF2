page 50124 "Directorio Laboral y SS list"
{
    Caption = 'Employment and SS Directory List', Comment = 'ESP="Lista directorio laboral y SS"';
    CardPageID = "Directorio Laboral y SS card";
    PageType = List;
    SourceTable = Friar;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Serie Friar"; Rec."No. Serie Friar")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Apellidos; Rec.Apellidos)
                {
                }
            }
        }
    }

    actions
    {
    }
}
