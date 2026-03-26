page 50032 "Proveedores WS"
{
    PageType = List;
    Caption = 'Vendors WS', Comment = 'ESP="Proveedores WS"';
    SourceTable = Vendor;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Name 2"; Rec."Name 2")
                {
                }
                field("Search Name"; Rec."Search Name")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("No."; Rec."No.")
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
                field("Our Account No."; Rec."Our Account No.")
                {
                }
                field("Last date modified"; Rec."Last date modified")
                {
                }
            }
        }
    }

    actions
    {
    }
}
