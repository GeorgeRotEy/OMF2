page 50145 "Regimen Actual List"
{
    Caption = 'Current Regime List', Comment = 'ESP="Regímenes Hermanos"';
    PageType = List;
    SourceTable = "Regimen Actual";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Nº Serie Friar"; Rec."Nº Serie Friar")
                {
                }
                field("Nombre Hermano"; Rec."Nombre Hermano")
                {
                }
                field("Apellido Hermano"; Rec."Apellido Hermano")
                {
                }
                field(" Tipo Situación"; Rec."Tipo Regimen")
                {
                }
                field("Régimen Actual"; Rec."Régimen Actual")
                {
                }
                field("Fecha Inicio"; Rec."Fecha Inicio")
                {
                }
                field("Fecha fin"; Rec."Fecha fin")
                {
                }
                field("Importe/Base"; Rec.Base)
                {
                    Caption = 'Importe/Base';
                }
                field(Cuota; Rec."Importe/Base")
                {
                    Caption = 'Cuota';
                }
                field("Seguro Médico"; Rec."Seguro Médico")
                {
                    OptionCaption = ' ,No,Sanitas,Sanitas VOCARE,Asisa General,Asisa Misionero';
                }
                field("Importe Médico"; Rec."Importe Médico")
                {
                }
                field("Tipo Pensionista"; Rec."Tipo Pensionista")
                {
                }
                field("Importe Pensionista"; Rec."Importe Pensionista")
                {
                }
                field("Importe Seguro Médico"; Rec."Importe Seguro Médico")
                {
                }
            }
        }
    }

    actions
    {
    }
}
