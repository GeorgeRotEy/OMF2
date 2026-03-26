xmlport 50010 "Export Importes Facts."
{
    Direction = Export;
    Encoding = UTF8;
    // FieldSeparator = '<|>';
    Caption = 'Export Facts Amounts', Comment = 'ESP="Export Importes Facts."';
    Format = Xml;

    schema
    {
        textelement(root)
        {
            tableelement("Sales Invoice Header"; "Sales Invoice Header")
            {
                XmlName = 'SalesInvoiceHeader';
                SourceTableView = WHERE("External Document No." = FILTER('FV*'));
                fieldelement(SalesInvoiceNo; "Sales Invoice Header"."No.")
                {
                }
                tableelement("Sales Invoice Line"; "Sales Invoice Line")
                {
                    LinkFields = "Document No." = FIELD("No.");
                    LinkTable = "Sales Invoice Header";
                    XmlName = 'SalesInvoiceLine';
                    fieldelement(LineNo; "Sales Invoice Line"."Line No.")
                    {
                    }
                    fieldelement(Amount_SL; "Sales Invoice Line".Amount)
                    {
                    }
                    fieldelement(AmountIncludingVAT_SL; "Sales Invoice Line"."Amount Including VAT")
                    {
                    }
                }
                tableelement("G/L Entry"; "G/L Entry")
                {
                    LinkFields = "Document No." = FIELD("No."), "Posting Date" = FIELD("Posting Date");
                    LinkTable = "Sales Invoice Header";
                    XmlName = 'GLEntry';
                    fieldelement(Amount_GL; "G/L Entry".Amount)
                    {
                    }
                    fieldelement(VATAmount_GL; "G/L Entry"."VAT Amount")
                    {
                    }
                    fieldelement(DebitAmount_GL; "G/L Entry"."Debit Amount")
                    {
                    }
                    fieldelement(CebitAmount_GL; "G/L Entry"."Credit Amount")
                    {
                    }
                }
                tableelement("VAT Entry"; "VAT Entry")
                {
                    LinkFields = "Document No." = FIELD("No."), "Posting Date" = FIELD("Posting Date");
                    LinkTable = "Sales Invoice Header";
                    XmlName = 'VATEntry';
                    fieldelement(Base_VAT; "VAT Entry".Base)
                    {
                    }
                    fieldelement(Amount_VAT; "VAT Entry".Amount)
                    {
                    }
                }
                tableelement("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    LinkFields = "Document No." = FIELD("No."), "Posting Date" = FIELD("Posting Date");
                    LinkTable = "Sales Invoice Header";
                    XmlName = 'CustLEntry';
                    fieldelement(RemainingAmount_C; "Cust. Ledger Entry"."Remaining Amount (LCY) stats.")
                    {
                    }
                    fieldelement(Amount_C; "Cust. Ledger Entry"."Amount (LCY) stats.")
                    {
                    }
                }
                tableelement("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    LinkFields = "Document No." = FIELD("No."), "Posting Date" = FIELD("Posting Date");
                    LinkTable = "Sales Invoice Header";
                    XmlName = 'DetailCustLEntry';
                    fieldelement(Amount_DC; "Detailed Cust. Ledg. Entry".Amount)
                    {
                    }
                    fieldelement(AmountLCY_DC; "Detailed Cust. Ledg. Entry"."Amount (LCY)")
                    {
                    }
                    fieldelement(DebitAmount_DC; "Detailed Cust. Ledg. Entry"."Debit Amount")
                    {
                    }
                    fieldelement(CebitAmount_DC; "Detailed Cust. Ledg. Entry"."Credit Amount")
                    {
                    }
                    fieldelement(DebitAmountLCY_DC; "Detailed Cust. Ledg. Entry"."Debit Amount")
                    {
                    }
                    fieldelement(CebitAmountLCY_DC; "Detailed Cust. Ledg. Entry"."Credit Amount")
                    {
                    }
                }
                tableelement("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
                {
                    LinkFields = "Document No." = FIELD("No."), "Posting Date" = FIELD("Posting Date");
                    ;
                    LinkTable = "Sales Invoice Header";
                    XmlName = 'BankAccLEntry';
                    fieldelement(Amount_B; "Bank Account Ledger Entry".Amount)
                    {
                    }
                    fieldelement(RemainingAmount_B; "Bank Account Ledger Entry"."Remaining Amount")
                    {
                    }
                    fieldelement(AmountLCY_B; "Bank Account Ledger Entry"."Amount (LCY)")
                    {
                    }
                    fieldelement(DebitAmount_B; "Bank Account Ledger Entry"."Debit Amount")
                    {
                    }
                    fieldelement(CebitAmount_B; "Bank Account Ledger Entry"."Credit Amount")
                    {
                    }
                    fieldelement(DebitAmountLCY_B; "Bank Account Ledger Entry"."Debit Amount (LCY)")
                    {
                    }
                    fieldelement(CebitAmountLCY_B; "Bank Account Ledger Entry"."Credit Amount (LCY)")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(rSalesInvoiceHeader);
                    rSalesInvoiceHeader.GET("Sales Invoice Header"."External Document No.");
                end;

                trigger OnBeforeInsertRecord()
                begin
                    currXMLport.SKIP;
                end;
            }

            trigger OnBeforePassVariable()
            begin
                // vlFiltro := 'FV*';
                // "Sales Invoice Header".SETFILTER("External Document No.",vlFiltro);
            end;
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
        rSalesInvoiceHeader: Record "Sales Invoice Header";
}
