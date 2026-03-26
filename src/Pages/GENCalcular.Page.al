page 50130 "GEN-Calcular"
{
    PageType = List;
    Caption = 'Calculate', Comment = 'ESP="Calcular"';
    SourceTable = "Cuentas Empresa";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.id)
                {
                }
                field(Empresa; Rec.Empresa)
                {
                }
                field("Nº Cuenta"; Rec."Nº Cuenta")
                {
                }
                field(Descripcion; Rec.Descripcion)
                {
                }
                field(Año; Rec.Año)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SETFILTER(Empresa, 'COM*|TIE*|HOS*|UNI*|EDI*|COL*|FRA*|PRO*');
        Rec.SETFILTER("Nº Cuenta", '20*|21*|23*|6*|7*|5505007|5530001');
    end;
}
