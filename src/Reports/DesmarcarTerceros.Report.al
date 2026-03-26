report 99998 "Desmarcar Terceros"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Third Party"; "Third Party")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                IF NOT vUnMarkThird THEN
                    CurrReport.BREAK
                ELSE BEGIN
                    Company.RESET();
                    IF Company.FINDSET() THEN
                        REPEAT
                            IF vThirdCust THEN
                                FunctionsS2g.DisableCustVendFromThirdParty2("Third Party", ThirdPartyType::Customer, Company.Name);

                            IF vThirdVend THEN
                                FunctionsS2g.DisableCustVendFromThirdParty2("Third Party", ThirdPartyType::Vendor, Company.Name);
                        UNTIL Company.NEXT() = 0;
                END;
            end;
        }
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.")
                                WHERE(Disabled = CONST(true));

            trigger OnAfterGetRecord()
            begin
                IF NOT vDeleteCust THEN
                    CurrReport.BREAK
                ELSE
                    Customer.DELETE(TRUE);
            end;
        }
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.")
                                WHERE(Disabled = CONST(true));

            trigger OnAfterGetRecord()
            begin
                IF NOT vDeleteVend THEN
                    CurrReport.BREAK
                ELSE
                    Vendor.DELETE(TRUE);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Desmarcar)
                {
                    field(DesmarcarTerceros; vUnMarkThird)
                    {
                        ApplicationArea = All;
                    }
                    group(Tipo)
                    {
                        field(Cliente; vThirdCust)
                        {
                            ApplicationArea = All;
                        }
                        field("Prov/Acree"; vThirdVend)
                        {
                            ApplicationArea = All;
                        }
                    }
                }
                group(ELIMINAR)
                {
                    field("ELIMINAR CLIENTES"; vDeleteCust)
                    {
                        ApplicationArea = All;
                    }
                    field("ELIMINAR PROVEEDORES"; vDeleteVend)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        FunctionsS2g: Codeunit "Functions S2G";
        Company: Record Company;
        ThirdPartyType: Option Customer,Vendor;
        vThirdCust: Boolean;
        vThirdVend: Boolean;
        vUnMarkThird: Boolean;
        vDeleteCust: Boolean;
        vDeleteVend: Boolean;
}
