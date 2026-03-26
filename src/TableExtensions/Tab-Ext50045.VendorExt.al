tableextension 50045 "Vendor Ext" extends Vendor
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
        field(50006; "Former Vendor No."; Code[20])
        {
            Caption = 'Former Vendor No.', Comment = 'ESP="Nº proveedor anterior"';
        }
        field(50100; "Control IRPF"; Option)
        {
            Caption = 'IRPF Control', Comment = 'ESP="Control IRPF"';
            OptionCaption = ' ,Obligatorio,Opcional';
            OptionMembers = " ",Obligatorio,Opcional;
        }
        field(50110; "Grupo registro IRPF"; Code[10])
        {
            Caption = 'IRPF Posting Group', Comment = 'ESP="Grupo registro IRPF"';
            TableRelation = IF ("Control IRPF" = FILTER(<> ' ')) "Grupo registro retención"."Cód. grupo";
        }
        field(50111; "Due Date First IRPF"; Date)
        {
            Caption = 'First IRPF Reduction End Date', Comment = 'ESP="Fecha fin reducción retención"';
        }
    }

    keys
    {
        key(Key14; "Third Party No.")
        {
        }
    }

    fieldgroups
    {
        addlast(DropDown; "VAT Registration No.")
        { }
    }

    var
        UpdatedFromThirdParty: Boolean;

    procedure SetUpdatedFromThirdParty()
    begin
        UpdatedFromThirdParty := TRUE;
    end;

    procedure FindFirstAllowedRec(Which: Text[1024]): Boolean
    var
        rlVend: Record Vendor;
    begin
        IF FIND(Which) THEN BEGIN
            rlVend := Rec;
            WHILE TRUE DO BEGIN
                IF NOT rlVend.Disabled THEN BEGIN
                    Rec := rlVend;
                    EXIT(TRUE);
                END;

                IF NEXT(1) = 0 THEN BEGIN
                    Rec := rlVend;
                    IF FIND(Which) THEN
                        WHILE TRUE DO BEGIN
                            IF NOT rlVend.Disabled THEN
                                EXIT(TRUE);

                            IF NEXT(-1) = 0 THEN
                                EXIT(FALSE);
                        END;
                END;
                rlVend := Rec;
            END;
        END;
        EXIT(FALSE);
    end;

    procedure FindNextAllowedRec(Steps: Integer): Integer
    var
        rlVend: Record Vendor;
        RealSteps: Integer;
        NextSteps: Integer;
    begin
        RealSteps := 0;
        IF Steps <> 0 THEN BEGIN
            rlVend := Rec;
            REPEAT
                NextSteps := NEXT(Steps / ABS(Steps));
                rlVend := Rec;
            UNTIL (NextSteps = 0) OR (NOT Disabled);
            RealSteps := NextSteps;
            Rec := rlVend;
            IF NOT FIND THEN;
        END;
        EXIT(RealSteps);
    end;
}