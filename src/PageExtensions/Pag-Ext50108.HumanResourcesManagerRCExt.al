pageextension 50108 "Human Resources Mgr. RC Ext" extends "Human Resources Manager RC"
{
    actions
    {
        addafter("Group")
        {
            group("Hermanos")
            {
                Caption = 'Hermanos';
                Image = HumanResources;

                action("Directorio Hermanos")
                {
                    ApplicationArea = All;
                    Caption = 'Directorio Hermanos';
                    Image = List;
                    RunObject = Page "List friar";
                    ToolTip = 'Abre el directorio de hermanos.';
                }
                action("Destino Hermano")
                {
                    ApplicationArea = All;
                    Caption = 'Destino Hermano';
                    Image = Navigate;
                    RunObject = Page "Destino Hermano";
                    ToolTip = 'Abre los destinos de hermanos.';
                }
                action("Directorio Laboral y SS")
                {
                    ApplicationArea = All;
                    Caption = 'Directorio Laboral y SS';
                    Image = Employee;
                    RunObject = Page "Directorio Laboral y SS list";
                    ToolTip = 'Abre el directorio laboral y de Seguridad Social.';
                }
                action("Regimenes Hermanos")
                {
                    ApplicationArea = All;
                    Caption = 'Regimenes Hermanos';
                    Image = RegisteredDocs;
                    RunObject = Page "Regimen Actual List";
                    ToolTip = 'Abre los regimenes de hermanos.';
                }
                action("Macro Tabla")
                {
                    ApplicationArea = All;
                    Caption = 'Macro Tabla';
                    Image = Table;
                    RunObject = Page "Macro Tabla";
                    ToolTip = 'Abre la macro tabla.';
                }
            }
        }
    }
}
