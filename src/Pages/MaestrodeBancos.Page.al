page 50150 "Maestro de Bancos"
{
    PageType = List;
    Caption = 'Bank Master', Comment = 'ESP="Maestro de Bancos"';
    SourceTable = "CCC Cod. Bancos";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("CCC Bank No."; Rec."CCC Bank No.")
                {
                    Caption = 'Nº';
                }
                field(Alias; Rec.Alias)
                {
                }
            }
        }
    }

    actions
    {
    }
}
