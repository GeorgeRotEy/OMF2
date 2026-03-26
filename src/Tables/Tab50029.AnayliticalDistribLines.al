table 50029 "Anaylitical Distrib. Lines"
{
    Caption = 'Analytical Distribution Lines', Comment = 'ESP="Líneas de distribución analítica"';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº documento"';
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.', Comment = 'ESP="Nº línea"';
        }
        field(3; "Source dimension code"; Code[20])
        {
            CalcFormula = lookup(
            "Analytical Distribution Hdr."."Source Dimension Code"
            where("Document No." = field("Document No."))
        );
            Caption = 'Source Dimension Code', Comment = 'ESP="Código dimensión origen"';
            FieldClass = FlowField;
            TableRelation = Dimension;
        }
        field(4; "Source dimension value"; Code[20])
        {
            Caption = 'Source Dimension Value', Comment = 'ESP="Valor dimensión origen"';
            TableRelation = "Dimension Value".Code;

            trigger OnLookup()
            begin
                getDistribHeader();
                LookUpDimensionValue(DistribHdr."Source dimension code", "Source dimension value");
            end;
        }
        field(5; "Destinati dimension code"; Code[20])
        {
            CalcFormula = lookup("Analytical Distribution Hdr."."Destination dimension code" WHERE("Document No." = FIELD("Document No.")));
            Caption = 'Destination Dimension Code', Comment = 'ESP="Código dimensión destino"';
            FieldClass = FlowField;
            TableRelation = Dimension;
        }
        field(6; "Destination dimension value"; Code[20])
        {
            Caption = 'Destination Dimension Value', Comment = 'ESP="Valor dimensión destino"';
            TableRelation = "Dimension Value".Code;

            trigger OnLookup()
            begin
                getDistribHeader();
                LookUpDimensionValue(DistribHdr."Destination dimension code", "Destination dimension value");
            end;
        }
        field(7; "Distribution percentage rate"; Decimal)
        {
            Caption = 'Distribution %', Comment = 'ESP="Porcentaje de distribución"';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Distribution percentage rate";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        Lineas: Record "Anaylitical Distrib. Lines";
    begin
        CheckTotalDitributionPercent();
    end;

    trigger OnModify()
    var
        Lineas: Record "Anaylitical Distrib. Lines";
    begin
        CheckTotalDitributionPercent();
    end;

    var
        Text_PorcentajeSuperado: Label 'Sum of Distribution % cannot be above 100%';
        DistribHdr: Record "Analytical Distribution Hdr.";

    local procedure CheckTotalDitributionPercent()
    var
        Lineas: Record "Anaylitical Distrib. Lines";
    begin
        Lineas.RESET;
        Lineas.SETRANGE("Document No.", "Document No.");
        Lineas.SETFILTER("Line No.", '<>%1', "Line No.");
        Lineas.CALCSUMS("Distribution percentage rate");

        IF "Distribution percentage rate" + Lineas."Distribution percentage rate" > 100 THEN
            ERROR(Text_PorcentajeSuperado);
    end;

    local procedure getDistribHeader()
    begin
        DistribHdr.RESET;
        DistribHdr.GET("Document No.");
    end;

    local procedure LookUpDimensionValue(DimensionCode: Code[20]; var DimensionValueCode: Code[20])
    var
        DimensionValue: Record "Dimension Value";
    begin
        getDistribHeader();

        DimensionValue.RESET;
        DimensionValue.FILTERGROUP(9);
        DimensionValue.SETRANGE("Dimension Code", DimensionCode);
        DimensionValue.FILTERGROUP(0);
        IF PAGE.RUNMODAL(0, DimensionValue) = ACTION::LookupOK THEN
            DimensionValueCode := DimensionValue.Code;
    end;
}
