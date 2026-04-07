namespace DataSchema.DataSchema;

report 50010 "Delete EDUCAMOS Pagadores"
{
    ApplicationArea = All;
    Caption = 'Delete EDUCAMOS Pagadores';
    UsageCategory = Tasks;
    UseRequestPage = false;
    ProcessingOnly = true;
    Permissions = tabledata "EDUCAMOS Pagador" = RIMD;

    trigger OnPreReport()
    var
        rlPagadores: Record "EDUCAMOS Pagador";
    begin
        rlPagadores.FindFirst();
        rlPagadores.DeleteAll();
    end;
}
