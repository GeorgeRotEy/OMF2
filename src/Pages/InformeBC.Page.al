page 50155 InformeBC
{
    PageType = List;
    Caption = 'BC Report', Comment = 'ESP="Informe BC"';
    SourceTable = InformeBC;
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
                field("Nombre Cuenta"; Rec."Nombre Cuenta")
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
                field("Source Type"; Rec."Source Type")
                {
                }
                field("Source No."; Rec."Source No.")
                {
                }
                field("Source Description"; Rec."Source Description")
                {
                }
                field("Main Bank"; Rec."Main Bank")
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
        Rec.SETFILTER("Nº Cuenta", '5720001|5700001');
    end;
}
