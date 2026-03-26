pageextension 50004 "G/L Budget Entries Ext" extends "G/L Budget Entries"
{
    //(CR001) S2G (RBM-R) 09-08-18: Comentarios en presupuestos
    layout
    {
        addafter("Entry No.")
        {
            field("Budget Comment"; Rec."Budget Comment")
            {
                ApplicationArea = All;
            }
        }
    }
}
