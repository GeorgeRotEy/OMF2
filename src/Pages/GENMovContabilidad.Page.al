page 50118 "GEN-MovContabilidad"
{
    PageType = List;
    Caption = 'Accounting Movements', Comment = 'ESP="Movimientos contabilidad"';
    SourceTable = TablaMovContabilidad;
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
                field("Nº mov"; Rec."Nº mov")
                {
                }
                field("Nº Cuenta"; Rec."Nº Cuenta")
                {
                }
                field("Fecha registro"; Rec."Fecha registro")
                {
                }
                field(Importe; Rec.Importe)
                {
                }
                field(Fecha2; Rec.Fecha2)
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

        Rec.SETFILTER("Nº Cuenta", '20*|21*|23*|6*|7*|5505007')
        /*
        DELETEALL();
        id := 0;
        Companies.RESET();
        //Companies.SETFILTER(Name, 'COM*|TIE*|HOS*|UNI*|EDI*|COL*|FRA*|PRO*');
        //Companies.SETFILTER(Name, 'EDI-ESPIGAS Y AZUCENAS|COL-ALICANTE|FRA-ALBACETE|PRO-EXPLOTACIONES VARIAS');

        IF Companies.FINDSET() THEN
          REPEAT
              GLEntry.CHANGECOMPANY(Companies.Name);
              GLEntry.RESET();
              GLEntry.SETCURRENTKEY("G/L Account No.","Source Type","Source No.","Posting Date");
              GLEntry.SETFILTER("G/L Account No.", '20*|21*|23*|6*|7');
              GLEntry.SETFILTER("Source Code", '<>ASTOREGUL');
              //GLEntry.SETFILTER("Posting Date",'%1..%2',010123D,311223D);
              IF GLEntry.FINDSET() THEN
                REPEAT
                  //IF(GLEntry."Posting Date" >= 010123D) AND(GLEntry."Posting Date" <= 311223D)THEN
                    BEGIN
                      INIT;
                      id += 1;
                      Empresa := Companies.Name;
                      "Nº mov" := GLEntry."Entry No.";
                      "Nº Cuenta" := GLEntry."G/L Account No.";
                      "Fecha registro" := GLEntry."Posting Date";
                       IF COPYSTR(GLEntry."G/L Account No.", 1, 1) = '7' THEN BEGIN
                          IF GLEntry.Amount < 0 THEN
                              Importe := -GLEntry.Amount
                          ELSE
                              Importe := GLEntry.Amount;
                      END
                      ELSE BEGIN
                          Importe := GLEntry.Amount;
                      END;
                      INSERT();
                      END
                UNTIL GLEntry.NEXT() = 0;
          UNTIL Companies.NEXT() = 0;
          */
    end;
}
