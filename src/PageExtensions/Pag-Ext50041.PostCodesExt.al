pageextension 50041 "Post Codes Ext" extends "Post Codes"
{
    Caption = 'Post Codes', Comment = 'ESP="Fraternidades"';

    layout
    {
        addbefore(Code)
        {
            field(Fraternity; Rec.Fraternity)
            {
                ApplicationArea = All;
            }
        }
        addafter("County Code")
        {
            field("Adress Fraternity"; Rec."Adress Fraternity")
            {
                ApplicationArea = All;
            }
            field("Phone No."; Rec."Phone No.")
            {
                ApplicationArea = All;
            }
            field(NIF; Rec.NIF)
            {
                ApplicationArea = All;
            }
            field("Cod. RER"; Rec."Cod. RER")
            {
                ApplicationArea = All;
            }
            field("Cod. CNAE"; Rec."Cod. CNAE")
            {
                ApplicationArea = All;
            }
            field("Destino Fraternidad Nav"; Rec."Destino Fraternidad Nav")
            {
                ApplicationArea = All;
            }
        }
    }
}
