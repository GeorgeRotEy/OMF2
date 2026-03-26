table 50013 "Employment SSD"
{
    Caption = 'Employment and Social Security Directory', Comment = 'ESP="Directorio laboral y de seguridad social"';

    fields
    {
        field(1; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.', Comment = 'ESP="NIF/CIF"';
        }
        field(2; "Social Security Number"; Text[30])
        {
            Caption = 'Social Security Number', Comment = 'ESP="Número de la Seguridad Social"';
        }
        field(3; "Digital Access"; Option)
        {
            Caption = 'Digital Access', Comment = 'ESP="Acceso digital"';
            OptionCaption = ',Clave Pin,Certificado Digital,DBI electronico,Telefono';
            OptionMembers = ,"Clave Pin","Certificado Digital","DBI electronico",Telefono;
        }
        field(4; Asset; Boolean)
        {
            Caption = 'Active', Comment = 'ESP="Activo"';
        }
        field(5; "General scheme"; Boolean)
        {
            Caption = 'General Scheme', Comment = 'ESP="Régimen general"';
        }
        field(6; Freelance; Boolean)
        {
            Caption = 'Freelance', Comment = 'ESP="Autónomo"';
        }
        field(7; Dioceses; Text[30])
        {
            Caption = 'Diocese', Comment = 'ESP="Diócesis"';
        }
        field(8; PaySheet; Decimal)
        {
            Caption = 'Payroll Amount', Comment = 'ESP="Nómina"';
        }
        field(9; "Trade-Position"; Option)
        {
            Caption = 'Position', Comment = 'ESP="Oficio / cargo"';
            OptionCaption = ',Parroco,Capellan,Vicario Parroquial,Profesor Colegio,Director Academico';
            OptionMembers = ,Parroco,Capellan,"Vicario Parroquial","Profesor Colegio","Director Academico";
        }
        field(10; Share; Decimal)
        {
            Caption = 'Contribution', Comment = 'ESP="Cuota"';
        }
        field(11; Base; Decimal)
        {
            Caption = 'Base Amount', Comment = 'ESP="Base"';
        }
        field(12; "Medical insurance amount"; Decimal)
        {
            Caption = 'Medical Insurance Amount', Comment = 'ESP="Importe seguro médico"';
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(14; Pensioners; Option)
        {
            Caption = 'Pensioner Type', Comment = 'ESP="Tipo de pensionista"';
            OptionMembers = ,Contributiva,"No contributiva";
        }
        field(15; "Work Life"; Boolean)
        {
            Caption = 'Employment History', Comment = 'ESP="Vida laboral"';
        }
        field(16; "Health Insurance"; Boolean)
        {
            Caption = 'Health Insurance', Comment = 'ESP="Seguro médico"';
        }
        field(17; Firm; Option)
        {
            Caption = 'Insurance Company', Comment = 'ESP="Compañía"';
            OptionMembers = ,Asisa,"Asisa Misioneros",Sanitas;
        }
        field(18; Comments; Text[250])
        {
            Caption = 'Comments', Comment = 'ESP="Observaciones"';
        }
    }

    keys
    {
        key(Key1; "VAT Registration No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
