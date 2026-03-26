table 50025 "General Setup"
{
    // // Mod. S2G 18/12/2017 (JGS) : TER001 ã Terceros.
    //       Nueva clave
    //             Primary Key
    //       Nuevos campos
    //             Primary Key.
    //             Centralized Third Party Mgt.
    //             Customer Numbering Preffix
    //             Vendor Numbering Preffix
    // // Mod. S2G 19/01/2018 (JGS) : TER001 ã Terceros.
    //         Nuevos campos
    //             Creditor Numbering Preffix

    Caption = 'General Setup', Comment = 'ESP="Configuración general"';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key', Comment = 'ESP="Clave primaria"';
        }
        field(40; "Centralized Third Party Mgt."; Boolean)
        {
            Caption = 'Centralized Third Party Mgt.', Comment = 'ESP="Gestión centralizada de terceros"';
            Description = 'TER001 - Maestro terceros';
            InitValue = true;
        }
        field(41; "Customer Numbering Preffix"; Code[10])
        {
            Caption = 'Customer Numbering Prefix', Comment = 'ESP="Prefijo numeración clientes"';
            Description = 'TER001 - Maestro terceros';
        }
        field(42; "Vendor Numbering Preffix"; Code[10])
        {
            Caption = 'Vendor Numbering Prefix', Comment = 'ESP="Prefijo numeración proveedores"';
            Description = 'TER001 - Maestro terceros';
        }
        field(43; "Creditor Numbering Preffix"; Code[10])
        {
            Caption = 'Creditor Numbering Prefix', Comment = 'ESP="Prefijo numeración acreedores"';
            Description = 'TER001 - Maestro terceros';
        }
        field(102; "Omite Third Party"; Boolean)
        {
            Caption = 'Omit Third Party for Customers and Vendors', Comment = 'ESP="Omitir tercero para clientes y proveedores"';
            Description = 'TER-001';
        }
        field(105; "Include Company Third Party"; Boolean)
        {
            Caption = 'Include Company in Third Party Statistics', Comment = 'ESP="Incluir empresa en estadística de terceros"';
            Description = 'TER-001';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
