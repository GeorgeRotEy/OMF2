page 50170 "Dashboard Work Links"
{
    Caption = 'Work Links', Comment = 'ESP="Enlaces de trabajo"';
    PageType = List;
    SourceTable = "Dashboard Work Link";
    SourceTableView = sorting(Active, "Sorting No.", "Page Name");
    ApplicationArea = All;
    UsageCategory = Administration;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sorting No."; Rec."Sorting No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the order in which the link appears on the dashboard.', Comment = 'ESP="Especifica el orden en que se muestra el enlace en el dashboard."';
                }
                field("Page Name"; Rec."Page Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the work page or service name.', Comment = 'ESP="Especifica la página o servicio de trabajo."';
                }
                field(URL; Rec.URL)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the URL to open.', Comment = 'ESP="Especifica la URL que se abrirá."';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies an optional description for the link.', Comment = 'ESP="Especifica una descripción opcional para el enlace."';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the link is shown on the dashboard.', Comment = 'ESP="Especifica si el enlace se muestra en el dashboard."';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = All;
                Caption = 'Open', Comment = 'ESP="Abrir"';
                ToolTip = 'Opens the selected work link.', Comment = 'ESP="Abre el enlace de trabajo seleccionado."';

                trigger OnAction()
                begin
                    if Rec.URL = '' then
                        exit;

                    Hyperlink(Rec.URL);
                end;
            }
        }
    }
}
