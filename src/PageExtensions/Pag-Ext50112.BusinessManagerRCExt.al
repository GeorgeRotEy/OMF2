pageextension 50112 "Business Manager RC Ext" extends "Business Manager Role Center"
{
    layout
    {
        addlast(rolecenter)
        {
            part(DashboardWorkLinksBMPart; "Dashboard Work Links Part")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(Sections)
        {
            group(WorkLinksBM)
            {
                Caption = 'Enlaces de trabajo';

                action(DashboardWorkLinksBMAction)
                {
                    ApplicationArea = All;
                    Caption = 'Enlaces de trabajo';
                    RunObject = Page "Dashboard Work Links";
                    ToolTip = 'Abre la lista de enlaces de trabajo del dashboard.';
                }
            }
        }
    }
}
