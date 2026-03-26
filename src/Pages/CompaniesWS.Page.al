page 50034 "Companies WS"
{
    PageType = List;
    Caption = 'Companies WS', Comment = 'ESP="Empresas WS"';
    SourceTable = "Company OFM";
    SourceTableView = SORTING(Name)
                      WHERE("Easy Register" = CONST(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                }
            }
        }
    }

    actions
    {
    }
}
