page 50060 "EDUCAMOS Mapeo Servicio Cuenta"
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    Caption = 'Service Account Mapping', Comment = 'ESP="Mapeo Servicio Cuenta"';
    PageType = List;
    SourceTable = "EDUCAMOS Mapeo Servicio Cuenta";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Service Code"; Rec."Service Code")
                {
                }
                field("Service Name"; Rec."Service Name")
                {
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}
