table 50085 "Grupo registro retención"
{
    // // Mod. S2G 19/10/2016 (CSM) : GF-010 Retenciones. IRPF.

    DrillDownPageID = "Grupos registro retención";
    LookupPageID = "Grupos registro retención";

    fields
    {
        field(10; "Cód. grupo"; Code[10])
        {
            Caption = 'Group Code', Comment = 'ESP="Código grupo"';
            Description = 'IRPF';
        }
        field(20; Descripcion; Text[30])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            Description = 'IRPF';
        }
        field(30; "% retención"; Decimal)
        {
            Caption = 'Withholding %', Comment = 'ESP="Porcentaje de retención"';
            Description = 'IRPF';

            trigger OnValidate()
            begin
                TestMovsIRPF(xRec);
            end;
        }
        field(40; "Cuenta compras"; Text[20])
        {
            Caption = 'Purchase Account', Comment = 'ESP="Cuenta compras"';
            Description = 'IRPF';
            TableRelation = "G/L Account"."No.";
        }
        field(50; "Cuenta ventas"; Text[20])
        {
            Caption = 'Sales Account', Comment = 'ESP="Cuenta ventas"';
            Description = 'IRPF';
            TableRelation = "G/L Account"."No.";
        }
        field(60; "Tipo retención"; Option)
        {
            Caption = 'Withholding Type', Comment = 'ESP="Tipo de retención"';
            Description = 'IRPF';
            OptionCaption = ',Professionals,Rent,Non-resident,Interests';
            OptionMembers = ,Profesionales,Alquiler,"No residente",Intereses;

            trigger OnValidate()
            begin
                TestMovsIRPF(xRec);
            end;
        }
        field(51009; "Clave IRPF"; Text[50])
        {
            Caption = 'IRPF key', Comment = 'ESP="Clave IRPF"';
            Description = '(RET): Cálculo de importes retención.';
        }
        field(51010; "Subclave IRPF"; Text[50])
        {
            Caption = 'IRPF subkey', Comment = 'ESP="Subclave IRPF"';
            Description = '(RET): Cálculo de importes retención.';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Cód. grupo")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cód. grupo", Descripcion, "% retención", "Tipo retención")
        {
        }
    }

    trigger OnRename()
    begin
        TestMovsIRPF(xRec);
    end;

    var
        Text60100: Label 'No puede modificar este dato porque existen movimientos asociados al Grupo Registro IRPF %1.';

    procedure TestMovsIRPF(var pRecGrupoRegIRPF: Record "Grupo registro retención")
    var
        RecMovsIRPF: Record "Movs. retenciones";
    begin
        // >> IRPF - Compruebo si existen Movs. IRPF del Grupo Registro IRPF.
        RecMovsIRPF.RESET;
        RecMovsIRPF.SETCURRENTKEY("Grupo registro retención");
        RecMovsIRPF.SETRANGE("Grupo registro retención", pRecGrupoRegIRPF."Cód. grupo");
        IF NOT (RecMovsIRPF.ISEMPTY) THEN
            ERROR(Text60100, pRecGrupoRegIRPF."Cód. grupo");
    end;
}
