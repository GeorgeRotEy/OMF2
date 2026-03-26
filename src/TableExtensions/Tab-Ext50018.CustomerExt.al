tableextension 50018 "Customer Ext" extends Customer
{
    fields
    {
        field(50004; "Third Party No."; Code[20])
        {
            Caption = 'Third Party No.', Comment = 'ESP="Nº tercero"';
            TableRelation = "Third Party";
        }
        field(50005; Disabled; Boolean)
        {
            Caption = 'Disabled', Comment = 'ESP="Deshabilitado"';
        }
        field(50006; "Former Customer No."; Code[20])
        {
            Caption = 'Former Customer No.', Comment = 'ESP="Nº cliente anterior"';
        }
        field(50008; "Customer Balance (LCY)"; Decimal)
        {
            Caption = 'Customer Balance (LCY)', Comment = 'ESP="Saldo cliente (DL)"';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            FieldClass = FlowField;
            CalcFormula = Sum(
                "Detailed Cust. Ledg. Entry"."Amount (LCY)"
                WHERE(
                    "Customer No." = FIELD("No."),
                    "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                    "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                    "Currency Code" = FIELD("Currency Filter"),
                    "Excluded from calculation" = CONST(false)
                )
            );
            Editable = false;
        }
        field(50100; "Control IRPF"; Option)
        {
            Caption = 'IRPF Control', Comment = 'ESP="Control IRPF"';
            OptionMembers = " ",Obligatorio,Opcional;
            OptionCaption = ' ,Obligatorio,Opcional';

            trigger OnValidate()
            begin
                if "Control IRPF" = "Control IRPF"::" " then
                    Validate("Grupo registro IRPF", '');
            end;
        }
        field(50110; "Grupo registro IRPF"; Code[10])
        {
            Caption = 'IRPF Posting Group', Comment = 'ESP="Grupo registro IRPF"';
            TableRelation =
                if ("Control IRPF" = filter(<> ' '))
                    "Grupo registro retención"."Cód. grupo";

            trigger OnValidate()
            begin
                if "Control IRPF" <> "Control IRPF"::" " then
                    TestField("Control IRPF");
            end;
        }
        field(50200; "EDUCAMOS id_unique_pagador"; Text[50])
        {
            Caption = 'EDUCAMOS Unique Payer ID', Comment = 'ESP="ID único pagador EDUCAMOS"';
        }
    }

    keys
    {
        key(ABAI_ThirdPartyNo; "Third Party No.")
        {
        }
        key(ABAI_EducamosId; "EDUCAMOS id_unique_pagador")
        {
        }
    }

    fieldgroups
    {
        addlast(DropDown; "Third Party No.", Disabled, "Former Customer No.", "Customer Balance (LCY)")
        {
        }
        addlast(Brick; "Third Party No.", "Customer Balance (LCY)")
        {
        }
    }

    var
        UpdatedFromThirdParty: Boolean;

    procedure SetUpdatedFromThirdParty()
    begin
        UpdatedFromThirdParty := true;
    end;

    procedure FindFirstAllowedRec(Which: Text[1024]): Boolean
    var
        rlCust: Record Customer;
    begin
        if Find(Which) then begin
            rlCust := Rec;
            while true do begin
                if not rlCust.Disabled then begin
                    Rec := rlCust;
                    exit(true);
                end;

                if Next(1) = 0 then begin
                    Rec := rlCust;
                    if Find(Which) then
                        while true do begin
                            if not rlCust.Disabled then
                                exit(true);

                            if Next(-1) = 0 then
                                exit(false);
                        end;
                end;
                rlCust := Rec;
            end;
        end;
        exit(false);
    end;

    procedure FindNextAllowedRec(Steps: Integer): Integer
    var
        rlCust: Record Customer;
        RealSteps: Integer;
        NextSteps: Integer;
    begin
        RealSteps := 0;
        if Steps <> 0 then begin
            rlCust := Rec;
            repeat
                NextSteps := Next(Steps / Abs(Steps));
                rlCust := Rec;
            until (NextSteps = 0) or (not Disabled);
            RealSteps := NextSteps;
            Rec := rlCust;
            if not Find then;
        end;
        exit(RealSteps);
    end;
}