pageextension 50080 "Dimension List Ext" extends "Dimension List"
{
    // Mod S2G (ABC) 09/10/17 ANA001: Reparto anal�tico
    //       - Sacados campos en la page
    layout
    {
        addafter(Name)
        {
            field(Distribution; Rec.Distribution)
            {
                ApplicationArea = All;
            }
            field("Do not split if assigned"; Rec."Do not split if assigned")
            {
                ApplicationArea = All;
            }
        }
    }
}
