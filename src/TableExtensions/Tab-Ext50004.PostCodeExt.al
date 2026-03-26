tableextension 50004 "Post Code Ext" extends "Post Code"
{
    fields
    {
        field(50000; Fraternity; Text[80])
        {
            Caption = 'Fraternity', Comment = 'ESP="Fraternidad"';
        }
        field(50001; "Phone No."; Text[30])
        {
            Caption = 'Phone No.', Comment = 'ESP="N.º teléfono"';
            ExtendedDatatype = PhoneNo;
        }
        field(50002; "Adress Fraternity"; Text[50])
        {
            Caption = 'Fraternity Address', Comment = 'ESP="Dirección fraternidad"';
        }
        field(50003; NIF; Text[13])
        {
            Caption = 'Tax Identification No.', Comment = 'ESP="NIF"';
        }
        field(50004; "Cod. RER"; Code[10])
        {
            Caption = 'RER Code', Comment = 'ESP="Cód. RER"';
        }
        field(50005; "Cod. CNAE"; Code[10])
        {
            Caption = 'CNAE Code', Comment = 'ESP="Cód. CNAE"';
        }
        field(50006; "Destino Fraternidad Nav"; Code[50])
        {
            Caption = 'Fraternity NAV Destination', Comment = 'ESP="Destino fraternidad NAV "';
        }
    }
}
