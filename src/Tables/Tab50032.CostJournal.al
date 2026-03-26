table 50032 "Cost Journal"
{
    Caption = 'Cost Journal', Comment = 'ESP="Diario coste"';

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Nº línea"';
        }
        field(2; "Posting date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha de registro"';
            ClosingDates = true;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº documento"';
        }
        field(4; "Distribution Account No."; Code[20])
        {
            Caption = 'Distribution Account No.', Comment = 'ESP="Nº cuenta de reparto"';
            TableRelation = "Schedule of Distrib. Accounts"."No.";
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(6; "Debit amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Debit Amount', Comment = 'ESP="Importe debe"';

            trigger OnValidate()
            begin
                Amount := "Debit amount";
                VALIDATE(Amount);
            end;
        }
        field(7; "Credit amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Credit Amount', Comment = 'ESP="Importe haber"';

            trigger OnValidate()
            begin
                Amount := -"Credit amount";
                VALIDATE(Amount);
            end;
        }
        field(8; Amount; Decimal)
        {
            BlankZero = true;
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(9; "Global dimension 1"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1', Comment = 'ESP="Dimensión global 1"';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(10; "Global dimension 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2', Comment = 'ESP="Dimensión global 2"';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(11; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID', Comment = 'ESP="Id. conjunto de dimensiones"';
            TableRelation = "Dimension Set Entry";
        }
        field(50; "Business Unit Code"; Code[10])
        {
            Caption = 'Business Unit Code', Comment = 'ESP="Cód. unidad de negocio"';
            TableRelation = "Business Unit";
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        cDimMgt: Codeunit DimensionManagement;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          cDimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2', "Distribution Account No.", "Line No."),
            "Global dimension 1", "Global dimension 2");
    end;
}
