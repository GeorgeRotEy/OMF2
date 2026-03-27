page 50056 "EDUCAMOS Input Data"
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    PageType = List;
    Caption = 'EDUCAMOS Input Data', Comment = 'ESP="EDUCAMOS Datos entrada"';
    SourceTable = "EDUCAMOS Input Data";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            grid(grid)
            {
                repeater(repeater)
                {
                    field("Entry No."; Rec."Entry No.")
                    {
                        Editable = false;
                    }
                    field("Importation DateTime"; Rec."Importation DateTime")
                    {
                        Editable = false;
                    }
                }
                group(Group)
                {
                    part("EDUCAMOS Input Data Subform"; "EDUCAMOS Input Data Subform")
                    {
                        ShowFilter = false;
                        SubPageLink = "Entry No." = FIELD("Entry No.");
                    }
                }
            }
        }
    }
}
