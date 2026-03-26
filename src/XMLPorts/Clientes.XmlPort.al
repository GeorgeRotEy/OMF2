xmlport 50008 Clientes
{
    UseDefaultNamespace = true;
    Caption = 'Customers', Comment = 'ESP="Clientes"';

    schema
    {
        textelement(ListaClientes)
        {
            tableelement(Customer; Customer)
            {
                XmlName = 'Cliente';
                SourceTableView = WHERE(Disabled = CONST(false));
                fieldelement(CodCliente; Customer."No.")
                {
                }
                fieldelement(NombreCliente; Customer.Name)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //(CR003) S2G (RBM-R) 07-11-18: Modificaciones Registro simple. Inicio
                    //Customer.FindFirstAllowedRec('=');
                    //(CR003) S2G (RBM-R) 07-11-18: Modificaciones Registro simple. Fin
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
}
