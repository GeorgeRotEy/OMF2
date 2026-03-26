page 50140 "COL-MovContabilidadGastos"
{
    PageType = List;
    Caption = 'Accounting Expense Movements', Comment = 'ESP="Movimientos contabilidad gastos"';
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
                field("Nº mov"; Rec."Nº mov")
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
                field("Entidad Codigo"; Rec."Entidad Codigo")
                {
                }
                field("Actividad Codigo"; Rec."Actividad Codigo")
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
        Rec.SETFILTER("Nº Cuenta", '6*|7402001|7020001');
    end;
}
