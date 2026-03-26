page 50135 "PRO-MovPresupuesto1"
{
    PageType = List;
    Caption = 'Budget Movements 1', Comment = 'ESP="Movimientos presupuesto 1"';
    SourceTable = TablaMovPresupuesto;
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
                field(Fecha; Rec.Fecha)
                {
                }
                field("Nº Cuenta"; Rec."Nº Cuenta")
                {
                }
                field(Importe; Rec.Importe)
                {
                }
                field("Entidad Codigo"; Rec."Entidad Codigo")
                {
                }
                field(Descripcion; Rec.Descripcion)
                {
                }
                field(Date; Rec.Date)
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
        Rec.SETFILTER("Nº cuenta", '20*|21*|23*|6*|7*|5505007|5530001');
    end;
}
