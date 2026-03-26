page 50003 "Donaciones test"
{
    // Es una pagina demo para presentar posibilidades a cliente (Eliminar)

    PageType = Card;
    Caption = 'Donations Test', Comment = 'ESP="Donaciones test"';
    SourceTable = Donation;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                }
                field(Post; Rec.Post)
                {
                }
                field("Posting date"; Rec."Posting date")
                {
                }
                field(Donor; Rec.Donor)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Dimension budget"; Rec."Dimension budget")
                {
                }
                field(Third; Rec.Third)
                {
                }
            }
        }
    }

    actions
    {
    }
}
