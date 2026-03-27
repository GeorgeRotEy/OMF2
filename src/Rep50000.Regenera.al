report 50015 "Regenera"
{
    ApplicationArea = All;
    Caption = 'Regenera';
    UsageCategory = Tasks;
    UseRequestPage = false;
    ProcessingOnly = true;
    Permissions = tabledata "VAT Registration Log" = m,
                  tabledata "Acc. Schedule Line" = m,
                  tabledata "Analysis View" = m,
                  tabledata "Gen. Journal Template" = m;

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
        fModifyVATRegistrationLog(pCompanyName);
        fModifyAccScheduleLine(pCompanyName);
        fModifyAnalysisView(pCompanyName);
        fModifyGenJnlTemplate(pCompanyName);
        fModifyGLSetup(pCompanyName);
        fModifyDepreciationBook(pCompanyName);
    end;

    local procedure fModifyVATRegistrationLog(pCompanyName: Text[30])
    var
        rlVATRegistrationLog: Record "VAT Registration Log";
    begin
        vWindow.Update(2, rlVATRegistrationLog.TableCaption);
        rlVATRegistrationLog.ChangeCompany(pCompanyName);

        if rlVATRegistrationLog.FindSet() then
            repeat
                if rlVATRegistrationLog."Account Type" = rlVATRegistrationLog."Account Type"::ThirdParty then
                    rlVATRegistrationLog."Account Type" := rlVATRegistrationLog."Account Type"::PostThirdParty;

                if rlVATRegistrationLog."Account Type" = rlVATRegistrationLog."Account Type"::"Company Information" then
                    rlVATRegistrationLog."Account Type" := rlVATRegistrationLog."Account Type"::"Third Party";

                rlVATRegistrationLog.Modify();
            until rlVATRegistrationLog.Next() = 0;
    end;

    local procedure fModifyAccScheduleLine(pCompanyName: Text[30])
    var
        rlAccScheduleLine: Record "Acc. Schedule Line";
    begin
        vWindow.Update(2, rlAccScheduleLine.TableCaption);
        rlAccScheduleLine.ChangeCompany(pCompanyName);

        if rlAccScheduleLine.FindSet() then
            repeat
                if rlAccScheduleLine."Totaling Type" = rlAccScheduleLine."Totaling Type"::"Account Category" then
                    rlAccScheduleLine."Totaling Type" := rlAccScheduleLine."Totaling Type"::"Distribution Entry";

                rlAccScheduleLine.Modify();
            until rlAccScheduleLine.Next() = 0;
    end;

    local procedure fModifyAnalysisView(pCompanyName: Text[30])
    var
        rlAnalysisView: Record "Analysis View";
    begin
        vWindow.Update(2, rlAnalysisView.TableCaption);
        rlAnalysisView.ChangeCompany(pCompanyName);

        if rlAnalysisView.FindSet() then
            repeat
                if rlAnalysisView."Account Source" = rlAnalysisView."Account Source"::"Distr. Account" then
                    rlAnalysisView."Account Source" := rlAnalysisView."Account Source"::"Distribution Account";

                rlAnalysisView.Modify();
            until rlAnalysisView.Next() = 0;
    end;

    local procedure fModifyGenJnlTemplate(pCompanyName: Text[30])
    var
        rlGenJnlTemplate: Record "Gen. Journal Template";
    begin
        vWindow.Update(2, rlGenJnlTemplate.TableCaption);
        rlGenJnlTemplate.ChangeCompany(pCompanyName);

        if rlGenJnlTemplate.FindSet() then
            repeat
                if rlGenJnlTemplate.Type = rlGenJnlTemplate.Type::"Easy Register" then
                    rlGenJnlTemplate.Type := rlGenJnlTemplate.Type::EasyRegister;

                if rlGenJnlTemplate.Type = rlGenJnlTemplate.Type::"Cash Register" then
                    rlGenJnlTemplate.Type := rlGenJnlTemplate.Type::CashRegister;

                rlGenJnlTemplate.Modify();
            until rlGenJnlTemplate.Next() = 0;
    end;

    local procedure fModifyGLSetup(pCompanyName: Text[30])
    var
        rlGLSetup: Record "General Ledger Setup";
    begin
        vWindow.Update(2, rlGLSetup.TableCaption);
        rlGLSetup.ChangeCompany(pCompanyName);

        if rlGLSetup.Get() then begin
            rlGLSetup."Cta. debe IT" := '4760001';

            rlGLSetup."Cta. haber IT Pers. Vig./Rec." := '6463001';

            rlGLSetup."Cta. haber IT Pers. C/C" := '6462001';

            rlGLSetup."Cta. haber IT Pers. limpieza" := '6464001';

            rlGLSetup."Cta. haber IT Pers. enfermeria" := '6468001';

            rlGLSetup."Cta. haber IT Pers. bibloteca" := '6467001';

            rlGLSetup."Cta. haber IT Otro colaborador" := '6469001';

            rlGLSetup.Modify();
        end;
    end;

    local procedure fModifyDepreciationBook(pCompanyName: Text[30])
    var
        rlDepBook: Record "Depreciation Book";
    begin
        vWindow.Update(2, rlDepBook.TableCaption);
        rlDepBook.ChangeCompany(pCompanyName);

        if rlDepBook.FindSet() then
            repeat
                rlDepBook."G/L Integration - Acq. Cost" := true;
                rlDepBook."G/L Integration - Depreciation" := true;
                rlDepBook."G/L Integration - Write-Down" := true;
                rlDepBook."G/L Integration - Appreciation" := true;
                rlDepBook."G/L Integration - Custom 1" := true;
                rlDepBook."G/L Integration - Custom 2" := true;
                rlDepBook."G/L Integration - Disposal" := true;
                rlDepBook."G/L Integration - Maintenance" := true;

                rlDepBook.Modify();
            until rlDepBook.Next() = 0;
    end;

    var
        vWindow: Dialog;
        tText000Lbl: Label 'Empresa: #1###############\Tabla: @2@@@@@@@@@@@@@@@@';
}
