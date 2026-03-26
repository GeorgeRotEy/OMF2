pageextension 50089 "Purchase Return Order Sub Ext" extends "Purchase Return Order Subform"
{
    layout
    {
        addafter("Job Line Type")
        {
            field("Grupo registro IRPF"; Rec."Grupo registro IRPF")
            {
                ApplicationArea = All;
            }
            field("Línea IRPF"; Rec."Línea IRPF")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
}
