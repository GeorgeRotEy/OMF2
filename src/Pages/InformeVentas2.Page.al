page 50153 InformeVentas2
{
    PageType = List;
    Caption = 'Sales Report 2', Comment = 'ESP="Informe ventas 2"';
    SourceTable = "Plan Corporativo";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
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
        Rec.SETFILTER("No.", '6???|7???');
    end;
}
