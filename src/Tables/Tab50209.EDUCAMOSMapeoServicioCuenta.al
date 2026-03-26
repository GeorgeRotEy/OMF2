table 50209 "EDUCAMOS Mapeo Servicio Cuenta" //EDUCAMOS
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    DataPerCompany = false;

    fields
    {
        field(1; "Service Code"; Code[20])
        {
            Caption = 'Service Code', Comment = 'ESP="Cód. servicio"';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('ACTIVIDAD'),
                                                  "Dimension Value Type" = CONST(Standard));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(2; "Service Name"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE(Code = FIELD("Service Code")));
            Caption = 'Service Name', Comment = 'ESP="Nombre servicio"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.', Comment = 'ESP="Nº cuenta"';
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(4; "G/L Account Name"; Text[100])
        {
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("G/L Account No.")));
            Caption = 'G/L Account Name', Comment = 'ESP="Nombre cuenta"';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Service Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
