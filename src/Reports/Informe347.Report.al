report 50037 "Informe - 347"
{
    // S2G(AAM) - 24/02/2020: Información del 347 por trimestres
    // S2G(JDT) - 02/03/2020: Modificaciones informe:
    //                             Mostrar Importe por campo ŽCompras DL o ŽVentas DL" en tabla detalle Cliente/Proveedor.
    //                             Nueva tabla que muestra movimientos de cliente/proveedor, solo movimientos de tipo documento facturas y abonos.
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Informe347.rdlc';
    Caption = 'Informe 347 - Clientes/Proveedores';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                ORDER(Ascending)
                                WHERE(Number = CONST(1));
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Logo; rCompanyInfo.Picture)
            {
            }
            column(vAnio; vAnio)
            {
            }
            column(vImporteMinCust; vImporteMinCust)
            {
            }
            column(vImporteMinVend; vImporteMinVend)
            {
            }

            trigger OnPreDataItem()
            begin
                rCompanyInfo.GET;
                rCompanyInfo.CALCFIELDS(Picture);
            end;
        }
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", Name;
            column(Customer_No; Customer."No.")
            {
            }
            column(Customer_Name; Customer.Name)
            {
            }
            column(Customer_VATRegistrationNo; Customer."VAT Registration No.")
            {
            }
            column(Customer_Pais; Customer."Country/Region Code")
            {
            }
            column(Customer_Provincia; Customer.County)
            {
            }
            column(Customer_PostCode; Customer."Post Code")
            {
            }
            column(Customer_vTrimestre1; vCustomerTrimestre1)
            {
            }
            column(Customer_vTrimestre2; vCustomerTrimestre2)
            {
            }
            column(Customer_vTrimestre3; vCustomerTrimestre3)
            {
            }
            column(Customer_vTrimestre4; vCustomerTrimestre4)
            {
            }
            column(Customer_TotalImporte; vCustomerTotalImporte)
            {
            }
            column(Customer_ImporteMin; vImporteMinCust)
            {
            }
            column(Customer_Codigo; vCodigo)
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Entry No.");
                column(CustLedgerEntry_EntryNo; "Cust. Ledger Entry"."Entry No.")
                {
                }
                column(CustLedgerEntry_FechaRegistro; "Cust. Ledger Entry"."Posting Date")
                {
                }
                column(CustLedgerEntry_TipoDoc; "Cust. Ledger Entry"."Document Type")
                {
                }
                column(CustLedgerEntry_NoDoc; "Cust. Ledger Entry"."Document No.")
                {
                }
                column(CustLedgerEntry_NoDocExt; "Cust. Ledger Entry"."External Document No.")
                {
                }
                column(CustLedgerEntry_NoCli; "Cust. Ledger Entry"."Customer No.")
                {
                }
                column(CustLedgerEntry_NombreCli; "Cust. Ledger Entry"."Customer Name")
                {
                }
                column(CustLedgerEntry_Descripcion; "Cust. Ledger Entry".Description)
                {
                }
                column(CustLedgerEntry_Importe; "Cust. Ledger Entry".Amount)
                {
                }
                column(vShow_Customer; vShow)
                {
                }
                dataitem(VATEntry_Customer; 254)
                {
                    DataItemLink = "Document No." = FIELD("Document No."),
                                   "Posting Date" = FIELD("Posting Date");
                    DataItemTableView = SORTING("Document No.", "Posting Date");
                    column(CustLedgerEntry_ImporteBase; VATEntry_Customer.Base)
                    {
                    }
                    column(CustLedgerEntry_ImporteIVA; VATEntry_Customer.Amount)
                    {
                    }
                }

                trigger OnPreDataItem()
                begin
                    //S2G(JDT) - 02/03/2020: Modificaciones informe:
                    "Cust. Ledger Entry".SETFILTER("Cust. Ledger Entry"."Document Type", '%1|%2', "Cust. Ledger Entry"."Document Type"::Invoice, "Cust. Ledger Entry"."Document Type"::"Credit Memo");
                    "Cust. Ledger Entry".SETFILTER("Cust. Ledger Entry"."Posting Date", '%1..%2', DMY2DATE(1, 1, vAnio), DMY2DATE(31, 12, vAnio));
                    IF "Cust. Ledger Entry".FINDSET THEN;
                    //S2G(JDT) - 02/03/2020: Modificaciones informe:
                end;
            }

            trigger OnAfterGetRecord()
            var
                rlCustLedgerEntry: Record "Cust. Ledger Entry";
                rlDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
            begin
                CLEAR(vCustomerTrimestre1);
                CLEAR(vCustomerTrimestre2);
                CLEAR(vCustomerTrimestre3);
                CLEAR(vCustomerTrimestre4);
                CLEAR(vCustomerTotalImporte);
                //S2G(JDT) - 02/03/2020: Modificaciones informe:
                CLEAR(vCodigo);
                vCodigo := 'B';
                //S2G(JDT) - 02/03/2020: Modificaciones informe:

                // 1 Trimestre
                CLEAR(rlCustLedgerEntry);
                rlCustLedgerEntry.SETCURRENTKEY("Customer No.");
                rlCustLedgerEntry.SETRANGE("Customer No.", Customer."No.");
                rlCustLedgerEntry.SETFILTER("Document Type", '%1|%2', rlCustLedgerEntry."Document Type"::Invoice, rlCustLedgerEntry."Document Type"::"Credit Memo");
                rlCustLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, 1, vAnio), DMY2DATE(31, 3, vAnio));
                //rlCustLedgerEntry.CALCSUMS(Amount);
                IF rlCustLedgerEntry.FINDFIRST THEN
                    REPEAT BEGIN
                        //S2G(JDT) - 02/03/2020: Modificaciones informe:
                        rlCustLedgerEntry.CALCFIELDS(Amount);
                        vCustomerTrimestre1 += rlCustLedgerEntry.Amount;
                        //S2G(JDT) - 02/03/2020: Modificaciones informe:
                    END;
                    UNTIL rlCustLedgerEntry.NEXT = 0;

                // 2 Trimestre
                CLEAR(rlCustLedgerEntry);
                rlCustLedgerEntry.SETRANGE("Customer No.", Customer."No.");
                rlCustLedgerEntry.SETFILTER("Document Type", '%1|%2', rlCustLedgerEntry."Document Type"::Invoice, rlCustLedgerEntry."Document Type"::"Credit Memo");
                rlCustLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, 4, vAnio), DMY2DATE(30, 6, vAnio));
                //rlCustLedgerEntry.CALCSUMS(Amount);
                IF rlCustLedgerEntry.FINDFIRST THEN
                    REPEAT BEGIN
                        //S2G(JDT) - 02/03/2020: Modificaciones informe:
                        rlCustLedgerEntry.CALCFIELDS(Amount);
                        vCustomerTrimestre2 += rlCustLedgerEntry.Amount;
                    END;
                    //S2G(JDT) - 02/03/2020: Modificaciones informe:
                    UNTIL rlCustLedgerEntry.NEXT = 0;

                // 3 Trimestre
                CLEAR(rlCustLedgerEntry);
                rlCustLedgerEntry.SETRANGE("Customer No.", Customer."No.");
                rlCustLedgerEntry.SETFILTER("Document Type", '%1|%2', rlCustLedgerEntry."Document Type"::Invoice, rlCustLedgerEntry."Document Type"::"Credit Memo");
                rlCustLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, 7, vAnio), DMY2DATE(30, 9, vAnio));
                //rlCustLedgerEntry.CALCSUMS(Amount);
                IF rlCustLedgerEntry.FINDFIRST THEN
                    REPEAT BEGIN
                        //S2G(JDT) - 02/03/2020: Modificaciones informe:
                        rlCustLedgerEntry.CALCFIELDS(Amount);
                        vCustomerTrimestre3 += rlCustLedgerEntry.Amount;
                    END;
                    //S2G(JDT) - 02/03/2020: Modificaciones informe:
                    UNTIL rlCustLedgerEntry.NEXT = 0;

                // 4 Trimestre
                CLEAR(rlCustLedgerEntry);
                rlCustLedgerEntry.SETRANGE("Customer No.", Customer."No.");
                rlCustLedgerEntry.SETFILTER("Document Type", '%1|%2', rlCustLedgerEntry."Document Type"::Invoice, rlCustLedgerEntry."Document Type"::"Credit Memo");
                rlCustLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, 10, vAnio), DMY2DATE(31, 12, vAnio));
                //rlCustLedgerEntry.CALCSUMS(Amount);
                IF rlCustLedgerEntry.FINDFIRST THEN
                    REPEAT BEGIN
                        //S2G(JDT) - 02/03/2020: Modificaciones informe:
                        rlCustLedgerEntry.CALCFIELDS(Amount);
                        vCustomerTrimestre4 += rlCustLedgerEntry.Amount;
                    END;
                    //S2G(JDT) - 02/03/2020: Modificaciones informe:
                    UNTIL rlCustLedgerEntry.NEXT = 0;

                // Totales Linea Cliente
                vCustomerTotalImporte := vCustomerTrimestre1 + vCustomerTrimestre2 + vCustomerTrimestre3 + vCustomerTrimestre4;

                //S2G(JDT) - 05/03/2020: Modificaciones informe:
                //Totales
                CLEAR(vShow);
                IF vCustomerTotalImporte > vImporteMinCust THEN BEGIN
                    vCustomerTotalT1 += vCustomerTrimestre1;
                    vCustomerTotalT2 += vCustomerTrimestre2;
                    vCustomerTotalT3 += vCustomerTrimestre3;
                    vCustomerTotalT4 += vCustomerTrimestre4;
                    vCustomerTotal += vCustomerTotalImporte;
                    vShow := TRUE;
                END;
                //S2G(JDT) - 05/03/2020: Modificaciones informe:
            end;
        }
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.", Name;
            column(Vendor_No; Vendor."No.")
            {
            }
            column(Vendor_Name; Vendor.Name)
            {
            }
            column(Vendor_VATRegistrationNo; Vendor."VAT Registration No.")
            {
            }
            column(Vendor_Pais; Vendor."Country/Region Code")
            {
            }
            column(Vendor_Provincia; Vendor.County)
            {
            }
            column(Vendor_PostCode; Vendor."Post Code")
            {
            }
            column(Vendor_vTrimestre1; vVendorTrimestre1)
            {
            }
            column(Vendor_vTrimestre2; vVendorTrimestre2)
            {
            }
            column(Vendor_vTrimestre3; vVendorTrimestre3)
            {
            }
            column(Vendor_vTrimestre4; vVendorTrimestre4)
            {
            }
            column(Vendor_TotalImporte; vVendorTotalImporte)
            {
            }
            column(Vendor_ImporteMin; vImporteMinVend)
            {
            }
            column(Vendor_Codigo; vCodigo)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Entry No.");
                column(VendLedgerEntry_EntryNo; "Vendor Ledger Entry"."Entry No.")
                {
                }
                column(VendLedgerEntry_FechaRegistro; "Vendor Ledger Entry"."Posting Date")
                {
                }
                column(VendLedgerEntry_TipoDoc; "Vendor Ledger Entry"."Document Type")
                {
                }
                column(VendLedgerEntry_NoDoc; "Vendor Ledger Entry"."Document No.")
                {
                }
                column(VendLedgerEntry_NoDocExt; "Vendor Ledger Entry"."External Document No.")
                {
                }
                column(VendLedgerEntry_NoVend; "Vendor Ledger Entry"."Vendor No.")
                {
                }
                column(VendLedgerEntry_NombreVend; "Vendor Ledger Entry"."Vendor Name")
                {
                }
                column(VendLedgerEntry_Descripcion; "Vendor Ledger Entry".Description)
                {
                }
                column(VendLedgerEntry_Importe; "Vendor Ledger Entry".Amount)
                {
                }
                column(vShow_Vendor; vShow)
                {
                }
                dataitem(VATEntry_Vendor; "VAT Entry")
                {
                    DataItemLink = "Document No." = FIELD("Document No."),
                                   "Posting Date" = FIELD("Posting Date");
                    DataItemTableView = SORTING("Document No.", "Posting Date");
                    column(VendLedgerEntry_ImporteBase; VATEntry_Vendor.Base)
                    {
                    }
                    column(VendLedgerEntry_ImporteIVA; VATEntry_Vendor.Amount)
                    {
                    }
                }

                trigger OnPreDataItem()
                begin
                    //S2G(JDT) - 02/03/2020: Modificaciones informe:
                    "Vendor Ledger Entry".SETFILTER("Vendor Ledger Entry"."Document Type", '%1|%2', "Vendor Ledger Entry"."Document Type"::Invoice, "Vendor Ledger Entry"."Document Type"::"Credit Memo");
                    "Vendor Ledger Entry".SETFILTER("Vendor Ledger Entry"."Posting Date", '%1..%2', DMY2DATE(1, 1, vAnio), DMY2DATE(31, 12, vAnio));
                    IF "Vendor Ledger Entry".FINDSET THEN;
                    //S2G(JDT) - 02/03/2020: Modificaciones informe:
                end;
            }

            trigger OnAfterGetRecord()
            var
                rlVendorLedgerEntry: Record "Vendor Ledger Entry";
                rlDetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
            begin
                CLEAR(vVendorTrimestre1);
                CLEAR(vVendorTrimestre2);
                CLEAR(vVendorTrimestre3);
                CLEAR(vVendorTrimestre4);
                CLEAR(vVendorTotalImporte);
                //S2G(JDT) - 02/03/2020: Modificaciones informe:
                CLEAR(vCodigo);
                vCodigo := 'A';
                //S2G(JDT) - 02/03/2020: Modificaciones informe:

                // 1 Trimestre
                CLEAR(rlVendorLedgerEntry);
                //rlVendorLedgerEntry.SETCURRENTKEY("Vendor No.","Posting Date");
                rlVendorLedgerEntry.SETCURRENTKEY("Vendor No.");
                rlVendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
                rlVendorLedgerEntry.SETFILTER("Document Type", '%1|%2', rlVendorLedgerEntry."Document Type"::Invoice, rlVendorLedgerEntry."Document Type"::"Credit Memo");
                rlVendorLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, 1, vAnio), DMY2DATE(31, 3, vAnio));
                //rlVendorLedgerEntry.CALCSUMS(Amount);
                IF rlVendorLedgerEntry.FINDFIRST THEN
                    REPEAT BEGIN
                        //S2G(JDT) - 02/03/2020: Modificaciones informe:
                        rlVendorLedgerEntry.CALCFIELDS(Amount);
                        vVendorTrimestre1 += rlVendorLedgerEntry.Amount;
                    END;
                    //S2G(JDT) - 02/03/2020: Modificaciones informe:
                    UNTIL rlVendorLedgerEntry.NEXT = 0;

                // 2 Trimestre
                CLEAR(rlVendorLedgerEntry);
                rlVendorLedgerEntry.SETCURRENTKEY("Vendor No.");
                rlVendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
                rlVendorLedgerEntry.SETFILTER("Document Type", '%1|%2', rlVendorLedgerEntry."Document Type"::Invoice, rlVendorLedgerEntry."Document Type"::"Credit Memo");
                rlVendorLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, 4, vAnio), DMY2DATE(30, 6, vAnio));
                //rlVendorLedgerEntry.CALCSUMS(Amount);
                IF rlVendorLedgerEntry.FINDFIRST THEN
                    REPEAT BEGIN
                        //S2G(JDT) - 02/03/2020: Modificaciones informe:
                        rlVendorLedgerEntry.CALCFIELDS(Amount);
                        vVendorTrimestre2 += rlVendorLedgerEntry.Amount;
                    END;
                    //S2G(JDT) - 02/03/2020: Modificaciones informe:
                    UNTIL rlVendorLedgerEntry.NEXT = 0;

                // 3 Trimestre
                CLEAR(rlVendorLedgerEntry);
                rlVendorLedgerEntry.SETCURRENTKEY("Vendor No.");
                rlVendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
                rlVendorLedgerEntry.SETFILTER("Document Type", '%1|%2', rlVendorLedgerEntry."Document Type"::Invoice, rlVendorLedgerEntry."Document Type"::"Credit Memo");
                rlVendorLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, 7, vAnio), DMY2DATE(30, 9, vAnio));
                //rlVendorLedgerEntry.CALCSUMS(Amount);
                IF rlVendorLedgerEntry.FINDFIRST THEN
                    REPEAT BEGIN
                        //S2G(JDT) - 02/03/2020: Modificaciones informe:
                        rlVendorLedgerEntry.CALCFIELDS(Amount);
                        vVendorTrimestre3 += rlVendorLedgerEntry.Amount;
                    END;
                    //S2G(JDT) - 02/03/2020: Modificaciones informe:
                    UNTIL rlVendorLedgerEntry.NEXT = 0;

                // 4 Trimestre
                CLEAR(rlVendorLedgerEntry);
                rlVendorLedgerEntry.SETCURRENTKEY("Vendor No.");
                rlVendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
                rlVendorLedgerEntry.SETFILTER("Document Type", '%1|%2', rlVendorLedgerEntry."Document Type"::Invoice, rlVendorLedgerEntry."Document Type"::"Credit Memo");
                rlVendorLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, 10, vAnio), DMY2DATE(31, 12, vAnio));
                //rlVendorLedgerEntry.CALCSUMS(Amount);
                IF rlVendorLedgerEntry.FINDFIRST THEN
                    REPEAT BEGIN
                        //S2G(JDT) - 02/03/2020: Modificaciones informe:
                        rlVendorLedgerEntry.CALCFIELDS(Amount);
                        vVendorTrimestre4 += rlVendorLedgerEntry.Amount;
                    END;
                    //S2G(JDT) - 02/03/2020: Modificaciones informe:
                    UNTIL rlVendorLedgerEntry.NEXT = 0;

                // Totales Linea Proveedor
                vVendorTotalImporte := vVendorTrimestre1 + vVendorTrimestre2 + vVendorTrimestre3 + vVendorTrimestre4;

                //S2G(JDT) - 05/03/2020: Modificaciones informe:
                //Totales
                CLEAR(vShow);
                IF vVendorTotalImporte < vImporteMinVend THEN BEGIN
                    vVendorTotalT1 += vVendorTrimestre1;
                    vVendorTotalT2 += vVendorTrimestre2;
                    vVendorTotalT3 += vVendorTrimestre3;
                    vVendorTotalT4 += vVendorTrimestre4;
                    vVendorTotal += vVendorTotalImporte;
                    vShow := TRUE;
                END;
                //S2G(JDT) - 05/03/2020: Modificaciones informe:
            end;
        }
        dataitem(Totales; 2000000026)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
            column(vCustomerTotalT1; vCustomerTotalT1)
            {
            }
            column(vCustomerTotalT2; vCustomerTotalT2)
            {
            }
            column(vCustomerTotalT3; vCustomerTotalT3)
            {
            }
            column(vCustomerTotalT4; vCustomerTotalT4)
            {
            }
            column(vCustomerTotal; vCustomerTotal)
            {
            }
            column(vVendorTotalT1; vVendorTotalT1)
            {
            }
            column(vVendorTotalT2; vVendorTotalT2)
            {
            }
            column(vVendorTotalT3; vVendorTotalT3)
            {
            }
            column(vVendorTotalT4; vVendorTotalT4)
            {
            }
            column(vVendorTotal; vVendorTotal)
            {
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Opciones)
                {
                    field(Anio; vAnio)
                    {
                        Caption = 'Año';
                    }
                    field(vImporteCust; vImporteMinCust)
                    {
                        Caption = 'Clientes Importe mínimo';
                    }
                    field(vImporteVend; vImporteMinVend)
                    {
                        Caption = 'Proveedores Importe mínimo';
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

    trigger OnInitReport()
    begin
        vAnio := DATE2DWY(TODAY, 3);
        vImporteMinCust := 3005;
        vImporteMinVend := -3005;
    end;

    trigger OnPreReport()
    var
        CaptionManagement: Codeunit "Caption Class";
    begin
    end;

    var
        vCustomerTrimestre1: Decimal;
        vCustomerTrimestre2: Decimal;
        vCustomerTrimestre3: Decimal;
        vCustomerTrimestre4: Decimal;
        vImporteMinCust: Decimal;
        vImporteMinVend: Decimal;
        vAnio: Integer;
        vCustomerTotalImporte: Decimal;
        vVendorTrimestre1: Decimal;
        vVendorTrimestre2: Decimal;
        vVendorTrimestre3: Decimal;
        vVendorTrimestre4: Decimal;
        vVendorTotalImporte: Decimal;
        rCompanyInfo: Record "Company Information";
        vCodigo: Code[20];
        vCustomerTotalT1: Decimal;
        vCustomerTotalT2: Decimal;
        vCustomerTotalT3: Decimal;
        vCustomerTotalT4: Decimal;
        vCustomerTotal: Decimal;
        vVendorTotalT1: Decimal;
        vVendorTotalT2: Decimal;
        vVendorTotalT3: Decimal;
        vVendorTotalT4: Decimal;
        vVendorTotal: Decimal;
        vShow: Boolean;

    local procedure fCustomerAntigua(rlCustLedgerEntry: Record "Cust. Ledger Entry"; rlDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        CLEAR(vCustomerTrimestre1);
        CLEAR(vCustomerTrimestre2);
        CLEAR(vCustomerTrimestre3);
        CLEAR(vCustomerTrimestre4);
        CLEAR(vCustomerTotalImporte);

        //Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Customer No.=FIELD("No."),Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
        //                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),"Posting Date"=FIELD("Date Filter"),
        //                                              Currency Code=FIELD(Currency Filter),Excluded from calculation=CONST(false)))

        // 1 Trimestre
        CLEAR(rlDetailedCustLedgEntry);
        rlDetailedCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.", "Posting Date");
        rlDetailedCustLedgEntry.SETRANGE("Customer No.", Customer."No.");
        rlDetailedCustLedgEntry.SETRANGE("Posting Date", DMY2DATE(1, 1, vAnio), DMY2DATE(31, 3, vAnio));
        rlDetailedCustLedgEntry.SETRANGE("Excluded from calculation", FALSE);
        rlDetailedCustLedgEntry.CALCSUMS(Amount);
        vCustomerTrimestre1 += rlDetailedCustLedgEntry.Amount;

        // 2 Trimestre
        CLEAR(rlDetailedCustLedgEntry);
        rlDetailedCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.", "Posting Date");
        rlDetailedCustLedgEntry.SETRANGE("Customer No.", Customer."No.");
        rlDetailedCustLedgEntry.SETRANGE("Posting Date", DMY2DATE(1, 4, vAnio), DMY2DATE(30, 6, vAnio));
        rlDetailedCustLedgEntry.SETRANGE("Excluded from calculation", FALSE);
        rlDetailedCustLedgEntry.CALCSUMS(Amount);
        vCustomerTrimestre2 += rlDetailedCustLedgEntry.Amount;

        // 3 Trimestre
        CLEAR(rlDetailedCustLedgEntry);
        rlDetailedCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.", "Posting Date");
        rlDetailedCustLedgEntry.SETRANGE("Customer No.", Customer."No.");
        rlDetailedCustLedgEntry.SETRANGE("Posting Date", DMY2DATE(1, 7, vAnio), DMY2DATE(30, 9, vAnio));
        rlDetailedCustLedgEntry.SETRANGE("Excluded from calculation", FALSE);
        rlDetailedCustLedgEntry.CALCSUMS(Amount);
        vCustomerTrimestre3 += rlDetailedCustLedgEntry.Amount;

        // 4 Trimestre
        CLEAR(rlDetailedCustLedgEntry);
        rlDetailedCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.", "Posting Date");
        rlDetailedCustLedgEntry.SETRANGE("Customer No.", Customer."No.");
        rlDetailedCustLedgEntry.SETRANGE("Posting Date", DMY2DATE(1, 10, vAnio), DMY2DATE(31, 12, vAnio));
        rlDetailedCustLedgEntry.SETRANGE("Excluded from calculation", FALSE);
        rlDetailedCustLedgEntry.CALCSUMS(Amount);
        vCustomerTrimestre4 += rlDetailedCustLedgEntry.Amount;

        /*
        // 1 Trimestre
        CLEAR(rlCustLedgerEntry);
        rlCustLedgerEntry.SETCURRENTKEY("Customer No.");
        rlCustLedgerEntry.SETRANGE("Customer No.",Customer."No.");
        rlCustLedgerEntry.SETRANGE("Date Filter",DMY2DATE(1,1,vAnio),DMY2DATE(31,3,vAnio));
        IF rlCustLedgerEntry.FINDFIRST THEN REPEAT
          CLEAR(rlDetailedCustLedgEntry);
          rlDetailedCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.","Posting Date");
          rlDetailedCustLedgEntry.SETRANGE("Ledger Entry Amount",TRUE);
          rlDetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",rlCustLedgerEntry."Entry No.");
          rlDetailedCustLedgEntry.SETRANGE("Posting Date",DMY2DATE(1,1,vAnio),DMY2DATE(31,3,vAnio));
          rlDetailedCustLedgEntry.CALCSUMS(Amount);
          vCustomerTrimestre1 += rlDetailedCustLedgEntry.Amount;
        UNTIL rlCustLedgerEntry.NEXT = 0;

        // 2 Trimestre
        CLEAR(rlCustLedgerEntry);
        rlCustLedgerEntry.SETRANGE("Customer No.",Customer."No.");
        rlCustLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,4,vAnio),DMY2DATE(30,6,vAnio));
        IF rlCustLedgerEntry.FINDFIRST THEN REPEAT
          CLEAR(rlDetailedCustLedgEntry);
          rlDetailedCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.","Posting Date");
          rlDetailedCustLedgEntry.SETRANGE("Ledger Entry Amount",TRUE);
          rlDetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",rlCustLedgerEntry."Entry No.");
          rlDetailedCustLedgEntry.SETRANGE("Posting Date",DMY2DATE(1,4,vAnio),DMY2DATE(30,6,vAnio));
          rlDetailedCustLedgEntry.CALCSUMS(Amount);
          vCustomerTrimestre2 += rlDetailedCustLedgEntry.Amount;
        UNTIL rlCustLedgerEntry.NEXT = 0;

        // 3 Trimestre
        CLEAR(rlCustLedgerEntry);
        rlCustLedgerEntry.SETRANGE("Customer No.",Customer."No.");
        rlCustLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,7,vAnio),DMY2DATE(30,9,vAnio));
        IF rlCustLedgerEntry.FINDFIRST THEN REPEAT
          CLEAR(rlDetailedCustLedgEntry);
          rlDetailedCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.","Posting Date");
          rlDetailedCustLedgEntry.SETRANGE("Ledger Entry Amount",TRUE);
          rlDetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",rlCustLedgerEntry."Entry No.");
          rlDetailedCustLedgEntry.SETRANGE("Posting Date",DMY2DATE(1,7,vAnio),DMY2DATE(30,9,vAnio));
          rlDetailedCustLedgEntry.CALCSUMS(Amount);
          vCustomerTrimestre3 += rlDetailedCustLedgEntry.Amount;
        UNTIL rlCustLedgerEntry.NEXT = 0;

        // 4 Trimestre
        CLEAR(rlCustLedgerEntry);
        rlCustLedgerEntry.SETRANGE("Customer No.",Customer."No.");
        rlCustLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,10,vAnio),DMY2DATE(31,12,vAnio));
        IF rlCustLedgerEntry.FINDFIRST THEN REPEAT
          CLEAR(rlDetailedCustLedgEntry);
          rlDetailedCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.","Posting Date");
          rlDetailedCustLedgEntry.SETRANGE("Ledger Entry Amount",TRUE);
          rlDetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",rlCustLedgerEntry."Entry No.");
          rlDetailedCustLedgEntry.SETRANGE("Posting Date",DMY2DATE(1,10,vAnio),DMY2DATE(31,12,vAnio));
          rlDetailedCustLedgEntry.CALCSUMS(Amount);
          vCustomerTrimestre4 += rlDetailedCustLedgEntry.Amount;
        UNTIL rlCustLedgerEntry.NEXT = 0;
        */

        // Totales
        vCustomerTotalImporte := vCustomerTrimestre1 + vCustomerTrimestre2 + vCustomerTrimestre3 + vCustomerTrimestre4;
    end;

    local procedure fVendorAntigua()
    var
        rlVendorLedgerEntry: Record "Vendor Ledger Entry";
        rlDetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        CLEAR(vVendorTrimestre1);
        CLEAR(vVendorTrimestre2);
        CLEAR(vVendorTrimestre3);
        CLEAR(vVendorTrimestre4);
        CLEAR(vVendorTotalImporte);

        //-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD("No."),Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
        //                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),"Posting Date"=FIELD("Date Filter"),
        //                                                Currency Code=FIELD(Currency Filter),Excluded from calculation=CONST(false)))

        // 1 Trimestre
        CLEAR(rlDetailedVendorLedgEntry);
        rlDetailedVendorLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.", "Posting Date");
        rlDetailedVendorLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        rlDetailedVendorLedgEntry.SETRANGE("Posting Date", DMY2DATE(1, 1, vAnio), DMY2DATE(31, 3, vAnio));
        rlDetailedVendorLedgEntry.SETRANGE("Excluded from calculation", FALSE);
        rlDetailedVendorLedgEntry.CALCSUMS(Amount);
        vVendorTrimestre1 += rlDetailedVendorLedgEntry.Amount;

        // 2 Trimestre
        CLEAR(rlDetailedVendorLedgEntry);
        rlDetailedVendorLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.", "Posting Date");
        rlDetailedVendorLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        rlDetailedVendorLedgEntry.SETRANGE("Posting Date", DMY2DATE(1, 4, vAnio), DMY2DATE(30, 6, vAnio));
        rlDetailedVendorLedgEntry.SETRANGE("Excluded from calculation", FALSE);
        rlDetailedVendorLedgEntry.CALCSUMS(Amount);
        vVendorTrimestre2 += rlDetailedVendorLedgEntry.Amount;

        // 3 Trimestre
        CLEAR(rlDetailedVendorLedgEntry);
        rlDetailedVendorLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.", "Posting Date");
        rlDetailedVendorLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        rlDetailedVendorLedgEntry.SETRANGE("Posting Date", DMY2DATE(1, 7, vAnio), DMY2DATE(30, 9, vAnio));
        rlDetailedVendorLedgEntry.SETRANGE("Excluded from calculation", FALSE);
        rlDetailedVendorLedgEntry.CALCSUMS(Amount);
        vVendorTrimestre3 += rlDetailedVendorLedgEntry.Amount;

        // 4 Trimestre
        CLEAR(rlDetailedVendorLedgEntry);
        rlDetailedVendorLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.", "Posting Date");
        rlDetailedVendorLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        rlDetailedVendorLedgEntry.SETRANGE("Posting Date", DMY2DATE(1, 10, vAnio), DMY2DATE(31, 12, vAnio));
        rlDetailedVendorLedgEntry.SETRANGE("Excluded from calculation", FALSE);
        rlDetailedVendorLedgEntry.CALCSUMS(Amount);
        vVendorTrimestre4 += rlDetailedVendorLedgEntry.Amount;

        /*
        // 1 Trimestre
        CLEAR(rlVendorLedgerEntry);
        rlVendorLedgerEntry.SETCURRENTKEY("Vendor No.","Posting Date");
        rlVendorLedgerEntry.SETRANGE("Vendor No.",Vendor."No.");
        rlVendorLedgerEntry.SETRANGE("Date Filter",DMY2DATE(1,1,vAnio),DMY2DATE(31,3,vAnio));
        IF rlVendorLedgerEntry.FINDFIRST THEN REPEAT
          CLEAR(rlDetailedVendorLedgEntry);
          rlDetailedVendorLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.","Posting Date");
          rlDetailedVendorLedgEntry.SETRANGE("Ledger Entry Amount",TRUE);
          rlDetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.",rlVendorLedgerEntry."Entry No.");
          rlDetailedVendorLedgEntry.SETRANGE("Posting Date",rlVendorLedgerEntry."Posting Date");
          rlDetailedVendorLedgEntry.CALCSUMS(Amount);
          vVendorTrimestre1 += rlDetailedVendorLedgEntry.Amount;
        UNTIL rlVendorLedgerEntry.NEXT = 0;

        // 2 Trimestre
        CLEAR(rlVendorLedgerEntry);
        rlVendorLedgerEntry.SETCURRENTKEY("Vendor No.","Posting Date");
        rlVendorLedgerEntry.SETRANGE("Vendor No.",Vendor."No.");
        rlVendorLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,4,vAnio),DMY2DATE(30,6,vAnio));
        IF rlVendorLedgerEntry.FINDFIRST THEN REPEAT
          CLEAR(rlDetailedVendorLedgEntry);
          rlDetailedVendorLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.","Posting Date");
          rlDetailedVendorLedgEntry.SETRANGE("Ledger Entry Amount",TRUE);
          rlDetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.",rlVendorLedgerEntry."Entry No.");
          rlDetailedVendorLedgEntry.SETRANGE("Posting Date",rlVendorLedgerEntry."Posting Date");
          rlDetailedVendorLedgEntry.CALCSUMS(Amount);
          vVendorTrimestre2 += rlDetailedVendorLedgEntry.Amount;
        UNTIL rlVendorLedgerEntry.NEXT = 0;

        // 3 Trimestre
        CLEAR(rlVendorLedgerEntry);
        rlVendorLedgerEntry.SETCURRENTKEY("Vendor No.","Posting Date");
        rlVendorLedgerEntry.SETRANGE("Vendor No.",Vendor."No.");
        rlVendorLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,7,vAnio),DMY2DATE(30,9,vAnio));
        IF rlVendorLedgerEntry.FINDFIRST THEN REPEAT
          CLEAR(rlDetailedVendorLedgEntry);
          rlDetailedVendorLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.","Posting Date");
          rlDetailedVendorLedgEntry.SETRANGE("Ledger Entry Amount",TRUE);
          rlDetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.",rlVendorLedgerEntry."Entry No.");
          rlDetailedVendorLedgEntry.SETRANGE("Posting Date",rlVendorLedgerEntry."Posting Date");
          rlDetailedVendorLedgEntry.CALCSUMS(Amount);
          vVendorTrimestre3 += rlDetailedVendorLedgEntry.Amount;
        UNTIL rlVendorLedgerEntry.NEXT = 0;

        // 4 Trimestre
        CLEAR(rlVendorLedgerEntry);
        rlVendorLedgerEntry.SETCURRENTKEY("Vendor No.","Posting Date");
        rlVendorLedgerEntry.SETRANGE("Vendor No.",Vendor."No.");
        rlVendorLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,10,vAnio),DMY2DATE(31,12,vAnio));
        IF rlVendorLedgerEntry.FINDFIRST THEN REPEAT
          CLEAR(rlDetailedVendorLedgEntry);
          rlDetailedVendorLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.","Posting Date");
          rlDetailedVendorLedgEntry.SETRANGE("Ledger Entry Amount",TRUE);
          rlDetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.",rlVendorLedgerEntry."Entry No.");
          rlDetailedVendorLedgEntry.SETRANGE("Posting Date",rlVendorLedgerEntry."Posting Date");
          rlDetailedVendorLedgEntry.CALCSUMS(Amount);
          vVendorTrimestre4 += rlDetailedVendorLedgEntry.Amount;
        UNTIL rlVendorLedgerEntry.NEXT = 0;
        */

        // Totales
        vVendorTotalImporte := vVendorTrimestre1 + vVendorTrimestre2 + vVendorTrimestre3 + vVendorTrimestre4;
    end;
}
