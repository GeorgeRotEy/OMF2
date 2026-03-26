table 50010 "Easy Register Concepts"
{
    // Mod. S2G (FMR) 31/10/14 CAR005 Gestión cajas centros
    //                         Nombre tabla
    //                           Configuración diario caja --> Cash Register Item (Concepto caja)
    //                         Campo
    //                           10 Service Type
    //                           11 Description
    //
    // Mod. S2G (RBM-R) 31/10/18 Modificaciones Registro Simple
    //
    // (CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple

    Caption = 'Easy Register Concepts', Comment = 'ESP="Conceptos de registro simple"';
    DataPerCompany = true;
    LookupPageID = "Easy Register Concepts";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code', Comment = 'ESP="Código"';
        }
        field(2; "Account Type"; Option)
        {
            Caption = 'Account Type', Comment = 'ESP="Tipo de cuenta"';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account', Comment = 'ESP="Cuenta contable,Cliente,Proveedor,Banco"';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account";
        }
        field(3; "Account No."; Code[20])
        {
            Caption = 'Account No.', Comment = 'ESP="Nº cuenta"';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Account Type" = CONST("Customer")) Customer
            ELSE IF ("Account Type" = CONST("Vendor")) Vendor;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(5; Type; Option)
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';
            OptionCaption = ' ,Receipts,Payments,Transfers', Comment = 'ESP=" ,Cobros,Pagos,Transferencias"';
            OptionMembers = " ",Receipts,Payments,Transfers;
        }
        field(6; "Easy Register Dimension Value"; Code[20])
        {
            Caption = 'Easy Register Dimension Value', Comment = 'ESP="Valor dim. reg. simple"';
            Description = '(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple';
            TableRelation = "Dimension Value".Code WHERE("Easy Register Dimension" = CONST(true),
                                                      Blocked = CONST(false),
                                                      "Dimension Value Type" = CONST(Standard));
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
