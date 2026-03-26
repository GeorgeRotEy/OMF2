pageextension 50014 "Posted Purchase Rcpt. Sub Ext" extends "Posted Purchase Rcpt. Subform"
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
