report 99999 ChecksCuenta
{
    Caption = 'ChecksCuenta', Comment = 'ESP="ChecksCuenta"';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin

                "G/L Account"."Baja en Plan Corporativo" := TRUE;
                "G/L Account".Blocked := TRUE;
                "G/L Account".MODIFY();
            end;

            trigger OnPostDataItem()
            begin
                MESSAGE(FORMAT("G/L Account".COUNT))
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
}
