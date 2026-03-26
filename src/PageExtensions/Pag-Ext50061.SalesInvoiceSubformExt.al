pageextension 50061 "Sales Invoice Subform Ext" extends "Sales Invoice Subform"
{
    // (SIDS-466) S2G (LAG): Mod dimension acceso directo:
    //     -Cambiamos Propiedad visible a TRUE de los siguientes campos:
    //       -ShortcutDimCode[3]
    //       -ShortcutDimCode[4]
    //       -ShortcutDimCode[5]
    //       -ShortcutDimCode[6]
    layout
    {
        moveafter(ShortcutDimCode8; "Gen. Prod. Posting Group")
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
            field("IRPF Posting Group"; Rec."IRPF Posting Group")
            {
                ApplicationArea = All;
            }
            field("IRPF Line"; Rec."IRPF Line")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
}
