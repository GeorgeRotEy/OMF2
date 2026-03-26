page 50126 "Regimen Sublist"
{
    AutoSplitKey = true;
    Caption = 'Regime Sublist', Comment = 'ESP="Sublista régimen"';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Regimen Actual";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(" Tipo Situación"; Rec."Tipo Regimen")
                {
                }
                field("Régimen Actual"; Rec."Régimen Actual")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Tipo Pensionista"; Rec."Tipo Pensionista")
                {
                    OptionCaption = ' ,Contributiva,No Contributiva';

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Seguro Médico"; Rec."Seguro Médico")
                {
                    OptionCaption = ' ,No,Sanitas,Sanitas VOCARE,Asisa General,Asisa Misionero';

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Fecha Inicio"; Rec."Fecha Inicio")
                {
                }
                field("Fecha Fin"; Rec."Fecha Fin")
                {
                    trigger OnValidate()
                    begin
                        IF Rec."Fecha Fin" < Rec."Fecha Inicio" THEN
                            ERROR('Fecha fin no puedes ser menor que la Fecha Inicio');
                    end;
                }
                field(Base; Rec.Base)
                {
                    Caption = 'Importe/Base';

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Importe/Base"; Rec."Importe/Base")
                {
                    Caption = 'Cuota';

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Importe Seguro Médico"; Rec."Importe Seguro Médico")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Importe Pensionista"; Rec."Importe Pensionista")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Salario Adecuado"; Rec."Salario Adecuado")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
            }
        }
    }

    actions
    {
    }
}
