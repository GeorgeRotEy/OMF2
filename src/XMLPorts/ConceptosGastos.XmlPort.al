xmlport 50004 "Conceptos Gastos"
{
    UseDefaultNamespace = true;
    Caption = 'Expense Concepts', Comment = 'ESP="Conceptos Gastos"';

    schema
    {
        textelement(Root)
        {
            tableelement("Easy Register Concepts"; "Easy Register Concepts")
            {
                XmlName = 'Conceptos';
                SourceTableView = WHERE(Type = CONST(2));
                fieldelement(CodConcepto; "Easy Register Concepts".Code)
                {
                }
                fieldelement(Description; "Easy Register Concepts".Description)
                {
                }
            }
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }
}
