table 50211 "EDUCAMOS Pagador"
{
    fields
    {
        field(1; personaId; Text[50])
        {
            Caption = 'Person ID', Comment = 'ESP="ID persona"';
        }
        field(2; nombre; Text[100])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(3; apellido1; Text[100])
        {
            Caption = 'First Lastname', Comment = 'ESP="Primer apellido"';
        }
        field(4; apellido2; Text[100])
        {
            Caption = 'Second Lastname', Comment = 'ESP="Segundo apellido"';
        }
        field(5; sexo; Text[20])
        {
            Caption = 'Gender', Comment = 'ESP="Sexo"';
        }
        field(6; tipoDocumento; Text[50])
        {
            Caption = 'Document Type', Comment = 'ESP="Tipo de documento"';
        }
        field(7; numeroDocumento; Text[50])
        {
            Caption = 'Document Number', Comment = 'ESP="Número documento"';
        }
        field(8; telefonoCasa; Text[30])
        {
            Caption = 'Home Phone', Comment = 'ESP="Teléfono casa"';
        }
        field(9; telefonoMovil1; Text[30])
        {
            Caption = 'Mobile Phone', Comment = 'ESP="Teléfono móvil 1"';
        }
        field(10; correoElectronico; Text[150])
        {
            Caption = 'Email', Comment = 'ESP="Correo electrónico"';
        }
        field(11; codigoSAGE; Text[50])
        {
            Caption = 'SAGE Code', Comment = 'ESP="Código SAGE"';
        }
        field(12; calle; Text[150])
        {
            Caption = 'Street', Comment = 'ESP="Calle"';
        }
        field(13; codigoPostal; Text[10])
        {
            Caption = 'Postal Code', Comment = 'ESP="Código postal"';
        }
        field(14; region; Text[100])
        {
            Caption = 'Region', Comment = 'ESP="Región"';
        }
        field(15; pais; Text[100])
        {
            Caption = 'Country', Comment = 'ESP="País"';
        }
        field(16; tipoVia; Text[50])
        {
            Caption = 'Street Type', Comment = 'ESP="Tipo vía"';
        }
        field(17; numero; Text[20])
        {
            Caption = 'Number', Comment = 'ESP="Número"';
        }
        field(18; bloque; Text[20])
        {
            Caption = 'Block', Comment = 'ESP="Bloque"';
        }
        field(19; escalera; Text[20])
        {
            Caption = 'Stair', Comment = 'ESP="Escalera"';
        }
        field(20; piso; Text[20])
        {
            Caption = 'Floor', Comment = 'ESP="Piso"';
        }
        field(21; puerta; Text[20])
        {
            Caption = 'Door', Comment = 'ESP="Puerta"';
        }
        field(22; localidad; Text[100])
        {
            Caption = 'Town', Comment = 'ESP="Localidad"';
        }
        field(23; codigoMunicipio; Text[20])
        {
            Caption = 'Municipality Code', Comment = 'ESP="Código municipio"';
        }
        field(24; concejo; Text[100])
        {
            Caption = 'Council', Comment = 'ESP="Concejo"';
        }
        field(25; provincia; Text[100])
        {
            Caption = 'Province', Comment = 'ESP="Provincia"';
        }
        field(70; "Importation DateTime"; DateTime)
        {
            Caption = 'Import Date/Time', Comment = 'ESP="Fecha y hora de importación"';
        }
        field(71; Processed; Boolean)
        {
            Caption = 'Processed', Comment = 'ESP="Procesado"';
        }
    }

    keys
    {
        key(PK; personaId) { Clustered = true; }
    }
}