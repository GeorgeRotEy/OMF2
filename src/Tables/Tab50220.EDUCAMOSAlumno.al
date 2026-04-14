table 50220 "EDUCAMOS Alumno"
{
    Caption = 'Student', Comment = 'ESP="Alumno"';
    DataPerCompany = false;

    fields
    {
        field(1; calendarioEscolarId; Text[50])
        {
            Caption = 'School Calendar ID', Comment = 'ESP="ID calendario escolar"';
        }
        field(2; personaId; Text[50])
        {
            Caption = 'Person Id', Comment = 'ESP="Identificador de persona"';
        }
        field(3; fechaAlta; Date)
        {
            Caption = 'Registration Date', Comment = 'ESP="Fecha de alta"';
        }
        field(4; fechaBaja; Date)
        {
            Caption = 'Deregistration Date', Comment = 'ESP="Fecha de baja"';
        }
        field(5; nombre; Text[100])
        {
            Caption = 'First Name', Comment = 'ESP="Nombre"';
        }
        field(6; apellido1; Text[100])
        {
            Caption = 'Last Name 1', Comment = 'ESP="Primer apellido"';
        }
        field(7; apellido2; Text[100])
        {
            Caption = 'Last Name 2', Comment = 'ESP="Segundo apellido"';
        }
        field(8; sexo; Text[20])
        {
            Caption = 'Gender', Comment = 'ESP="Sexo"';
        }
        field(9; fechaNacimiento; Date)
        {
            Caption = 'Birth Date', Comment = 'ESP="Fecha de nacimiento"';
        }
        field(10; localidadNacimiento; Text[100])
        {
            Caption = 'Birth City', Comment = 'ESP="Localidad de nacimiento"';
        }
        field(12; paisNacimiento; Text[50])
        {
            Caption = 'Country of Birth', Comment = 'ESP="País de nacimiento"';
        }
        field(13; nacionalidad; Text[50])
        {
            Caption = 'Nationality', Comment = 'ESP="Nacionalidad"';
        }
        field(14; telefonoCasa; Text[30])
        {
            Caption = 'Home Phone', Comment = 'ESP="Teléfono de casa"';
        }
        field(15; telefonoEmergencia; Text[30])
        {
            Caption = 'Emergency Phone', Comment = 'ESP="Teléfono de emergencia"';
        }
        field(16; telefonoMovil1; Text[30])
        {
            Caption = 'Mobile Phone 1', Comment = 'ESP="Teléfono móvil 1"';
        }
        field(17; telefonoMovil2; Text[30])
        {
            Caption = 'Mobile Phone 2', Comment = 'ESP="Teléfono móvil 2"';
        }
        field(18; correoElectronico; Text[100])
        {
            Caption = 'Email', Comment = 'ESP="Correo electrónico"';
        }
        field(19; personaTutorPersonalId; Text[50])
        {
            Caption = 'Personal Tutor Id', Comment = 'ESP="Identificador tutor personal"';
        }
        field(20; matricula; Text[30])
        {
            Caption = 'Enrollment Number', Comment = 'ESP="Matrícula"';
        }
        field(21; hijoEmpleado; Boolean)
        {
            Caption = 'Employee Child', Comment = 'ESP="Hijo de empleado"';
        }
        field(22; hijoAntiguoAlumno; Boolean)
        {
            Caption = 'Former Student Child', Comment = 'ESP="Hijo de antiguo alumno"';
        }
        field(23; emancipado; Boolean)
        {
            Caption = 'Emancipated', Comment = 'ESP="Emancipado"';
        }
        field(24; centroProcedencia; Text[100])
        {
            Caption = 'Previous School', Comment = 'ESP="Centro de procedencia"';
        }
        field(25; codigoMunicipioNacimiento; Text[20])
        {
            Caption = 'Birth Municipality Code', Comment = 'ESP="Código municipio de nacimiento"';
        }
        field(26; provinciaNacimiento; Text[50])
        {
            Caption = 'Birth Province', Comment = 'ESP="Provincia de nacimiento"';
        }
        field(27; tipoDocumento; Text[20])
        {
            Caption = 'Document Type', Comment = 'ESP="Tipo de documento"';
        }
        field(28; numeroDocumento; Text[30])
        {
            Caption = 'Document Number', Comment = 'ESP="Número de documento"';
        }
        field(29; familiaId; Text[50])
        {
            Caption = 'Family Id', Comment = 'ESP="Identificador de familia"';
        }
        field(30; tipoMatricula; Text[30])
        {
            Caption = 'Enrollment Type', Comment = 'ESP="Tipo de matrícula"';
        }
        field(31; matriculaCentroAdscrito; Text[30])
        {
            Caption = 'Attached Center Enrollment', Comment = 'ESP="Matrícula centro adscrito"';
        }
        field(32; nia; Text[30])
        {
            Caption = 'NIA', Comment = 'ESP="NIA"';
        }
        field(33; nhaPrimaria; Text[30])
        {
            Caption = 'Primary NHA', Comment = 'ESP="NHA Primaria"';
        }
        field(34; nhaSecundaria; Text[30])
        {
            Caption = 'Secondary NHA', Comment = 'ESP="NHA Secundaria"';
        }
        field(35; nhaBachillerato; Text[30])
        {
            Caption = 'High School NHA', Comment = 'ESP="NHA Bachillerato"';
        }
        field(36; numeroExpedienteCf; Text[30])
        {
            Caption = 'CF File Number', Comment = 'ESP="Número expediente CF"';
        }
        field(37; numeroSeguridadSocial; Text[30])
        {
            Caption = 'Social Security Number', Comment = 'ESP="Número Seguridad Social"';
        }
        field(38; numeroTarjetaSanitaria; Text[30])
        {
            Caption = 'Health Card Number', Comment = 'ESP="Número tarjeta sanitaria"';
        }
        field(39; numeroResidente; Text[30])
        {
            Caption = 'Resident Number', Comment = 'ESP="Número residente"';
        }
        field(40; adaptacionCurricular; Text[50])
        {
            Caption = 'Curriculum Adaptation', Comment = 'ESP="Adaptación curricular"';
        }
        field(41; exentoSeguroEscolar; Boolean)
        {
            Caption = 'School Insurance Exempt', Comment = 'ESP="Exento seguro escolar"';
        }
        field(42; fechaIncorporacionCapv; Date)
        {
            Caption = 'CAPV Incorporation Date', Comment = 'ESP="Fecha incorporación CAPV"';
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
        key(PK; personaId)
        {
            Clustered = true;
        }
    }
}