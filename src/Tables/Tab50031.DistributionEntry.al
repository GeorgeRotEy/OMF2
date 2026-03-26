table 50031 "Distribution Entry"
{
    Caption = 'Distribution Entry', Comment = 'ESP="Movimiento de reparto"';
    DrillDownPageID = "Distribution Entry";
    LookupPageID = "Distribution Entry";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº movimiento"';
        }
        field(2; "Distrib. account no."; Code[20])
        {
            Caption = 'Distribution Account No.', Comment = 'ESP="Nº cuenta de reparto"';
            TableRelation = "Schedule of Distrib. Accounts"."No.";
        }
        field(3; "Posting date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha de registro"';
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº documento"';
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(6; "Description of assignment"; Text[50])
        {
            Caption = 'Assignment Description', Comment = 'ESP="Descripción de la asignación"';
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';

            trigger OnValidate()
            begin
                IF Amount > 0 THEN
                    "Debit amount" := Amount
                ELSE
                    "Credit amount" := -Amount;
            end;
        }
        field(8; "Debit amount"; Decimal)
        {
            Caption = 'Debit Amount', Comment = 'ESP="Importe debe"';

            trigger OnValidate()
            var
                Currency: Record Currency;
            begin
                CLEAR(Currency);
                Currency.InitRoundingPrecision();

                "Debit amount" := ROUND("Debit amount", Currency."Amount Rounding Precision");
                Amount := "Debit amount";
                VALIDATE(Amount);
            end;
        }
        field(9; "Credit amount"; Decimal)
        {
            Caption = 'Credit Amount', Comment = 'ESP="Importe haber"';

            trigger OnValidate()
            begin
                CLEAR(Currency);
                Currency.InitRoundingPrecision();

                "Credit amount" := ROUND("Credit amount", Currency."Amount Rounding Precision");
                Amount := -"Credit amount";
                VALIDATE(Amount);
            end;
        }
        field(10; "G/L Account"; Code[20])
        {
            Caption = 'G/L Account', Comment = 'ESP="Cuenta contable"';
            TableRelation = "G/L Account"."No.";
        }
        field(11; "G/L Entry No."; Integer)
        {
            Caption = 'G/L Entry No.', Comment = 'ESP="Nº mov. contabilidad"';
            TableRelation = "G/L Entry"."Entry No.";
        }
        field(12; "Source code"; Code[10])
        {
            Caption = 'Source Code', Comment = 'ESP="Cód. origen"';
        }
        field(13; Assigned; Boolean)
        {
            Caption = 'Assigned', Comment = 'ESP="Asignado"';
        }
        field(14; "Assignment Document No."; Code[20])
        {
            Caption = 'Assignment Document No.', Comment = 'ESP="Nº documento asignación"';
            TableRelation = "Analytical Distribution Hdr.";
        }
        field(15; "User Id."; Code[50])
        {
            Caption = 'User ID', Comment = 'ESP="Id. usuario"';
        }
        field(16; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name', Comment = 'ESP="Nombre sección diario"';
        }
        field(17; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code', Comment = 'ESP="Cód. dimensión global 1"';
        }
        field(18; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code', Comment = 'ESP="Cód. dimensión global 2"';
        }
        field(19; "Dimension Set Id"; Integer)
        {
            Caption = 'Dimension Set ID', Comment = 'ESP="Id. conjunto de dimensiones"';
        }
        field(20; "Distribution Id."; Code[20])
        {
            Caption = 'Distribution ID', Comment = 'ESP="Id. reparto"';
        }
        field(21; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.', Comment = 'ESP="Nº transacción"';
        }
        field(22; "Distribution Id. No. Series"; Code[20])
        {
            Caption = 'Distribution ID No. Series', Comment = 'ESP="Serie num. id reparto"';
        }
        field(23; "Source Entry No."; Integer)
        {
            Caption = 'Source Entry No.', Comment = 'ESP="Nº mov. origen"';
            TableRelation = "Distribution Entry"."Entry No.";
        }
        field(45; "Business Unit Code"; Code[10])
        {
            Caption = 'Business Unit Code', Comment = 'ESP="Cód. unidad de negocio"';
            TableRelation = "Business Unit";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Distribution Id.")
        {
        }
        key(Key3; "Dimension Set Id")
        {
        }
        key(Key4; "G/L Entry No.")
        {
        }
        key(Key5; "Distrib. account no.", "Global Dimension 1 Code", "Global Dimension 2 Code")
        {
            SumIndexFields = Amount, "Debit amount", "Credit amount";
        }
        key(Key6; "Distrib. account no.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting date")
        {
            SumIndexFields = Amount, "Debit amount", "Credit amount";
        }
        key(Key7; "Document No.", "Business Unit Code", "Posting date")
        {
            SumIndexFields = Amount, "Debit amount", "Credit amount";
        }
        key(Key8; "Document No.", "Posting date")
        {
            SumIndexFields = Amount, "Debit amount", "Credit amount";
        }
        key(Key9; "Distrib. account no.", Assigned)
        {
            SumIndexFields = Amount, "Debit amount", "Credit amount";
        }
        key(Key10; "Transaction No.")
        {
        }
        key(Key11; "Distrib. account no.", "Posting date")
        {
            SumIndexFields = Amount, "Debit amount", "Credit amount";
        }
        key(Key12; "Assignment Document No.", "G/L Account", "Posting date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        cDimMgt: Codeunit DimensionManagement;
        Currency: Record Currency;

    procedure ShowDimensions()
    begin
        "Dimension Set Id" :=
          cDimMgt.EditDimensionSet(
            "Dimension Set Id", STRSUBSTNO('%1 %2', "Distrib. account no.", "Entry No."),
            "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;
}
