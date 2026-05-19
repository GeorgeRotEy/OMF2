codeunit 50019 "Process Load GL Entry PBI Ppto"
{
    trigger OnRun()
    begin
        TablaMovPresupuesto.DELETEALL();
        TablaMovPresupuesto.id := 0;
        Companies.RESET();
        Companies.SETFILTER(Name, 'PRO*|COL*|COM*|TIE*|HOS*|UNI*|EDI*|FRA*');
        IF Companies.FINDSET() THEN
            REPEAT
                rGLBudgetName.CHANGECOMPANY(Companies.Name);
                rGLBudgetName.RESET();
                rGLBudgetName.SETRANGE("Power BI", TRUE);
                IF rGLBudgetName.FINDSET() THEN
                    REPEAT
                        rGLBudgetEntry.CHANGECOMPANY(Companies.Name);
                        rGLBudgetEntry.RESET();
                        //rGLBudgetEntry.SETFILTER("G/L Account No.", '20*|21*|23*|6*|7*|5505007|5530001|5523001|5524001');
                        rGLBudgetEntry.SETFILTER("G/L Account No.", '20*|21*|23*|6*|7*|5505007|5523001|5524001');
                        rGLBudgetEntry.SETRANGE("Budget Name", rGLBudgetName.Name);
                        IF rGLBudgetEntry.FINDSET() THEN
                            REPEAT

                                TablaMovPresupuesto.INIT();
                                TablaMovPresupuesto.id += 1;
                                TablaMovPresupuesto.Empresa := Companies.Name;
                                TablaMovPresupuesto.Fecha := rGLBudgetEntry."Budget Name";
                                TablaMovPresupuesto.Date := rGLBudgetEntry.Date;
                                TablaMovPresupuesto."Nº cuenta" := rGLBudgetEntry."G/L Account No.";
                                TablaMovPresupuesto."Entidad Codigo" := rGLBudgetEntry."Global Dimension 1 Code";
                                TablaMovPresupuesto.Descripcion := rGLBudgetEntry.Description;
                                TablaMovPresupuesto.Comentario := rGLBudgetEntry."Budget Comment";
                                TablaMovPresupuesto."Servicio Codigo" := rGLBudgetEntry."Global Dimension 2 Code";
                                IF
                                (COPYSTR(rGLBudgetEntry."G/L Account No.", 1, 1) = '7') OR
                                (COPYSTR(rGLBudgetEntry."G/L Account No.", 1, 7) = '5505007') THEN
                                    TablaMovPresupuesto.Importe := -(rGLBudgetEntry.Amount)
                                /*
                                     IF
                                       ((rGLBudgetEntry.Amount)<0) THEN
                                         Importe := -(rGLBudgetEntry.Amount)
                                       ELSE
                                         Importe := -(rGLBudgetEntry.Amount);
                                         */
                                ELSE
                                    TablaMovPresupuesto.Importe := rGLBudgetEntry.Amount;
                                TablaMovPresupuesto.INSERT();
                            UNTIL rGLBudgetEntry.NEXT() = 0;
                    UNTIL rGLBudgetName.NEXT() = 0;
            UNTIL Companies.NEXT() = 0;
        IF GUIALLOWED() THEN
            MESSAGE('FIN');
    end;

    var
        Companies: Record Company;
        rGLBudgetEntry: Record "G/L Budget Entry";
        rGLBudgetName: Record "G/L Budget Name";
        TablaMovPresupuesto: Record TablaMovPresupuesto;
}
