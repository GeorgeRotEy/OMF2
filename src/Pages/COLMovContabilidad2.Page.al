page 50133 "COL-MovContabilidad2"
{
    PageType = List;
    Caption = 'Accounting Movements 2', Comment = 'ESP="Movimientos contabilidad 2"';
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
                field("Entidad Codigo"; Rec."Entidad Codigo")
                {
                }
                field("Actividad Codigo"; Rec."Actividad Codigo")
                {
                }
                field("Servicio Codigo"; Rec."Servicio Codigo")
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
        Rec.SETFILTER(Empresa, 'COL*|PRO*');
        Rec.SETFILTER("Nº Cuenta", '20*|21*|23*|6*|7*');
    end;
}
