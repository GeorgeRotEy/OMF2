page 50109 "PRO-MovPresupuesto"
{
    PageType = List;
    Caption = 'Budget Movements', Comment = 'ESP="Movimientos presupuesto"';
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
                field(Comentario; Rec.Comentario)
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
        Rec.SETFILTER(Empresa, 'PRO*');
        Rec.SETFILTER("Nº cuenta", '20*|21*|23*|6*|7*|5505007|5530001');
    end;
}
