pageextension 50073 "Purchase Quote Archive Sub Ext" extends "Purchase Quote Archive Subform"
{
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
