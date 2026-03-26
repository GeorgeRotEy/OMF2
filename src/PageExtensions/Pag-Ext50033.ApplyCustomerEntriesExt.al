pageextension 50033 "Apply Customer Entries Ext" extends "Apply Customer Entries"
{
    layout
    {
        addafter("Global Dimension 2 Code")
        {
            field("Nº Documento Externo"; Rec."External Document No.")
            {
                Caption = 'Nº Documento Externo';
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
}
