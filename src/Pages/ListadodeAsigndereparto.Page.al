page 50019 "Listado de Asign. de  reparto"
{
    CardPageID = "Analytical Distribution";
    Caption = 'Distribution Assignment List', Comment = 'ESP="Listado de asign. de reparto"';
    Editable = false;
    PageType = List;
    SourceTable = "Analytical Distribution Hdr.";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field(Level; Rec.Level)
                {
                }
                field("Valid from date"; Rec."Valid from date")
                {
                }
                field("Valid to date"; Rec."Valid to date")
                {
                }
                field("Source dimension code"; Rec."Source dimension code")
                {
                }
                field("Destination dimension code"; Rec."Destination dimension code")
                {
                }
                field("Account interval"; Rec."Account interval")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
            }
        }
    }

    actions
    {
    }
}
