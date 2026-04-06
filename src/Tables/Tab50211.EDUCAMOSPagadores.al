table 50211 "EDUCAMOS Pagadores"
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
        //Grupo dirección
        field(20; calle; Text[150])
        {
            Caption = 'Street', Comment = 'ESP="Calle"';
        }
        field(21; codigoPostal; Text[10])
        {
            Caption = 'Postal Code', Comment = 'ESP="Código postal"';
        }
        field(22; region; Text[100])
        {
            Caption = 'Region', Comment = 'ESP="Región"';
        }
        field(23; pais; Text[100])
        {
            Caption = 'Country', Comment = 'ESP="País"';
        }
        field(24; tipoVia; Text[50])
        {
            Caption = 'Street Type', Comment = 'ESP="Tipo vía"';
        }
        field(25; numero; Text[20])
        {
            Caption = 'Number', Comment = 'ESP="Número"';
        }
        field(26; bloque; Text[20])
        {
            Caption = 'Block', Comment = 'ESP="Bloque"';
        }
        field(27; escalera; Text[20])
        {
            Caption = 'Stair', Comment = 'ESP="Escalera"';
        }
        field(28; piso; Text[20])
        {
            Caption = 'Floor', Comment = 'ESP="Piso"';
        }
        field(29; puerta; Text[20])
        {
            Caption = 'Door', Comment = 'ESP="Puerta"';
        }
        field(30; localidad; Text[100])
        {
            Caption = 'Town', Comment = 'ESP="Localidad"';
        }
        field(31; codigoMunicipio; Text[20])
        {
            Caption = 'Municipality Code', Comment = 'ESP="Código municipio"';
        }
        field(32; concejo; Text[100])
        {
            Caption = 'Council', Comment = 'ESP="Concejo"';
        }
        field(33; provincia; Text[100])
        {
            Caption = 'Province', Comment = 'ESP="Provincia"';
        }
        //Grupo medios pago
        field(40; pagadorMedioPagoId; Text[50])
        {
            Caption = 'Payer Payment Method ID', Comment = 'ESP="ID medio de pago"';
        }
        field(41; medioPago; Text[100])
        {
            Caption = 'Payment Method', Comment = 'ESP="Medio de pago"';
        }
        field(42; porDefectoMedioPago; Boolean)
        {
            Caption = 'Default Payment Method', Comment = 'ESP="Por defecto (medio de pago)"';
        }
        //Grupo cuenta bancaria del medio de pago
        field(50; bic; Text[20])
        {
            Caption = 'BIC', Comment = 'ESP="BIC"';
        }
        field(51; codigoPais; Text[5])
        {
            Caption = 'Country Code', Comment = 'ESP="Código país"';
        }
        field(52; digitoControlIban; Text[5])
        {
            Caption = 'IBAN Check Digit', Comment = 'ESP="Dígito control IBAN"';
        }
        field(53; entidad; Text[10])
        {
            Caption = 'Entity', Comment = 'ESP="Entidad"';
        }
        field(54; sucursal; Text[10])
        {
            Caption = 'Branch', Comment = 'ESP="Sucursal"';
        }
        field(55; digitoControl; Text[5])
        {
            Caption = 'Control Digit', Comment = 'ESP="Dígito control"';
        }
        field(56; numeroCuenta; Text[20])
        {
            Caption = 'Account Number', Comment = 'ESP="Número de cuenta"';
        }
        //Grupo dependientes económicos
        field(60; dependientePersonaId; Text[50])
        {
            Caption = 'Dependent Person ID', Comment = 'ESP="ID persona dependiente"';
        }
        field(61; dependientePorDefecto; Boolean)
        {
            Caption = 'Default Dependent', Comment = 'ESP="Por defecto (dependiente)"';
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
        key(PK; personaId)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}