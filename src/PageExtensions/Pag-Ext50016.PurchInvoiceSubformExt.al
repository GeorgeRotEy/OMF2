pageextension 50016 "Posted Purch. Invoice Sub Ext" extends "Posted Purch. Invoice Subform"
{
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        moveafter("Depr. Acquisition Cost"; "VAT %")
        addafter("VAT %")
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
