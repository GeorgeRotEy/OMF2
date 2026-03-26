table 50030 "Schedule of Distrib. Accounts"
{
    Caption = 'Schedule of Distrib. Accounts', Comment = 'ESP="Plan de cuentas de reparto"';
    DataCaptionFields = "No.", Name;
    DrillDownPageID = "Distribution Account Card";
    LookupPageID = "Chart of schedule List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Número"';
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(3; Type; Option)
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';
            OptionCaption = 'Cost Type,Heading,Total,Begin-Total,End-Total';
            OptionMembers = "Tipo coste",Encabezado,Total,"Total inicio","Total fin";

            trigger OnValidate()
            begin
                IF Type <> xRec.Type THEN
                    Blocked := Type <> Type::"Tipo coste";

                // CHange only if no entries or budget
                IF Blocked AND NOT xRec.Blocked THEN BEGIN
                    rMovREparto.SETRANGE(rMovREparto."Distrib. account no.", "No.");
                    IF NOT rMovREparto.ISEMPTY THEN
                        ERROR(Text001, "No.", rMovREparto.TABLECAPTION);
                END;

                Totaling := '';
            end;
        }
        field(4; Totaling; Text[250])
        {
            Caption = 'Totaling', Comment = 'ESP="Sumatorio"';
            TableRelation = "Schedule of Distrib. Accounts";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5; "Interval of GC accounts"; Text[250])
        {
            Caption = 'G/L Account Interval', Comment = 'ESP="Intervalo de cuentas contables"';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(6; "Dimension filter 1"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Dimension Filter 1', Comment = 'ESP="Filtro dimensión 1"';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; "Dimension filter 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Dimension Filter 2', Comment = 'ESP="Filtro dimensión 2"';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(8; Balance; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Balance', Comment = 'ESP="Saldo"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Distribution Entry".Amount WHERE("Distrib. account no." = FIELD("No."),
                                                             "Distrib. account no." = FIELD(FILTER(Totaling)),
                                                             "Global Dimension 1 Code" = FIELD("Dimension filter 1"),
                                                             "Global Dimension 2 Code" = FIELD("Dimension filter 2"),
                                                             "Posting date" = FIELD("Date Filter"),
                                                             "Business Unit Code" = FIELD("Business Unit Filter")));
        }
        field(9; "Balance to assign"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Balance to Assign', Comment = 'ESP="Saldo a asignar"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Distribution Entry".Amount WHERE("Distrib. account no." = FIELD("No."),
                                                             Assigned = CONST(false),
                                                             "Global Dimension 1 Code" = FIELD("Dimension filter 1"),
                                                             "Global Dimension 2 Code" = FIELD("Dimension filter 2"),
                                                             "Posting date" = FIELD("Date Filter"),
                                                             "Business Unit Code" = FIELD("Business Unit Filter"),
                                                             "Assignment Document No." = FILTER('')));
        }
        field(10; Blocked; Boolean)
        {
            Caption = 'Blocked', Comment = 'ESP="Bloqueado"';
        }
        field(11; "Last date modified"; Date)
        {
            Caption = 'Last Date Modified', Comment = 'ESP="Última fecha de modificación"';
            Editable = false;
        }
        field(12; "Modified by"; Code[50])
        {
            Caption = 'Modified By', Comment = 'ESP="Modificado por"';
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                EYFunctions: Codeunit "EY Functions";
                ModifiedBy: Code[50];
            begin
                ModifiedBy := "Modified by";
                EYFunctions.LookupUserID(ModifiedBy);
            end;
        }
        field(13; Indentation; Integer)
        {
            Caption = 'Indentation', Comment = 'ESP="Indentación"';
        }
        field(28; "Date Filter"; Date)
        {
            Caption = 'Date Filter', Comment = 'ESP="Filtro de fecha"';
            FieldClass = FlowFilter;
        }
        field(42; "Business Unit Filter"; Code[10])
        {
            Caption = 'Business Unit Filter', Comment = 'ESP="Filtro unidad de negocio"';
            FieldClass = FlowFilter;
            TableRelation = "Business Unit";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Last date modified" := TODAY;
        "Modified by" := USERID;
    end;

    trigger OnModify()
    begin
        "Last date modified" := TODAY;
        "Modified by" := USERID;
    end;

    var
        rMovREparto: Record "Distribution Entry";
        Text001: Label 'Cannot change %1 cost type. %1 associateds.';
}
