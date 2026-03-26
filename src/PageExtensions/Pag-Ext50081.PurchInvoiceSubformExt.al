pageextension 50081 "Purch. Invoice Subform Ext" extends "Purch. Invoice Subform"
{
    // (SIDS-466) S2G (LAG): Mod dimension acceso directo:
    //     -Cambiamos Propiedad visible a TRUE de los siguientes campos:
    //       -ShortcutDimCode[3]
    //       -ShortcutDimCode[4]
    //       -ShortcutDimCode[5]
    //       -ShortcutDimCode[6]

    layout
    {
        modify(ShortcutDimCode3)
        {
            Visible = true;
        }
        modify(ShortcutDimCode4)
        {
            Visible = true;
        }
        modify(ShortcutDimCode5)
        {
            Visible = true;
        }
        modify(ShortcutDimCode6)
        {
            Visible = true;
        }
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
