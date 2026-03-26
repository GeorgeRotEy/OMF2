pageextension 50093 "Sales Invoice List Ext" extends "Sales Invoice List"
{
    // //M�d. S2G (JGS) 02/02/2018
    //       Nuevo campo : Importe IVA incluido

    layout
    {
        moveafter(Amount; "Amount Including VAT")
        addafter("Amount Including VAT")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
            }
            field(Email; Rec.Email)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                // (CJ08) S2G (JDT) 25-10-19:
                Rec.fBloquearRegistro;
                // (CJ08) S2G (JDT) 25-10-19:
            end;
        }
        modify("Post &Batch")
        {
            trigger OnBeforeAction()
            begin
                // (CJ08) S2G (JDT) 25-10-19:
                Rec.fBloquearRegistro;
                // (CJ08) S2G (JDT) 25-10-19:
            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            begin
                // (CJ08) S2G (JDT) 25-10-19:
                Rec.fBloquearRegistro;
                // (CJ08) S2G (JDT) 25-10-19:
            end;
        }
    }
}
