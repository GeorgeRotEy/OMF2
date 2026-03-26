pageextension 50030 "General Ledger Entries Ext" extends "General Ledger Entries"
{
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
    //   (SIDS-466) S2G (LAG) 26-02-20: Mod dimensiones acceso directo.
    //     New Fields:
    //       -Shortcut Dimension 3
    //       -Shortcut Dimension 4
    //       -Shortcut Dimension 5
    //       -Shortcut Dimension 6

    DataCaptionExpression = GetCaption();
    layout
    {
        //Intercompany
        // modify("IC Partner Code")
        // {
        //     Visible = false;
        // }
        addafter(Description)
        {
            field("Posting concept"; Rec."Posting concept")
            {
                ApplicationArea = All;
            }
        }
        addafter("Entry No.")
        {
            field("Source Description"; Rec."Source Description")
            {
                ApplicationArea = All;
            }
            field("<Account Name>"; vGLAcc.Name)
            {
                Caption = 'Nombre cuenta';
                ApplicationArea = All;
            }
            field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 4"; Rec."Shortcut Dimension 4")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 5"; Rec."Shortcut Dimension 5")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 6"; Rec."Shortcut Dimension 6")
            {
                ApplicationArea = All;
            }
        }
        moveafter(Amount; "Source Code")
        moveafter("Source Code"; "Source No.")
        moveafter("<Account Name>"; "Business Unit Code")
        moveafter("Business Unit Code"; "External Document No.")
    }

    var
        vGLAcc: Record "G/L Account";

    local procedure GetCaption(): Text[250]
    begin
        IF vGLAcc."No." <> Rec."G/L Account No." THEN
            IF NOT vGLAcc.GET(Rec."G/L Account No.") THEN
                IF Rec.GETFILTER(Rec."G/L Account No.") <> '' THEN
                    IF vGLAcc.GET(Rec.GETRANGEMIN(Rec."G/L Account No.")) THEN;
        EXIT(STRSUBSTNO('%1 %2', vGLAcc."No.", vGLAcc.Name))
    end;
}
