page 50117 "GEN-MovPresupuesto"
{
    PageType = List;
    Caption = 'Budget Movements', Comment = 'ESP="Movimientos presupuesto"';
    SourceTable = TablaMovPresupuesto;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.id)
                {
                }
                field(Empresa; Rec.Empresa)
                {
                }
                field(Fecha; Rec.Fecha)
                {
                }
                field("Nº Cuenta"; Rec."Nº Cuenta")
                {
                }
                field(Importe; Rec.Importe)
                {
                }
                field("Entidad Codigo"; Rec."Entidad Codigo")
                {
                }
                field(Comentario; Rec.Comentario)
                {
                }
                field(Date; Rec.Date)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SETFILTER("Nº cuenta", '20*|21*|23*|6*|7*|5505007|5530001');
        /*
        DELETEALL();
        id := 0;
        Companies.RESET();
        Companies.SETFILTER(Name, 'COM*|TIE*|HOS*|UNI*|EDI*|COL*|FRA*|PRO*');
        IF Companies.FINDSET() THEN
          REPEAT
             rGLBudgetName.CHANGECOMPANY(Companies.Name);
             rGLBudgetName.RESET();
             rGLBudgetName.SETFILTER("Power BI", 'TRUE');
             IF rGLBudgetName.FINDSET() THEN
             REPEAT
              rGLBudgetEntry.CHANGECOMPANY(Companies.Name);
              rGLBudgetEntry.RESET();
              rGLBudgetEntry.SETFILTER("G/L Account No.", '2*|6*|7*');
              rGLBudgetEntry.SETRANGE("Budget Name",rGLBudgetName.Name);
              IF rGLBudgetEntry.FINDSET() THEN
                REPEAT

                      INIT;
                      id += 1;
                      Empresa := Companies.Name;
                      Fecha := rGLBudgetEntry."Budget Name";
                      "Nº cuenta" := rGLBudgetEntry."G/L Account No.";
                      Comentario:= rGLBudgetEntry."Budget Comment";
                   IF
                                  (COPYSTR(rGLBudgetEntry."G/L Account No.", 1, 1) = '7') THEN BEGIN
                                IF
                                  ((rGLBudgetEntry.Amount)<0) THEN
                                    Importe := -(rGLBudgetEntry.Amount)
                                  ELSE
                                    Importe := rGLBudgetEntry.Amount;
                                  END
                                  ELSE BEGIN
                                      Importe := rGLBudgetEntry.Amount;
                                  END;
                      INSERT();
                UNTIL rGLBudgetEntry.NEXT() = 0;
              UNTIL rGLBudgetName.NEXT=0;
          UNTIL Companies.NEXT() = 0;
          */
    end;
}
