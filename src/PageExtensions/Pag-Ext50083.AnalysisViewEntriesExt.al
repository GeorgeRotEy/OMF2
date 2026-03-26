pageextension 50083 "Analysis View Entries Ext" extends "Analysis View Entries"
{
    // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n.
    //       - Mostrar campo "Source Code"

    layout
    {
        addafter("Add.-Curr. Credit Amount")
        {
            field("Source Code"; Rec."Source Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
