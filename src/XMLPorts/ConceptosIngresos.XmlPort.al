xmlport 50003 "Conceptos Ingresos"
{
    UseDefaultNamespace = true;
    Caption = 'Income Concepts', Comment = 'ESP="Conceptos Ingresos"';

    schema
    {
        textelement(Root)
        {
            tableelement("Easy Register Concepts"; "Easy Register Concepts")
            {
                XmlName = 'Conceptos';
                SourceTableView = WHERE(Type = CONST(1));
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
