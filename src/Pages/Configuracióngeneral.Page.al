page 50025 "Configuración general"
{
    PageType = Card;
    Caption = 'General Setup', Comment = 'ESP="Configuración general"';
    SourceTable = "General Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(ThirdParties)
            {
                Caption = 'Third Parties', Comment = 'ESP="Terceros"';
                field("Centralized Third Party Mgt."; Rec."Centralized Third Party Mgt.")
                {
                }
                field("Customer Numbering Preffix"; Rec."Customer Numbering Preffix")
                {
                }
                field("Vendor Numbering Preffix"; Rec."Vendor Numbering Preffix")
                {
                }
                field("Creditor Numbering Preffix"; Rec."Creditor Numbering Preffix")
                {
                }
            }
        }
    }

    actions
    {
    }
}
