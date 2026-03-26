pageextension 50079 "Dimensions Ext" extends Dimensions
{
    //(CR003) S2G (RBM-R) 12-11-18: Modificaciones Registro simple

    layout
    {
        addafter("Consolidation Code")
        {
            field("Easy Register Dimension"; Rec."Easy Register Dimension")
            {
                ApplicationArea = All;
            }
        }
    }
}
