xmlport 50009 Activos
{
    UseDefaultNamespace = true;
    Caption = 'Fixed Assets', Comment = 'ESP="Activos"';

    schema
    {
        textelement(Root)
        {
            tableelement("Fixed Asset"; "Fixed Asset")
            {
                XmlName = 'Activo';
                fieldelement(CodActivo; "Fixed Asset"."No.")
                {
                }
                fieldelement(DescActivo; "Fixed Asset".Description)
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
