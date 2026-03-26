table 50041 "Third Party Bank Account"
{
    // // Mod. S2G 18/12/2017 (JGS) : TER001 ã Terceros.

    Caption = 'Third Party Bank Account', Comment = 'ESP="Cuenta bancaria de tercero"';
    DataPerCompany = false;
    DrillDownPageID = "Third Party Bank Acc. List";
    LookupPageID = "Third Party Bank Acc. List";

    fields
    {
        field(1; "Third Party No."; Code[20])
        {
            Caption = 'Third Party No.', Comment = 'ESP="Nº tercero"';
            TableRelation = "Third Party";
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code', Comment = 'ESP="Código"';
            NotBlank = true;
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(5; "Name 2"; Text[50])
        {
            Caption = 'Name 2', Comment = 'ESP="Nombre 2"';
        }
        field(6; Address; Text[50])
        {
            Caption = 'Address', Comment = 'ESP="Dirección"';
        }
        field(7; "Address 2"; Text[50])
        {
            Caption = 'Address 2', Comment = 'ESP="Dirección 2"';
        }
        field(8; City; Text[30])
        {
            Caption = 'City', Comment = 'ESP="Ciudad"';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(9; "Post Code"; Code[20])
        {
            Caption = 'Post Code', Comment = 'ESP="Código postal"';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(10; Contact; Text[50])
        {
            Caption = 'Contact', Comment = 'ESP="Contacto"';
        }
        field(11; "Phone No."; Text[30])
        {
            Caption = 'Phone No.', Comment = 'ESP="Teléfono"';
            ExtendedDatatype = PhoneNo;
        }
        field(12; "Telex No."; Text[20])
        {
            Caption = 'Telex No.', Comment = 'ESP="Télex"';
        }
        field(13; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.', Comment = 'ESP="Sucursal bancaria"';
        }
        field(14; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.', Comment = 'ESP="Nº cuenta bancaria"';

            trigger OnValidate()
            begin
                TESTFIELD("CCC Bank Account No.", '');
            end;
        }
        field(15; "Transit No."; Text[20])
        {
            Caption = 'Transit No.', Comment = 'ESP="Nº tránsito"';
        }
        field(16; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code', Comment = 'ESP="Cód. divisa"';
            TableRelation = Currency;
        }
        field(17; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code', Comment = 'ESP="Cód. país/región"';
            TableRelation = "Country/Region";
        }
        field(18; County; Text[30])
        {
            Caption = 'County', Comment = 'ESP="Provincia"';
        }
        field(19; "Fax No."; Text[30])
        {
            Caption = 'Fax No.', Comment = 'ESP="Nº fax"';
        }
        field(20; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back', Comment = 'ESP="Respuesta télex"';
        }
        field(21; "Language Code"; Code[10])
        {
            Caption = 'Language Code', Comment = 'ESP="Cód. idioma"';
            TableRelation = Language;
        }
        field(22; "E-Mail"; Text[80])
        {
            Caption = 'Email', Comment = 'ESP="Correo electrónico"';
            ExtendedDatatype = EMail;
        }
        field(23; "Home Page"; Text[80])
        {
            Caption = 'Home Page', Comment = 'ESP="Página web"';
            ExtendedDatatype = URL;
        }
        field(24; IBAN; Code[50])
        {
            Caption = 'IBAN', Comment = 'ESP="IBAN"';

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                CompanyInfo.CheckIBAN(IBAN);
            end;
        }
        field(25; "SWIFT Code"; Code[20])
        {
            Caption = 'SWIFT Code', Comment = 'ESP="Código SWIFT"';
        }
        field(1211; "Bank Clearing Code"; Text[50])
        {
            Caption = 'Bank Clearing Code', Comment = 'ESP="Código de compensación bancaria"';
        }
        field(1212; "Bank Clearing Standard"; Text[50])
        {
            Caption = 'Bank Clearing Standard', Comment = 'ESP="Estándar de compensación bancaria"';
            TableRelation = "Bank Clearing Standard";
        }
        field(10700; "CCC Bank No."; Text[4])
        {
            Caption = 'CCC Bank No.', Comment = 'ESP="CCC - Nº banco"';
            Numeric = true;

            trigger OnValidate()
            begin
                "CCC Bank No." := PrePadString("CCC Bank No.", MAXSTRLEN("CCC Bank No."));
                BuildCCC;
            end;
        }
        field(10701; "CCC Bank Branch No."; Text[4])
        {
            Caption = 'CCC Bank Branch No.', Comment = 'ESP="CCC - Nº sucursal"';
            Numeric = true;

            trigger OnValidate()
            begin
                "CCC Bank Branch No." := PrePadString("CCC Bank Branch No.", MAXSTRLEN("CCC Bank Branch No."));
                BuildCCC;
            end;
        }
        field(10702; "CCC Control Digits"; Text[2])
        {
            Caption = 'CCC Control Digits', Comment = 'ESP="CCC - Dígitos control"';
            Numeric = true;

            trigger OnValidate()
            begin
                "CCC Control Digits" := PrePadString("CCC Control Digits", MAXSTRLEN("CCC Control Digits"));
                BuildCCC;
            end;
        }
        field(10703; "CCC Bank Account No."; Text[10])
        {
            Caption = 'CCC Bank Account No.', Comment = 'ESP="CCC - Nº cuenta"';
            Numeric = true;

            trigger OnValidate()
            begin
                "CCC Bank Account No." := PrePadString("CCC Bank Account No.", MAXSTRLEN("CCC Bank Account No."));
                BuildCCC;
            end;
        }
        field(10704; "CCC No."; Text[20])
        {
            Caption = 'CCC No.', Comment = 'ESP="CCC"';
            Numeric = true;

            trigger OnValidate()
            begin
                "CCC Bank No." := COPYSTR("CCC No.", 1, 4);
                "CCC Bank Branch No." := COPYSTR("CCC No.", 5, 4);
                "CCC Control Digits" := COPYSTR("CCC No.", 9, 2);
                "CCC Bank Account No." := COPYSTR("CCC No.", 11, 23);
            end;
        }
        field(10705; "Use For Electronic Payments"; Boolean)
        {
            Caption = 'Use For Electronic Payments', Comment = 'ESP="Usar para pagos electrónicos"';

            trigger OnValidate()
            var
                ThirdPartyBankAcc: Record "Third Party Bank Account";
                Text1100000: Label 'Use for Electronic Payments can  be checked for only one of the Vendor''s Bank Accounts. ';
            begin
                ThirdPartyBankAcc.SETRANGE("Third Party No.", "Third Party No.");
                ThirdPartyBankAcc.SETRANGE("Use For Electronic Payments", TRUE);
                IF ThirdPartyBankAcc.FINDFIRST THEN
                    IF (ThirdPartyBankAcc.COUNT = 1) AND "Use For Electronic Payments" THEN
                        IF xRec."Use For Electronic Payments" <> "Use For Electronic Payments" THEN
                            ERROR(Text1100000);
            end;
        }
    }

    keys
    {
        key(Key1; "Third Party No.", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PostCode: Record "Post Code";
        ThirdParty: Record "Third Party";
        BankAccIdentifierIsEmptyErr: Label 'You must specify either a Bank Account No. or an IBAN.';
        BankAccDeleteErr: Label 'You cannot delete this bank account because it is associated with one or more open ledger entries.';

    procedure BuildCCC()
    begin
        "CCC No." := "CCC Bank No." + "CCC Bank Branch No." + "CCC Control Digits" + "CCC Bank Account No.";
        IF "CCC No." <> '' THEN
            TESTFIELD("Bank Account No.", '');
    end;

    procedure PrePadString(InString: Text[250]; MaxLen: Integer): Text[250]
    begin
        EXIT(PADSTR('', MaxLen - STRLEN(InString), '0') + InString);
    end;

    procedure GetBankAccountNoWithCheck() AccountNo: Text
    begin
        AccountNo := GetBankAccountNo;
        IF AccountNo = '' THEN
            ERROR(BankAccIdentifierIsEmptyErr);
    end;

    procedure GetBankAccountNo(): Text
    begin
        IF IBAN <> '' THEN
            EXIT(DELCHR(IBAN, '=<>'));

        IF "Bank Account No." <> '' THEN
            EXIT("Bank Account No.");
    end;
}
