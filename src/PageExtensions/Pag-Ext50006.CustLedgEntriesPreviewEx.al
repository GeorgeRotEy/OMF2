pageextension 50006 "Cust. Ledg. Entries Preview Ex" extends "Cust. Ledg. Entries Preview"
{
    layout
    {
        addafter("Remaining Pmt. Disc. Possible")
        {
            field("Sales (LCY)"; Rec."Sales (LCY)")
            {
                ApplicationArea = All;
            }
        }
    }
}
