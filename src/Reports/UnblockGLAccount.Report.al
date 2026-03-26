report 99996 "Unblock GLAccount"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Company; Company)
        {
            DataItemTableView = SORTING(Name);
            RequestFilterFields = Name;

            trigger OnAfterGetRecord()
            begin
                GLAccount.RESET();
                GLAccount.CHANGECOMPANY(Company.Name);
                IF GLAccount.FINDSET() THEN
                    REPEAT
                        GLAccount.Blocked := FALSE;
                        GLAccount.MODIFY();
                    UNTIL GLAccount.NEXT() = 0;
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

    var
        GLAccount: Record "G/L Account";
}
