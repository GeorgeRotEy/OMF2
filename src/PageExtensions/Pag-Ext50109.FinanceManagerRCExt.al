pageextension 50109 "Finance Manager RC Ext" extends "Finance Manager Role Center"
{
    layout
    {
        addlast(rolecenter)
        {
            part(DashboardWorkLinksFMPart; "Dashboard Work Links Part")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("Detail Trial Balance")
        {
            action("Main Accounting Book Schools")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Libro mayor OFM Colegios';
                Image = Report;
                RunObject = Report "Main Accounting Book Schools";
                ToolTip = 'Ejecuta el informe Libro mayor OFM Colegios.';
            }
        }
        addlast(Sections)
        {
            group(WorkLinksFM)
            {
                Caption = 'Enlaces de trabajo';

                action(DashboardWorkLinksFMAction)
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

pageextension 50110 "Accountant RC Ext" extends "Accountant Role Center"
{
    layout
    {
        addlast(rolecenter)
        {
            part(DashboardWorkLinksACCPart; "Dashboard Work Links Part")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast("G/L Reports")
        {
            action("Main Accounting Book Schools")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Libro mayor OFM Colegios';
                Image = Report;
                RunObject = Report "Main Accounting Book Schools";
                ToolTip = 'Ejecuta el informe Libro mayor OFM Colegios.';
            }
        }
        addlast(Sections)
        {
            group(WorkLinksACC)
            {
                Caption = 'Enlaces de trabajo';

                action(DashboardWorkLinksACCAction)
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

pageextension 50111 "Accounting Manager RC Ext" extends "Accounting Manager Role Center"
{
    layout
    {
        addlast(rolecenter)
        {
            part(DashboardWorkLinksAMPart; "Dashboard Work Links Part")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("Detail Account Statement")
        {
            action("Main Accounting Book Schools")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Libro mayor OFM Colegios';
                Image = Report;
                RunObject = Report "Main Accounting Book Schools";
                ToolTip = 'Ejecuta el informe Libro mayor OFM Colegios.';
            }
        }
        addlast(Sections)
        {
            group(WorkLinksAM)
            {
                Caption = 'Enlaces de trabajo';

                action(DashboardWorkLinksAMAction)
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