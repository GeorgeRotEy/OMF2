page 50169 "Dashboard Work Links Part"
{
    Caption = 'Work Links', Comment = 'ESP="Enlaces de trabajo"';
    PageType = ListPart;
    SourceTable = "Dashboard Work Link";
    SourceTableView = sorting(Active, "Sorting No.", "Page Name") where(Active = const(true));
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Page Name"; Rec."Page Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the work page or service name.', Comment = 'ESP="Especifica la página o servicio de trabajo."';

                    trigger OnDrillDown()
                    begin
                        OpenLink();
                    end;
                }
                field(URL; Rec.URL)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the URL to open.', Comment = 'ESP="Especifica la URL que se abrirá."';

                    trigger OnDrillDown()
                    begin
                        OpenLink();
                    end;
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
                    OpenLink();
                end;
            }
            action(Manage)
            {
                ApplicationArea = All;
                Caption = 'Manage Links', Comment = 'ESP="Administrar enlaces"';
                RunObject = Page "Dashboard Work Links";
                ToolTip = 'Opens the page to create, edit, or delete work links.', Comment = 'ESP="Abre la página para crear, modificar o eliminar enlaces de trabajo."';
            }
        }
    }

    local procedure OpenLink()
    begin
        if Rec.URL = '' then
            exit;

        Hyperlink(Rec.URL);
    end;
}