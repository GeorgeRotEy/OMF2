pageextension 50018 "Posted Purch. Cr. Memo Sub Ext" extends "Posted Purch. Cr. Memo Subform"
{
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        addafter("Appl.-to Item Entry")
        {
            field("Grupo registro IRPF"; Rec."Grupo registro IRPF")
            {
                ApplicationArea = All;
            }
            field("Línea IRPF"; Rec."Línea IRPF")
            {
                ApplicationArea = All;
            }
        }
    }
}
