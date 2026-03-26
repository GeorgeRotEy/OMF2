page 50014 "Situación Laboral"
{
    PageType = List;
    Caption = 'Employment Situation', Comment = 'ESP="Situación Laboral"';
    SourceTable = "Friar Ledger Entry";
    SourceTableView = SORTING("No. Mov")
                      ORDER(Ascending)
                      WHERE(Type = CONST("Situación Laboral"));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Serie Friar"; Rec."No. Serie Friar")
                {
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field("Date start"; Rec."Date start")
                {
                }
                field("Date end"; Rec."Date end")
                {
                }
                field("Self employee"; Rec."Self employee")
                {
                }
                field("No Seguridad Social"; Rec."No Seguridad Social")
                {
                }
                field(Active; Rec.Active)
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
        Rec.Type := Rec.Type::"situación laboral";
    end;
}
