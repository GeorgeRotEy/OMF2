tableextension 50015 "GL Account Ext" extends "G/L Account"
{
    fields
    {
        modify("No.")
        {
            trigger OnBeforeValidate()
            begin
                cFuncionesPLC.fControlTipoGestionPlan(vDesdeCorporativo);
            end;
        }
        modify(Name)
        {
            trigger OnBeforeValidate()
            begin
                cFuncionesPLC.fControlTipoGestionPlan(vDesdeCorporativo);
            end;
        }
        modify("Search Name")
        {
            trigger OnBeforeValidate()
            begin
                cFuncionesPLC.fControlTipoGestionPlan(vDesdeCorporativo);
            end;
        }
        modify("Account Type")
        {
            trigger OnBeforeValidate()
            var
                GLEntry: Record "G/L Entry";
                GLBudgetEntry: Record "G/L Budget Entry";
            begin
                cFuncionesPLC.fControlTipoGestionPlan(vDesdeCorporativo);
                case "Account Type" of
                    "Account Type"::Posting:
                        "API Account Type" := "API Account Type"::Posting;
                    "Account Type"::Heading:
                        "API Account Type" := "API Account Type"::Heading;
                    "Account Type"::Total:
                        "API Account Type" := "API Account Type"::Total;
                    "Account Type"::"Begin-Total":
                        "API Account Type" := "API Account Type"::"Begin-Total";
                    "Account Type"::"End-Total":
                        "API Account Type" := "API Account Type"::"End-Total";
                end;

                if ("Account Type" <> "Account Type"::Posting) and
                   (xRec."Account Type" = xRec."Account Type"::Posting)
                then begin
                    GLEntry.SETCURRENTKEY("G/L Account No.");
                    IF vEmpresa <> '' THEN
                        GLEntry.CHANGECOMPANY(vEmpresa);
                    GLEntry.SetRange("G/L Account No.", "No.");
                    if not GLEntry.IsEmpty() then
                        Error(
                          Text000Lbl,
                          FieldCaption("Account Type"));
                    IF vEmpresa <> '' THEN
                        GLBudgetEntry.CHANGECOMPANY(vEmpresa);
                    GLBudgetEntry.SetRange("G/L Account No.", "No.");
                    if not GLBudgetEntry.IsEmpty() then
                        Error(
                          Text001Lbl,
                          FieldCaption("Account Type"));
                end;
                Totaling := '';
                UpdateMyAccount(FieldNo(Totaling));
                if "Account Type" = "Account Type"::Posting then begin
                    if "Account Type" <> xRec."Account Type" then
                        "Direct Posting" := true;
                end else
                    "Direct Posting" := false;

                exit;
            end;
        }
        modify("Income/Balance")
        {
            trigger OnBeforeValidate()
            begin
                cFuncionesPLC.fControlTipoGestionPlan(vDesdeCorporativo);
            end;
        }
        modify("Debit/Credit")
        {
            trigger OnBeforeValidate()
            begin
                cFuncionesPLC.fControlTipoGestionPlan(vDesdeCorporativo);
            end;
        }
        modify(Blocked)
        {
            trigger OnBeforeValidate()
            begin
                TESTFIELD("Baja en Plan Corporativo", FALSE);
            end;
        }
        modify("Direct Posting")
        {
            trigger OnBeforeValidate()
            begin
                cFuncionesPLC.fControlTipoGestionPlan(vDesdeCorporativo);
            end;
        }
        field(50000; "Incluir en reparto analítico"; Boolean)
        {
            Caption = 'Include in Analytical Distribution', Comment = 'ESP="Incluir en reparto analítico"';
        }
        field(50001; "Importe Debe Analítico"; Decimal)
        {
            Caption = 'Analytical Debit Amount', Comment = 'ESP="Importe debe analítico"';
            FieldClass = FlowField;
            CalcFormula = sum(
                "Distribution Entry"."Debit amount"
                where(
                    "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                    "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                    "Posting date" = field("Date Filter"),
                    "Assignment Document No." = field("Filtro Reparto"),
                    "G/L Account" = field("No."),
                    "Source code" = field("Source Code Filter")
                )
            );
        }
        field(50002; "Importe Haber Analítico"; Decimal)
        {
            Caption = 'Analytical Credit Amount', Comment = 'ESP="Importe haber analítico"';
            FieldClass = FlowField;
            CalcFormula = sum(
                "Distribution Entry"."Credit amount"
                where(
                    "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                    "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                    "Posting date" = field("Date Filter"),
                    "Assignment Document No." = field("Filtro Reparto"),
                    "G/L Account" = field("No."),
                    "Source code" = field("Source Code Filter")
                )
            );
        }
        field(50003; "Filtro Actividad"; Code[10])
        {
            Caption = 'Activity Filter', Comment = 'ESP="Filtro actividad"';
            FieldClass = FlowFilter;
        }
        field(50004; "Filtro Reparto"; Code[10])
        {
            Caption = 'Distribution Filter', Comment = 'ESP="Filtro reparto"';
            FieldClass = FlowFilter;
        }
        field(50005; "Source Filter"; Code[20])
        {
            Caption = 'Source Filter', Comment = 'ESP="Filtro origen"';
            FieldClass = FlowFilter;
        }
        field(50006; "Source Code Filter"; Code[20])
        {
            Caption = 'Source Code Filter', Comment = 'ESP="Filtro cód. origen"';
            FieldClass = FlowFilter;
            TableRelation = "Source Code";
        }
        field(50007; "Balance at Date OFM"; Decimal)
        {
            Caption = 'Balance at Date', Comment = 'ESP="Saldo a fecha"';
            AutoFormatType = 1;
            CalcFormula = sum("G/L Entry".Amount where("G/L Account No." = field("No."),
                                                       "G/L Account No." = field(filter(Totaling)),
                                                       "Business Unit Code" = field("Business Unit Filter"),
                                                       "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                       "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                       "Posting Date" = field(upperlimit("Date Filter")),
                                                       "Source No." = field("Source Filter"),
                                                       "Source Code" = field("Source Code Filter"),
                                                       "VAT Reporting Date" = field(upperlimit("VAT Reporting Date Filter")),
                                                       "Dimension Set ID" = field("Dimension Set ID Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "Net Change OFM"; Decimal)
        {
            Caption = 'Net Change', Comment = 'ESP="Mov. neto"';
            AutoFormatType = 1;
            CalcFormula = sum("G/L Entry".Amount where("G/L Account No." = field("No."),
                                                       "G/L Account No." = field(filter(Totaling)),
                                                       "Business Unit Code" = field("Business Unit Filter"),
                                                       "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                       "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                       "Posting Date" = field("Date Filter"),
                                                       "Source No." = field("Source Filter"),
                                                       "Source Code" = field("Source Code Filter"),
                                                       "VAT Reporting Date" = field("VAT Reporting Date Filter"),
                                                       "Dimension Set ID" = field("Dimension Set ID Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "Balance OFM"; Decimal)
        {
            Caption = 'Balance', Comment = 'ESP="Saldo"';
            AutoFormatType = 1;
            CalcFormula = sum("G/L Entry".Amount where("G/L Account No." = field("No."),
                                                       "G/L Account No." = field(filter(Totaling)),
                                                       "Business Unit Code" = field("Business Unit Filter"),
                                                       "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                       "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                       "Source Code" = field("Source Code Filter"),
                                                       "Dimension Set ID" = field("Dimension Set ID Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Debit Amount OFM"; Decimal)
        {
            Caption = 'Debit Amount', Comment = 'ESP="Importe debe"';
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("G/L Entry"."Debit Amount" where("G/L Account No." = field("No."),
                                                               "G/L Account No." = field(filter(Totaling)),
                                                               "Business Unit Code" = field("Business Unit Filter"),
                                                               "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                               "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                               "Posting Date" = field("Date Filter"),
                                                               "Source No." = field("Source Filter"),
                                                               "Source Code" = field("Source Code Filter"),
                                                               "VAT Reporting Date" = field("VAT Reporting Date Filter"),
                                                               "Dimension Set ID" = field("Dimension Set ID Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Credit Amount OFM"; Decimal)
        {
            Caption = 'Credit Amount', Comment = 'ESP="Importe haber"';
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("G/L Entry"."Credit Amount" where("G/L Account No." = field("No."),
                                                                "G/L Account No." = field(filter(Totaling)),
                                                                "Business Unit Code" = field("Business Unit Filter"),
                                                                "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                "Posting Date" = field("Date Filter"),
                                                                "Source No." = field("Source Filter"),
                                                                "Source Code" = field("Source Code Filter"),
                                                                "VAT Reporting Date" = field("VAT Reporting Date Filter"),
                                                                "Dimension Set ID" = field("Dimension Set ID Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "Additional-Currency NC OFM"; Decimal)
        {
            Caption = 'Additional-Currency Net Change', Comment = 'ESP="Mov. neto divisa adicional"';
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            CalcFormula = sum("G/L Entry"."Additional-Currency Amount" where("G/L Account No." = field("No."),
                                                                             "G/L Account No." = field(filter(Totaling)),
                                                                             "Business Unit Code" = field("Business Unit Filter"),
                                                                             "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "VAT Reporting Date" = field("VAT Reporting Date Filter"),
                                                                             "Posting Date" = field("Date Filter"),
                                                                             "Source Code" = field("Source Code Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Add.-Currency BaD OFM"; Decimal)
        {
            Caption = 'Add.-Currency Balance at Date', Comment = 'ESP="Saldo a fecha divisa adicional"';
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            CalcFormula = sum("G/L Entry"."Additional-Currency Amount" where("G/L Account No." = field("No."),
                                                                             "G/L Account No." = field(filter(Totaling)),
                                                                             "Business Unit Code" = field("Business Unit Filter"),
                                                                             "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "VAT Reporting Date" = field(upperlimit("VAT Reporting Date Filter")),
                                                                             "Posting Date" = field(upperlimit("Date Filter")),
                                                                             "Source Code" = field("Source Code Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014; "Add.-Currency Balance OFM"; Decimal)
        {
            Caption = 'Additional-Currency Balance', Comment = 'ESP="Saldo divisa adicional"';
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            CalcFormula = sum("G/L Entry"."Additional-Currency Amount" where("G/L Account No." = field("No."),
                                                                             "G/L Account No." = field(filter(Totaling)),
                                                                             "Business Unit Code" = field("Business Unit Filter"),
                                                                             "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "Source Code" = field("Source Code Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015; "Add.-Currency Debit Amount OFM"; Decimal)
        {
            Caption = 'Add.-Currency Debit Amount', Comment = 'ESP="Importe debe divisa adicional"';
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            CalcFormula = sum("G/L Entry"."Add.-Currency Debit Amount" where("G/L Account No." = field("No."),
                                                                             "G/L Account No." = field(filter(Totaling)),
                                                                             "Business Unit Code" = field("Business Unit Filter"),
                                                                             "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "VAT Reporting Date" = field("VAT Reporting Date Filter"),
                                                                             "Posting Date" = field("Date Filter"),
                                                                             "Source Code" = field("Source Code Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50016; "Add.-Currency Cred. Amount OFM"; Decimal)
        {
            Caption = 'Add.-Currency Credit Amount', Comment = 'ESP="Importe haber divisa adicional"';
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            CalcFormula = sum("G/L Entry"."Add.-Currency Credit Amount" where("G/L Account No." = field("No."),
                                                                              "G/L Account No." = field(filter(Totaling)),
                                                                              "Business Unit Code" = field("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                              "VAT Reporting Date" = field("VAT Reporting Date Filter"),
                                                                              "Posting Date" = field("Date Filter"),
                                                                              "Source Code" = field("Source Code Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50050; "IC G/L Account No."; Code[20])
        {
            Caption = 'IC G/L Account No.', Comment = 'ESP="Nº cuenta IC"';
        }
        field(50085; "Cod retencion"; Code[20])
        {
            Caption = 'Withholding Code', Comment = 'ESP="Cód retención"';
            TableRelation = "Grupo registro retención"."Cód. grupo";
        }
        field(50300; "Budget Control Not Applied"; Boolean)
        {
            Caption = 'Budget Control Not Applied', Comment = 'ESP="Control presupuestario no aplicado"';
        }
        field(51000; "Baja en Plan Corporativo"; Boolean)
        {
            Caption = 'Deregister in Corporate Plan', Comment = 'ESP="Baja en plan corporativo"';
            Editable = false;
        }
    }

    trigger OnBeforeInsert()
    begin
        IF NOT vDesdeCorporativo then
            Error(Text002Lbl);

        cFuncionesPLC.fControlTipoGestionPlan(vDesdeCorporativo);

        DimMgt.UpdateDefaultDim(DATABASE::"G/L Account", "No.",
          "Global Dimension 1 Code", "Global Dimension 2 Code");

        IF NOT vDesdeCorporativo THEN
            IF CostAccSetup.GET THEN
                CostAccMgt.UpdateCostTypeFromGLAcc(Rec, xRec, 0);

        exit;
    end;

    trigger OnBeforeModify()
    begin
        "Last Date Modified" := TODAY;

        IF NOT vDesdeCorporativo THEN
            IF CostAccSetup.GET THEN
                CostAccMgt.UpdateCostTypeFromGLAcc(Rec, xRec, 1);

        exit;
    end;

    trigger OnBeforeRename()
    var
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
    begin
        SalesLine.RenameNo(SalesLine.Type::"G/L Account", xRec."No.", "No.");
        PurchaseLine.RenameNo(PurchaseLine.Type::"G/L Account", xRec."No.", "No.");
        cFuncionesPLC.fControlTipoGestionPlan(vDesdeCorporativo);
        "Last Date Modified" := TODAY;

        IF NOT vDesdeCorporativo THEN
            IF CostAccSetup.READPERMISSION THEN
                CostAccMgt.UpdateCostTypeFromGLAcc(Rec, xRec, 3);

        exit;
    end;

    var
        CostAccSetup: Record "Cost Accounting Setup";
        DimMgt: Codeunit DimensionManagement;
        CostAccMgt: Codeunit "Cost Account Mgt";
        cFuncionesPLC: Codeunit "Functions S2G";
        vEmpresa: Text[50];
        vDesdeCorporativo: Boolean;
        Text000Lbl: Label 'You cannot change %1 because there are one or more ledger entries associated with this account.', Comment = 'ESP="No puede cambiar %1 porque hay uno o más movimientos asociados a esta cuenta"';
        Text001Lbl: Label 'You cannot change %1 because this account is part of one or more budgets.', Comment = 'ESP="No puede cambiar %1 porque esta cuenta es parte de uno o más presupuestos"';
        Text002Lbl: Label 'G/L accounts can only be created from the Corporate Chart of Accounts and brought into the company chart of accounts using the Bring Corporate Accounts function.', Comment = 'ESP="Las cuentas contables solo se pueden crear desde el Plan de Cuentas Corporativo y traer al plan de cuentas de la empresa con la funcion Traer cuentas corporativas."';

    procedure fCambiarCompañia(pEmpresa: Text[50])
    begin
        vEmpresa := pEmpresa;
        ChangeCompany(pEmpresa);
    end;

    procedure fDesdeCuentaCorporativa(pDesdeCorporativo: Boolean)
    begin
        vDesdeCorporativo := pDesdeCorporativo;
    end;

    local procedure UpdateMyAccount(CallingFieldNo: Integer)
    var
        MyAccount: Record "My Account";
    begin
        case CallingFieldNo of
            FieldNo(Name):
                begin
                    MyAccount.SetRange("Account No.", "No.");
                    if not MyAccount.IsEmpty() then
                        MyAccount.ModifyAll(Name, Name);
                end;
            FieldNo(Totaling):
                begin
                    MyAccount.SetRange("Account No.", "No.");
                    if not MyAccount.IsEmpty() then
                        MyAccount.ModifyAll(Totaling, Totaling);
                end;
        end;
    end;
}
