page 50036 "Reports Generation"
{
    Caption = 'Reports Generation', Comment = 'ESP="Generación de informes"';
    PageType = List;
    SourceTable = "Reports Generation";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Custom Report"; Rec."Custom Report")
                {
                }
                field("Report ID"; Rec."Report ID")
                {
                }
                field("Report name"; Rec."Report name")
                {
                }
                field("Format to export"; Rec."Format to export")
                {
                }
                field("Email to export"; Rec."Email to export")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Run Report")
            {
                Caption = 'Ejecutar informe', Comment = 'ESP="Ejecutar informe"';
                Image = "Action";

                trigger OnAction()
                begin
                    REPORT.RUN(Rec."Report ID", TRUE);
                end;
            }
            action("Guardar en PDF")
            {
                Image = Print;
                Caption = 'Save as PDF', Comment = 'ESP="Guardar en PDF"';
                trigger OnAction()
                begin
                    //-CR01
                    Rec.openReportPDF;
                    //+CR01
                end;
            }
            action("Guardar en Excel")
            {
                Image = Excel;
                Caption = 'Save as Excel', Comment = 'ESP="Guardar en Excel"';
                trigger OnAction()
                begin
                    //--CR01
                    Rec.openReportEXCEL;
                    //++CR01
                end;
            }
            action(Test)
            {
                Caption = 'Report Presupuestos Filtro Fecha', Comment = 'ESP="Informe de presupuestos con filtro de fecha"';

                trigger OnAction()
                var
                    TestDate: Date;
                begin
                    REPORT.RUN(Report::"Export Templ Bud Excel KPMG", TRUE);
                end;
            }
        }
        area(Promoted)
        {
            actionref(Run_Promoted; "Run Report") { }
            actionref(PDF_Promoted; "Guardar en PDF") { }
            actionref(Excel_Promoted; "Guardar en Excel") { }
        }
    }
}
