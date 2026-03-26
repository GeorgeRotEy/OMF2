xmlport 50005 "Conceptos Transfer"
{
    UseDefaultNamespace = true;
    Caption = 'Transfer Concepts', Comment = 'ESP="Conceptos Transfer"';

    schema
    {
        textelement(Root)
        {
            tableelement("Easy Register Concepts"; "Easy Register Concepts")
            {
                XmlName = 'Conceptos';
                SourceTableView = WHERE(Type = CONST(3));
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
