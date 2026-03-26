table 50042 "Business Group Setup"
{
    Caption = 'Business Group Setup', Comment = 'ESP="Configuración grupo de negocio"';
    DataPerCompany = false;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key', Comment = 'ESP="Clave primaria"';

            trigger OnValidate()
            begin
                // Mod. S2G 18/12/2017 (JGS) : TER001 ã Terceros.
            end;
        }
        field(2; "Last Third Party No."; Code[20])
        {
            Caption = 'Last Third Party No.', Comment = 'ESP="Último nº tercero"';
            InitValue = '000001';

            trigger OnValidate()
            begin
                IF "Last Third Party No." <> '' THEN
                    CheckNextThirdPartyNo;
            end;
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

    trigger OnInsert()
    begin
        IF "Last Third Party No." = '' THEN
            "Last Third Party No." := LastThirdPartyNo;
    end;

    var
        NextThirdPartyAlreadyExists: Label 'Next third party no. already exists: %1', Comment = 'ESP="El siguiente nº de tercero ya existe: %1"';
        UnableToIncreaseIssue: Label 'You must fill in a code which can be increased', Comment = 'ESP="Debe informar un código que pueda incrementarse"';
        LastThirdPartyNo: Label '000000';

    local procedure CheckNextThirdPartyNo()
    var
        ThirdParty: Record "Third Party";
    begin
        IF (COPYSTR("Last Third Party No.", STRLEN("Last Third Party No."), 1) < '0') OR
           (COPYSTR("Last Third Party No.", STRLEN("Last Third Party No."), 1) > '9')
        THEN
            ERROR(UnableToIncreaseIssue);
        IF ThirdParty.GET(INCSTR("Last Third Party No.")) THEN
            ERROR(STRSUBSTNO(NextThirdPartyAlreadyExists, INCSTR("Last Third Party No.")));
    end;
}
