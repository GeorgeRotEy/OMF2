tableextension 50025 "Vendor Ledger Entry Ext" extends "Vendor Ledger Entry"
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
        field(50002; "Vendor Name OFM"; Text[101])
        {
            Caption = 'Vendor Name', Comment = 'ESP="Nombre proveedor"';
        }
        field(50003; "Posting concept"; Text[250])
        {
            Caption = 'Posting Concept', Comment = 'ESP="Concepto contable"';
        }
    }
}
