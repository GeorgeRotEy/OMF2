xmlport 50000 "Bancos Empresa"
{
    UseDefaultNamespace = true;
    Caption = 'Company Banks', Comment = 'ESP="Bancos Empresa"';

    schema
    {
        textelement(Root)
        {
            tableelement("Bank Account"; "Bank Account")
            {
                XmlName = 'Banco';
                fieldelement(CodBanco; "Bank Account"."No.")
                {
                }
                fieldelement(NombreBanco; "Bank Account".Name)
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
