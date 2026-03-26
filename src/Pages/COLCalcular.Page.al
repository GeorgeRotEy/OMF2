page 50115 "COL-Calcular"
{
    PageType = List;
    SourceTable = "Cuentas Empresa";
    Caption = 'Calculate', Comment = 'ESP="Calcular"';
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
        Rec.SETFILTER(Rec.Empresa, 'COL*');
        Rec.SETFILTER(Rec."Nº Cuenta", '20*|21*|23*|6*|7*');
    end;
}
