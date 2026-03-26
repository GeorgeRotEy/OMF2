table 50015 "Esudios y Publicaciones"
{
    Caption = 'Studies and Publications', Comment = 'ESP="Estudios y publicaciones"';

    fields
    {
        field(1; "Registration number"; Code[10])
        {
            Caption = 'Registration Number', Comment = 'ESP="Número de registro"';
        }
        field(2; "No. Serie Friar"; Code[20])
        {
            Caption = 'Friar No.', Comment = 'ESP="Nº serie hermano"';
            TableRelation = Friar."No. Serie Friar";
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(4; Surnames; Text[50])
        {
            Caption = 'Surnames', Comment = 'ESP="Apellidos"';
        }
        field(5; Type; Option)
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';
            OptionMembers = ,Estudio,Publicacion;
        }
        field(6; Date; Date)
        {
            Caption = 'Date', Comment = 'ESP="Fecha"';
        }
    }

    keys
    {
        key(Key1; "Registration number")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
