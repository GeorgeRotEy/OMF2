table 50028 "Analytical Distribution Hdr."
{
    Caption = 'Analytical Distribution', Comment = 'ESP="Distribución analítica"';
    LookupPageID = "Listado de Asign. de  reparto";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº documento"';

            trigger OnValidate()
            begin
                AnalyticalDistSetup.GET();

                IF "Document No." <> xRec."Document No." THEN BEGIN
                    NoSeriesMgt.TestManual(AnalyticalDistSetup."No Series Distribution");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "No. Series"; Code[20])
        {
            Caption = 'No. Series', Comment = 'ESP="Serie de numeración"';
        }
        field(3; Level; Integer)
        {
            Caption = 'Level', Comment = 'ESP="Nivel"';
            MaxValue = 99;
            MinValue = 0;
        }
        field(4; "Valid from date"; Date)
        {
            Caption = 'Valid From Date', Comment = 'ESP="Fecha válida desde"';
        }
        field(5; "Valid to date"; Date)
        {
            Caption = 'Valid To Date', Comment = 'ESP="Fecha válida hasta"';
        }
        field(6; "Source dimension code"; Code[20])
        {
            Caption = 'Source Dimension Code', Comment = 'ESP="Código dimensión origen"';
            TableRelation = Dimension;

            trigger OnValidate()
            var
                Lineas: Record "Anaylitical Distrib. Lines";
            begin
                CheckDimensionChange(xRec."Source dimension code", "Source dimension code", FIELDNO("Source dimension code"));
            end;
        }
        field(7; "Destination dimension code"; Code[20])
        {
            Caption = 'Destination Dimension Code', Comment = 'ESP="Código dimensión destino"';
            TableRelation = Dimension;

            trigger OnValidate()
            var
                Lineas: Record "Anaylitical Distrib. Lines";
            begin
                CheckDimensionChange(xRec."Destination dimension code", "Destination dimension code", FIELDNO("Destination dimension code"));
            end;
        }
        field(8; "Account interval"; Text[250])
        {
            Caption = 'Account Interval', Comment = 'ESP="Intervalo de cuentas"';

            trigger OnLookup()
            var
                DistribAccount: Record "Schedule of Distrib. Accounts";
            begin
                IF PAGE.RUNMODAL(0, DistribAccount) = ACTION::LookupOK THEN
                    "Account interval" := DistribAccount."No.";
            end;
        }
        field(9; Blocked; Boolean)
        {
            Caption = 'Blocked', Comment = 'ESP="Bloqueado"';
        }
        field(10; "Dest. Dimension processing"; Option)
        {
            Caption = 'Destination Dimension Processing', Comment = 'ESP="Tratamiento dimensión destino"';
            OptionCaption = 'Process always,Ignore if filled,Ignore if blank', Comment = 'ESP="Procesar siempre,Ignorar si informado,Ignorar si en blanco"';
            OptionMembers = "Process always","Ignore if filled","Ignore if blank";
        }
        field(11; "From Posting Date"; Date)
        {
            Caption = 'From Posting Date', Comment = 'ESP="Fecha registro desde"';
        }
        field(12; "To Posting Date"; Date)
        {
            Caption = 'To Posting Date', Comment = 'ESP="Fecha registro hasta"';
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
        key(Key2; Level, Blocked)
        {
        }
    }

    fieldgroups
    {
    }

    //TO DO MIG
    // trigger OnInsert()
    // begin
    //     InitInsert;
    // end;

    var
        AnalyticalDistSetup: Record "Analytical Distribution Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Text_ConfirmChange: Label 'Dimension %1 has been changed by %2, unconsistent lines will be deleted. Do you want to proceed?', Comment = 'ESP="La dimensión %1 ha sido cambiada por %2, se eliminarán las líneas inconsistentes. ¿Desea continuar?"';
        Text_ProcessCancelled: Label 'Process cancelled by user', Comment = 'ESP="Proceso cancelado por el usuario"';
        Text_DimensionsAreEqual: Label '%1 cannot be equal to %2', Comment = 'ESP="%1 no puede ser igual a %2"';

    procedure InitInsert()
    begin
        IF "Document No." = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMgt.AreRelated(GetNoSeriesCode, "No. Series");
        END;
    end;

    procedure TestNoSeries()
    begin
        AnalyticalDistSetup.GET();
        AnalyticalDistSetup.TESTFIELD("No Series Distribution");
    end;

    procedure GetNoSeriesCode(): Code[10]
    begin
        AnalyticalDistSetup.GET();
        EXIT(AnalyticalDistSetup."No Series Distribution");
    end;

    procedure GetTotalDistribRate(): Decimal
    var
        Lineas: Record "Anaylitical Distrib. Lines";
    begin
        Lineas.RESET;
        Lineas.SETRANGE("Document No.", "Document No.");
        Lineas.CALCSUMS("Distribution percentage rate");
        EXIT(Lineas."Distribution percentage rate");
    end;

    local procedure CheckDimensions()
    begin
        IF "Source dimension code" = "Destination dimension code" THEN
            ERROR(Text_DimensionsAreEqual, FIELDCAPTION("Source dimension code"), FIELDCAPTION("Destination dimension code"));
    end;

    local procedure CheckDimensionChange(OldDimCode: Code[20]; NewDimCode: Code[20]; ChangedFieldNo: Integer)
    var
        Lineas: Record "Anaylitical Distrib. Lines";
    begin
        IF (OldDimCode <> NewDimCode) THEN BEGIN
            Lineas.RESET;
            Lineas.SETRANGE("Document No.", "Document No.");
            IF Lineas.COUNT = 0 THEN EXIT;

            IF NOT CONFIRM(STRSUBSTNO(Text_ConfirmChange, OldDimCode, NewDimCode)) THEN ERROR(Text_ProcessCancelled);

            IF ChangedFieldNo = FIELDNO("Source dimension code") THEN Lineas.SETRANGE("Source dimension code", OldDimCode);
            IF ChangedFieldNo = FIELDNO("Destination dimension code") THEN Lineas.SETRANGE("Destinati dimension code", OldDimCode);

            Lineas.DELETEALL;
        END;

        CheckDimensions();
    end;
}
