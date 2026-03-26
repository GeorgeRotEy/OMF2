page 50143 "Macro Tabla"
{
    PageType = List;
    Caption = 'Macro Table', Comment = 'ESP="Macro Tabla"';
    SourceTable = "Friar Options";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Nº Serie Friar"; Rec."Nº Serie Friar")
                {
                }
                field("Nombre Hermano"; Rec."Nombre Hermano")
                {
                }
                field("Apellido Hermano"; Rec."Apellido Hermano")
                {
                }
                field("Data Friar Type"; Rec."Data Friar Type")
                {
                }
                field("Oficios/Cargos"; Rec."Oficios/Cargos")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Fecha Inicio"; Rec."Fecha Inicio")
                {
                }
                field("Fecha fin"; Rec."Fecha fin")
                {
                }
                field(Actual; Rec.Actual)
                {
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field(UltimoDestino; UltimoDestino)
                {
                    Caption = 'Ultimo Destino';

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field(Poblacion; Poblacion)
                {
                    Caption = 'Poblacion';

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field(Descripcion; Rec.Descripcion)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CLEAR(isCalc);
        FriarLedgerEntry.RESET();
        FriarLedgerEntry.SETRANGE("No. Serie Friar", Rec."Nº Serie Friar");
        //Rec.SETRANGE(Actual,TRUE);//calcular con if en actual y el tipo de oficio
        //Rec.SETRANGE("Data Friar Type",Rec."Data Friar Type"::Oficios);
        FriarLedgerEntry.SETAUTOCALCFIELDS(City);
        IF FriarLedgerEntry.FINDFIRST() THEN
            IF (Rec.Actual = TRUE) AND (Rec."Data Friar Type" = Rec."Data Friar Type"::Oficios) THEN BEGIN
                Poblacion := FriarLedgerEntry.City;
                UltimoDestino := FriarLedgerEntry.Fraternity;
                isCalc := TRUE;
                //CurrPage."Ultimo Destino".
            END;
        IF NOT isCalc THEN BEGIN
            CLEAR(Poblacion);
            CLEAR(UltimoDestino);
        END;
    end;

    var
        FriarLedgerEntry: Record "Friar Ledger Entry";
        Poblacion: Text;
        isCalc: Boolean;
        UltimoDestino: Text[50];
}
