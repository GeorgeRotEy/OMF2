page 50154 InformeSaldoCyP
{
    PageType = List;
    Caption = 'P&L Balance Report', Comment = 'ESP="Informe saldo CyP"';
    SourceTable = InformeSaldoCyP;
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
                field("Document Type"; Rec."Document Type")
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
        Rec.SETFILTER("Nº Cuenta", '4100001|4000001|4300001');
    end;
}
