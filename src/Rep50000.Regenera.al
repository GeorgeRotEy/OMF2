report 50015 "Regenera"
{
    ApplicationArea = All;
    Caption = 'Regenera';
    UsageCategory = Tasks;
    UseRequestPage = false;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Invoice Header" = RIMD,
                  tabledata "Sales Cr.Memo Header" = RIMD;

    trigger OnPreReport()
    begin
        vWindow.Open(tText000Lbl);
    end;

    trigger OnPostReport()
    var
        rlCompany: Record Company;
    begin
        if rlCompany.FindSet() then
            repeat
                vWindow.Update(1, rlCompany.Name);
                fProcessCompany(rlCompany.Name);
            until rlCompany.Next() = 0;

        vWindow.Close();
        Message('Proceso completado');
    end;

    local procedure fProcessCompany(pCompanyName: Text[30])
    begin
        fModifySalesInvHeader(pCompanyName);
        fModifySalesCrMemoHeader(pCompanyName);
    end;

    local procedure fModifySalesInvHeader(pCompanyName: Text[30])
    var
        rlSalesInvHeader: Record "Sales Invoice Header";
    begin
        vWindow.Update(2, rlSalesInvHeader.TableCaption);
        rlSalesInvHeader.ChangeCompany(pCompanyName);

        if rlSalesInvHeader.FindSet() then
            repeat
                if rlSalesInvHeader."Language Code" = '' then
                    rlSalesInvHeader."Language Code" := 'ESP';

                rlSalesInvHeader.Modify();
            until rlSalesInvHeader.Next() = 0;
    end;

    local procedure fModifySalesCrMemoHeader(pCompanyName: Text[30])
    var
        rlSalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        vWindow.Update(2, rlSalesCrMemoHeader.TableCaption);
        rlSalesCrMemoHeader.ChangeCompany(pCompanyName);

        if rlSalesCrMemoHeader.FindSet() then
            repeat
                if rlSalesCrMemoHeader."Language Code" = '' then
                    rlSalesCrMemoHeader."Language Code" := 'ESP';

                rlSalesCrMemoHeader.Modify();
            until rlSalesCrMemoHeader.Next() = 0;
    end;

    var
        vWindow: Dialog;
        tText000Lbl: Label 'Empresa: #1\Tabla: #2#####################################';
}
