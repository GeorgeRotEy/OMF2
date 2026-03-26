page 50152 InformeVentas
{
    PageType = List;
    Caption = 'Sales Report', Comment = 'ESP="Informe ventas"';
    SourceTable = TablaMovContabilidad;
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
                field(Descripcion; Rec.Descripcion)
                {
                }
                field("Nº Cuenta"; Rec."Nº Cuenta")
                {
                }
                field("Fecha registro"; Rec."Fecha registro")
                {
                }
                field(Importe; Rec.Importe)
                {
                }
                field("Nº mov"; Rec."Nº mov")
                {
                }
                field("Account Name"; Rec."Account Name")
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
        Rec.SETFILTER("Nº Cuenta", '6??????|7??????');
    end;
}
