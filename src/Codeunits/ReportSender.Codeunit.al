
codeunit 50004 "Report Sender"
{
    // Mod. S2G (RBM-R) GF-006: Report delivery
    // KPMG.GRL Send the report on a configured day of the month.
    // TEMS-363 Add ShowRowNo.

    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        RepAccountSchedule: Report "Account Schedule";
        DateRange: Text;
        StartDate: Date;
        EndDate: Date;
    begin
        ReportSenderSetup.Reset();
        ReportSenderSetup.SetRange(Active, true);

        GLBudgetName.Reset();
        GLBudgetName.SetRange(Active, true);
        if not GLBudgetName.FindFirst() then
            exit;

        if not ReportSenderSetup.FindSet() then
            exit;

        repeat
            if ShouldSendReport(ReportSenderSetup."Day of the month") then begin
                Clear(RepAccountSchedule);

                FileName := GetAttachmentFileName(ReportSenderSetup);
                GetPreviousMonthDateRange(StartDate, EndDate);
                DateRange := Format(StartDate) + '..' + Format(EndDate);

                RepAccountSchedule.SetAccSchedNameNonEditable(ReportSenderSetup."Acc. Schedule Name");
                RepAccountSchedule.SetColumnLayoutName(ReportSenderSetup."Column Layout Name");
                RepAccountSchedule.SetFilters(DateRange, GLBudgetName.Name, '', '', '', '', '', '');
                SendAccountScheduleReport(RepAccountSchedule, ReportSenderSetup.Email, FileName, DateRange);
            end;
        until ReportSenderSetup.Next() = 0;
    end;

    local procedure SendAccountScheduleReport(var RepAccountSchedule: Report "Account Schedule"; RecipientEmail: Text[250]; AttachmentFileName: Text; DateRange: Text)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
    begin
        TempBlob.CreateOutStream(OutStr);
        RepAccountSchedule.SaveAs('', ReportFormat::Pdf, OutStr);
        TempBlob.CreateInStream(InStr);

        EmailMessage.Create(RecipientEmail, AttachmentFileName, StrSubstNo(BodyLbl, AttachmentFileName, DateRange) + 'Enviado desde la empresa :' + CompanyName(), false);
        EmailMessage.AddAttachment(AttachmentFileName, PdfContentTypeLbl, InStr);
        Email.Send(EmailMessage);
    end;

    local procedure ShouldSendReport(DayOfMonth: Integer): Boolean
    begin
        exit((DayOfMonth = 0) or (Date2DMY(Today(), 1) = DayOfMonth));
    end;

    local procedure GetAttachmentFileName(ReportsSenderSetup: Record "Reports Sender Setup"): Text
    begin
        exit(ReportsSenderSetup."Acc. Schedule Name" + '_' + ConvertStr(Format(Today()), '/', '_') + CompanyName() + '.pdf');
    end;

    local procedure GetPreviousMonthDateRange(var StartDate: Date; var EndDate: Date)
    var
        CurrentMonth: Integer;
        CurrentYear: Integer;
    begin
        CurrentMonth := Date2DMY(Today(), 2);
        CurrentYear := Date2DMY(Today(), 3);

        if CurrentMonth = 1 then begin
            StartDate := DMY2Date(1, 12, CurrentYear - 1);
            EndDate := DMY2Date(31, 12, CurrentYear - 1);
            exit;
        end;

        StartDate := DMY2Date(1, CurrentMonth - 1, CurrentYear);
        EndDate := CalcDate('+1M-1D', StartDate);
    end;

    var
        ReportSenderSetup: Record "Reports Sender Setup";
        GLBudgetName: Record "G/L Budget Name";
        FileName: Text;
        BodyLbl: Label 'Informe %1 correspondiente al periodo %2';
        PdfContentTypeLbl: Label 'application/pdf', Locked = true;
}
