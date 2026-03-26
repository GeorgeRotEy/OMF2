page 50001 "History Donation"
{
    // //Mód, S2G (SEG) 16/01/18 :   -Nuevas variables: (rgDonation, Reportdon)
    //                               -Page Action : Carta donación
    Caption = 'Donation History', Comment = 'ESP="Histórico donaciones"';
    Editable = false;
    PageType = List;
    SourceTable = Donation;
    SourceTableView = WHERE(Post = CONST(true));
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
                field(Post; Rec.Post)
                {
                    Caption = 'Post';
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
        area(processing)
        {
            action("Carta donación")
            {
                Image = "Report";
                Caption = 'Donation Letter', Comment = 'ESP="Carta de donación"';

                trigger OnAction()
                begin
                    //Mód. S2G (SEG) 16.01.18 Botón para generar carta de donación BEGIN
                    rgDonation.RESET();
                    CurrPage.SETSELECTIONFILTER(rgDonation);
                    CLEAR(Reportdon);
                    Reportdon.SETTABLEVIEW(rgDonation);
                    Reportdon.RUN();
                    //Mód. S2G (SEG) 16.01.18 END
                end;
            }
        }
    }

    var
        rgDonation: Record Donation;
        Reportdon: Report "Recibo donaciones";
}
