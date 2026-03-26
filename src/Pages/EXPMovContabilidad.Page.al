page 50102 "EXP-MovContabilidad"
{
    PageType = List;
    Caption = 'Accounting Movements', Comment = 'ESP="Movimientos contabilidad"';
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
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        Rec.SETFILTER(Empresa, 'COM*|TIE*|HOS*|UNI*|EDI*');
        Rec.SETFILTER("Nº Cuenta", '20*|21*|23*|6*|7*');
    end;
}
