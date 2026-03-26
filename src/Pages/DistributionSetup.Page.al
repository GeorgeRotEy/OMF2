page 50029 "Distribution Setup"
{
    // Mód. S2G (ABC) 20/02/2017 UPGRADE NAV 5.00 SP1 to 2017

    Caption = 'Distribution Setup', Comment = 'ESP="Configuración distribución"';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Analytical Distribution Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No Series Assignment"; Rec."No Series Assignment")
                {
                }
                field("Transfer start date"; Rec."Transfer start date")
                {
                }
                field("No Series Distribution"; Rec."No Series Distribution")
                {
                }
            }
        }
    }

    actions
    {
    }
}
