tableextension 50021 "Cust. Ledger Entry Ext" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "Source Company Name"; Text[30])
        {
            Caption = 'Source Company Name', Comment = 'ESP="Nombre empresa origen"';
            TableRelation = Company.Name;
        }
        field(50001; "Third Party No."; Code[20])
        {
            Caption = 'Third Party No.', Comment = 'ESP="Nº tercero"';
            TableRelation = "Third Party";
        }
        field(50002; "Customer Name OFM"; Text[101])
        {
            Caption = 'Customer Name', Comment = 'ESP="Nombre cliente"';
        }
        field(50003; "Posting concept"; Text[250])
        {
            Caption = 'Posting Concept', Comment = 'ESP="Concepto contable"';
        }
    }
}