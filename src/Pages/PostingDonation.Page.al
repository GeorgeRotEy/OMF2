page 50000 "Posting Donation"
{
    // //Mód S2G (JGS) 18/12/17 Creacion de página para registro de donaciones.

    PageType = List;
    Caption = 'Posting Donation', Comment = 'ESP="Registro donaciones"';
    SourceTable = Donation;
    SourceTableView = SORTING("No.")
                      WHERE(Post = CONST(false));
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
                field(Third; Rec.Third)
                {
                }
                field(Donor; Rec.Donor)
                {
                }
                field(Post; Rec.Post)
                {
                }
                field("Posting date"; Rec."Posting date")
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Registrar)
            {
                Image = Post;
                Caption = 'Register', Comment = 'ESP="Registrar"';

                trigger OnAction()
                var
                    locDonation: Record Donation;
                    locUser: Record User;
                begin

                    //Mod. S2G (SEG) 16/01/2018 Evitar registros en blanco BEGIN

                    Rec.TESTFIELD("Posting date");
                    Rec.TESTFIELD(Amount);
                    Rec.TESTFIELD(Donor);

                    //Mod. S2G (SEG) 16/01/2018 END

                    //Mod. S2G (JMP) 4/1/2018. Indicar que las líneas seleccionadas se han registran, grabando el Usuario que ejecuta la acción
                    //y la fecha en que la ejecuta. INICIO.

                    CurrPage.SETSELECTIONFILTER(locDonation);

                    IF locDonation.FINDSET() THEN
                        REPEAT
                            locDonation.Post := TRUE;
                            locUser.RESET();
                            locUser.SETRANGE("User Name", USERID);
                            IF locUser.FINDFIRST() THEN
                                locDonation."User ID" := locUser."User Name";
                            locDonation."Registro interno" := WORKDATE;
                            locDonation.MODIFY();
                        UNTIL locDonation.NEXT() = 0;

                    CurrPage.UPDATE;

                    //Mod. S2G (JMP) 4/1/2018. Indicar que las líneas seleccionadas se han registran, grabando el Usuario que ejecuta la acción
                    //y la fecha en que la ejecuta. FIN
                end;
            }
        }
    }
}
