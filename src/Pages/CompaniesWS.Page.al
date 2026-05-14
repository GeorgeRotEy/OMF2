page 50034 "Companies WS"
{
    PageType = List;
    Caption = 'Companies WS', Comment = 'ESP="Empresas WS"';
    SourceTable = "Company OFM";
    SourceTableView = SORTING(Name)
                      WHERE("Easy Register" = CONST(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; rec."Company ID")
                {
                    Caption = 'Id';
                }
                field(Name; Rec.Name)
                {
                }

            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        EmptyCompanyId: Guid;
    begin
        SyncCompanyIds();
        Clear(EmptyCompanyId);
        Rec.SetFilter("Company Id", '<>%1', EmptyCompanyId);
    end;

    local procedure SyncCompanyIds()
    var
        Company: Record Company;
        CompanyOFM: Record "Company OFM";
        CompanyId: Guid;
    begin
        if CompanyOFM.FindSet(true) then
            repeat
                Clear(CompanyId);
                if Company.Get(CompanyOFM.Name) then
                    CompanyId := Company.Id;

                if CompanyOFM."Company Id" <> CompanyId then begin
                    CompanyOFM."Company Id" := CompanyId;
                    CompanyOFM.Modify();
                end;
            until CompanyOFM.Next() = 0;
    end;
}
