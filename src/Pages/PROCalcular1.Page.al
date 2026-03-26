page 50136 "PRO-Calcular1"
{
    PageType = List;
    Caption = 'Calculate 1', Comment = 'ESP="Calcular 1"';
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
        Rec.SETFILTER(Empresa, 'PRO*|COL*');
        Rec.SETFILTER("Nº Cuenta", '20*|21*|23*|6*|7*|5505007|5530001');
    end;
}
