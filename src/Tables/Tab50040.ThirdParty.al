table 50040 "Third Party"
{
    // (RET): Retenciones de garantía y de IRPF   //Guarantee and IRPF withholding //JGS ELIMINADOS LOS CAMPOS
    // // Mod. S2G 18/12/2017 (JGS) : TER001 ã Terceros.
    //         Nuevos campos
    //             Company Vendor Balance
    //             Company Vend. Balance (LCY)
    //             Company Vendor Net Change
    //             Company Vend. Net Change (LCY)
    //             Company G/L Balance
    //             Vendor Template Code
    //             No. anterior
    //
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos
    //                  Nuevos campo y clave: EDUCAMOS id_unique_pagador
    //
    // (CR002) S2G (RBM-R) 29-08-18: Validación de CIF en Terceros

    Caption = 'Third Party', Comment = 'ESP="Tercero"';
    DataCaptionFields = "No.", Name;
    DataPerCompany = false;
    DrillDownPageID = "Third Party List";
    LookupPageID = "Third Party List";
    Permissions = TableData "Cust. Ledger Entry" = r,
                  TableData Job = r,
                  TableData "VAT Registration Log" = rd,
                  TableData "Service Header" = r,
                  TableData "Service Item" = rm,
                  TableData "Service Contract Header" = rm;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Número"';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';

            trigger OnValidate()
            begin
                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
                    "Search Name" := Name;

                //++EIM-1316 (DVM)
                //IF (UPPERCASE(Rec.Name) <> UPPERCASE(xRec.Name)) OR (UPPERCASE(Rec."Name 2") <> UPPERCASE(xRec."Name 2")) THEN
                //ERROR('Error al renombrar el tercero.');
                // --EIM-1316 (DVM)
            end;
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name', Comment = 'ESP="Nombre de búsqueda"';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2', Comment = 'ESP="Nombre 2"';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address', Comment = 'ESP="Dirección"';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2', Comment = 'ESP="Dirección 2"';
        }
        field(7; City; Text[30])
        {
            Caption = 'City', Comment = 'ESP="Ciudad"';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(8; Contact; Text[50])
        {
            Caption = 'Contact', Comment = 'ESP="Contacto"';

            trigger OnLookup()
            var
                ContactBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
            end;
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.', Comment = 'ESP="Teléfono"';
            ExtendedDatatype = PhoneNo;
        }
        field(10; "Telex No."; Text[20])
        {
            Caption = 'Telex No.', Comment = 'ESP="Télex"';
        }
        field(11; "Document Sending Profile"; Code[20])
        {
            Caption = 'Document Sending Profile', Comment = 'ESP="Perfil de envío de documentos"';
            TableRelation = "Document Sending Profile".Code;
        }
        field(14; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.', Comment = 'ESP="Nuestra cuenta"';
        }
        field(15; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code', Comment = 'ESP="Cód. territorio"';
            TableRelation = Territory;
        }
        field(16; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code', Comment = 'ESP="Cód. dimensión global 1"';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(17; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code', Comment = 'ESP="Cód. dimensión global 2"';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(18; "Chain Name"; Code[10])
        {
            Caption = 'Chain Name', Comment = 'ESP="Nombre cadena"';
        }
        field(19; "Budgeted Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Budgeted Amount', Comment = 'ESP="Importe presupuestado"';
        }
        field(20; "Credit Limit (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Credit Limit (LCY)', Comment = 'ESP="Límite crédito (DL)"';
        }
        field(21; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group', Comment = 'ESP="Grupo registro cliente"';
            TableRelation = "Customer Posting Group";
        }
        field(22; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code', Comment = 'ESP="Cód. divisa"';
            TableRelation = Currency;
        }
        field(23; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group', Comment = 'ESP="Grupo precio cliente"';
            TableRelation = "Customer Price Group";
        }
        field(24; "Language Code"; Code[10])
        {
            Caption = 'Language Code', Comment = 'ESP="Cód. idioma"';
            TableRelation = Language;
        }
        field(26; "Statistics Group"; Integer)
        {
            Caption = 'Statistics Group', Comment = 'ESP="Grupo estadístico"';
        }
        field(27; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code', Comment = 'ESP="Cód. términos pago"';
            TableRelation = "Payment Terms";
        }
        field(28; "Fin. Charge Terms Code"; Code[10])
        {
            Caption = 'Fin. Charge Terms Code', Comment = 'ESP="Cód. términos recargo financiero"';
            TableRelation = "Finance Charge Terms";
        }
        field(29; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code', Comment = 'ESP="Cód. vendedor"';
            TableRelation = "Salesperson/Purchaser";
        }
        field(30; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code', Comment = 'ESP="Cód. método envío"';
            TableRelation = "Shipment Method";
        }
        field(31; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code', Comment = 'ESP="Cód. agente de transporte"';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                IF "Shipping Agent Code" <> xRec."Shipping Agent Code" THEN
                    VALIDATE("Shipping Agent Service Code", '');
            end;
        }
        field(32; "Place of Export"; Code[20])
        {
            Caption = 'Place of Export', Comment = 'ESP="Lugar de exportación"';
        }
        field(33; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code', Comment = 'ESP="Cód. dto. factura"';
            TableRelation = Customer;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(34; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group', Comment = 'ESP="Grupo descuento cliente"';
            TableRelation = "Customer Discount Group";
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code', Comment = 'ESP="Cód. país/región"';
            NotBlank = true;
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                PostCode.ValidateCountryCode(City, "Post Code", County, "Country/Region Code");
            end;
        }
        field(36; "Collection Method"; Code[20])
        {
            Caption = 'Collection Method', Comment = 'ESP="Método de cobro"';
        }
        field(37; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(38; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Customer),
                                              "No." = FIELD("No.")));
            Caption = 'Comment', Comment = 'ESP="Comentario"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; Blocked; Option)
        {
            Caption = 'Blocked', Comment = 'ESP="Bloqueado"';
            OptionCaption = ' ,Ship,Invoice,All', Comment = 'ESP=" ,Enviar,Facturar,Todo"';
            OptionMembers = " ",Ship,Invoice,All;
        }
        field(40; "Invoice Copies"; Integer)
        {
            Caption = 'Invoice Copies', Comment = 'ESP="Copias de factura"';
        }
        field(41; "Last Statement No."; Integer)
        {
            Caption = 'Last Statement No.', Comment = 'ESP="Último nº extracto"';
        }
        field(42; "Print Statements"; Boolean)
        {
            Caption = 'Print Statements', Comment = 'ESP="Imprimir extractos"';
        }
        field(45; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.', Comment = 'ESP="Nº cliente facturar a"';
            TableRelation = Customer;
        }
        field(46; Priority; Integer)
        {
            Caption = 'Priority', Comment = 'ESP="Prioridad"';
        }
        field(47; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code', Comment = 'ESP="Cód. método de pago"';
            TableRelation = "Payment Method";

            trigger OnValidate()
            var
                PaymentMethod: Record "Payment Method";
            begin
                IF "Payment Method Code" = '' THEN
                    EXIT;
                PaymentMethod.GET("Payment Method Code");
                IF PaymentMethod."Direct Debit" AND ("Payment Terms Code" = '') THEN
                    "Payment Terms Code" := PaymentMethod."Direct Debit Pmt. Terms Code";
            end;
        }
        field(54; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified', Comment = 'ESP="Última fecha de modificación"';
            Editable = false;
        }
        field(55; "Date Filter"; Date)
        {
            Caption = 'Date Filter', Comment = 'ESP="Filtro de fecha"';
            FieldClass = FlowFilter;
        }
        field(56; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter', Comment = 'ESP="Filtro dimensión global 1"';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(57; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter', Comment = 'ESP="Filtro dimensión global 2"';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(58; "Company Customer Balance"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Company Customer Balance', Comment = 'ESP="Saldo cliente empresa"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Third Party No." = FIELD("No."),
                                                            "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                             "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                             "Currency Code" = FIELD("Currency Code"),
                                                             "Excluded from calculation" = CONST(false)));
        }
        field(59; "Company Cust. Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Third Party No." = FIELD("No."),
                                                                     "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                     "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                     "Currency Code" = FIELD("Currency Filter"),
                                                                     "Excluded from calculation" = CONST(false)));
            Caption = 'Company Cust. Balance (LCY)', Comment = 'ESP="Saldo cliente empresa (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Company Customer Net Change"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Third Party No." = FIELD("No."),
                                                             "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                             "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                             "Posting Date" = FIELD("Date Filter"),
                                                             "Currency Code" = FIELD("Currency Filter"),
                                                             "Excluded from calculation" = CONST(false)));
            Caption = 'Company Customer Net Change', Comment = 'ESP="Variación neta cliente empresa"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Company Cust. Net Change (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Third Party No." = FIELD("No."),
                                                                     "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                     "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                     "Posting Date" = FIELD("Date Filter"),
                                                                     "Currency Code" = FIELD("Currency Filter"),
                                                                     "Excluded from calculation" = CONST(false)));
            Caption = 'Company Cust. Net Change (LCY)', Comment = 'ESP="Variación neta cliente empresa (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Sales (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Cust. Ledger Entry"."Sales (LCY)" WHERE("Customer No." = FIELD("No."),
                                                            "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                            "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                            "Posting Date" = FIELD("Date Filter"),
                                                            "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Sales (LCY)', Comment = 'ESP="Ventas (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Profit (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Cust. Ledger Entry"."Profit (LCY)" WHERE("Customer No." = FIELD("No."),
                                                             "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                             "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                             "Posting Date" = FIELD("Date Filter"),
                                                             "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Profit (LCY)', Comment = 'ESP="Beneficio (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Inv. Discounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Cust. Ledger Entry"."Inv. Discount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                    "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                    "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                    "Posting Date" = FIELD("Date Filter"),
                                                                    "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Inv. Discounts (LCY)', Comment = 'ESP="Descuentos factura (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Pmt. Discounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                      "Entry Type" = FILTER("Payment Discount" .. "Payment Discount (VAT Adjustment)"),
                                                                      "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                      "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                      "Posting Date" = FIELD("Date Filter"),
                                                                      "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Pmt. Discounts (LCY)', Comment = 'ESP="Descuentos pago (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66; "Balance Due"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."),
                                                             "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                             "Initial Entry Due Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                             "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                             "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                             "Currency Code" = FIELD("Currency Filter"),
                                                             "Excluded from calculation" = CONST(false)));
            Caption = 'Balance Due', Comment = 'ESP="Saldo vencido"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(67; "Balance Due (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                     "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                                     "Initial Entry Due Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                                     "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                     "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                     "Currency Code" = FIELD("Currency Filter"),
                                                                     "Excluded from calculation" = CONST(false)));
            Caption = 'Balance Due (LCY)', Comment = 'ESP="Saldo vencido (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(69; Payments; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(Payment),
                                                              "Entry Type" = CONST("Initial Entry"),
                                                              "Customer No." = FIELD("No."),
                                                              "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                              "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                              "Posting Date" = FIELD("Date Filter"),
                                                              "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Payments', Comment = 'ESP="Pagos"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Invoice Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(Invoice),
                                                             "Entry Type" = CONST("Initial Entry"),
                                                             "Customer No." = FIELD("No."),
                                                             "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                             "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                             "Posting Date" = FIELD("Date Filter"),
                                                             "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Invoice Amounts', Comment = 'ESP="Importes de facturas"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "Cr. Memo Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Initial Document Type" = CONST("Credit Memo"),
                                                              "Entry Type" = CONST("Initial Entry"),
                                                              "Customer No." = FIELD("No."),
                                                              "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                              "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                              "Posting Date" = FIELD("Date Filter"),
                                                              "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Cr. Memo Amounts', Comment = 'ESP="Importes abonos"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(72; "Finance Charge Memo Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Initial Document Type" = CONST("Finance Charge Memo"),
                                                              "Entry Type" = CONST("Initial Entry"),
                                                              "Customer No." = FIELD("No."),
                                                              "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                              "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                              "Posting Date" = FIELD("Date Filter"),
                                                              "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Finance Charge Memo Amounts', Comment = 'ESP="Importes notas de cargo"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(74; "Payments (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(Payment),
                                                                      "Entry Type" = CONST("Initial Entry"),
                                                                      "Customer No." = FIELD("No."),
                                                                      "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                      "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                      "Posting Date" = FIELD("Date Filter"),
                                                                      "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Payments (LCY)', Comment = 'ESP="Pagos (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(75; "Inv. Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(Invoice),
                                                                     "Entry Type" = CONST("Initial Entry"),
                                                                     "Customer No." = FIELD("No."),
                                                                     "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                     "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                     "Posting Date" = FIELD("Date Filter"),
                                                                     "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Inv. Amounts (LCY)', Comment = 'ESP="Importes facturas (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76; "Cr. Memo Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST("Credit Memo"),
                                                                      "Entry Type" = CONST("Initial Entry"),
                                                                      "Customer No." = FIELD("No."),
                                                                      "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                      "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                      "Posting Date" = FIELD("Date Filter"),
                                                                      "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Cr. Memo Amounts (LCY)', Comment = 'ESP="Importes abonos (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(77; "Fin. Charge Memo Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST("Finance Charge Memo"),
                                                                     "Entry Type" = CONST("Initial Entry"),
                                                                     "Customer No." = FIELD("No."),
                                                                     "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                     "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                     "Posting Date" = FIELD("Date Filter"),
                                                                     "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Fin. Charge Memo Amounts (LCY)', Comment = 'ESP="Importes notas de cargo (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(78; "Outstanding Orders"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Outstanding Amount" WHERE("Document Type" = CONST(Order),
                                                           "Bill-to Customer No." = FIELD("No."),
                                                           "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                           "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Orders', Comment = 'ESP="Pedidos pendientes"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79; "Shipped Not Invoiced"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Shipped Not Invoiced" WHERE("Document Type" = CONST(Order),
                                                             "Bill-to Customer No." = FIELD("No."),
                                                             "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                             "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                             "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Shipped Not Invoiced', Comment = 'ESP="Enviado no facturado"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Application Method"; Option)
        {
            Caption = 'Application Method', Comment = 'ESP="Método de liquidación"';
            OptionCaption = 'Manual,Apply to Oldest', Comment = 'ESP="Manual,Aplicar al más antiguo"';
            OptionMembers = Manual,"Apply to Oldest";
        }
        field(82; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT', Comment = 'ESP="Precios con IVA incluido"';
        }
        field(83; "Location Code"; Code[10])
        {
            Caption = 'Location Code', Comment = 'ESP="Cód. almacén"';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(84; "Fax No."; Text[30])
        {
            Caption = 'Fax No.', Comment = 'ESP="Nº fax"';
        }
        field(85; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back', Comment = 'ESP="Respuesta télex"';
        }
        field(86; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.', Comment = 'ESP="NIF/CIF"';
            NotBlank = true;

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                //(CR002) S2G (RBM-R) 29-08-18: Validación de CIF en Terceros. Inicio
                IF rVATRegNoFormat.Test("VAT Registration No.", "Country/Region Code", "No.", DATABASE::"Third Party") THEN
                    IF "VAT Registration No." <> xRec."VAT Registration No." THEN
                        cEYFunctions.fLogThirdParty(Rec);
                //(CR002) S2G (RBM-R) 29-08-18: Validación de CIF en Terceros. Fin
            end;
        }
        field(87; "Combine Shipments"; Boolean)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Combine Shipments', Comment = 'ESP="Combinar envíos"';
        }
        field(88; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group', Comment = 'ESP="Grupo registro gen. negocio"';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                    IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") THEN
                        VALIDATE("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(89; Picture; BLOB)
        {
            Caption = 'Picture', Comment = 'ESP="Imagen"';
            SubType = Bitmap;
        }
        field(90; GLN; Code[13])
        {
            Caption = 'GLN', Comment = 'ESP="GLN"';
            Numeric = true;

            trigger OnValidate()
            var
                GLNCalculator: Codeunit "GLN Calculator";
            begin
                IF GLN <> '' THEN
                    GLNCalculator.AssertValidCheckDigit13(GLN);
            end;
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code', Comment = 'ESP="Código postal"';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(92; County; Text[30])
        {
            Caption = 'County', Comment = 'ESP="Provincia"';
        }
        field(97; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Debit Amount" WHERE("Customer No." = FIELD("No."),
           "Entry Type" = FILTER(<> Application),
           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
           "Posting Date" = FIELD("Date Filter"),
           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Debit Amount', Comment = 'ESP="Importe debe"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(98; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Credit Amount" WHERE("Customer No." = FIELD("No."),
            "Entry Type" = FILTER(<> Application),
            "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
            "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
            "Posting Date" = FIELD("Date Filter"),
            "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Credit Amount', Comment = 'ESP="Importe haber"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                 "Entry Type" = FILTER(<> Application),
                 "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                 "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                 "Posting Date" = FIELD("Date Filter"),
                 "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Debit Amount (LCY)', Comment = 'ESP="Importe debe (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                  "Entry Type" = FILTER(<> Application),
                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                  "Posting Date" = FIELD("Date Filter"),
                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Credit Amount (LCY)', Comment = 'ESP="Importe haber (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'Email', Comment = 'ESP="Correo electrónico"';
            ExtendedDatatype = EMail;
        }
        field(103; "Home Page"; Text[80])
        {
            Caption = 'Home Page', Comment = 'ESP="Página web"';
            ExtendedDatatype = URL;
        }
        field(104; "Reminder Terms Code"; Code[10])
        {
            Caption = 'Reminder Terms Code', Comment = 'ESP="Cód. términos recordatorio"';
            TableRelation = "Reminder Terms";
        }
        field(105; "Reminder Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(Reminder),
                      "Entry Type" = CONST("Initial Entry"),
                      "Customer No." = FIELD("No."),
                      "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                      "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                      "Posting Date" = FIELD("Date Filter"),
                      "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Reminder Amounts', Comment = 'ESP="Importes recordatorios"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(106; "Reminder Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(Reminder),
           "Entry Type" = CONST("Initial Entry"),
           "Customer No." = FIELD("No."),
           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
           "Posting Date" = FIELD("Date Filter"),
           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Reminder Amounts (LCY)', Comment = 'ESP="Importes recordatorios (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series', Comment = 'ESP="Serie num."';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code', Comment = 'ESP="Cód. área impuestos"';
            TableRelation = "Tax Area";
        }
        field(109; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable', Comment = 'ESP="Sujeto a impuestos"';
        }
        field(110; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group', Comment = 'ESP="Grupo registro IVA negocio"';
            TableRelation = "VAT Business Posting Group";
        }
        field(111; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter', Comment = 'ESP="Filtro divisa"';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(113; "Outstanding Orders (LCY)"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Outstanding Amount (LCY)" WHERE("Document Type" = CONST(Order),
       "Bill-to Customer No." = FIELD("No."),
       "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
       "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
       "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Orders (LCY)', Comment = 'ESP="Pedidos pendientes (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(114; "Shipped Not Invoiced (LCY)"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Shipped Not Invoiced (LCY)" WHERE("Document Type" = CONST(Order),
         "Bill-to Customer No." = FIELD("No."),
         "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
         "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
         "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Shipped Not Invoiced (LCY)', Comment = 'ESP="Enviado no facturado (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(115; Reserve; Option)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Reserve', Comment = 'ESP="Reserva"';
            InitValue = Optional;
            OptionCaption = 'Never,Optional,Always', Comment = 'ESP="Nunca,Opcional,Siempre"';
            OptionMembers = Never,Optional,Always;
        }
        field(116; "Block Payment Tolerance"; Boolean)
        {
            Caption = 'Block Payment Tolerance', Comment = 'ESP="Bloquear tolerancia de pago"';

            trigger OnValidate()
            begin
                UpdatePaymentTolerance((CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(117; "Pmt. Disc. Tolerance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
            "Entry Type" = FILTER("Payment Discount Tolerance" | "Payment Discount Tolerance (VAT Adjustment)" | "Payment Discount Tolerance (VAT Excl.)"),
            "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
            "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
            "Posting Date" = FIELD("Date Filter"),
            "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Pmt. Disc. Tolerance (LCY)', Comment = 'ESP="Tolerancia dto. pago (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(118; "Pmt. Tolerance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
            "Entry Type" = FILTER("Payment Tolerance" | "Payment Tolerance (VAT Adjustment)" | "Payment Tolerance (VAT Excl.)"),
            "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
            "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
            "Posting Date" = FIELD("Date Filter"),
            "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Pmt. Tolerance (LCY)', Comment = 'ESP="Tolerancia de pago (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }

        //Intercompany
        // field(119; "IC Partner Code"; Code[20])
        // {
        //     Caption = 'IC Partner Code';
        //     TableRelation = "IC Partner";

        //     trigger OnValidate()
        //     var
        //         CustLedgEntry: Record "Cust. Ledger Entry";
        //         AccountingPeriod: Record "Accounting Period";
        //         ICPartner: Record "IC Partner";
        //     begin
        //         IF xRec."IC Partner Code" <> "IC Partner Code" THEN BEGIN
        //             IF NOT CustLedgEntry.SETCURRENTKEY("Customer No.", Open) THEN
        //                 CustLedgEntry.SETCURRENTKEY("Customer No.");
        //             CustLedgEntry.SETRANGE("Customer No.", "No.");
        //             CustLedgEntry.SETRANGE(Open, TRUE);
        //             IF CustLedgEntry.FINDLAST THEN
        //                 ERROR(Text012, FIELDCAPTION("IC Partner Code"), TABLECAPTION);

        //             CustLedgEntry.RESET;
        //             CustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date");
        //             CustLedgEntry.SETRANGE("Customer No.", "No.");
        //             AccountingPeriod.SETRANGE(Closed, FALSE);
        //             IF AccountingPeriod.FINDFIRST THEN BEGIN
        //                 CustLedgEntry.SETFILTER("Posting Date", '>=%1', AccountingPeriod."Starting Date");
        //                 IF CustLedgEntry.FINDFIRST THEN
        //                     IF NOT CONFIRM(Text011, FALSE, TABLECAPTION) THEN
        //                         "IC Partner Code" := xRec."IC Partner Code";
        //             END;
        //         END;

        //         IF "IC Partner Code" <> '' THEN BEGIN
        //             ICPartner.GET("IC Partner Code");
        //             IF (ICPartner."Customer No." <> '') AND (ICPartner."Customer No." <> "No.") THEN
        //                 ERROR(Text010, FIELDCAPTION("IC Partner Code"), "IC Partner Code", TABLECAPTION, ICPartner."Customer No.");
        //             ICPartner."Customer No." := "No.";
        //             ICPartner.MODIFY;
        //         END;

        //         IF (xRec."IC Partner Code" <> "IC Partner Code") AND ICPartner.GET(xRec."IC Partner Code") THEN BEGIN
        //             ICPartner."Customer No." := '';
        //             ICPartner.MODIFY;
        //         END;
        //     end;
        // }
        field(120; Refunds; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(Refund),
                      "Entry Type" = CONST("Initial Entry"),
                      "Customer No." = FIELD("No."),
                      "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                      "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                      "Posting Date" = FIELD("Date Filter"),
                      "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Refunds', Comment = 'ESP="Reembolsos"';
            FieldClass = FlowField;
        }
        field(121; "Refunds (LCY)"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(Refund),
           "Entry Type" = CONST("Initial Entry"),
           "Customer No." = FIELD("No."),
           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
           "Posting Date" = FIELD("Date Filter"),
           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Refunds (LCY)', Comment = 'ESP="Reembolsos (DL)"';
            FieldClass = FlowField;
        }
        field(122; "Other Amounts"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(" "),
                      "Entry Type" = CONST("Initial Entry"),
                      "Customer No." = FIELD("No."),
                      "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                      "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                      "Posting Date" = FIELD("Date Filter"),
                      "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Other Amounts', Comment = 'ESP="Otros importes"';
            FieldClass = FlowField;
        }
        field(123; "Other Amounts (LCY)"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(" "),
           "Entry Type" = CONST("Initial Entry"),
           "Customer No." = FIELD("No."),
           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
           "Posting Date" = FIELD("Date Filter"),
           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Other Amounts (LCY)', Comment = 'ESP="Otros importes (DL)"';
            FieldClass = FlowField;
        }
        field(124; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %', Comment = 'ESP="% anticipo"';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(125; "Outstanding Invoices (LCY)"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Outstanding Amount (LCY)" WHERE("Document Type" = CONST(Invoice),
       "Bill-to Customer No." = FIELD("No."),
       "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
       "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
       "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Invoices (LCY)', Comment = 'ESP="Facturas pendientes (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(126; "Outstanding Invoices"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Outstanding Amount" WHERE("Document Type" = CONST(Invoice),
                    "Bill-to Customer No." = FIELD("No."),
                    "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                    "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                    "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Invoices', Comment = 'ESP="Facturas pendientes"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130; "Bill-to No. Of Archived Doc."; Integer)
        {
            CalcFormula = Count("Sales Header Archive" WHERE("Document Type" = CONST(Order),
                                                      "Bill-to Customer No." = FIELD("No.")));
            Caption = 'Bill-to No. Of Archived Doc.', Comment = 'ESP="Nº docs. archivados facturar a"';
            FieldClass = FlowField;
        }
        field(131; "Sell-to No. Of Archived Doc."; Integer)
        {
            CalcFormula = Count("Sales Header Archive" WHERE("Document Type" = CONST(Order),
                                                      "Sell-to Customer No." = FIELD("No.")));
            Caption = 'Sell-to No. Of Archived Doc.', Comment = 'ESP="Nº docs. archivados vender a"';
            FieldClass = FlowField;
        }
        field(132; "Partner Type"; Option)
        {
            Caption = 'Partner Type', Comment = 'ESP="Tipo de tercero"';
            OptionCaption = ' ,Company,Person', Comment = 'ESP=" ,Empresa,Persona"';
            OptionMembers = " ",Company,Person;
        }
        field(140; Image; Media)
        {
            Caption = 'Image', Comment = 'ESP="Imagen"';
            ExtendedDatatype = Person;
        }
        field(288; "Preferred Bank Account Code"; Code[10])
        {
            Caption = 'Preferred Bank Account Code', Comment = 'ESP="Cód. cuenta bancaria preferida"';
            TableRelation = "Customer Bank Account".Code WHERE("Customer No." = FIELD("No."));
        }
        field(840; "Cash Flow Payment Terms Code"; Code[10])
        {
            Caption = 'Cash Flow Payment Terms Code', Comment = 'ESP="Cód. términos pago flujo caja"';
            TableRelation = "Payment Terms";
        }
        field(5049; "Primary Contact No."; Code[20])
        {
            Caption = 'Primary Contact No.', Comment = 'ESP="Nº contacto principal"';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
                TempCust: Record Customer temporary;
            begin
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SETRANGE("No.", "No.");
                IF ContBusRel.FINDFIRST THEN
                    Cont.SETRANGE("Company No.", ContBusRel."Contact No.")
                ELSE
                    Cont.SETRANGE("No.", '');

                IF "Primary Contact No." <> '' THEN
                    IF Cont.GET("Primary Contact No.") THEN;
                IF PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK THEN BEGIN
                    TempCust.COPY(Rec);
                    FIND;
                    TRANSFERFIELDS(TempCust, FALSE);
                    VALIDATE("Primary Contact No.", Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
                Contact := '';
                IF "Primary Contact No." <> '' THEN BEGIN
                    Cont.GET("Primary Contact No.");

                    ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                    ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
                    ContBusRel.SETRANGE("No.", "No.");
                    ContBusRel.FINDFIRST;

                    IF Cont."Company No." <> ContBusRel."Contact No." THEN
                        ERROR(Text003, Cont."No.", Cont.Name, "No.", Name);

                    IF Cont.Type = Cont.Type::Person THEN
                        Contact := Cont.Name
                END;
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center', Comment = 'ESP="Centro de responsabilidad"';
            TableRelation = "Responsibility Center";
        }
        field(5750; "Shipping Advice"; Option)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Shipping Advice', Comment = 'ESP="Aviso de envío"';
            OptionCaption = 'Partial,Complete', Comment = 'ESP="Parcial,Completo"';
            OptionMembers = Partial,Complete;
        }
        field(5790; "Shipping Time"; DateFormula)
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Time', Comment = 'ESP="Plazo de envío"';
        }
        field(5792; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code', Comment = 'ESP="Cód. servicio agente transporte"';
            TableRelation = "Shipping Agent Services".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));

            trigger OnValidate()
            begin
                IF ("Shipping Agent Code" <> '') AND
                   ("Shipping Agent Service Code" <> '')
                THEN
                    IF ShippingAgentService.GET("Shipping Agent Code", "Shipping Agent Service Code") THEN
                        "Shipping Time" := ShippingAgentService."Shipping Time"
                    ELSE
                        EVALUATE("Shipping Time", '<>');
            end;
        }
        field(5900; "Service Zone Code"; Code[10])
        {
            Caption = 'Service Zone Code', Comment = 'ESP="Cód. zona de servicio"';
            TableRelation = "Service Zone";
        }
        field(5902; "Contract Gain/Loss Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Contract Gain/Loss Entry".Amount WHERE("Customer No." = FIELD("No."),
                                                               "Ship-to Code" = FIELD("Ship-to Filter"),
                                                               "Change Date" = FIELD("Date Filter")));
            Caption = 'Contract Gain/Loss Amount', Comment = 'ESP="Importe ganancia/pérdida contrato"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5903; "Ship-to Filter"; Code[10])
        {
            Caption = 'Ship-to Filter', Comment = 'ESP="Filtro enviar a"';
            FieldClass = FlowFilter;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("No."));
        }
        field(5910; "Outstanding Serv. Orders (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Service Line"."Outstanding Amount (LCY)" WHERE("Document Type" = CONST(Order),
         "Bill-to Customer No." = FIELD("No."),
         "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
         "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
         "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Serv. Orders (LCY)', Comment = 'ESP="Pedidos servicio pendientes (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5911; "Serv Shipped Not Invoiced(LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Service Line"."Shipped Not Invoiced (LCY)" WHERE("Document Type" = CONST(Order),
           "Bill-to Customer No." = FIELD("No."),
           "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
           "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Serv Shipped Not Invoiced (LCY)', Comment = 'ESP="Servicio enviado no facturado (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5912; "Outstanding Serv.Invoices(LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Service Line"."Outstanding Amount (LCY)" WHERE("Document Type" = CONST(Invoice),
         "Bill-to Customer No." = FIELD("No."),
         "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
         "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
         "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Serv. Invoices (LCY)', Comment = 'ESP="Facturas servicio pendientes (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.', Comment = 'ESP="Permitir dto. línea"';
            InitValue = true;
        }
        field(7171; "No. of Quotes"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Quote),
                                              "Sell-to Customer No." = FIELD("No.")));
            Caption = 'No. of Quotes', Comment = 'ESP="Nº presupuestos"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7172; "No. of Blanket Orders"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST("Blanket Order"),
                                              "Sell-to Customer No." = FIELD("No.")));
            Caption = 'No. of Blanket Orders', Comment = 'ESP="Nº pedidos marco"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7173; "No. of Orders"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Order),
                                              "Sell-to Customer No." = FIELD("No.")));
            Caption = 'No. of Orders', Comment = 'ESP="Nº pedidos"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7174; "No. of Invoices"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Invoice),
                                              "Sell-to Customer No." = FIELD("No.")));
            Caption = 'No. of Invoices', Comment = 'ESP="Nº facturas"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7175; "No. of Return Orders"; Integer)
        {
            AccessByPermission = TableData "Return Receipt Header" = R;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST("Return Order"),
                                              "Sell-to Customer No." = FIELD("No.")));
            Caption = 'No. of Return Orders', Comment = 'ESP="Nº pedidos devolución"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7176; "No. of Credit Memos"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST("Credit Memo"),
                                              "Sell-to Customer No." = FIELD("No.")));
            Caption = 'No. of Credit Memos', Comment = 'ESP="Nº abonos"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7177; "No. of Pstd. Shipments"; Integer)
        {
            CalcFormula = Count("Sales Shipment Header" WHERE("Sell-to Customer No." = FIELD("No.")));
            Caption = 'No. of Pstd. Shipments', Comment = 'ESP="Nº envíos registrados"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7178; "No. of Pstd. Invoices"; Integer)
        {
            CalcFormula = Count("Sales Invoice Header" WHERE("Sell-to Customer No." = FIELD("No.")));
            Caption = 'No. of Pstd. Invoices', Comment = 'ESP="Nº facturas registradas"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7179; "No. of Pstd. Return Receipts"; Integer)
        {
            CalcFormula = Count("Return Receipt Header" WHERE("Sell-to Customer No." = FIELD("No.")));
            Caption = 'No. of Pstd. Return Receipts', Comment = 'ESP="Nº recepciones devolución registradas"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7180; "No. of Pstd. Credit Memos"; Integer)
        {
            CalcFormula = Count("Sales Cr.Memo Header" WHERE("Sell-to Customer No." = FIELD("No.")));
            Caption = 'No. of Pstd. Credit Memos', Comment = 'ESP="Nº abonos registrados"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7181; "No. of Ship-to Addresses"; Integer)
        {
            CalcFormula = Count("Ship-to Address" WHERE("Customer No." = FIELD("No.")));
            Caption = 'No. of Ship-to Addresses', Comment = 'ESP="Nº direcciones de envío"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7182; "Bill-To No. of Quotes"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Quote),
                                              "Bill-to Customer No." = FIELD("No.")));
            Caption = 'Bill-To No. of Quotes', Comment = 'ESP="Nº presupuestos facturar a"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7183; "Bill-To No. of Blanket Orders"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST("Blanket Order"),
                                              "Bill-to Customer No." = FIELD("No.")));
            Caption = 'Bill-To No. of Blanket Orders', Comment = 'ESP="Nº pedidos marco facturar a"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7184; "Bill-To No. of Orders"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Order),
                                              "Bill-to Customer No." = FIELD("No.")));
            Caption = 'Bill-To No. of Orders', Comment = 'ESP="Nº pedidos facturar a"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7185; "Bill-To No. of Invoices"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Invoice),
                                              "Bill-to Customer No." = FIELD("No.")));
            Caption = 'Bill-To No. of Invoices', Comment = 'ESP="Nº facturas facturar a"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7186; "Bill-To No. of Return Orders"; Integer)
        {
            AccessByPermission = TableData "Return Receipt Header" = R;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST("Return Order"),
                                              "Bill-to Customer No." = FIELD("No.")));
            Caption = 'Bill-To No. of Return Orders', Comment = 'ESP="Nº pedidos devolución facturar a"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7187; "Bill-To No. of Credit Memos"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST("Credit Memo"),
                                              "Bill-to Customer No." = FIELD("No.")));
            Caption = 'Bill-To No. of Credit Memos', Comment = 'ESP="Nº abonos facturar a"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7188; "Bill-To No. of Pstd. Shipments"; Integer)
        {
            CalcFormula = Count("Sales Shipment Header" WHERE("Bill-to Customer No." = FIELD("No.")));
            Caption = 'Bill-To No. of Pstd. Shipments', Comment = 'ESP="Nº envíos registrados facturar a"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7189; "Bill-To No. of Pstd. Invoices"; Integer)
        {
            CalcFormula = Count("Sales Invoice Header" WHERE("Bill-to Customer No." = FIELD("No.")));
            Caption = 'Bill-To No. of Pstd. Invoices', Comment = 'ESP="Nº facturas registradas facturar a"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7190; "Bill-To No. of Pstd. Return R."; Integer)
        {
            CalcFormula = Count("Return Receipt Header" WHERE("Bill-to Customer No." = FIELD("No.")));
            Caption = 'Bill-To No. of Pstd. Return R.', Comment = 'ESP="Nº recepciones devolución registradas facturar a"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7191; "Bill-To No. of Pstd. Cr. Memos"; Integer)
        {
            CalcFormula = Count("Sales Cr.Memo Header" WHERE("Bill-to Customer No." = FIELD("No.")));
            Caption = 'Bill-To No. of Pstd. Cr. Memos', Comment = 'ESP="Nº abonos registrados facturar a"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7600; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code', Comment = 'ESP="Cód. calendario base"';
            TableRelation = "Base Calendar";
        }
        field(8100; "Creation Date/Time"; DateTime)
        {
            Caption = 'Creation Date/Time', Comment = 'ESP="Fecha/hora creación"';
            Editable = false;
        }
        field(8101; "Creation User ID"; Code[50])
        {
            Caption = 'Creation User ID', Comment = 'ESP="Usuario creador"';
            NotBlank = true;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                cEYFunctions.LookupUserID("Creation User ID");
            end;

            trigger OnValidate()
            begin
                cEYFunctions.ValidateUserID("Creation User ID");
            end;
        }
        field(10700; "Payment Days Code"; Code[20])
        {
            Caption = 'Payment Days Code', Comment = 'ESP="Cód. días de pago"';
            TableRelation = Customer;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10701; "Non-Paymt. Periods Code"; Code[20])
        {
            Caption = 'Non-Paymt. Periods Code', Comment = 'ESP="Cód. periodos no pagables"';
            TableRelation = Customer;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50058; "Company Vendor Balance"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Third Party No." = FIELD("No."),
    "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
    "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
    "Currency Code" = FIELD("Currency Filter"),
    "Excluded from calculation" = CONST(false)));
            Caption = 'Company Vendor Balance', Comment = 'ESP="Saldo proveedor empresa"';
            Description = 'TER001 - Terceros';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50059; "Company Vend. Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Third Party No." = FIELD("No."),
            "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
            "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
            "Currency Code" = FIELD("Currency Filter"),
            "Excluded from calculation" = CONST(false)));
            Caption = 'Company Vend. Balance (LCY)', Comment = 'ESP="Saldo proveedor empresa (DL)"';
            Description = 'TER001 - Terceros';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50060; "Company Vendor Net Change"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Third Party No." = FIELD("No."),
    "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
    "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
    "Posting Date" = FIELD("Date Filter"),
    "Currency Code" = FIELD("Currency Filter"),
    "Excluded from calculation" = CONST(false)));
            Caption = 'Company Vendor Net Change', Comment = 'ESP="Variación neta proveedor empresa"';
            Description = 'TER001 - Terceros';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50061; "Company Vend. Net Change (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Third Party No." = FIELD("No."),
            "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
            "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
            "Posting Date" = FIELD("Date Filter"),
            "Currency Code" = FIELD("Currency Filter"),
            "Excluded from calculation" = CONST(false)));
            Caption = 'Company Vend. Net Change (LCY)', Comment = 'ESP="Variación neta proveedor empresa (DL)"';
            Description = 'TER001 - Terceros';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50062; "Company G/L Balance"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Third Party No." = FIELD("No."),
     "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
     "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter")));
            Caption = 'Company G/L Balance', Comment = 'ESP="Saldo contable empresa"';
            Description = 'TER001 - Terceros';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50063; "Company G/L Net Change"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Third Party No." = FIELD("No."),
     "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
     "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
     "Posting Date" = FIELD("Date Filter")));
            Caption = 'Company G/L Net Change', Comment = 'ESP="Variación neta contable empresa"';
            Description = 'TER001 - Terceros';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50070; "Customer Template Code"; Code[10])
        {
            Caption = 'Customer Template Code', Comment = 'ESP="Cód. plantilla cliente"';
            Description = 'TER001 - Terceros';
            TableRelation = "Config. Template Header" WHERE("Table ID" = CONST(18));
        }
        field(50071; "Vendor Template Code"; Code[10])
        {
            Caption = 'Vendor Template Code', Comment = 'ESP="Cód. plantilla proveedor"';
            Description = 'TER001 - Terceros';
            TableRelation = "Config. Template Header" WHERE("Table ID" = CONST(23));
        }
        field(50101; "No. anterior"; Code[20])
        {
            Caption = 'Previous No.', Comment = 'ESP="Nº anterior"';
            Description = 'TER001 - Terceros';
        }
        field(50200; "EDUCAMOS id_unique_pagador"; Text[50]) //EDUCAMOS
        {
            Caption = 'EDUCAMOS Payer Unique ID', Comment = 'ESP="EDUCAMOS id_unique_pagador"';
            Description = 'Mod. S2G (RBM-R) IN-001: Interfaz Educamos';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; "Customer Posting Group")
        {
        }
        key(Key4; "Currency Code")
        {
        }
        key(Key5; "Country/Region Code")
        {
        }
        key(Key6; "Gen. Bus. Posting Group")
        {
        }
        key(Key7; Name, Address, City)
        {
        }
        key(Key8; "VAT Registration No.")
        {
        }
        key(Key9; Name)
        {
        }
        key(Key10; City)
        {
        }
        key(Key11; "Post Code")
        {
        }
        key(Key12; "Phone No.")
        {
        }
        key(Key13; Contact)
        {
        }
        key(Key14; "EDUCAMOS id_unique_pagador")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, City, "Post Code", "Phone No.", Contact)
        {
        }
        fieldgroup(Brick; "No.", Name, "Company Cust. Balance (LCY)", Contact, "Balance Due (LCY)", Image)
        {
        }
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            GetNextThirdPartyNo("No.", "Creation Date/Time", TRUE);
        END;
        "Creation User ID" := USERID;
    end;

    var
        Text000: Label 'You cannot delete %1 %2 because there is at least one outstanding Sales %3 for this customer.', Comment = 'ESP="No puede eliminar %1 %2 porque existe al menos un %3 de venta pendiente para este cliente."';
        Text002: Label 'Do you wish to create a contact for %1 %2?', Comment = 'ESP="¿Desea crear un contacto para %1 %2?"';
        SalesSetup: Record "Sales & Receivables Setup";
        CommentLine: Record "Comment Line";
        SalesOrderLine: Record "Sales Line";
        CustBankAcc: Record "Customer Bank Account";
        ShipToAddr: Record "Ship-to Address";
        PostCode: Record "Post Code";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        ShippingAgentService: Record "Shipping Agent Services";
        RMSetup: Record "Marketing Setup";
        SalesPrepmtPct: Record "Sales Prepayment %";
        ServContract: Record "Service Contract Header";
        ServiceItem: Record "Service Item";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        MoveEntries: Codeunit MoveEntries;
        UpdateContFromCust: Codeunit "CustCont-Update";
        DimMgt: Codeunit DimensionManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        InsertFromContact: Boolean;
        MoveDocs: Codeunit "Document-Move";
        Text003: Label 'Contact %1 %2 is not related to customer %3 %4.', Comment = 'ESP="El contacto %1 %2 no está relacionado con el cliente %3 %4."';
        Text004: Label 'post', Comment = 'ESP="registrar"';
        Text005: Label 'create', Comment = 'ESP="crear"';
        Text006: Label 'You cannot %1 this type of document when Customer %2 is blocked with type %3', Comment = 'ESP="No puede %1 este tipo de documento cuando el cliente %2 está bloqueado con el tipo %3"';
        Text007: Label 'You cannot delete %1 %2 because there is at least one not cancelled Service Contract for this customer.', Comment = 'ESP="No puede eliminar %1 %2 porque existe al menos un contrato de servicio no cancelado para este cliente."';
        Text008: Label 'Deleting the %1 %2 will cause the %3 to be deleted for the associated Service Items. Do you want to continue?', Comment = 'ESP="Eliminar %1 %2 provocará que se elimine %3 para los productos de servicio asociados. ¿Desea continuar?"';
        Text009: Label 'Cannot delete customer.', Comment = 'ESP="No se puede eliminar el cliente."';
        Text010: Label 'The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3. Enter another code.', Comment = 'ESP="El %1 %2 ha sido asignado a %3 %4.\El mismo %1 no puede introducirse en más de un %3. Introduzca otro código."';
        Text011: Label 'Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?', Comment = 'ESP="La conciliación de transacciones IC puede ser difícil si cambia el código de socio IC porque este %1 tiene movimientos en un ejercicio fiscal que aún no se ha cerrado.\ ¿Desea cambiar de todos modos el código de socio IC?"';
        Text012: Label 'You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.', Comment = 'ESP="No puede cambiar el contenido del campo %1 porque este %2 tiene uno o más movimientos abiertos."';
        Text013: Label 'You cannot delete %1 %2 because there is at least one outstanding Service %3 for this customer.', Comment = 'ESP="No puede eliminar %1 %2 porque existe al menos un %3 de servicio pendiente para este cliente."';
        Text014: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.', Comment = 'ESP="Antes de poder usar Online Map, debe rellenar la ventana de configuración de Online Map.\Consulte Configurar Online Map en la ayuda."';
        Text015: Label 'You cannot delete %1 %2 because there is at least one %3 associated to this customer.', Comment = 'ESP="No puede eliminar %1 %2 porque existe al menos un %3 asociado a este cliente."';
        AllowPaymentToleranceQst: Label 'Do you want to allow payment tolerance for entries that are currently open?', Comment = 'ESP="¿Desea permitir tolerancia de pago para los movimientos que actualmente están abiertos?"';
        RemovePaymentRoleranceQst: Label 'Do you want to remove payment tolerance from entries that are currently open?', Comment = 'ESP="¿Desea quitar la tolerancia de pago de los movimientos que actualmente están abiertos?"';
        CreateNewCustTxt: Label 'Create a new customer card for %1', Comment = 'ESP="Crear una nueva ficha de cliente para %1"';
        SelectCustErr: Label 'You must select an existing customer.', Comment = 'ESP="Debe seleccionar un cliente existente."';
        CustNotRegisteredTxt: Label 'This customer is not registered. To continue, choose one of the following options:', Comment = 'ESP="Este cliente no está registrado. Para continuar, elija una de las siguientes opciones:"';
        SelectCustTxt: Label 'Select an existing customer', Comment = 'ESP="Seleccionar un cliente existente"';
        InsertFromTemplate: Boolean;
        LookupRequested: Boolean;
        vClave: Text[50];
        vSubclave: Text[50];
        vResidencia: Option;
        rVATRegNoFormat: Record "VAT Registration No. Format";
        cVATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
        cEYFunctions: Codeunit "EY Functions";

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Customer, "No.", FieldNumber, ShortcutDimCode);
        MODIFY;
    end;

    procedure CheckBlockedCustOnDocs(Cust2: Record Customer; DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; Shipment: Boolean; Transaction: Boolean)
    begin
        IF ((Cust2.Blocked = Cust2.Blocked::All) OR
    ((Cust2.Blocked = Cust2.Blocked::Invoice) AND
     (DocType IN [DocType::Quote, DocType::Order, DocType::Invoice, DocType::"Blanket Order"])) OR
    ((Cust2.Blocked = Cust2.Blocked::Ship) AND (DocType IN [DocType::Quote, DocType::Order, DocType::"Blanket Order"]) AND
     (NOT Transaction)) OR
    ((Cust2.Blocked = Cust2.Blocked::Ship) AND (DocType IN [DocType::Quote, DocType::Order, DocType::Invoice, DocType::"Blanket Order"]) AND
     Shipment AND Transaction))
THEN
            Cust2.CustBlockedErrorMessage(Cust2, Transaction);
    end;

    procedure CheckBlockedCustOnJnls(Cust2: Record Customer; DocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; Transaction: Boolean)
    begin
        IF (Cust2.Blocked = Cust2.Blocked::All) OR ((Cust2.Blocked = Cust2.Blocked::Invoice) AND (DocType IN [DocType::Invoice, DocType::" "]))
THEN
            Cust2.CustBlockedErrorMessage(Cust2, Transaction)
    end;

    procedure CustBlockedErrorMessage(Cust2: Record Customer; Transaction: Boolean)
    var
        "Action": Text[30];
    begin
        IF Transaction THEN
            Action := Text004
        ELSE
            Action := Text005;
        ERROR(Text006, Action, Cust2."No.", Cust2.Blocked);
    end;

    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        IF MapPoint.FINDFIRST THEN
            MapMgt.MakeSelection(DATABASE::Customer, GETPOSITION)
        ELSE
            MESSAGE(Text014);
    end;

    procedure GetTotalAmountLCY(): Decimal
    begin
        CALCFIELDS("Company Cust. Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)", "Outstanding Invoices (LCY)",
          "Outstanding Serv. Orders (LCY)", "Serv Shipped Not Invoiced(LCY)", "Outstanding Serv.Invoices(LCY)");

        EXIT(GetTotalAmountLCYCommon);
    end;

    procedure GetTotalAmountLCYUI(): Decimal
    begin
        SETAUTOCALCFIELDS("Company Cust. Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)", "Outstanding Invoices (LCY)",
          "Outstanding Serv. Orders (LCY)", "Serv Shipped Not Invoiced(LCY)", "Outstanding Serv.Invoices(LCY)");

        EXIT(GetTotalAmountLCYCommon);
    end;

    local procedure GetTotalAmountLCYCommon(): Decimal
    var
        SalesLine: Record "Sales Line";
        ServiceLine: Record "Service Line";
        SalesOutstandingAmountFromShipment: Decimal;
        ServOutstandingAmountFromShipment: Decimal;
        InvoicedPrepmtAmountLCY: Decimal;
    begin
        SalesOutstandingAmountFromShipment := SalesLine.OutstandingInvoiceAmountFromShipment("No.");
        ServOutstandingAmountFromShipment := ServiceLine.OutstandingInvoiceAmountFromShipment("No.");
        InvoicedPrepmtAmountLCY := GetInvoicedPrepmtAmountLCY;

        EXIT("Company Cust. Balance (LCY)" + "Outstanding Orders (LCY)" + "Shipped Not Invoiced (LCY)" + "Outstanding Invoices (LCY)" +
          "Outstanding Serv. Orders (LCY)" + "Serv Shipped Not Invoiced(LCY)" + "Outstanding Serv.Invoices(LCY)" -
          SalesOutstandingAmountFromShipment - ServOutstandingAmountFromShipment - InvoicedPrepmtAmountLCY);
    end;

    procedure GetSalesLCY(): Decimal
    var
        CustomerSalesYTD: Record Customer;
        AccountingPeriod: Record "Accounting Period";
        StartDate: Date;
        EndDate: Date;
    begin
        StartDate := AccountingPeriod.GetFiscalYearStartDate(WORKDATE);
        EndDate := AccountingPeriod.GetFiscalYearEndDate(WORKDATE);
        //CustomerSalesYTD := Rec;
        CustomerSalesYTD."SECURITYFILTERING"("SECURITYFILTERING");
        CustomerSalesYTD.SETRANGE("Date Filter", StartDate, EndDate);
        CustomerSalesYTD.CALCFIELDS("Sales (LCY)");
        EXIT(CustomerSalesYTD."Sales (LCY)");
    end;

    procedure CalcAvailableCredit(): Decimal
    begin
        EXIT(CalcAvailableCreditCommon(FALSE));
    end;

    procedure CalcAvailableCreditUI(): Decimal
    begin
        EXIT(CalcAvailableCreditCommon(TRUE));
    end;

    local procedure CalcAvailableCreditCommon(CalledFromUI: Boolean): Decimal
    begin
        IF "Credit Limit (LCY)" = 0 THEN
            EXIT(0);
        IF CalledFromUI THEN
            EXIT("Credit Limit (LCY)" - GetTotalAmountLCYUI);
        EXIT("Credit Limit (LCY)" - GetTotalAmountLCY);
    end;

    procedure CalcOverdueBalance() OverDueBalance: Decimal
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        CustLedgEntryRemainAmtQuery: Query "Cust. Ledg. Entry Remain. Amt.";
    begin
        CustLedgEntryRemainAmtQuery.SETRANGE(Customer_No, "No.");
        CustLedgEntryRemainAmtQuery.SETRANGE(IsOpen, TRUE);
        CustLedgEntryRemainAmtQuery.SETFILTER(Due_Date, '<%1', WORKDATE);
        CustLedgEntryRemainAmtQuery.OPEN;

        IF CustLedgEntryRemainAmtQuery.READ THEN
            OverDueBalance := CustLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;
    end;

    procedure GetLegalEntityType(): Text
    begin
        EXIT(FORMAT("Partner Type"));
    end;

    procedure GetLegalEntityTypeLbl(): Text
    begin
        EXIT(FIELDCAPTION("Partner Type"));
    end;

    procedure SetStyle(): Text
    begin
        IF CalcAvailableCredit < 0 THEN
            EXIT('Unfavorable');
        EXIT('');
    end;

    procedure HasValidDDMandate(Date: Date): Boolean
    var
        SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
    begin
        EXIT(SEPADirectDebitMandate.GetDefaultMandate("No.", Date) <> '');
    end;

    procedure GetInvoicedPrepmtAmountLCY(): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SETCURRENTKEY("Document Type", "Bill-to Customer No.");
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE("Bill-to Customer No.", "No.");
        SalesLine.CALCSUMS("Prepmt. Amount Inv. (LCY)", "Prepmt. VAT Amount Inv. (LCY)");
        EXIT(SalesLine."Prepmt. Amount Inv. (LCY)" + SalesLine."Prepmt. VAT Amount Inv. (LCY)");
    end;

    procedure CalcCreditLimitLCYExpendedPct(): Decimal
    begin
        IF "Credit Limit (LCY)" = 0 THEN
            EXIT(0);

        IF "Company Cust. Balance (LCY)" / "Credit Limit (LCY)" < 0 THEN
            EXIT(0);

        IF "Company Cust. Balance (LCY)" / "Credit Limit (LCY)" > 1 THEN
            EXIT(10000);

        EXIT(ROUND("Company Cust. Balance (LCY)" / "Credit Limit (LCY)" * 10000, 1));
    end;

    procedure CreateAndShowNewInvoice()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader.SETRANGE("Sell-to Customer No.", "No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUN(PAGE::"Sales Invoice", SalesHeader)
    end;

    procedure CreateAndShowNewOrder()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader.SETRANGE("Sell-to Customer No.", "No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUN(PAGE::"Sales Order", SalesHeader)
    end;

    procedure CreateAndShowNewCreditMemo()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
        SalesHeader.SETRANGE("Sell-to Customer No.", "No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUN(PAGE::"Sales Credit Memo", SalesHeader)
    end;

    procedure CreateAndShowNewQuote()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
        SalesHeader.SETRANGE("Sell-to Customer No.", "No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUN(PAGE::"Sales Quote", SalesHeader)
    end;

    local procedure UpdatePaymentTolerance(UseDialog: Boolean)
    begin
        IF "Block Payment Tolerance" THEN BEGIN
            IF UseDialog THEN
                IF NOT CONFIRM(RemovePaymentRoleranceQst, FALSE) THEN
                    EXIT;
            //PaymentToleranceMgt.DelTolCustLedgEntry(Rec);
        END ELSE BEGIN
            IF UseDialog THEN
                IF NOT CONFIRM(AllowPaymentToleranceQst, FALSE) THEN
                    EXIT;
            //PaymentToleranceMgt.CalcTolCustLedgEntry(Rec);
        END;
    end;

    procedure GetBillToCustomerNo(): Code[20]
    begin
        IF "Bill-to Customer No." <> '' THEN
            EXIT("Bill-to Customer No.");
        EXIT("No.");
    end;

    procedure HasAddress(): Boolean
    begin
        CASE TRUE OF
            Address <> '':
                EXIT(TRUE);
            "Address 2" <> '':
                EXIT(TRUE);
            City <> '':
                EXIT(TRUE);
            "Country/Region Code" <> '':
                EXIT(TRUE);
            County <> '':
                EXIT(TRUE);
            "Post Code" <> '':
                EXIT(TRUE);
            Contact <> '':
                EXIT(TRUE);
        END;

        EXIT(FALSE);
    end;

    procedure GetCustNo(CustomerText: Text): Text
    begin
        EXIT(GetCustNoOpenCard(CustomerText, TRUE));
    end;

    procedure GetCustNoOpenCard(CustomerText: Text; ShowCustomerCard: Boolean): Code[20]
    var
        Customer: Record Customer;
        CustomerNo: Code[20];
        CustomerWithoutQuote: Text;
        CustomerFilterFromStart: Text;
        CustomerFilterContains: Text;
    begin
        IF CustomerText = '' THEN
            EXIT('');

        IF STRLEN(CustomerText) <= MAXSTRLEN(Customer."No.") THEN
            IF Customer.GET(COPYSTR(CustomerText, 1, MAXSTRLEN(Customer."No."))) THEN
                EXIT(Customer."No.");

        CustomerWithoutQuote := CONVERTSTR(CustomerText, '''', '?');

        Customer.SETFILTER(Name, '''@' + CustomerWithoutQuote + '''');
        IF Customer.FINDFIRST THEN
            EXIT(Customer."No.");
        Customer.SETRANGE(Name);

        CustomerFilterFromStart := '''@' + CustomerWithoutQuote + '*''';

        Customer.FILTERGROUP := -1;
        Customer.SETFILTER("No.", CustomerFilterFromStart);

        Customer.SETFILTER(Name, CustomerFilterFromStart);

        IF Customer.FINDFIRST THEN
            EXIT(Customer."No.");

        CustomerFilterContains := '''@*' + CustomerWithoutQuote + '*''';

        Customer.SETFILTER("No.", CustomerFilterContains);
        Customer.SETFILTER(Name, CustomerFilterContains);
        Customer.SETFILTER(City, CustomerFilterContains);
        Customer.SETFILTER(Contact, CustomerFilterContains);
        Customer.SETFILTER("Phone No.", CustomerFilterContains);
        Customer.SETFILTER("Post Code", CustomerFilterContains);

        IF Customer.COUNT = 0 THEN
            MarkCustomersWithSimilarName(Customer, CustomerText);

        IF Customer.COUNT = 1 THEN BEGIN
            Customer.FINDFIRST;
            EXIT(Customer."No.");
        END;

        IF NOT GUIALLOWED THEN
            ERROR(SelectCustErr);

        IF Customer.COUNT = 0 THEN BEGIN
            IF Customer.WRITEPERMISSION THEN
                CASE STRMENU(
                       STRSUBSTNO(
                         '%1,%2', STRSUBSTNO(CreateNewCustTxt, CONVERTSTR(CustomerText, ',', '.')), SelectCustTxt), 1, CustNotRegisteredTxt) OF
                    0:
                        ERROR(SelectCustErr);
                    1:
                        EXIT(CreateNewCustomer(COPYSTR(CustomerText, 1, MAXSTRLEN(Customer.Name)), ShowCustomerCard));
                END;
            Customer.RESET;
        END;

        IF ShowCustomerCard THEN
            CustomerNo := PickCustomer(Customer)
        ELSE BEGIN
            LookupRequested := TRUE;
            EXIT('');
        END;

        IF CustomerNo <> '' THEN
            EXIT(CustomerNo);

        ERROR(SelectCustErr);
    end;

    local procedure MarkCustomersWithSimilarName(var Customer: Record Customer; CustomerText: Text)
    var
        TypeHelper: Codeunit "Type Helper";
        CustomerCount: Integer;
        CustomerTextLenght: Integer;
        Treshold: Integer;
    begin
        IF CustomerText = '' THEN
            EXIT;
        IF STRLEN(CustomerText) > MAXSTRLEN(Customer.Name) THEN
            EXIT;
        CustomerTextLenght := STRLEN(CustomerText);
        Treshold := CustomerTextLenght DIV 5;
        IF Treshold = 0 THEN
            EXIT;

        Customer.RESET;
        Customer.ASCENDING(FALSE); // most likely to search for newest customers
        IF Customer.FINDSET THEN
            REPEAT
                CustomerCount += 1;
                IF ABS(CustomerTextLenght - STRLEN(Customer.Name)) <= Treshold THEN
                    IF TypeHelper.TextDistance(UPPERCASE(CustomerText), UPPERCASE(Customer.Name)) <= Treshold THEN
                        Customer.MARK(TRUE);
            UNTIL Customer.MARK OR (Customer.NEXT = 0) OR (CustomerCount > 1000);
        Customer.MARKEDONLY(TRUE);
    end;

    local procedure CreateNewCustomer(CustomerName: Text[50]; ShowCustomerCard: Boolean): Code[20]
    var
        Customer: Record Customer;
        CustomerCard: Page "Customer Card";
    begin
        IF NOT cEYFunctions.NewCustomerFromTemplate(Customer) THEN
            Customer.INSERT(TRUE);

        Customer.Name := CustomerName;
        Customer.MODIFY(TRUE);
        COMMIT;
        IF NOT ShowCustomerCard THEN
            EXIT(Customer."No.");
        Customer.SETRANGE("No.", Customer."No.");
        CustomerCard.SETTABLEVIEW(Customer);
        IF NOT (CustomerCard.RUNMODAL = ACTION::OK) THEN
            ERROR(SelectCustErr);

        EXIT(Customer."No.");
    end;

    local procedure PickCustomer(var Customer: Record Customer): Code[20]
    var
        CustomerList: Page "Customer List";
    begin
        IF Customer.FINDSET THEN
            REPEAT
                Customer.MARK(TRUE);
            UNTIL Customer.NEXT = 0;
        IF Customer.FINDFIRST THEN;
        Customer.MARKEDONLY := TRUE;

        CustomerList.SETTABLEVIEW(Customer);
        CustomerList.SETRECORD(Customer);
        CustomerList.LOOKUPMODE := TRUE;
        IF CustomerList.RUNMODAL = ACTION::LookupOK THEN
            CustomerList.GETRECORD(Customer)
        ELSE
            CLEAR(Customer);

        EXIT(Customer."No.");
    end;

    procedure OpenCustomerLedgerEntries(FilterOnDueEntries: Boolean)
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        DetailedCustLedgEntry.SETRANGE("Customer No.", "No.");
        COPYFILTER("Global Dimension 1 Filter", DetailedCustLedgEntry."Initial Entry Global Dim. 1");
        COPYFILTER("Global Dimension 2 Filter", DetailedCustLedgEntry."Initial Entry Global Dim. 2");
        IF FilterOnDueEntries AND (GETFILTER("Date Filter") <> '') THEN BEGIN
            COPYFILTER("Date Filter", DetailedCustLedgEntry."Initial Entry Due Date");
            DetailedCustLedgEntry.SETFILTER("Posting Date", '<=%1', GETRANGEMAX("Date Filter"));
        END;
        COPYFILTER("Currency Filter", DetailedCustLedgEntry."Currency Code");
        CustLedgerEntry.DrillDownOnEntries(DetailedCustLedgEntry);
    end;

    procedure SetInsertFromTemplate(FromTemplate: Boolean)
    begin
        InsertFromTemplate := FromTemplate;
    end;

    procedure IsLookupRequested() Result: Boolean
    begin
        Result := LookupRequested;
        LookupRequested := FALSE;
    end;

    procedure GetNextThirdPartyNo(var ThirdPartyNo: Code[20]; var CreationDateTime: DateTime; ModifyLastThirdPartyNo: Boolean)
    var
        BusinessGroupSetup: Record "Business Group Setup";
    begin
        IF NOT BusinessGroupSetup.GET THEN BEGIN
            BusinessGroupSetup.INIT;
            BusinessGroupSetup.INSERT(TRUE);
        END;
        BusinessGroupSetup.TESTFIELD("Last Third Party No.");

        ThirdPartyNo := INCSTR(BusinessGroupSetup."Last Third Party No.");
        CreationDateTime := CURRENTDATETIME;
        IF ModifyLastThirdPartyNo THEN BEGIN
            BusinessGroupSetup."Last Third Party No." := ThirdPartyNo;
            BusinessGroupSetup.MODIFY;
        END;
    end;

    procedure CheckThirdPartyEnabled(CompName: Text[50]; ThirdPartyType: Option Customer,Vendor; ThirdPartyNo: Code[20]; var ThirdPartyEnabled: Boolean; var CustVendNo: Code[20])
    var
        Cust: Record Customer;
        Vend: Record Vendor;
    begin
        IF CompName = '' THEN
            EXIT;
        CustVendNo := '';
        IF ThirdPartyType = ThirdPartyType::Customer THEN BEGIN
            Cust.RESET;
            Cust.CHANGECOMPANY(CompName);
            Cust.SETCURRENTKEY("Third Party No.");
            Cust.SETRANGE("Third Party No.", ThirdPartyNo);
            IF Cust.FINDLAST THEN BEGIN
                ThirdPartyEnabled := NOT Cust.Disabled;
                IF ThirdPartyEnabled THEN
                    CustVendNo := Cust."No.";
            END ELSE BEGIN
                ThirdPartyEnabled := FALSE;
                CustVendNo := '';
            END;
        END ELSE BEGIN
            Vend.RESET;
            Vend.CHANGECOMPANY(CompName);
            Vend.SETCURRENTKEY("Third Party No.");
            Vend.SETRANGE("Third Party No.", ThirdPartyNo);
            IF Vend.FINDLAST THEN BEGIN
                ThirdPartyEnabled := NOT Vend.Disabled;
                IF ThirdPartyEnabled THEN
                    CustVendNo := Vend."No.";
            END ELSE BEGIN
                ThirdPartyEnabled := FALSE;
                CustVendNo := '';
            END;
        END;
    end;
}
