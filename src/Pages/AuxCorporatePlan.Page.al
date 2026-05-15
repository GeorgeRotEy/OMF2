page 50043 "Aux. Corporate Plan"
{
    // // Mod. S2G 16/12/2017 (JGS) : GF001 ã Plan de cuentas corporativo.

    Caption = 'Aux. Corporate Plan', Comment = 'ESP="Aux. Plan corporativo"';
    PageType = List;
    SourceTable = "Aux plan corporativo";
    ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Nº"; Rec."Nº")
                {
                    StyleExpr = Vcolor;
                }
                field(Nombre; Rec.Nombre)
                {
                    StyleExpr = Vcolor;
                }
                field("Tipo mov."; Rec."Tipo mov.")
                {
                }
                field("Comercial/Balance"; Rec."Comercial/Balance")
                {
                }
                field(Acción; Rec.Acción)
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Debe/Haber"; Rec."Debe/Haber")
                {
                }
                field("Entrada directa"; Rec."Entrada directa")
                {
                }
                field(Sumatorio; Rec.Sumatorio)
                {
                }
                field("Cta. consol. debe"; Rec."Cta. consol. debe")
                {
                }
                field("Cta. consol. haber"; Rec."Cta. consol. haber")
                {
                }
                field("Tipo IVA"; Rec."Tipo IVA")
                {
                }
                field("Cta. regularización"; Rec."Cta. regularización")
                {
                }
                field("Existe en plan"; Rec."Existe en plan")
                {
                    Enabled = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Seleccionar cuenta")
            {
                Image = "Action";
                Caption = 'Select Account', Comment = 'ESP="Seleccionar cuenta"';

                trigger OnAction()
                begin
                    MarkRegister;
                end;
            }
        }
        area(Promoted)
        {
            group(Process)
            {
                Caption = 'Process', Comment = 'ESP="Procesar"';

                actionref(SelectAccount_Promoted; "Seleccionar cuenta")
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        updatecolor;
    end;

    var
        Vcolor: Text;

    local procedure updatecolor()
    begin

        Vcolor := 'standar';

        IF Rec."Existe en plan" THEN
            Vcolor := 'Subordinate';

        IF Rec.Acción = Rec.Acción::Traer THEN
            Vcolor := 'Favorable';
    end;

    local procedure MarkRegister()
    begin

        CurrPage.SETSELECTIONFILTER(Rec);

        IF Rec.FINDSET() THEN
            REPEAT
                IF NOT Rec."Existe en plan" THEN BEGIN
                    IF Rec.Acción = Rec.Acción::" " THEN
                        Rec.Acción := Rec.Acción::Traer
                    ELSE
                        Rec.Acción := Rec.Acción::" ";

                    Rec.MODIFY();
                END;
            UNTIL Rec.NEXT() = 0;
        Rec.RESET();
    end;

    procedure SetTempRecords(var TempAuxPlanCorporativo: Record "Aux plan corporativo" temporary)
    begin
        Rec.Copy(TempAuxPlanCorporativo, true);
    end;
}