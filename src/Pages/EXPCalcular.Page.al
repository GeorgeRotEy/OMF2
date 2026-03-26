page 50103 "EXP-Calcular"
{
    Caption = 'Calculate', Comment = 'ESP="Calcular"';
    PageType = List;
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
        Rec.SETFILTER(Empresa, 'COM*|TIE*|HOS*|UNI*|EDI*');
        Rec.SETFILTER("Nº Cuenta", '20*|21*|23*|6*|7*');
    end;
}
