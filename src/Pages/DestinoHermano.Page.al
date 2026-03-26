page 50015 "Destino Hermano"
{
    PageType = List;
    Caption = 'Friar Destination', Comment = 'ESP="Destino Hermano"';
    SourceTable = "Friar Ledger Entry";
    SourceTableView = SORTING("Date start")
                      ORDER(Descending);
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Fraternity; Rec.Fraternity)
                {
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("No. Serie Friar"; Rec."No. Serie Friar")
                {
                    TableRelation = Friar."No. Serie Friar";

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Nombre Hermano"; Rec."Nombre Hermano")
                {
                }
                field("Apellidos Hermano"; Rec."Apellidos Hermano")
                {
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field("Date start"; Rec."Date start")
                {
                    DrillDown = true;
                }
                field("Date end"; Rec."Date end")
                {
                }
                field(Comments; Rec.Comments)
                {
                }
                field(Active; Rec.Active)
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field(City; Rec.City)
                {
                }
                field(Trienio; Rec.Trienio)
                {
                    Visible = false;
                }
                field("Extra Domum"; Rec."Extra Domum")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::destino;
        IF gFriarCode <> '' THEN
            Rec."No. Serie Friar" := gFriarCode;
    end;

    var
        gFriarCode: Code[20];

    procedure setFriarCode(pFriarCode: Code[20])
    begin
        gFriarCode := pFriarCode;
    end;
}
