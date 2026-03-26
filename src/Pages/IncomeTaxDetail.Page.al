page 50077 "Income Tax Detail"
{
    // // Mod. S2G 19/10/2016 (CSM) : GF-010 Retenciones. IRPF.

    Caption = 'Income Tax Detail', Comment = 'ESP="Detalle impuesto sobre la renta"';
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
                    trigger OnValidate()
                    begin
                        IF DateFilter <> '' THEN BEGIN
                            RetentEntry.SETFILTER("Fecha registro", DateFilter);
                            DateFilter := RetentEntry.GETFILTER("Fecha registro");
                        END;
                        FillInTable;
                        IF Rec.FINDFIRST() THEN;

                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field("<GLAccFilter>"; GLAccFilter)
                {
                    trigger OnValidate()
                    begin
                        FillInTable;
                        IF Rec.FINDFIRST() THEN;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field(TypeFilter; TypeFilter)
                {
                    trigger OnValidate()
                    begin
                        FillInTable;
                        IF Rec.FINDFIRST() THEN;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field(CodeFilter; CodeFilter)
                {
                    TableRelation = "Grupo registro retención";

                    trigger OnValidate()
                    begin
                        FillInTable;
                        IF Rec.FINDFIRST() THEN;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field(TypeRetFilter; TypeRetFilter)
                {
                    trigger OnValidate()
                    begin
                        FillInTable;
                        IF Rec.FINDFIRST() THEN;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
            group(Group)
            {
                field(TipoMov; Selection)
                {
                    Caption = 'Include VAT entries';
                    OptionCaption = 'Open,Closed,Open and Closed';
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin

                        FillInTable;
                        IF Rec.FINDFIRST() THEN;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
            repeater(repeater)
            {
                Editable = false;
                field("Grupo registro retención"; Rec."Grupo registro retención")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Nº documento"; Rec."Nº documento")
                {
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Nº documento externo"; Rec."Nº documento externo")
                {
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Fecha registro"; Rec."Fecha registro")
                {
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field(Base; Rec.Base)
                {
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("% retención"; Rec."% retención")
                {
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field(Importe; Rec.Importe)
                {
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Cuenta retención"; Rec."Cuenta retención")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Tipo documento"; Rec."Tipo documento")
                {
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field(Declarado; Rec.Declarado)
                {
                    Caption = 'Declarado';
                }
                field("Importe IRPF liberado Total"; Rec."Importe IRPF liberado Total")
                {
                    Caption = 'Importe IRPF declarado';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = vTotalLine;

                    trigger OnDrillDown()
                    var
                        rlGLEntry: Record "G/L Entry";
                    begin

                        //IF (STRPOS(Código,'TOTAL') = 0) THEN BEGIN
                        IF NOT vTotalLine THEN BEGIN
                            rlGLEntry.RESET();
                            rlGLEntry.SETCURRENTKEY("Movimiento IRPF liquidado");
                            rlGLEntry.FILTERGROUP(3);
                            rlGLEntry.SETRANGE("Movimiento IRPF liquidado", Rec."No. mov. original");
                            rlGLEntry.FILTERGROUP(0);
                            PAGE.RUNMODAL(0, rlGLEntry);
                        END;
                    end;
                }
                field("No. mov. contabilidad"; Rec."No. mov. contabilidad")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Nº mov."; Rec."Nº mov.")
                {
                    Style = Strong;
                    StyleExpr = vTotalLine;
                }
                field("Clave IRPF"; Rec."Clave IRPF")
                {
                }
                field("Subclave IRPF"; Rec."Subclave IRPF")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Caption = 'Post', Comment = 'ESP="Registrar"';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    rpLiqIRPF: Report "Liquidación IRPF_2";
                    Textl50000: Label '¿Confirma que desea registrar la Liquidación para las líneas actuales?';
                    Textl50001: Label 'Proceso cancelado por el usuario.';
                    bProcess: Boolean;
                begin

                    IF CONFIRM(Textl50000) THEN BEGIN
                        fTestSetupRetention;

                        CLEAR(rpLiqIRPF);
                        // CSM-20dic2016 begin
                        CurrPage.SETSELECTIONFILTER(Rec);
                        // CSM-20dic2016 end
                        rpLiqIRPF.fSetRecord(Rec);
                        rpLiqIRPF.RUNMODAL;
                        bProcess := rpLiqIRPF.fGetProcess;
                        // CSM-20dic2016 begin
                        Rec.RESET();
                        // CSM-20dic2016 end
                        IF bProcess THEN
                            CurrPage.CLOSE();
                    END ELSE
                        MESSAGE(Textl50001);
                end;
            }
            action(UnPost)
            {
                Caption = 'UnPost', Comment = 'ESP="Desregistrar"';
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    rpLiqIRPF: Report "DesLiquidación IRPF_2";
                    Textl50001: Label 'Proceso cancelado por el usuario.';
                    bProcess: Boolean;
                    Textl50002: Label '¿Confirma que desea Desliquidar las líneas actuales?';
                begin

                    IF CONFIRM(Textl50002) THEN BEGIN
                        fTestSetupRetention;

                        CLEAR(rpLiqIRPF);
                        // CSM-20dic2016 begin
                        CurrPage.SETSELECTIONFILTER(Rec);
                        // CSM-20dic2016 end
                        rpLiqIRPF.fSetRecord(Rec);
                        rpLiqIRPF.RUNMODAL;
                        bProcess := rpLiqIRPF.fGetProcess;
                        // CSM-20dic2016 begin
                        Rec.RESET();
                        // CSM-20dic2016 end
                        IF bProcess THEN
                            CurrPage.CLOSE();
                    END ELSE
                        MESSAGE(Textl50001);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        vTotalLine := STRPOS(Rec."Grupo registro retención", 'TOTAL') <> 0;
    end;

    trigger OnOpenPage()
    begin
        FillInTable;
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
        Rec.RESET();
        Rec.DELETEALL();

        TotalBase := 0;
        TotalCuota := 0;
        TotalLiq := 0;

        CodeTotalBase := 0;
        CodeTotalCuota := 0;
        CodeTotalLiq := 0;

        EntryNo := 0;
        LastCode := '';
        RetentionLedgEntry.RESET();
        // Mod. S2G 19/10/2016 (CSM) : begin
        //RetentionLedgEntry.SETCURRENTKEY(Tipo,Código,"Fecha registro","Cuenta retención");
        //RetentionLedgEntry.SETCURRENTKEY(Tipo,"Cod. origen","Grupo registro retención","Fecha registro");
        RetentionLedgEntry.SETCURRENTKEY(Tipo, "Tipo retención", "Cod. origen", "Grupo registro retención", "Fecha registro");
        // Mod. S2G 19/10/2016 (CSM) : end

        RetentionLedgEntry.SETFILTER(RetentionLedgEntry."No. mov. contabilidad", '<>%1', 0);

        //RetentionLedgEntry.SETRANGE(Tipo,RetentionLedgEntry.Tipo::IRPF);
        //RetentionLedgEntry.SETFILTER(Tipo,'%1|%2',RetentionLedgEntry.Tipo::Compra,RetentionLedgEntry.Tipo::"2");
        RetentionLedgEntry.SETFILTER(Tipo, '%1', TypeFilter);
        IF CodeFilter <> '' THEN
            // Mod. S2G 19/10/2016 (CSM) : begin
            //RetentionLedgEntry.SETFILTER(Código,CodeFilter);
            RetentionLedgEntry.SETFILTER("Grupo registro retención", CodeFilter);
        // Mod. S2G 19/10/2016 (CSM) : end
        IF DateFilter <> '' THEN
            RetentionLedgEntry.SETFILTER("Fecha registro", DateFilter);

        IF GLAccFilter <> '' THEN
            RetentionLedgEntry.SETFILTER("Cuenta retención", GLAccFilter);

        // Mod. S2G 19/10/2016 (CSM) : begin
        //TypeRetFilter := TypeRetFilter::Profesionales;  //se comenta línea porque se permiten todos los tipos.  CSM-20dic2016
        IF TypeRetFilter = 0 THEN
            RetentionLedgEntry.SETRANGE(RetentionLedgEntry."Tipo retención") //se muestran TODAS las líneas.
        ELSE
            RetentionLedgEntry.SETFILTER(RetentionLedgEntry."Tipo retención", '%1', TypeRetFilter);

        /*
        // Mod. S2G 19/10/2016 (CSM) : end
        IF TypeFilter = 0 THEN
          RetentionLedgEntry.SETFILTER(RetentionLedgEntry."Tipo tercero",'%1|%2',RetentionLedgEntry."Tipo tercero"::"0",RetentionLedgEntry."Tipo tercero"::"2")
        ELSE
          RetentionLedgEntry.SETRANGE(RetentionLedgEntry."Tipo tercero",RetentionLedgEntry."Tipo tercero"::"1");
        // Mod. S2G 19/10/2016 (CSM) : begin
        */
        // Mod. S2G 19/10/2016 (CSM) : end

        IF Selection = Selection::Closed THEN
            RetentionLedgEntry.SETRANGE(RetentionLedgEntry.Declarado, TRUE);
        IF Selection = Selection::Open THEN
            RetentionLedgEntry.SETRANGE(RetentionLedgEntry.Declarado, FALSE);

        IF RetentionLedgEntry.FINDSET() THEN
            REPEAT
                // Mod. S2G 19/10/2016 (CSM) : begin
                //IF (LastCode <> '') AND (LastCode <> RetentionLedgEntry.Código) THEN BEGIN
                IF (LastCode <> '') AND (LastCode <> RetentionLedgEntry."Grupo registro retención") THEN BEGIN
                    // Mod. S2G 19/10/2016 (CSM) : end
                    EntryNo := EntryNo + 1;
                    Rec.INIT();
                    Rec."Nº mov." := EntryNo;
                    //se comenta línea porque se permiten todos los tipos.  CSM-20dic2016 begin
                    //"Tipo retención" := "Tipo retención"::Profesionales;
                    Rec."Tipo retención" := RetentionLedgEntry."Tipo retención";
                    //se comenta línea porque se permiten todos los tipos.  CSM-20dic2016 end

                    // Mod. S2G 19/10/2016 (CSM) : begin
                    //Código := 'TOTAL' + ' ' + LastCode;
                    Rec."Grupo registro retención" := 'TOTAL' + ' ' + LastCode;
                    // Mod. S2G 19/10/2016 (CSM) : end
                    Rec.Base := CodeTotalBase;
                    Rec.Importe := CodeTotalCuota;
                    Rec."Importe IRPF liberado Total" := -CodeTotalLiq;
                    Rec."Tipo documento" := Rec."Tipo documento"::SubTotal;
                    Rec.INSERT();
                    CodeTotalBase := 0;
                    CodeTotalCuota := 0;
                    CodeTotalLiq := 0;
                END;
                EntryNo := EntryNo + 1;
                Rec.INIT();
                Rec := RetentionLedgEntry;
                Rec."Nº mov." := EntryNo;
                Rec."No. mov. original" := RetentionLedgEntry."Nº mov.";
                RetentionLedgEntry.CALCFIELDS(RetentionLedgEntry."Importe IRPF liberado");
                Rec."Importe IRPF liberado Total" := RetentionLedgEntry."Importe IRPF liberado";

                Rec.INSERT();
                CodeTotalBase := CodeTotalBase + RetentionLedgEntry.Base;
                CodeTotalCuota := CodeTotalCuota + RetentionLedgEntry.Importe;
                CodeTotalLiq := CodeTotalLiq + RetentionLedgEntry."Importe IRPF liberado";
                TotalBase := TotalBase + RetentionLedgEntry.Base;
                TotalCuota := TotalCuota + RetentionLedgEntry.Importe;
                TotalLiq := TotalLiq + RetentionLedgEntry."Importe IRPF liberado";
                LastCode := RetentionLedgEntry."Grupo registro retención";
            //Liberado

            //
            UNTIL RetentionLedgEntry.NEXT() = 0;

        IF RetentionLedgEntry.COUNT <> 0 THEN BEGIN
            EntryNo := EntryNo + 1;
            Rec.INIT();
            Rec."Nº mov." := EntryNo;
            //Tipo := Tipo::Compra;
            //se comenta línea porque se permiten todos los tipos.  CSM-20dic2016 begin
            //"Tipo retención" := "Tipo retención"::Profesionales;
            Rec."Tipo retención" := RetentionLedgEntry."Tipo retención";
            //se comenta línea porque se permiten todos los tipos.  CSM-20dic2016 end
            Rec."Grupo registro retención" := 'TOTAL' + ' ' + RetentionLedgEntry."Grupo registro retención";
            Rec.Base := CodeTotalBase;
            Rec.Importe := CodeTotalCuota;
            Rec."Importe IRPF liberado Total" := -CodeTotalLiq;
            Rec."Tipo documento" := Rec."Tipo documento"::SubTotal;
            Rec.INSERT();

            EntryNo := EntryNo + 1;
            Rec.INIT();
            Rec."Nº mov." := EntryNo;
            //Tipo := Tipo::Compra;
            //se comenta línea porque se permiten todos los tipos.  CSM-20dic2016 begin
            //"Tipo retención" := "Tipo retención"::Profesionales;
            Rec."Tipo retención" := RetentionLedgEntry."Tipo retención";
            //se comenta línea porque se permiten todos los tipos.  CSM-20dic2016 end
            Rec."Grupo registro retención" := 'TOTAL';
            Rec.Base := TotalBase;
            Rec.Importe := TotalCuota;
            Rec."Importe IRPF liberado Total" := -TotalLiq;
            Rec."Tipo documento" := Rec."Tipo documento"::Total;
            Rec.INSERT();
        END;
        CurrPage.UPDATE(FALSE);
    end;

    procedure fTestSetupRetention()
    var
        rlPurchSetup: Record "Purchases & Payables Setup";
        rlSourceCodeSetup: Record "Source Code Setup";
    begin

        rlPurchSetup.RESET();
        rlPurchSetup.GET();

        rlPurchSetup.TESTFIELD(rlPurchSetup."Retention Jnl. Template");
        rlPurchSetup.TESTFIELD(rlPurchSetup."Retention Jnl. Batch");
        rlPurchSetup.TESTFIELD(rlPurchSetup."Número serie Liquidación IRPF");

        rlSourceCodeSetup.RESET();
        rlSourceCodeSetup.GET();
        rlSourceCodeSetup.TESTFIELD("Retention Application");
    end;
}
