page 50113 "COL-MovPresupuesto"
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
                field("Nº cuenta"; Rec."Nº cuenta")
                {
                }
                field(Importe; Rec.Importe)
                {
                }
                field("Entidad Codigo"; Rec."Entidad Codigo")
                {
                }
                field(Alumnos; Rec.Alumnos)
                {
                }
                field(Comentario; Rec.Comentario)
                {
                }
                field("Servicio Codigo"; Rec."Servicio Codigo")
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
        Rec.SETFILTER(Empresa, 'COL*');
        Rec.SETFILTER("Nº cuenta", '20*|21*|23*|6*|7*');
    end;
}
