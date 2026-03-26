pageextension 50095 "Blanket Sales Orders Ext" extends "Blanket Sales Orders"
{
    actions
    {
        modify("Make &Order")
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
