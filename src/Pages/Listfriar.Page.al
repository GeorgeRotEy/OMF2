page 50009 "List friar"
{
    Caption = 'Friar List', Comment = 'ESP="Directorio Hermanos"';
    CardPageID = "Card friar";
    PageType = List;
    SourceTable = Friar;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Serie Friar"; Rec."No. Serie Friar")
                {
                }
                field(Name_Rel; Rec.Name_Rel)
                {
                }
                field(Apellidos; Rec.Apellidos)
                {
                }
                field("Destino Fraternidad"; Rec."Destino Fraternidad")
                {
                }
                field(Población; Rec.Población)
                {
                }
                field("Destino Fraternidad Nav"; Rec."Destino Fraternidad Nav")
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
        Friar.RESET();

        IF Friar.FINDFIRST() THEN
            REPEAT
                FriarLedgeEntry.RESET();

                FriarLedgeEntry.SETCURRENTKEY("Date start");
                FriarLedgeEntry.SETASCENDING("Date start", FALSE);
                FriarLedgeEntry.SETRANGE("No. Serie Friar", Friar."No. Serie Friar");
                FriarLedgeEntry.SETRANGE(Active, TRUE);
                FriarLedgeEntry.SETAUTOCALCFIELDS(City);
                IF FriarLedgeEntry.FINDFIRST() THEN BEGIN
                    Friar."Destino Fraternidad" := FriarLedgeEntry.Fraternity;
                    Friar.Población := FriarLedgeEntry.City;
                    rcPostCode.RESET();
                    IF rcPostCode.GET(FriarLedgeEntry."Post Code", FriarLedgeEntry.City) THEN
                        Friar."Destino Fraternidad Nav" := rcPostCode."Destino Fraternidad Nav";
                END
                ELSE BEGIN
                    Friar."Destino Fraternidad" := '';
                    Friar.Población := '';
                    Friar."Destino Fraternidad Nav" := '';
                END;
                Friar.MODIFY();
            UNTIL Friar.NEXT() = 0;
    end;

    var
        FriarLedgeEntry: Record "Friar Ledger Entry";
        Friar: Record Friar;
        rcPostCode: Record "Post Code";
}
