pageextension 50102 "Blanket Purchase Orders Ext" extends "Blanket Purchase Orders"
{
    actions
    {
        modify(MakeOrder)
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
