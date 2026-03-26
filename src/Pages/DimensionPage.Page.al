page 50167 DimensionPage
{
    PageType = List;
    Caption = 'Dimension Page', Comment = 'ESP="Página dimensiones"';
    SourceTable = DimensionTable;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; Rec.Id)
                {
                }
                field(Code; Rec.Code)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Company; Rec.Company)
                {
                }
            }
        }
    }

    actions
    {
    }
}
