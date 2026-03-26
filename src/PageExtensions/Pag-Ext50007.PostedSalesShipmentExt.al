pageextension 50007 "Posted Sales Shipment Ext" extends "Posted Sales Shipment"
{
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Control IRPF"; Rec."Control IRPF")
            {
                ApplicationArea = All;
            }
            field("Grupo registro IRPF"; Rec."Grupo registro IRPF")
            {
                ApplicationArea = All;
            }
        }
    }
}
