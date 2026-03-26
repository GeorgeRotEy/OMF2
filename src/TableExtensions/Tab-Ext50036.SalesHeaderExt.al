tableextension 50036 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                Rec.VALIDATE("Control IRPF", Customer."Control IRPF");
                Rec.VALIDATE("Grupo registro IRPF", Customer."Grupo registro IRPF");
            end;
        }
        field(50000; "VAT Registration Noº"; Code[20])
        {
            Caption = 'VAT Registration Noº', Comment = 'ESP="Nº registro IVA"';
            FieldClass = FlowField;
            CalcFormula = lookup(
                Customer."VAT Registration No."
                where("No." = field("Bill-to Customer No."))
            );
        }
        field(50001; Email; Text[100])
        {
            Caption = 'Email', Comment = 'ESP="Email"';
            FieldClass = FlowField;
            CalcFormula = lookup(
                Customer."E-Mail"
                where("No." = field("Bill-to Customer No."))
            );
        }
        field(50002; "Bank of collection"; Code[50])
        {
            Caption = 'Bank of Collection', Comment = 'ESP="Banco de cobro"';

            trigger OnLookup()
            var
                locBankAccount: Record "Bank Account";
                locPageBankAccountList: Page "Bank Account List";
            begin
                locBankAccount.Reset();
                locPageBankAccountList.SetRecord(locBankAccount);
                locPageBankAccountList.SetTableView(locBankAccount);
                locPageBankAccountList.LookupMode(true);
                if locPageBankAccountList.RunModal() = Action::LookupOK then begin
                    locPageBankAccountList.GetRecord(locBankAccount);
                    "Bank of collection" := locBankAccount.IBAN;
                end;
            end;
        }
        field(50003; "User Name"; Code[50])
        {
            Caption = 'User Name', Comment = 'ESP="Nombre usuario"';
            Editable = false;
            TableRelation = "User"."User Name";
        }
        field(50004; "User Full Name"; Text[80])
        {
            Caption = 'User Full Name', Comment = 'ESP="Nombre completo usuario"';
            Editable = false;
            TableRelation = "User"."Full Name";
        }
        field(50100; "Control IRPF"; Option)
        {
            Caption = 'IRPF Control', Comment = 'ESP="Control IRPF"';
            OptionCaption = ' ,Obligatorio,Opcional';
            OptionMembers = " ",Obligatorio,Opcional;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);

                if "Control IRPF" = "Control IRPF"::" " then
                    Validate("Grupo registro IRPF", '');
            end;
        }
        field(50101; "Grupo registro IRPF"; Code[10])
        {
            Caption = 'IRPF Posting Group', Comment = 'ESP="Grupo registro IRPF"';
            TableRelation = if ("Control IRPF" = filter(<> ' '))
                                "Grupo registro retención"."Cód. grupo";

            trigger OnValidate()
            var
                CuGestionIRPF: Codeunit "Gestión IRPF";
            begin
                TestField(Status, Status::Open);

                if "Grupo registro IRPF" <> '' then
                    TestField("Control IRPF");

                CuGestionIRPF.ActualizarIRPFLinVenta("Document Type", "No.", "Grupo registro IRPF");
            end;
        }
        field(50200; "EDUCAMOS id_unique_recibo"; Text[50])
        {
            Caption = 'EDUCAMOS Unique Receipt ID', Comment = 'ESP="ID único recibo EDUCAMOS"';
        }
        field(50300; "Budg. Control Status"; Option)
        {
            Caption = 'Budget Control Status', Comment = 'ESP="Estado control ppto."';
            OptionCaption = ' ,Blocked,Unblocked';
            OptionMembers = " ",Blocked,Unblocked;
        }
    }

    keys
    {
        key(Key50000; "EDUCAMOS id_unique_recibo")
        { }
    }

    procedure fBloquearRegistro()
    begin
        rSalesLine2.SetRange("Document Type", "Document Type");
        rSalesLine2.SetRange("Document No.", "No.");
        if not rSalesLine2.FindFirst() then
            Error(Text080, "Document Type", "No.");
    end;

    var
        rSalesLine2: Record "Sales Line";
        Text080: Label 'Debe rellenar al menos una línea en %1 %2';
}
