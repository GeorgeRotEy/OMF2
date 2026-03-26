xmlport 50013 "Bank Accounts"
{
    Caption = 'Bank Accounts', Comment = 'ESP="Cuentas bancarias"';
    UseDefaultNamespace = true;

    schema
    {
        textelement(ListaBancos)
        {
            tableelement("Bank Account"; "Bank Account")
            {
                XmlName = 'BankAccount';
                fieldelement(NumBanco; "Bank Account"."No.")
                {
                }
                fieldelement(NombreBanco; "Bank Account".Name)
                {
                }
                fieldelement(Saldo; "Bank Account".Balance)
                {
                    AutoCalcField = true;
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
