page 50030 "Concepto Ingresos WS"
{
    PageType = List;
    Caption = 'Income Concept WS', Comment = 'ESP="Concepto ingresos WS"';
    SourceTable = "Easy Register Concepts";
    SourceTableView = WHERE(Type = CONST(Receipts));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field("Account Type"; Rec."Account Type")
                {
                }
                field("Account No."; Rec."Account No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Type; Rec.Type)
                {
                }
            }
        }
    }

    actions
    {
    }
}
