xmlport 50002 Proveedores
{
    UseDefaultNamespace = true;
    Caption = 'Vendors', Comment = 'ESP="Proveedores"';

    schema
    {
        textelement(Root)
        {
            tableelement(Vendor; Vendor)
            {
                XmlName = 'Proveedores';
                fieldelement(CodProveedor; Vendor."No.")
                {
                }
                fieldelement(NomProveedor; Vendor.Name)
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
