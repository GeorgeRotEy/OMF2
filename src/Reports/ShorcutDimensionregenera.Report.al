report 50090 "Shorcut Dimension regenera"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            trigger OnAfterGetRecord()
            begin
                rGLSetup.GET();
                bChange := FALSE;

                IF rGLSetup."Shortcut Dimension 3 Code" <> '' THEN
                    IF rDimSetEntry.GET("G/L Entry"."Dimension Set ID", rGLSetup."Shortcut Dimension 3 Code") THEN BEGIN
                        "G/L Entry"."Shortcut Dimension 3" := rDimSetEntry."Dimension Value Code";
                        bChange := TRUE;
                    END;

                IF rGLSetup."Shortcut Dimension 4 Code" <> '' THEN
                    IF rDimSetEntry.GET("G/L Entry"."Dimension Set ID", rGLSetup."Shortcut Dimension 4 Code") THEN BEGIN
                        "G/L Entry"."Shortcut Dimension 4" := rDimSetEntry."Dimension Value Code";
                        bChange := TRUE;
                    END;

                IF rGLSetup."Shortcut Dimension 5 Code" <> '' THEN
                    IF rDimSetEntry.GET("G/L Entry"."Dimension Set ID", rGLSetup."Shortcut Dimension 5 Code") THEN BEGIN
                        "G/L Entry"."Shortcut Dimension 5" := rDimSetEntry."Dimension Value Code";
                        bChange := TRUE;
                    END;

                IF rGLSetup."Shortcut Dimension 6 Code" <> '' THEN
                    IF rDimSetEntry.GET("G/L Entry"."Dimension Set ID", rGLSetup."Shortcut Dimension 6 Code") THEN BEGIN
                        "G/L Entry"."Shortcut Dimension 6" := rDimSetEntry."Dimension Value Code";
                        bChange := TRUE;
                    END;

                IF bChange THEN
                    "G/L Entry".MODIFY();
            end;
        }
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            trigger OnAfterGetRecord()
            begin
                rGLSetup.GET();
                bChange := FALSE;

                IF rGLSetup."Shortcut Dimension 3 Code" <> '' THEN
                    IF rDimSetEntry.GET("Bank Account Ledger Entry"."Dimension Set ID", rGLSetup."Shortcut Dimension 3 Code") THEN BEGIN
                        "Bank Account Ledger Entry"."Shortcut Dimension 3" := rDimSetEntry."Dimension Value Code";
                        bChange := TRUE;
                    END;

                IF rGLSetup."Shortcut Dimension 4 Code" <> '' THEN
                    IF rDimSetEntry.GET("Bank Account Ledger Entry"."Dimension Set ID", rGLSetup."Shortcut Dimension 4 Code") THEN BEGIN
                        "Bank Account Ledger Entry"."Shortcut Dimension 4" := rDimSetEntry."Dimension Value Code";
                        bChange := TRUE;
                    END;

                IF rGLSetup."Shortcut Dimension 5 Code" <> '' THEN
                    IF rDimSetEntry.GET("Bank Account Ledger Entry"."Dimension Set ID", rGLSetup."Shortcut Dimension 5 Code") THEN BEGIN
                        "Bank Account Ledger Entry"."Shortcut Dimension 5" := rDimSetEntry."Dimension Value Code";
                        bChange := TRUE;
                    END;

                IF rGLSetup."Shortcut Dimension 6 Code" <> '' THEN
                    IF rDimSetEntry.GET("Bank Account Ledger Entry"."Dimension Set ID", rGLSetup."Shortcut Dimension 6 Code") THEN BEGIN
                        "Bank Account Ledger Entry"."Shortcut Dimension 6" := rDimSetEntry."Dimension Value Code";
                        bChange := TRUE;
                    END;

                IF bChange THEN
                    "Bank Account Ledger Entry".MODIFY();
            end;
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        MESSAGE('Proceso finalizado')
    end;

    var
        rDimSetEntry: Record "Dimension Set Entry";
        rGLSetup: Record "General Ledger Setup";
        bChange: Boolean;
}
