table 50221 "EDUCAMOS EtapaEducativa"
{
    Caption = 'Educational Stage', Comment = 'ESP="Etapa educativa"';

    fields
    {
        field(1; calendarioEscolarId; Text[50])
        {
            Caption = 'School Calendar Id', Comment = 'ESP="Identificador calendario escolar"';
        }
        field(2; nivelEducativoColegioId; Text[50])
        {
            Caption = 'School Educational Level Id', Comment = 'ESP="Identificador nivel educativo del colegio"';
        }
        field(3; nombre; Text[100])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(4; reducido; Text[20])
        {
            Caption = 'Short Name', Comment = 'ESP="Nombre reducido"';
        }
        field(5; nivelEducativoId; Integer)
        {
            Caption = 'Educational Level Id', Comment = 'ESP="Identificador nivel educativo"';
        }
        field(70; "Importation DateTime"; DateTime)
        {
            Caption = 'Import Date/Time', Comment = 'ESP="Fecha y hora importación"';
        }
        field(71; Processed; Boolean)
        {
            Caption = 'Processed', Comment = 'ESP="Procesado"';
        }
    }

    keys
    {
        key(PK; calendarioEscolarId, nivelEducativoColegioId)
        {
            Clustered = true;
        }
    }
}