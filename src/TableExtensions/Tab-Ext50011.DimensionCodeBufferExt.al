tableextension 50011 "Dimension Code Buffer Ext" extends "Dimension Code Buffer"
{
    // (CR001) S2G (RBM-R) 09-08-18: Comentarios en presupuestos
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
    // (CR003) S2G (RBM-R) 04-11-19: Modificaciones Registro simple
    // S2G (ARP) 19-11-19: Modificación para excluir del cálculo los movs. de regularización
    // (1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos
    // (FCO) S2G (CSM) 07/04/2020 : Filtro Código Origen, para excluir Movs Regularización. (1.2)
    //       - NEW FIELD: 50006 "Source code filter"

    fields
    {
        field(50006; "Source Code Filter"; Code[20])
        {
            Caption = 'Source Code Filter', Comment = 'ESP="Filtro cód. origen"';
            FieldClass = FlowFilter;
            TableRelation = "Source Code";
        }
    }

    procedure fGetBudgetComment(pBudgetName: Code[10]) BudgCom: Text
    var
        rlGLBudgetEntry: Record "G/L Budget Entry";
    begin
        //(CR001) S2G (RBM-R) 09-08-18: Comentarios en presupuestos
        BudgCom := '';
        rlGLBudgetEntry.RESET();
        rlGLBudgetEntry.SETCURRENTKEY("Budget Name", "G/L Account No.", Date);
        rlGLBudgetEntry.SETRANGE("Budget Name", pBudgetName);
        rlGLBudgetEntry.SETRANGE("G/L Account No.", Code);
        rlGLBudgetEntry.SETFILTER("Budget Comment", '<>%1', '');
        IF rlGLBudgetEntry.FINDSET() THEN
            REPEAT
                BudgCom += rlGLBudgetEntry."Budget Comment" + ' ';
            UNTIL rlGLBudgetEntry.NEXT() = 0;
    end;

    procedure fCalculateNewFields(pAccountNo: Code[20]; var pLastYearBudget: Decimal; var pLastYearReal: Decimal)
    var
        rlGLBudgetName: Record "G/L Budget Name";
        rlGLBudgetEntry: Record "G/L Budget Entry";
        rlGLAccount: Record "G/L Account";
        vlStartDate: Date;
        vlEndDate: Date;
        rlGLEntry: Record "G/L Entry";
        rlSourceCodeSetup: Record "Source Code Setup";
        vlBudgetNameLastYear: Code[10];
    begin
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
        pLastYearBudget := 0;
        pLastYearReal := 0;

        //(1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos. Inicio
        // rlGLBudgetName.RESET();
        // rlGLBudgetName.SETCURRENTKEY(Active);
        // rlGLBudgetName.SETRANGE(Active, TRUE);
        // IF rlGLBudgetName.FINDFIRST() THEN
        //  vlBudgetName := rlGLBudgetName.Name
        // ELSE
        //  EXIT;
        //(1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos. Fin

        EVALUATE(vlStartDate, '01/01/' + FORMAT(DATE2DMY(TODAY, 3)));
        EVALUATE(vlEndDate, '31/12/' + FORMAT(DATE2DMY(TODAY, 3)));

        rlGLBudgetEntry.RESET();
        rlGLBudgetEntry.SETCURRENTKEY("Budget Name", "G/L Account No.", Date);

        //(1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos. Inicio
        //rlGLBudgetEntry.SETRANGE("Budget Name", vlBudgetName);
        vlBudgetNameLastYear := '';
        rlGLBudgetName.RESET();
        rlGLBudgetName.SETRANGE("Last Year Budget", TRUE);
        IF rlGLBudgetName.FINDFIRST() THEN
            vlBudgetNameLastYear := rlGLBudgetName.Name;
        rlGLBudgetEntry.SETRANGE("Budget Name", vlBudgetNameLastYear);
        //(1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos. Fin

        IF STRLEN(pAccountNo) < 7 THEN
            rlGLBudgetEntry.SETFILTER("G/L Account No.", '%1..%2', pAccountNo, PADSTR(pAccountNo, 7, '9'))
        ELSE
            rlGLBudgetEntry.SETRANGE("G/L Account No.", pAccountNo);

        //(1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos. Inicio
        //rlGLBudgetEntry.SETFILTER(Date, '%1..%2', vlStartDate, vlEndDate);
        //(1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos. Fin

        IF rlGLBudgetEntry.FINDSET() THEN
            REPEAT
                pLastYearBudget += rlGLBudgetEntry.Amount;
            UNTIL rlGLBudgetEntry.NEXT() = 0;

        //(CR003) S2G (RBM-R) 04-11-19: Modificaciones Registro simple. Inicio
        //EVALUATE(vlStartDate, '01/' + FORMAT(DATE2DMY(TODAY, 2)) + '/' + FORMAT(DATE2DMY(TODAY, 3)));
        EVALUATE(vlStartDate, '01/' + FORMAT(DATE2DMY(TODAY, 2)) + '/' + FORMAT(DATE2DMY(TODAY, 3) - 1));
        //(CR003) S2G (RBM-R) 04-11-19: Modificaciones Registro simple. Fin

        vlEndDate := CALCDATE('+12M-1D', vlStartDate);

        //S2G (ARP) 19-11-19: Modificación para excluir del cálculo los movs. de regularización
        CLEAR(rlSourceCodeSetup);
        rlSourceCodeSetup.GET();
        //S2G (ARP) 19-11-19: Modificación para excluir del cálculo los movs. de regularización. Fin.
        rlGLAccount.RESET();
        rlGLAccount.SETRANGE("No.", pAccountNo);
        rlGLAccount.SETFILTER("Date Filter", '%1..%2', vlStartDate, vlEndDate);
        IF rlGLAccount.FINDSET() THEN BEGIN
            //S2G (ARP) 19-11-19: Modificación para excluir del cálculo los movs. de regularización
            //rlGLAccount.CALCFIELDS("Net Change");
            //pLastYearReal := rlGLAccount."Net Change";
            CLEAR(rlGLEntry);
            rlGLEntry.SETRANGE("G/L Account No.", pAccountNo);
            IF rlGLAccount.Totaling <> '' THEN
                rlGLEntry.SETFILTER("G/L Account No.", rlGLAccount.Totaling);
            rlGLEntry.SETFILTER("Business Unit Code", rlGLAccount."Business Unit Filter");
            rlGLEntry.SETFILTER("Global Dimension 1 Code", rlGLAccount."Global Dimension 1 Filter");
            rlGLEntry.SETFILTER("Global Dimension 2 Code", rlGLAccount."Global Dimension 2 Filter");
            rlGLEntry.SETFILTER("Posting Date", '%1..%2', vlStartDate, vlEndDate);
            rlGLEntry.SETFILTER("Source No.", rlGLAccount."Source Filter");
            rlGLEntry.SETFILTER("Source Code", '<>%1', rlSourceCodeSetup."Close Income Statement");
            rlGLEntry.CALCSUMS(Amount);
            pLastYearReal := rlGLEntry.Amount;
            //S2G (ARP) 19-11-19: Modificación para excluir del cálculo los movs. de regularización. Fin.
        END;
    end;

    local procedure "//GRL KPMG"()
    begin
    end;

    //pAPI para determinar si la llamada viene desde una API
    procedure fCalculateNewFields2(pAccountNo: Code[20]; var pLastYearBudget: Decimal; var pLastYearReal: Decimal; FromDate: Date; ToDate: Date; pAPI: Boolean)
    var
        rlGLBudgetName: Record "G/L Budget Name";
        rlGLBudgetEntry: Record "G/L Budget Entry";
        rlGLAccount: Record "G/L Account";
        vlStartDate: Date;
        vlEndDate: Date;
        rlGLEntry: Record "G/L Entry";
        rlSourceCodeSetup: Record "Source Code Setup";
        vlBudgetNameLastYear: Code[10];
    begin
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
        pLastYearBudget := 0;
        pLastYearReal := 0;

        //(1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos. Inicio
        // rlGLBudgetName.RESET();
        // rlGLBudgetName.SETCURRENTKEY(Active);
        // rlGLBudgetName.SETRANGE(Active, TRUE);
        // IF rlGLBudgetName.FINDFIRST() THEN
        //  vlBudgetName := rlGLBudgetName.Name
        // ELSE
        //  EXIT;
        //(1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos. Fin
        if pAPI then begin
            EVALUATE(vlStartDate, FORMAT(DATE2DMY(TODAY, 3)) + '-01-01');
            EVALUATE(vlEndDate, FORMAT(DATE2DMY(TODAY, 3)) + '-12-31');
        end else begin
            EVALUATE(vlStartDate, '01/01/' + FORMAT(DATE2DMY(TODAY, 3)));
            EVALUATE(vlEndDate, '31/12/' + FORMAT(DATE2DMY(TODAY, 3)));
        end;
        //delete
        //MESSAGE('Presupuesto desde %1 hasta %2',FORMAT(vlStartDate),FORMAT(vlEndDate));
        //delete

        rlGLBudgetEntry.RESET();
        rlGLBudgetEntry.SETCURRENTKEY("Budget Name", "G/L Account No.", Date);

        //(1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos. Inicio
        //rlGLBudgetEntry.SETRANGE("Budget Name", vlBudgetName);
        vlBudgetNameLastYear := '';
        rlGLBudgetName.RESET();
        rlGLBudgetName.SETRANGE("Last Year Budget", TRUE);
        IF rlGLBudgetName.FINDFIRST() THEN
            vlBudgetNameLastYear := rlGLBudgetName.Name;
        rlGLBudgetEntry.SETRANGE("Budget Name", vlBudgetNameLastYear);
        //(1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos. Fin

        IF STRLEN(pAccountNo) < 7 THEN
            rlGLBudgetEntry.SETFILTER("G/L Account No.", '%1..%2', pAccountNo, PADSTR(pAccountNo, 7, '9'))
        ELSE
            rlGLBudgetEntry.SETRANGE("G/L Account No.", pAccountNo);

        //(1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos. Inicio
        //rlGLBudgetEntry.SETFILTER(Date, '%1..%2', vlStartDate, vlEndDate);
        //(1.6) S2G (RBM-R) 12-03-20: Modificaciones presupuestos. Fin

        IF rlGLBudgetEntry.FINDSET() THEN
            REPEAT
                pLastYearBudget += rlGLBudgetEntry.Amount;
            UNTIL rlGLBudgetEntry.NEXT() = 0;

        //(CR003) S2G (RBM-R) 04-11-19: Modificaciones Registro simple. Inicio
        //EVALUATE(vlStartDate, '01/' + FORMAT(DATE2DMY(TODAY, 2)) + '/' + FORMAT(DATE2DMY(TODAY, 3)));
        EVALUATE(vlStartDate, '01/' + FORMAT(DATE2DMY(TODAY, 2)) + '/' + FORMAT(DATE2DMY(TODAY, 3) - 1));
        //(CR003) S2G (RBM-R) 04-11-19: Modificaciones Registro simple. Fin

        vlEndDate := CALCDATE('+12M-1D', vlStartDate);

        //KPMG-GRL 08/12/2020. Filtro Fecha realizado. Begin
        IF (FromDate <> 0D) AND (ToDate <> 0D) THEN BEGIN
            vlStartDate := FromDate;
            vlEndDate := ToDate;
        END;
        //KPMG-GRL 08/12/2020. Filtro Fecha realizado. End

        //delete
        //MESSAGE('Realizado desde %1 hasta %2',FORMAT(vlStartDate),FORMAT(vlEndDate));
        //delete

        //S2G (ARP) 19-11-19: Modificación para excluir del cálculo los movs. de regularización
        CLEAR(rlSourceCodeSetup);
        rlSourceCodeSetup.GET();
        //S2G (ARP) 19-11-19: Modificación para excluir del cálculo los movs. de regularización. Fin.
        rlGLAccount.RESET();
        rlGLAccount.SETRANGE("No.", pAccountNo);
        rlGLAccount.SETFILTER("Date Filter", '%1..%2', vlStartDate, vlEndDate);
        IF rlGLAccount.FINDSET() THEN BEGIN
            //S2G (ARP) 19-11-19: Modificación para excluir del cálculo los movs. de regularización
            //rlGLAccount.CALCFIELDS("Net Change");
            //pLastYearReal := rlGLAccount."Net Change";
            CLEAR(rlGLEntry);
            rlGLEntry.SETRANGE("G/L Account No.", pAccountNo);
            IF rlGLAccount.Totaling <> '' THEN
                rlGLEntry.SETFILTER("G/L Account No.", rlGLAccount.Totaling);
            rlGLEntry.SETFILTER("Business Unit Code", rlGLAccount."Business Unit Filter");
            rlGLEntry.SETFILTER("Global Dimension 1 Code", rlGLAccount."Global Dimension 1 Filter");
            rlGLEntry.SETFILTER("Global Dimension 2 Code", rlGLAccount."Global Dimension 2 Filter");
            rlGLEntry.SETFILTER("Posting Date", '%1..%2', vlStartDate, vlEndDate);
            rlGLEntry.SETFILTER("Source No.", rlGLAccount."Source Filter");
            rlGLEntry.SETFILTER("Source Code", '<>%1', rlSourceCodeSetup."Close Income Statement");
            rlGLEntry.CALCSUMS(Amount);
            pLastYearReal := rlGLEntry.Amount;
            //S2G (ARP) 19-11-19: Modificación para excluir del cálculo los movs. de regularización. Fin.
        END;
    end;
}
