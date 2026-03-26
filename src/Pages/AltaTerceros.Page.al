page 50046 "Alta Terceros "
{
    Caption = 'Post Third Party', Comment = 'ESP="Alta terceros"';
    RefreshOnActivate = true;
    SourceTable = "Alta Terceros";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("Country/Region Code"; Rec."Country/Region Code")
            {
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ShowMandatory = true;
            }
            field("Post Code"; Rec."Post Code")
            {
            }
            field(City; Rec.City)
            {
            }
            field(County; Rec.County)
            {
            }
            field(Name; Rec.Name)
            {
            }
            field(Address; Rec.Address)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Crear Tercero")
            {
                Image = CreateDocument;
                Caption = 'Create Third Party', Comment = 'ESP="Crear Tercero"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec.fCheckCampos;
                    Rec.fTransferDatos;
                    Rec.DELETE();
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CLEAR(Rec);
    end;
}
