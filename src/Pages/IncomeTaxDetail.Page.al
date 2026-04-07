page 50077 "Income Tax Detail"
{
    // // Mod. S2G 19/10/2016 (CSM) : GF-010 Retenciones. IRPF.

    Caption = 'Income Tax Detail', Comment = 'ESP="IRPF Desglose"';
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Movs. retenciones";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters', Comment = 'ESP="Filtros"';

                field(DateFilter; DateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Dete Filter', Comment = 'ESP="Filtro fecha"';
                    trigger OnValidate()
                    begin
                        if DateFilter <> '' then begin
                            RetentEntry.SetFilter("Fecha registro", DateFilter);
                            DateFilter := RetentEntry.GetFilter("Fecha registro");
                        end;
                        FillInTable;
                        if Rec.FindFirst() then;

                        CurrPage.Update(false);
                    end;
                }
                field("<GLAccFilter>"; GLAccFilter)
                {
                    ApplicationArea = All;
                    Caption = 'GLA FIlter', Comment = 'ESP="Filtro Cuenta"';
                    trigger OnValidate()
                    begin
                        FillInTable;
                        if Rec.FindFirst() then;
                        CurrPage.Update(false);
                    end;
                }
                field(TypeFilter; TypeFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Type', Comment = 'ESP="Tipo"';
                    trigger OnValidate()
                    begin
                        FillInTable;
                        if Rec.FindFirst() then;
                        CurrPage.Update(false);
                    end;
                }
                field(CodeFilter; CodeFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Code Filter', Comment = 'ESP="Filtro Cód. retención"';
                    TableRelation = "Grupo registro retención";

                    trigger OnValidate()
                    begin
                        FillInTable;
                        if Rec.FindFirst() then;
                        CurrPage.Update(false);
                    end;
                }
                field(TypeRetFilter; TypeRetFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Tipo Filter', Comment = 'ESP="Filtro tipo retención"';
                    trigger OnValidate()
                    begin
                        FillInTable;
                        if Rec.FindFirst() then;
                        CurrPage.Update(false);
                    end;
                }
            }

            group(Group)
            {
                Caption = 'Options', Comment = 'ESP="Opciones"';

                field(TipoMov; Selection)
                {
                    ApplicationArea = All;
                    Caption = 'Include VAT entries', Comment = 'ESP="Incluir movimientos IVA"';
                    OptionCaption = 'Open,Closed,Open and Closed';
                    Style = StandardAccent;
                    StyleExpr = true;

                    trigger OnValidate()
                    begin
                        FillInTable;
                        if Rec.FindFirst() then;
                        CurrPage.Update(false);
                    end;
                }
            }

            repeater(repeater)
            {
                Editable = false;

                field("Grupo registro retención"; Rec."Grupo registro retención")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Nº documento"; Rec."Nº documento")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Nº documento externo"; Rec."Nº documento externo")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Fecha registro"; Rec."Fecha registro")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field(Base; Rec.Base)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("% retención"; Rec."% retención")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field(Importe; Rec.Importe)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Cuenta retención"; Rec."Cuenta retención")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Tipo documento"; Rec."Tipo documento")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field(Declarado; Rec.Declarado)
                {
                    ApplicationArea = All;
                    Caption = 'Declared', Comment = 'ESP="Declarado"';
                }
                field("Importe IRPF liberado Total"; Rec."Importe IRPF liberado Total")
                {
                    ApplicationArea = All;
                    Caption = 'Declared Income Tax Amount', Comment = 'ESP="Importe IRPF declarado"';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = vTotalLine;

                    trigger OnDrillDown()
                    var
                        rlGLEntry: Record "G/L Entry";
                    begin
                        if not vTotalLine then begin
                            rlGLEntry.Reset();
                            rlGLEntry.SetCurrentKey("Movimiento IRPF liquidado");
                            rlGLEntry.FilterGroup(3);
                            rlGLEntry.SetRange("Movimiento IRPF liquidado", Rec."No. mov. original");
                            rlGLEntry.FilterGroup(0);
                            Page.RunModal(0, rlGLEntry);
                        end;
                    end;
                }
                field("No. mov. contabilidad"; Rec."No. mov. contabilidad")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Nº mov."; Rec."Nº mov.")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Clave IRPF"; Rec."Clave IRPF")
                {
                    ApplicationArea = All;
                }
                field("Subclave IRPF"; Rec."Subclave IRPF")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            group(ProcessPromoted)
            {
                Caption = 'Process', Comment = 'ESP="Proceso"';

                actionref(PostPromoted; Post)
                {
                }
                actionref(UnPostPromoted; UnPost)
                {
                }
            }
        }

        area(processing)
        {
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post', Comment = 'ESP="Registrar"';
                Image = Post;

                trigger OnAction()
                var
                    rpLiqIRPF: Report "Liquidación IRPF_2";
                    Textl50000: Label '¿Confirma que desea registrar la Liquidación para las líneas actuales?';
                    Textl50001: Label 'Proceso cancelado por el usuario.';
                    bProcess: Boolean;
                begin
                    if Confirm(Textl50000) then begin
                        fTestSetupRetention;

                        Clear(rpLiqIRPF);
                        CurrPage.SetSelectionFilter(Rec);
                        rpLiqIRPF.fSetRecord(Rec);
                        rpLiqIRPF.RunModal;
                        bProcess := rpLiqIRPF.fGetProcess;
                        Rec.Reset();
                        if bProcess then
                            CurrPage.Close();
                    end else
                        Message(Textl50001);
                end;
            }

            action(UnPost)
            {
                ApplicationArea = All;
                Caption = 'UnPost', Comment = 'ESP="Desregistrar"';
                Image = UnApply;

                trigger OnAction()
                var
                    rpLiqIRPF: Report "DesLiquidación IRPF_2";
                    Textl50001: Label 'Proceso cancelado por el usuario.';
                    bProcess: Boolean;
                    Textl50002: Label '¿Confirma que desea Desliquidar las líneas actuales?';
                begin
                    if Confirm(Textl50002) then begin
                        fTestSetupRetention;

                        Clear(rpLiqIRPF);
                        CurrPage.SetSelectionFilter(Rec);
                        rpLiqIRPF.fSetRecord(Rec);
                        rpLiqIRPF.RunModal;
                        bProcess := rpLiqIRPF.fGetProcess;
                        Rec.Reset();
                        if bProcess then
                            CurrPage.Close();
                    end else
                        Message(Textl50001);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        vTotalLine := StrPos(Rec."Grupo registro retención", 'TOTAL') <> 0;
    end;

    trigger OnOpenPage()
    begin
        BackfillRetentionLedgerLinks();
        FillInTable;
        IF NOt Rec.FindFirst() then
            ShowNoDataDiagnostics();
    end;

    var
        RetentEntry: Record "Movs. retenciones";
        DateFilter: Text[1024];
        GLAccFilter: Text[1024];
        CodeFilter: Text[1024];
        vTotalLine: Boolean;
        Selection: Option Open,Closed,"Open and Closed";
        TypeFilter: Option Compras,Ventas;
        TypeRetFilter: Option " ",Profesionales,Alquiler,"No residente",Intereses;

    procedure FillInTable()
    var
        RetentionLedgEntry: Record "Movs. retenciones";
        LastCode: Code[20];
        TotalBase: Decimal;
        TotalCuota: Decimal;
        CodeTotalBase: Decimal;
        CodeTotalCuota: Decimal;
        EntryNo: Integer;
        TotalLiq: Decimal;
        CodeTotalLiq: Decimal;
    begin
        Rec.Reset();
        Rec.DeleteAll();

        TotalBase := 0;
        TotalCuota := 0;
        TotalLiq := 0;

        CodeTotalBase := 0;
        CodeTotalCuota := 0;
        CodeTotalLiq := 0;

        EntryNo := 0;
        LastCode := '';
        RetentionLedgEntry.Reset();
        RetentionLedgEntry.SetCurrentKey(Tipo, "Tipo retención", "Cod. origen", "Grupo registro retención", "Fecha registro");

        //RetentionLedgEntry.SetFilter("No. mov. contabilidad", '<>%1', 0);
        //RetentionLedgEntry.SetFilter(Tipo, '%1', TypeFilter);
        case TypeFilter of
            TypeFilter::Compras:
                RetentionLedgEntry.SetRange(Tipo, RetentionLedgEntry.Tipo::Compra);
            TypeFilter::Ventas:
                RetentionLedgEntry.SetRange(Tipo, RetentionLedgEntry.Tipo::Venta);
        End;

        if CodeFilter <> '' then
            RetentionLedgEntry.SetFilter("Grupo registro retención", CodeFilter);

        if DateFilter <> '' then
            RetentionLedgEntry.SetFilter("Fecha registro", DateFilter);

        if GLAccFilter <> '' then
            RetentionLedgEntry.SetFilter("Cuenta retención", GLAccFilter);

        if TypeRetFilter = 0 then
            RetentionLedgEntry.SetRange(RetentionLedgEntry."Tipo retención")
        else
            RetentionLedgEntry.SetFilter(RetentionLedgEntry."Tipo retención", '%1', TypeRetFilter);

        if Selection = Selection::Closed then
            RetentionLedgEntry.SetRange(RetentionLedgEntry.Declarado, true);
        if Selection = Selection::Open then
            RetentionLedgEntry.SetRange(RetentionLedgEntry.Declarado, false);

        if RetentionLedgEntry.FindSet() then
            repeat
                if (LastCode <> '') and (LastCode <> RetentionLedgEntry."Grupo registro retención") then begin
                    EntryNo := EntryNo + 1;
                    Rec.Init();
                    Rec."Nº mov." := EntryNo;
                    Rec."Tipo retención" := RetentionLedgEntry."Tipo retención";
                    Rec."Grupo registro retención" := 'TOTAL' + ' ' + LastCode;
                    Rec.Base := CodeTotalBase;
                    Rec.Importe := CodeTotalCuota;
                    Rec."Importe IRPF liberado Total" := -CodeTotalLiq;
                    Rec."Tipo documento" := Rec."Tipo documento"::SubTotal;
                    Rec.Insert();
                    CodeTotalBase := 0;
                    CodeTotalCuota := 0;
                    CodeTotalLiq := 0;
                end;

                EntryNo := EntryNo + 1;
                Rec.Init();
                Rec := RetentionLedgEntry;
                Rec."Nº mov." := EntryNo;
                Rec."No. mov. original" := RetentionLedgEntry."Nº mov.";
                RetentionLedgEntry.CalcFields(RetentionLedgEntry."Importe IRPF liberado");
                Rec."Importe IRPF liberado Total" := RetentionLedgEntry."Importe IRPF liberado";

                Rec.Insert();
                CodeTotalBase := CodeTotalBase + RetentionLedgEntry.Base;
                CodeTotalCuota := CodeTotalCuota + RetentionLedgEntry.Importe;
                CodeTotalLiq := CodeTotalLiq + RetentionLedgEntry."Importe IRPF liberado";
                TotalBase := TotalBase + RetentionLedgEntry.Base;
                TotalCuota := TotalCuota + RetentionLedgEntry.Importe;
                TotalLiq := TotalLiq + RetentionLedgEntry."Importe IRPF liberado";
                LastCode := RetentionLedgEntry."Grupo registro retención";
            until RetentionLedgEntry.Next() = 0;

        if RetentionLedgEntry.Count <> 0 then begin
            EntryNo := EntryNo + 1;
            Rec.Init();
            Rec."Nº mov." := EntryNo;
            Rec."Tipo retención" := RetentionLedgEntry."Tipo retención";
            Rec."Grupo registro retención" := 'TOTAL' + ' ' + RetentionLedgEntry."Grupo registro retención";
            Rec.Base := CodeTotalBase;
            Rec.Importe := CodeTotalCuota;
            Rec."Importe IRPF liberado Total" := -CodeTotalLiq;
            Rec."Tipo documento" := Rec."Tipo documento"::SubTotal;
            Rec.Insert();

            EntryNo := EntryNo + 1;
            Rec.Init();
            Rec."Nº mov." := EntryNo;
            Rec."Tipo retención" := RetentionLedgEntry."Tipo retención";
            Rec."Grupo registro retención" := 'TOTAL';
            Rec.Base := TotalBase;
            Rec.Importe := TotalCuota;
            Rec."Importe IRPF liberado Total" := -TotalLiq;
            Rec."Tipo documento" := Rec."Tipo documento"::Total;
            Rec.Insert();
        end;

        CurrPage.Update(false);
    end;


    local procedure BackfillRetentionLedgerLinks()
    var
        RetentionLedgEntry: Record "Movs. retenciones";
        GLEntry: Record "G/L Entry";
    begin
        RetentionLedgEntry.RESET();
        RetentionLedgEntry.SETRANGE("No. mov. contabilidad", 0);
        IF RetentionLedgEntry.FINDSET() THEN
            REPEAT
                GLEntry.RESET();
                GLEntry.SETRANGE("No. mov. retención", RetentionLedgEntry."Nº mov.");
                IF GLEntry.FINDFIRST() THEN BEGIN
                    RetentionLedgEntry."No. mov. contabilidad" := GLEntry."Entry No.";
                    RetentionLedgEntry."Dimension Set ID" := GLEntry."Dimension Set ID";
                    RetentionLedgEntry.MODIFY();
                END;
            UNTIL RetentionLedgEntry.NEXT() = 0;
    end;

    local procedure ShowNoDataDiagnostics()
    var
        RetentionLedgEntry: Record "Movs. retenciones";
        TotalCount: Integer;
        LinkedCount: Integer;
        PurchaseLinkedCount: Integer;
        PurchaseOpenCount: Integer;
        PurchaseClosedCount: Integer;
        SalesLinkedCount: Integer;
        SalesOpenCount: Integer;
        SalesClosedCount: Integer;
        EmptyMsg: Label 'La página no ha encontrado líneas. Total : %1. Con Nº mov. contabilidad: %2. Compras enlazadas: %3. Compras abiertas: %4. Compras cerradas: %5. Ventas enlazadas: %6. Ventas abiertas: %7. Ventas cerradas: %8.';
    begin
        RetentionLedgEntry.RESET();
        TotalCount := RetentionLedgEntry.COUNT();

        RetentionLedgEntry.RESET();
        RetentionLedgEntry.SETFILTER("No. mov. contabilidad", '<>%1', 0);
        LinkedCount := RetentionLedgEntry.COUNT();

        RetentionLedgEntry.RESET();
        RetentionLedgEntry.SETFILTER("No. mov. contabilidad", '<>%1', 0);
        RetentionLedgEntry.SETRANGE(Tipo, RetentionLedgEntry.Tipo::Compra);
        PurchaseLinkedCount := RetentionLedgEntry.COUNT();

        RetentionLedgEntry.RESET();
        RetentionLedgEntry.SETFILTER("No. mov. contabilidad", '<>%1', 0);
        RetentionLedgEntry.SETRANGE(Tipo, RetentionLedgEntry.Tipo::Compra);
        RetentionLedgEntry.SETRANGE(Declarado, FALSE);
        PurchaseOpenCount := RetentionLedgEntry.COUNT();

        RetentionLedgEntry.RESET();
        RetentionLedgEntry.SETFILTER("No. mov. contabilidad", '<>%1', 0);
        RetentionLedgEntry.SETRANGE(Tipo, RetentionLedgEntry.Tipo::Compra);
        RetentionLedgEntry.SETRANGE(Declarado, TRUE);
        PurchaseClosedCount := RetentionLedgEntry.COUNT();

        RetentionLedgEntry.RESET();
        RetentionLedgEntry.SETFILTER("No. mov. contabilidad", '<>%1', 0);
        RetentionLedgEntry.SETRANGE(Tipo, RetentionLedgEntry.Tipo::Venta);
        SalesLinkedCount := RetentionLedgEntry.COUNT();

        RetentionLedgEntry.RESET();
        RetentionLedgEntry.SETFILTER("No. mov. contabilidad", '<>%1', 0);
        RetentionLedgEntry.SETRANGE(Tipo, RetentionLedgEntry.Tipo::Venta);
        RetentionLedgEntry.SETRANGE(Declarado, FALSE);
        SalesOpenCount := RetentionLedgEntry.COUNT();

        RetentionLedgEntry.RESET();
        RetentionLedgEntry.SETFILTER("No. mov. contabilidad", '<>%1', 0);
        RetentionLedgEntry.SETRANGE(Tipo, RetentionLedgEntry.Tipo::Venta);
        RetentionLedgEntry.SETRANGE(Declarado, TRUE);
        SalesClosedCount := RetentionLedgEntry.COUNT();

        MESSAGE(
         EmptyMsg,
         TotalCount,
         LinkedCount,
         PurchaseLinkedCount,
         PurchaseOpenCount,
         PurchaseClosedCount,
         SalesLinkedCount,
         SalesOpenCount,
         SalesClosedCount);
    end;


    procedure fTestSetupRetention()
    var
        rlPurchSetup: Record "Purchases & Payables Setup";
        rlSourceCodeSetup: Record "Source Code Setup";
    begin
        rlPurchSetup.Reset();
        rlPurchSetup.Get();

        rlPurchSetup.TestField(rlPurchSetup."Retention Jnl. Template");
        rlPurchSetup.TestField(rlPurchSetup."Retention Jnl. Batch");
        rlPurchSetup.TestField(rlPurchSetup."Número serie Liquidación IRPF");

        rlSourceCodeSetup.Reset();
        rlSourceCodeSetup.Get();
        rlSourceCodeSetup.TestField("Retention Application");
    end;

}