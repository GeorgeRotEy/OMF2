page 50004 "Report Sender Setup"
{
    // Mod. S2G (RBM-R) GF-006: Envío de informes
    // KPMG.GRL  New Day of the month field
    // TEMS-363 APAREJA Sacammos el campo Show Row No

    Caption = 'Report Sender Setup', Comment = 'ESP="Envío informes"';
    PageType = List;
    SourceTable = "Reports Sender Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Acc. Schedule Name"; Rec."Acc. Schedule Name")
                {
                }
                field("Column Layout Name"; Rec."Column Layout Name")
                {
                }
                field(Email; Rec.Email)
                {
                }
                field(Active; Rec.Active)
                {
                }
                field("Day of the month"; Rec."Day of the month")
                {
                }
                field("Show Row No."; Rec.ShowRowNo)
                {
                    Caption = 'Mostrar n.º fila';
                }
            }
        }
    }

    actions
    {
    }
}
