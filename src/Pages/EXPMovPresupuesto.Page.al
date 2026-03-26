page 50101 "EXP-MovPresupuesto"
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
                field(Importe; Rec.Importe)
                {
                }
                field("Entidad Codigo"; Rec."Entidad Codigo")
                {
                }
                field(Comentario; Rec.Comentario)
                {
                }
                field("Nº Cuenta"; Rec."Nº Cuenta")
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
        Rec.SETFILTER(Empresa, 'COM*|TIE*|HOS*|UNI*|EDI*');
        Rec.SETFILTER("Nº cuenta", '20*|21*|23*|6*|7*');
    end;
}
