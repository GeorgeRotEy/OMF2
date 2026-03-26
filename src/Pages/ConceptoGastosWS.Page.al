page 50031 "Concepto Gastos WS"
{
    PageType = List;
    Caption = 'Expense Concept WS', Comment = 'ESP="Concepto gastos WS"';
    SourceTable = "Easy Register Concepts";
    SourceTableView = WHERE(Type = CONST(Payments));
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
                field(Description; Rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}
