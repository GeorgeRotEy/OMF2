page 50138 Frailes
{
    PageType = List;
    Caption = 'Friars', Comment = 'ESP="Frailes"';
    SourceTable = Frailes;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID Hermano"; Rec."ID Hermano")
                {
                }
                field(Fraternidad; Rec.Fraternidad)
                {
                }
                field(Inicio; Rec.Inicio)
                {
                }
                field(Final; Rec.Final)
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
        FriarLedgerEntry.RESET();
        FriarLedgerEntry.CHANGECOMPANY('PRO-PROVINCIA INMACULADA');
        IF FriarLedgerEntry.FINDSET() THEN
            REPEAT
                Rec.INIT();
                IF FriarLedgerEntry.Active THEN BEGIN
                    Rec."ID Hermano" := FriarLedgerEntry."No. Serie Friar";
                    Rec.Fraternidad := FriarLedgerEntry.Fraternity;
                    Rec.Final := FriarLedgerEntry."Date end";
                    Rec.Inicio := FriarLedgerEntry."Date start";
                    Rec.INSERT();
                END;
            UNTIL FriarLedgerEntry.NEXT() = 0;
    end;

    var
        FriarLedgerEntry: Record "Friar Ledger Entry";
}
