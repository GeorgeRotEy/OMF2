tableextension 50027 "Bank Acc. Ledger Entry Ext" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50000; "Shortcut Dimension 3"; Code[20])
        {
            Caption = 'Shortcut Dimension 3', Comment = 'ESP="Dimensión acceso directo 3"';
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
            DataClassification = ToBeClassified;
        }
        field(50001; "Shortcut Dimension 4"; Code[20])
        {
            Caption = 'Shortcut Dimension 4', Comment = 'ESP="Dimensión acceso directo 4"';
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
            DataClassification = ToBeClassified;
        }
        field(50002; "Shortcut Dimension 5"; Code[20])
        {
            Caption = 'Shortcut Dimension 5', Comment = 'ESP="Dimensión acceso directo 5"';
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
            DataClassification = ToBeClassified;
        }
        field(50003; "Shortcut Dimension 6"; Code[20])
        {
            Caption = 'Shortcut Dimension 6', Comment = 'ESP="Dimensión acceso directo 6"';
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
            DataClassification = ToBeClassified;
        }
        field(50004; "Posting concept"; Text[250])
        {
            Caption = 'Posting Concept', Comment = 'ESP="Concepto contable"';
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Entry"."Posting concept" WHERE("Entry No." = FIELD("Entry No.")));
        }
    }
}