page 50119 "Oficios Sublist"
{
    AutoSplitKey = true;
    Caption = 'Occupations Sublist', Comment = 'ESP="Sublista oficios"';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Friar Options";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fecha Inicio"; Rec."Fecha Inicio")
                {
                }
                field("Fecha fin"; Rec."Fecha fin")
                {
                }
                field("Oficios/Cargos"; Rec."Oficios/Cargos")
                {
                    Editable = true;
                    Enabled = true;
                    Visible = true;
                }
                field(Actual; Rec.Actual)
                {
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field(Fraternidad; UltimoDestino)
                {
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field(Poblacion; PoblacionDestinoHermano)
                {
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field(Descripcion; Rec.Descripcion)
                {
                }
                field(ID; Rec.ID)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        // TEMS-267
        CLEAR(isCalc);
        FriarLedgeEntry.RESET();
        FriarLedgeEntry.SETCURRENTKEY("Date start");
        FriarLedgeEntry.SETASCENDING("Date start", FALSE);
        FriarLedgeEntry.SETRANGE("No. Serie Friar", Rec."Nº Serie Friar");
        FriarLedgeEntry.SETRANGE(Active, TRUE);
        FriarLedgeEntry.SETAUTOCALCFIELDS(City);
        IF (Rec.Actual = TRUE) AND (Rec."Data Friar Type" = Rec."Data Friar Type"::Oficios) THEN
            IF FriarLedgeEntry.FINDFIRST() THEN BEGIN
                PoblacionDestinoHermano := FriarLedgeEntry.City;
                UltimoDestino := FriarLedgeEntry.Fraternity;
                isCalc := TRUE;
            END;
        IF NOT isCalc THEN BEGIN
            CLEAR(PoblacionDestinoHermano);
            CLEAR(UltimoDestino);
        END;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.UPDATE;
    end;

    var
        PoblacionDestinoHermano: Text;
        UltimoDestino: Text;
        FriarLedgeEntry: Record "Friar Ledger Entry";
        isCalc: Boolean;
}
