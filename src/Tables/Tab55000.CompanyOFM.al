table 55000 "Company OFM"
{
    Caption = 'Company OFM', Comment = 'ESP="Empresas OFM"';
    DataPerCompany = false;

    fields
    {
        field(1; Name; Text[30])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(2; "Easy Register"; Boolean)
        {
            Caption = 'Easy Register', Comment = 'ESP="Registro simple"';
        }
        field(3; "School ID"; Integer)
        {
            Caption = 'School ID', Comment = 'ESP="ID colegio"';
        }
        field(4; "Entidad ID"; Integer)
        {
            Caption = 'Entidad ID', Comment = 'ESP="ID entidad"';
        }
        field(5; "Evaluation Company"; Boolean)
        {
            Caption = 'Evaluation Company', Comment = 'ESP="Empresa de evaluación"';
        }
        field(6; "Company ID"; Guid)
        {
            Caption = 'Company ID', Comment = 'ESP="Empresa ID"';
        }

    }
    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
}
