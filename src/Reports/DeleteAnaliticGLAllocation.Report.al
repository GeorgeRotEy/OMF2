report 50002 "Delete Analitic G/L Allocation"
{
    // // Mod. S2G 19/10/2017 (CPA) : CUNEF Reparto analítico.

    Caption = 'Cost Allocation', Comment = 'ESP="Distribución de costes"';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(MovDistribucion; 50031)
        {
            DataItemTableView = SORTING("Distribution Id.")
                                ORDER(Ascending);
            RequestFilterFields = "Distribution Id.";
            RequestFilterHeading = 'Mov. Reparto Analítica';

            trigger OnAfterGetRecord()
            var
                Text_Deleted: Label 'Entry deleted', Comment = 'ESP="Movimiento eliminado"';
            begin
                NumMovReparto += 1;
                Window.UPDATE(1, NumMovReparto);

                IF MovDistribucion."Source code" <> SourceCodeSetup."Distribution Allocation" THEN
                    MovDistribucion.DELETE
                /*
                MovDistribucion."Assignment Document No." := '';
                MovDistribucion."Distribution Id." := '';
                MovDistribucion."Distribution Id. No. Series" := '';
                MovDistribucion.MODIFY();
                */
                ELSE BEGIN
                    MovDistribucion.Assigned := FALSE;
                    MovDistribucion.Amount := 0;
                    MovDistribucion."Debit amount" := 0;
                    MovDistribucion."Credit amount" := 0;
                    MovDistribucion.Description := Text_Deleted;
                    MovDistribucion."Assignment Document No." := '';
                    MovDistribucion."Distribution Id." := '';
                    MovDistribucion."Distribution Id. No. Series" := '';
                    MovDistribucion.MODIFY();
                END;
            end;

            trigger OnPostDataItem()
            var
                RegMovs: Record "Distribution Registers";
            begin
                IF _TransactionNo <> 0 THEN BEGIN
                    RegMovs.GET(_TransactionNo);
                    RegMovs.Reversed := TRUE;
                    RegMovs.MODIFY();
                END;

                Window.CLOSE();
                MESSAGE(Text023);
            end;

            trigger OnPreDataItem()
            begin
                IF _TransactionNo <> 0 THEN
                    SETRANGE("Transaction No.", _TransactionNo);

                IF COUNT > 0 THEN BEGIN
                    IF NOT CONFIRM(Text_Confirm) THEN ERROR(Text024);
                END ELSE
                    ERROR(Texto025);

                Window.OPEN(Text022);

                NumMovReparto := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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

    trigger OnPreReport()
    begin
        SourceCodeSetup.GET();
        SourceCodeSetup.TESTFIELD("Distribution Allocation");
    end;

    var
        SourceCodeSetup: Record "Source Code Setup";
        NumMovReparto: Integer;
        Text022: Label 'Posting Cost Entries @1@@@@@@@@@@\', Comment = 'ESP="Registrando movimientos de costes @1@@@@@@@@@@\\"';
        Window: Dialog;
        Text023: Label 'Process finished', Comment = 'ESP="Proceso finalizado"';
        _TransactionNo: Integer;
        Text024: Label 'Proceso cancelado a petición del usuario', Comment = 'ESP="Proceso cancelado a petición del usuario"';
        Text_Confirm: Label 'Éste proceso modifica el importe de los movimientos de reparto analítico para anular los asientos. Desea continuar?', Comment = 'ESP="Éste proceso modifica el importe de los movimientos de reparto analítico para anular los asientos. Desea continuar?"';
        Texto025: Label 'No hay nada que eliminar', Comment = 'ESP="No hay nada que eliminar"';

    procedure setTransactionNo(TransactionNo: Integer)
    begin
        _TransactionNo := TransactionNo;
    end;
}
