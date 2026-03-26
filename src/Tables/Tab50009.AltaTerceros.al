table 50009 "Alta Terceros"
{
    Caption = 'Post Third Party', Comment = 'ESP="Alta de terceros"';
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Número"';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address', Comment = 'ESP="Dirección"';
        }
        field(7; City; Text[30])
        {
            Caption = 'City', Comment = 'ESP="Ciudad"';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code', Comment = 'ESP="Código país/región"';
            NotBlank = true;
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                PostCode.ValidateCountryCode(City, "Post Code", County, "Country/Region Code");
            end;
        }
        field(86; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.', Comment = 'ESP="NIF/CIF"';
            NotBlank = true;

            trigger OnValidate()
            begin
                //(CJ02) S2G (JDT) 28-10-19: Validación de CIF en Alta Terceros
                IF rVATRegNoFormat.Test("VAT Registration No.", "Country/Region Code", "No.", DATABASE::"Alta Terceros") THEN
                    IF "VAT Registration No." <> xRec."VAT Registration No." THEN
                        cEYFunctions.fLogCheckAltaTerceros(Rec);
                //(CJ02) S2G (JDT) 28-10-19:
            end;
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code', Comment = 'ESP="Código postal"';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(92; County; Text[30])
        {
            Caption = 'County', Comment = 'ESP="Provincia"';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "No." := '1';
        IF xRec.FINDLAST THEN
            "No." := INCSTR(xRec."No.");
    end;

    var
        PostCode: Record "Post Code";
        rVATRegNoFormat: Record "VAT Registration No. Format";
        cEYFunctions: Codeunit "EY Functions";
        rThirdParty: Record "Third Party";

        pThirdPartyCard: Page "Third Party Card";
        Text001: Label 'Este CIF/NIF %1 ya esta existe.';

    procedure fCheckCampos()
    begin
        TESTFIELD(Name);
        TESTFIELD("VAT Registration No.");
        TESTFIELD(Address);
        TESTFIELD(City);
        TESTFIELD("Country/Region Code");
        TESTFIELD(County);
        TESTFIELD("Post Code");

        rThirdParty.SETRANGE(rThirdParty."VAT Registration No.", Rec."VAT Registration No.");
        IF rThirdParty.FINDFIRST THEN
            ERROR(Text001, "VAT Registration No.");
    end;

    procedure fTransferDatos()
    begin
        CLEAR(rThirdParty);
        rThirdParty.INSERT(TRUE);
        rThirdParty.Name := Name;
        rThirdParty."VAT Registration No." := "VAT Registration No.";
        rThirdParty.Address := Address;
        rThirdParty.City := City;
        rThirdParty."Country/Region Code" := "Country/Region Code";
        rThirdParty.County := County;
        rThirdParty."Post Code" := "Post Code";
        rThirdParty.MODIFY;

        rThirdParty.SETRANGE(rThirdParty."No.", rThirdParty."No.");
        pThirdPartyCard.SETTABLEVIEW(rThirdParty);
        pThirdPartyCard.RUN;
    end;
}
