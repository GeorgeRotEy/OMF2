xmlport 50007 "G/L Account List"
{
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple

    UseDefaultNamespace = true;
    Caption = 'G/L Account List', Comment = 'ESP="Lista cuentas contables"';

    schema
    {
        textelement(Root)
        {
            tableelement("G/L Account"; "G/L Account")
            {
                XmlName = 'Cuentas';
                SourceTableView = SORTING("Account Type")
                                  ORDER(Ascending)
                                  WHERE("Account Type" = CONST(Posting));
                fieldelement(No; "G/L Account"."No.")
                {
                }
                fieldelement(Name; "G/L Account".Name)
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
