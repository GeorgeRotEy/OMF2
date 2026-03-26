page 50005 "Easy Register Concepts"
{
    // Mod. S2G (FMR) 31/10/14 CAR005 Gestión cajas centros
    //
    // (CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple

    Caption = 'Easy Register Concepts', Comment = 'ESP="Conceptos de registro simple"';
    PageType = List;
    SourceTable = "Easy Register Concepts";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Account Type"; Rec."Account Type")
                {
                }
                field("Account No."; Rec."Account No.")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Easy Register Dimension Value"; Rec."Easy Register Dimension Value")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(creation)
        {
        }
    }
}
