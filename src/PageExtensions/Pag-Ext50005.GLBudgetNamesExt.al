pageextension 50005 "G/L Budget Names Ext" extends "G/L Budget Names"
{
    // Mod. S2G (RBM-R) GF-007: Control Presupuestario
    //   (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
    layout
    {
        addafter(Blocked)
        {
            field(Active; Rec.Active)
            {
                ApplicationArea = All;
            }
            field(Template; Rec.Template)
            {
                ApplicationArea = All;
            }
            field("Last Year Budget"; Rec."Last Year Budget")
            {
                ApplicationArea = All;
            }
            field("Power BI"; Rec."Power BI")
            {
                ApplicationArea = All;
            }
        }
    }
}
