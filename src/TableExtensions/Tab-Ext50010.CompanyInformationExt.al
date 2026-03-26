tableextension 50010 "Company Information Ext" extends "Company Information"
{
    fields
    {
        field(50001; LogoAzul; BLOB)
        {
            Caption = 'Blue Picture', Comment = 'ESP="Imagen azul"';
            SubType = Bitmap;
        }
        field(50002; LogoNegro; BLOB)
        {
            Caption = 'Black Picture', Comment = 'ESP="Imagen negra"';
            SubType = Bitmap;
        }
        field(50003; LogoColegio; BLOB)
        {
            Caption = 'School Picture', Comment = 'ESP="Imagen colegio"';
            SubType = Bitmap;
        }
        field(50004; SelloProvincia; BLOB)
        {
            Caption = 'Province Stamp Picture', Comment = 'ESP="Sello provincia"';
            SubType = Bitmap;
        }
        field(50005; SelloEntidad; BLOB)
        {
            Caption = 'Company Stamp Picture', Comment = 'ESP="Sello entidad"';
            SubType = Bitmap;
        }
        field(50006; ExtensionTelf; Text[30])
        {
            Caption = 'Phone Extension', Comment = 'ESP="Extensión teléfono"';
        }
    }
}
