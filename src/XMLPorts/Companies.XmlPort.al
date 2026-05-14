xmlport 50001 Companies
{
    UseDefaultNamespace = true;
    Caption = 'Companies', Comment = 'ESP="Empresas"';

    schema
    {
        textelement(Root)
        {
            tableelement(Company; Company)
            {
                XmlName = 'Companies';
                // SourceTableView = WHERE(Field50000 = CONST(true));
                fieldelement(Empresa; Company.Name)
                {
                }
                textelement(TrozoURL)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    URL := GETURL(CLIENTTYPE::SOAP, Company.Name, OBJECTTYPE::Codeunit, 50002);

                    n := STRPOS(URL, Text000Lbl);
                    m := STRPOS(URL, Text001Lbl);

                    SubStr1 := DELSTR(URL, n, STRLEN(URL));
                    SubStr2 := DELSTR(SubStr1, 1, STRLEN(Text001Lbl));

                    TrozoURL := SubStr2;
                end;
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

    var
        n: Integer;
        m: Integer;
        Text000Lbl: Label '/Codeunit/ServiciosWebOFM';
        Text001Lbl: Label 'http://OFMNAV.ofminmaculada.local:2102/WS/WS/';
        SubStr1: Text;
        SubStr2: Text;
        URL: Text;
        CompanyOFM: Record "Company OFM";
}
