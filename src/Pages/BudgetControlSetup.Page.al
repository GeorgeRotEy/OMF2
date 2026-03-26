page 50007 "Budget Control Setup"
{
    // Mod. S2G (RBM-R) GF-007: Control Presupuestario

    Caption = 'Budget Control Setup', Comment = 'ESP="Configuración control presupuestario"';
    PageType = Card;
    SourceTable = "Budget Control Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Control Start Date"; Rec."Control Start Date")
                {
                }
                field("Control End Date"; Rec."Control End Date")
                {
                }
            }
            group(Prompts)
            {
                Caption = 'Prompts', Comment = 'ESP="Avisos"';
                field("Message %"; Rec."Message %")
                {
                }
                field("Warning %"; Rec."Warning %")
                {
                }
                field("Error %"; Rec."Error %")
                {
                }
                field("Email Address Message"; Rec."Email Address Message")
                {
                }
                field("Email Address Warning"; Rec."Email Address Warning")
                {
                }
                field("Email Address Error"; Rec."Email Address Error")
                {
                }
            }
            group("Dimensions Control")
            {
                Caption = 'Dimensions Control', Comment = 'ESP="Control de dimensiones"';
                field("Global Dim. 1 Control"; Rec."Global Dim. 1 Control")
                {
                }
                field("Global Dim. 2 Control"; Rec."Global Dim. 2 Control")
                {
                }
            }
        }
    }

    actions
    {
    }
}
