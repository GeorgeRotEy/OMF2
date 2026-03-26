table 50007 "Plan Corporativo"
{
    // // Mod. S2G 16/12/2017 (JGS) : GF001 ã Plan de cuentas corporativo.
    // // Mod. S2G 31/01/2018 (JGS) : Permisos de usuario.

    Caption = 'Corporate Plan', Comment = 'ESP="Plan corporativo"';
    DataPerCompany = false;
    // LookupPageID = 50040;

    fields
    {
        field(1; "No."; Text[20])
        {
            Caption = 'No.', Comment = 'ESP="Número"';
            NotBlank = true;
            Numeric = true;

            trigger OnValidate()
            var
                TestNo: Integer;
            begin
                IF (xRec."No." <> '') THEN
                    IF (STRLEN("No.") > 5) <> (STRLEN(xRec."No.") > 5) THEN
                        ERROR(Text1100001,
                          FIELDNAME("Account Type"));
                EVALUATE(TestNo, COPYSTR("No.", 1, 1));
                IF TestNo IN [6 .. 7] THEN
                    "Income/Balance" := "Income/Balance"::"Income Statement"
                ELSE
                    IF TestNo IN [8 .. 9] THEN
                        "Income/Balance" := "Income/Balance"::Capital
                    ELSE
                        "Income/Balance" := "Income/Balance"::"Balance Sheet";
                CASE TestNo OF
                    6:
                        "Gen. Posting Type" := "Gen. Posting Type"::Purchase;
                    7:
                        "Gen. Posting Type" := "Gen. Posting Type"::Sale;
                    ELSE
                        "Gen. Posting Type" := 0;
                END;
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';

            trigger OnValidate()
            begin
                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
                    "Search Name" := Name;
            end;
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name', Comment = 'ESP="Nombre de búsqueda"';
        }
        field(4; "Account Type"; Option)
        {
            Caption = 'Account Type', Comment = 'ESP="Tipo de cuenta"';
            OptionCaption = 'Posting,Heading', Comment = 'ESP="Movimiento,Encabezado"';
            OptionMembers = Posting,Heading;

            trigger OnValidate()
            var
                GLEntry: Record "G/L Entry";
                GLBudgetEntry: Record "G/L Budget Entry";
            begin
                Totaling := '';
                IF "Account Type" = "Account Type"::Posting THEN BEGIN
                    IF "Account Type" <> xRec."Account Type" THEN
                        "Direct Posting" := TRUE;
                END ELSE
                    "Direct Posting" := FALSE;
            end;
        }
        field(9; "Income/Balance"; Option)
        {
            Caption = 'Income/Balance', Comment = 'ESP="Comercial / Balance"';
            OptionCaption = 'Income Statement,Balance Sheet,Capital', Comment = 'ESP="Pérdidas y ganancias,Balance,Capital"';
            OptionMembers = "Income Statement","Balance Sheet",Capital;
        }
        field(10; "Debit/Credit"; Option)
        {
            Caption = 'Debit/Credit', Comment = 'ESP="Debe / Haber"';
            OptionCaption = 'Both,Debit,Credit', Comment = 'ESP="Ambos,Debe,Haber"';
            OptionMembers = Both,Debit,Credit;
        }
        field(14; "Direct Posting"; Boolean)
        {
            Caption = 'Direct Posting', Comment = 'ESP="Entrada directa"';
            InitValue = true;
        }
        field(19; Indentation; Integer)
        {
            Caption = 'Indentation', Comment = 'ESP="Indentación"';
            MinValue = 0;
        }
        field(34; Totaling; Text[250])
        {
            Caption = 'Totaling', Comment = 'ESP="Sumatorio"';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(40; "Consol. Debit Acc."; Code[20])
        {
            Caption = 'Consol. Debit Acc.', Comment = 'ESP="Cuenta de consolidación debe"';

            trigger OnValidate()
            var
                ConflictGLAcc: Record "G/L Account";
            begin
            end;
        }
        field(41; "Consol. Credit Acc."; Code[20])
        {
            Caption = 'Consol. Credit Acc.', Comment = 'ESP="Cuenta de consolidación haber"';

            trigger OnValidate()
            var
                ConflictGLAcc: Record "G/L Account";
            begin
            end;
        }
        field(43; "Gen. Posting Type"; Option)
        {
            Caption = 'Gen. Posting Type', Comment = 'ESP="Tipo registro gen."';
            OptionCaption = ' ,Purchase,Sale', Comment = 'ESP=" ,Compra,Venta"';
            OptionMembers = " ",Purchase,Sale;
        }
        field(10700; "Income Stmt. Bal. Acc."; Code[20])
        {
            Caption = 'Income Stmt. Bal. Acc.', Comment = 'ESP="Cuenta regularización (PyG/Balance)"';
            TableRelation = "Plan Corporativo"."No.";
        }
        field(51000; "Baja en Plan Corporativo"; Boolean)
        {
            Caption = 'Deregister in Corporate Plan', Comment = 'ESP="Baja en plan corporativo"';

            trigger OnValidate()
            begin
                fModificarBajaPlanCorporativo();
            end;
        }
        field(51004; "Descripción amplia"; Text[100])
        {
            Caption = 'Extended Description', Comment = 'ESP="Descripción amplia"';

            trigger OnValidate()
            begin
                //VALIDATE(Name,COPYSTR("Descripción amplia",1,MAXSTRLEN(Name)));
            end;
        }
        field(3010551; "Cost Type No."; Text[20])
        {
            Caption = 'Cost Type No.', Comment = 'ESP="Nº tipo de coste"';
            Editable = true;
            TableRelation = "Cost Type";
            ValidateTableRelation = false;
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

    trigger OnDelete()
    begin
        // Mod. S2G 31/01/2018 (JGS) : Permisos de usuario.
        IF rUserSetup.GET(USERID) THEN BEGIN
            IF NOT rUserSetup."Advance Chart" THEN BEGIN
                ERROR('No tiene autorización para crear cuentas contables.');
            END;
        END;
        // Mod. S2G 31/01/2018 (JGS) : Permisos de usuario.
        fEliminarCuentaCorporativa();
    end;

    trigger OnInsert()
    begin
        // Mod. S2G 31/01/2018 (JGS) : Permisos de usuario.
        IF rUserSetup.GET(USERID) THEN BEGIN
            IF NOT rUserSetup."Advance Chart" THEN BEGIN
                ERROR('No tiene autorización para crear cuentas contables.');
            END;
        END;
        // Mod. S2G 31/01/2018 (JGS) : Permisos de usuario.
    end;

    trigger OnModify()
    begin
        // Mod. S2G 31/01/2018 (JGS) : Permisos de usuario.
        IF rUserSetup.GET(USERID) THEN BEGIN
            IF NOT rUserSetup."Advance Chart" THEN BEGIN
                ERROR('No tiene autorización para crear cuentas contables.');
            END;
        END;
        // Mod. S2G 31/01/2018 (JGS) : Permisos de usuario.
        fControlModificación();
    end;

    trigger OnRename()
    begin
        ERROR(Text50007, TABLECAPTION);
    end;

    var
        Text000: Label 'You cannot change %1 because there are one or more ledger entries associated with this account.';
        Text001: Label 'You cannot change %1 because this account is part of one or more budgets.';
        Text1100001: Label 'The length of the new value is not acceptable, as it implies a change in %1.';
        Text50000: Label 'Do you want to create the account in all companies which follow the Corporate Accounts Plan?';
        Text50001: Label 'The account %1 has been correctly created at company %2.';
        Text50002: Label 'The field "Baja en Plan Corporativo" has been completed correctly with the value %1 in accounts plan of company %2';
        Text50003: Label 'The account %1 has not been deleted at company %2.';
        Text50004: Label 'The account %1 has been deleted correctly.';
        Text50005: Label 'The account %1 it has been modified correctly at company %2';
        Text50006: Label 'Has been modified the value of the field <%1> to <%2> at the account <%3>.\Do you want update it in all companies which follow the Corporate Accounts Plan?';
        Text50007: Label 'Cannot be renamed the registries of the table %1';
        rLicensePermission: Record "License Permission";
        rCostAccountingSetup: Record "Cost Accounting Setup";
        cCostAccountMgt: Codeunit "Cost Account Mgt";
        rUserSetup: Record "User Setup";

    procedure SetupNewGLAcc(OldGLAcc: Record "Plan Corporativo"; BelowOldGLAcc: Boolean)
    var
        OldGLAcc2: Record "Plan Corporativo";
    begin
        IF NOT BelowOldGLAcc THEN BEGIN
            OldGLAcc2 := OldGLAcc;
            OldGLAcc.COPY(Rec);
            OldGLAcc := OldGLAcc2;
            IF NOT OldGLAcc.FIND('<') THEN
                OldGLAcc.INIT;
        END;
        "Income/Balance" := OldGLAcc."Income/Balance";
    end;

    procedure "*******Funciones*******"()
    begin
    end;

    procedure "fControlModificación"()
    var
        vlModificarEntradaDirecta: Boolean;
        vlModificarCtaConsolDebe: Boolean;
        vlModificarCtaConsolHaber: Boolean;
    begin
        vlModificarEntradaDirecta := FALSE;
        vlModificarCtaConsolDebe := FALSE;
        vlModificarCtaConsolHaber := FALSE;

        IF ("Direct Posting" <> xRec."Direct Posting") THEN
            IF CONFIRM(Text50006, TRUE, FIELDCAPTION("Direct Posting"), "Direct Posting", "No.") THEN
                vlModificarEntradaDirecta := TRUE;

        IF ("Consol. Debit Acc." <> xRec."Consol. Debit Acc.") THEN
            IF CONFIRM(Text50006, TRUE, FIELDCAPTION("Consol. Debit Acc."), "Consol. Debit Acc.", "No.") THEN
                vlModificarCtaConsolDebe := TRUE;

        IF ("Consol. Credit Acc." <> xRec."Consol. Credit Acc.") THEN
            IF CONFIRM(Text50006, TRUE, FIELDCAPTION("Consol. Credit Acc."), "Consol. Credit Acc.", "No.") THEN
                vlModificarCtaConsolHaber := TRUE;
    end;

    procedure fModificarBajaPlanCorporativo()
    var
        rlCompany: Record Company;
        rlGeneralLedgerSetup: Record "General Ledger Setup";
        rlGLAccount: Record "G/L Account";
        vlContador: Integer;
    begin
        vlContador := 0;
        CLEAR(rlCompany);
        IF rlCompany.FIND('-') THEN
            REPEAT
                CLEAR(rlGeneralLedgerSetup);
                rlGeneralLedgerSetup.CHANGECOMPANY(rlCompany.Name);
                rlGeneralLedgerSetup.GET();
                IF rlGeneralLedgerSetup."Tipo gestión plan de cuentas" =
                   rlGeneralLedgerSetup."Tipo gestión plan de cuentas"::Corporativo THEN BEGIN
                    CLEAR(rlGLAccount);
                    //rlGLAccount.fCambiarCompañía(rlCompany.Name);
                    IF rlGLAccount.GET("No.") THEN BEGIN
                        IF "Baja en Plan Corporativo" THEN
                            rlGLAccount.Blocked := TRUE;
                        rlGLAccount."Baja en Plan Corporativo" := "Baja en Plan Corporativo";
                        rlGLAccount.MODIFY;
                        vlContador += 1;
                    END;
                END;
            UNTIL rlCompany.NEXT = 0;
        MESSAGE(Text50002, "Baja en Plan Corporativo", vlContador);
    end;

    procedure fEliminarCuentaCorporativa()
    var
        rlCompany: Record Company;
        rlGeneralLedgerSetup: Record "General Ledger Setup";
        rlGLAccount: Record "G/L Account";
    begin
        TESTFIELD("Baja en Plan Corporativo");
        CLEAR(rlCompany);
        IF rlCompany.FIND('-') THEN
            REPEAT
                CLEAR(rlGeneralLedgerSetup);
                rlGeneralLedgerSetup.CHANGECOMPANY(rlCompany.Name);
                rlGeneralLedgerSetup.GET();
                IF rlGeneralLedgerSetup."Tipo gestión plan de cuentas" =
                   rlGeneralLedgerSetup."Tipo gestión plan de cuentas"::Corporativo THEN BEGIN
                    CLEAR(rlGLAccount);
                    //rlGLAccount.fCambiarCompañía(rlCompany.Name);
                    IF rlGLAccount.GET("No.") THEN
                        ERROR(Text50003, "No.", rlCompany.Name);
                END;
            UNTIL rlCompany.NEXT = 0;
        MESSAGE(Text50004, "No.");
    end;
}
