pageextension 50056 "Payment Methods Ext" extends "Payment Methods"
{
    layout
    {
        addafter("SII Payment Method Code")
        {
            field(Transfer; Rec.Transfer)
            {
                ApplicationArea = All;
            }
        }
    }
}
