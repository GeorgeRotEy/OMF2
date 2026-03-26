page 50139 "PRO/COL-MovContabilidad1"
{
    PageType = List;
    Caption = 'Accounting Movements 1', Comment = 'ESP="Movimientos contabilidad 1"';
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
                field(Fecha2; Rec.Fecha2)
                {
                }
                field(Descripcion; Rec.Descripcion)
                {
                }
                field("Entidad Codigo"; Rec."Entidad Codigo")
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
        Rec.SETFILTER("Nº Cuenta", '20*|21*|23*|6*|7*|5505007|5530001');
    end;
}
