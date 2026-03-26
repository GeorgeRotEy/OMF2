report 50004 "Delete Distribution Entries"
{
    Caption = 'Delete Cost Entries', Comment = 'ESP="Eliminar movimientos de costes"';
    Permissions = TableData "G/L Entry" = rm;
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem5327; 50033)
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Descending);

            trigger OnAfterGetRecord()
            var
                CostEntry: Record "Distribution Entry";
            begin
                Window.UPDATE(1, "No.");

                CostEntry.RESET();
                CostEntry.SETRANGE("Entry No.", "From Entry No.", "To Entry No.");
                CostEntry.DELETEALL();
            end;

            trigger OnPostDataItem()
            begin
                DELETEALL();
                RESET();
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("No.", CostRegister2."No.", CostRegister3."No.");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESP="Opciones"';
                    field(FromRegisterNo; CostRegister2."No.")
                    {
                        Caption = 'From Register No.', Comment = 'ESP="Desde nº registro"';
                        Lookup = true;
                        TableRelation = "Cost Register" WHERE(Closed = CONST(false));
                        ApplicationArea = All;
                    }
                    field(ToRegisterNo; CostRegister3."No.")
                    {
                        Caption = 'To Register No.', Comment = 'ESP="Hasta nº registro"';
                        Editable = false;
                        TableRelation = "Cost Register" WHERE(Closed = CONST(false));
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            CostRegister2.FINDLAST;
            CostRegister3.FINDLAST;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        CostRegister: Record "Cost Register";
    begin
        IF CostRegister2."No." > CostRegister3."No." THEN
            ERROR(Text000Lbl);

        IF NOT CONFIRM(Text001Lbl, FALSE, CostRegister2."No.", CostRegister3."No.") THEN
            ERROR('');

        IF NOT CONFIRM(Text004Lbl) THEN
            ERROR('');

        CostRegister.FINDLAST;
        IF CostRegister."No." > CostRegister3."No." THEN
            ERROR(STRSUBSTNO(CostRegisterHasBeenModifiedErr, CostRegister."No."));

        Window.OPEN(Text005Lbl +
          Text006);
    end;

    var
        Text000Lbl: Label 'From Register No. must not be higher than To Register No..', Comment = 'ESP="Nº registro desde no debe ser mayor que Nº registro hasta."';
        Text001Lbl: Label 'All corresponding cost entries and register entries will be deleted. Do you want to delete cost register %1 to %2?', Comment = 'ESP="Se eliminarán todos los movimientos de costes y registros correspondientes. ¿Desea eliminar el registro de costes del %1 al %2?"';
        Text004Lbl: Label 'Are you sure?', Comment = 'ESP="¿Está seguro?"';
        Text005Lbl: Label 'Delete cost register\', Comment = 'ESP="Eliminar registro de costes\"';
        Text006: Label 'Register  no.      #1######', Comment = 'ESP="Nº registro      #1######"';
        CostRegister2: Record "Distribution Registers";
        CostRegister3: Record "Distribution Registers";
        Window: Dialog;
        CostRegisterHasBeenModifiedErr: Label 'Another user has modified the cost register. The To Register No. field must be equal to %1.\Run the Delete Cost Entries batch job again.', Comment = 'ESP="Otro usuario ha modificado el registro de costes. El campo Nº registro hasta debe ser igual a %1.\Ejecute de nuevo el proceso por lotes Eliminar movimientos de costes."';

    procedure InitializeRequest(NewFromRegisterNo: Integer; NewToRegisterNo: Integer)
    begin
        CostRegister2."No." := NewFromRegisterNo;
        CostRegister3."No." := NewToRegisterNo;
    end;
}
