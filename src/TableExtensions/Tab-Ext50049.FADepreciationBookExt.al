tableextension 50049 "FA Depreciation Book Ext" extends "FA Depreciation Book"
{
    fields
    {
        modify("FA Posting Group")
        {
            trigger OnAfterValidate()
            var
                rlFAPostingGroup: Record "FA Posting Group";
            begin
                //Mod. S2G (JPB) 02-07-2019: INICIO
                rlFAPostingGroup.RESET();
                rlFAPostingGroup.SETRANGE(Code, "FA Posting Group");
                IF rlFAPostingGroup.FINDSET() THEN BEGIN
                    "Straight-Line %" := rlFAPostingGroup."Related Straight-Line %";
                    VALIDATE("Straight-Line %");
                    MODIFY(TRUE);
                END;
                //Mod. S2G (JPB) 02-07-2019: FIN
            end;
        }
    }
}
