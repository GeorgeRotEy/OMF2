table 50124 "Dashboard Work Link"
{
    Caption = 'Dashboard Work Link', Comment = 'ESP="Enlace de trabajo dashboard"';
    DataClassification = CustomerContent;
    DrillDownPageId = "Dashboard Work Links";
    LookupPageId = "Dashboard Work Links";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº movimiento"';
            AutoIncrement = true;
        }
        field(2; "Page Name"; Text[100])
        {
            Caption = 'Page', Comment = 'ESP="Página"';
            DataClassification = CustomerContent;
        }
        field(3; URL; Text[2048])
        {
            Caption = 'URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(4; Description; Text[250])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
        }
        field(5; "Sorting No."; Integer)
        {
            Caption = 'Sorting No.', Comment = 'ESP="Nº orden"';
            DataClassification = CustomerContent;
        }
        field(6; Active; Boolean)
        {
            Caption = 'Active', Comment = 'ESP="Activo"';
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Sorting; Active, "Sorting No.", "Page Name")
        {
        }
    }
}