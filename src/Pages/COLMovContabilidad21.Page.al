page 50129 "COL-MovContabilidad2.1"
{
    PageType = List;
    Caption = 'Accounting Movements 2.1', Comment = 'ESP="Movimientos contabilidad 2.1"';
    SourceTable = TablaMovContabilidad2;
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
                field("Entidad Codigo"; Rec."Entidad Codigo")
                {
                }
                field("Actividad Codigo"; Rec."Actividad Codigo")
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
        Rec.DELETEALL();
        Rec.id := 0;
        Companies.RESET();
        Companies.SETFILTER(Name, 'COL*');
        IF Companies.FINDSET() THEN
            REPEAT
                GLEntry.CHANGECOMPANY(Companies.Name);
                GLEntry.RESET();
                GLEntry.SETFILTER("G/L Account No.", '2*|6*|7*');
                GLEntry.SETFILTER("Source Code", '<>ASTOREGUL');
                IF GLEntry.FINDSET() THEN
                    REPEAT
                        IF (GLEntry."Posting Date" >= 20220101D) AND (GLEntry."Posting Date" <= 20231231D) THEN BEGIN
                            Rec.INIT();
                            Rec.id += 1;
                            Rec.Empresa := Companies.Name;
                            Rec."Fecha registro" := GLEntry."Posting Date";
                            IF
                            (COPYSTR(GLEntry."G/L Account No.", 1, 1) = '7') THEN
                                IF
                                 ((GLEntry.Amount) < 0) THEN
                                    Rec.Importe := -(GLEntry.Amount)
                                ELSE
                                    Rec.Importe := GLEntry.Amount;
                            Rec.INSERT();
                        END;
                    UNTIL GLEntry.NEXT() = 0;
            UNTIL Companies.NEXT() = 0;
    end;

    var
        Companies: Record Company;
        GLEntry: Record "G/L Entry";
}
