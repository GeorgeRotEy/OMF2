pageextension 50103 "Purch Return Order List Ext" extends "Purchase Return Order List"
{
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
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                // (CJ08) S2G (JDT) 25-10-19:
                Rec.fBloquearRegistro;
                // (CJ08) S2G (JDT) 25-10-19:
            end;
        }
        modify(PostBatch)
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
