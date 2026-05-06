page 50004 "Report Sender Setup"
{
    // Mod. S2G (RBM-R) GF-006: Report delivery
    // KPMG.GRL New Day of the month field.
    // TEMS-363 Add Show Row No.

    Caption = 'Report Sender Setup', Comment = 'ESP="Envio informes"';
    PageType = List;
    SourceTable = "Reports Sender Setup";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Acc. Schedule Name"; Rec."Acc. Schedule Name")
                {
                    ApplicationArea = All;
                }
                field("Column Layout Name"; Rec."Column Layout Name")
                {
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field("Day of the month"; Rec."Day of the month")
                {
                    ApplicationArea = All;
                }
                field("Show Row No."; Rec.ShowRowNo)
                {
                    ApplicationArea = All;
                    Caption = 'Show Row No.', Comment = 'ESP="Mostrar no. fila"';
                }
            }
        }
    }
}
