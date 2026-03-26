page 50160 "Main Bank Page"
{
    PageType = List;
    Caption = 'Main Bank Page', Comment = 'ESP="Página banco principal"';
    SourceTable = "Main Bank Table";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Main Bank"; Rec."Main Bank")
                {
                }
            }
        }
    }

    actions
    {
    }
}
