page 50033 "Bancos WS"
{
    Caption = 'Banks WS', Comment = 'ESP="Bancos WS"';
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Bank Account";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Search Name"; Rec."Search Name")
                {
                }
                field("Name 2"; Rec."Name 2")
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field(City; Rec.City)
                {
                }
                field(Contact; Rec.Contact)
                {
                }
                field("Phone No."; Rec."Phone No.")
                {
                }
                field("Telex No."; Rec."Telex No.")
                {
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                }
                field("Transit No."; Rec."Transit No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}
