report 50091 "Proceso marcar Forzar saldo"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                Company.RESET();
                Company.SETFILTER(Name, 'FRA*');
                IF Company.FINDSET() THEN
                    REPEAT
                        GenJournalTemplate.CHANGECOMPANY(Company.Name);
                        GenJournalTemplate.GET('GENERAL');
                        GenJournalTemplate."Force Doc. Balance" := TRUE;
                        GenJournalTemplate.MODIFY();
                    UNTIL Company.NEXT() = 0;
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
        GenJournalTemplate: Record "Gen. Journal Template";
        Company: Record Company;
}
