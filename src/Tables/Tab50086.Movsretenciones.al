table 50086 "Movs. retenciones"
{
    // // Mod. S2G 19/10/2016 (CSM) : GF-010 Retenciones. IRPF.

    DrillDownPageID = "Movs. retenciones";
    LookupPageID = "Movs. retenciones";

    fields
    {
        field(10; "Nº mov."; Integer)
        {
            Caption = 'Movement No.', Comment = 'ESP="Nº movimiento"';
            Description = 'IRPF';
        }
        field(12; "No. mov. contabilidad"; Integer)
        {
            Caption = 'G/L Entry No.', Comment = 'ESP="Nº movimiento contabilidad"';
            TableRelation = "G/L Entry"."Entry No.";
        }
        field(17; "Cuenta retención"; Code[20])
        {
            Caption = 'Withholding Account', Comment = 'ESP="Cuenta de retención"';
            TableRelation = "G/L Account";
        }
        field(20; "Grupo registro retención"; Code[20])
        {
            Caption = 'Withholding Posting Group', Comment = 'ESP="Grupo registro retención"';
            Description = 'IRPF';
            TableRelation = "Grupo registro retención"."Cód. grupo";
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code', Comment = 'ESP="Dimensión global 1"';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code', Comment = 'ESP="Dimensión global 2"';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(25; "% retención"; Decimal)
        {
            Caption = 'Withholding %', Comment = 'ESP="Porcentaje de retención"';
            Description = 'IRPF';
        }
        field(30; "Fecha registro"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha de registro"';
            Description = 'IRPF';
        }
        field(40; "Tipo documento"; Option)
        {
            Caption = 'Document Type', Comment = 'ESP="Tipo de documento"';
            Description = 'IRPF';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return,,,,,Posted Invoice,Posted Credit Memo,Subtotal,Total';
            OptionMembers = Oferta,Pedido,Factura,Abono,"Pedido abierto","Devolución",,,,,"Fact. Registrada","Abono Registrado",SubTotal,Total;
        }
        field(50; "Nº documento"; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº documento"';
            Description = 'IRPF';
        }
        field(55; "Nº linea IRPF"; Integer)
        {
            Caption = 'IRPF Line No.', Comment = 'ESP="Nº línea IRPF"';
            Description = 'IRPF';
        }
        field(60; Tipo; Option)
        {
            Caption = 'Type', Comment = 'ESP="Tipo (Compra/Venta)"';
            Description = 'IRPF';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Compra,Venta;
        }
        field(70; Base; Decimal)
        {
            Caption = 'Base Amount', Comment = 'ESP="Base imponible"';
            Description = 'IRPF';
        }
        field(80; Importe; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
            Description = 'IRPF';
        }
        field(85; "Importe calculado"; Decimal)
        {
            Caption = 'Calculated Amount', Comment = 'ESP="Importe calculado"';
            Description = 'IRPF';
        }
        field(90; "Id. usuario"; Code[50])
        {
            Caption = 'User ID', Comment = 'ESP="Id. usuario"';
            Description = 'IRPF';
        }
        field(100; "Cod. origen"; Code[20])
        {
            Caption = 'Source Code', Comment = 'ESP="Código origen"';
            Description = 'IRPF';
            TableRelation = IF ("Tipo" = CONST(Compra)) Vendor."No."
            ELSE IF (Tipo = CONST(Venta)) Customer."No.";
        }
        field(110; "Cod. auditoría"; Code[10])
        {
            Caption = 'Audit Code', Comment = 'ESP="Código auditoría"';
            Description = 'IRPF';
        }
        field(120; "Nº documento externo"; Code[20])
        {
            Caption = 'External Document No.', Comment = 'ESP="Nº documento externo"';
            Description = 'IRPF';
        }
        field(130; "Fecha emision documento"; Date)
        {
            Caption = 'Document Issue Date', Comment = 'ESP="Fecha emisión documento"';
            Description = 'IRPF';
        }
        field(140; "CIF/NIF"; Text[20])
        {
            Caption = 'VAT Registration No.', Comment = 'ESP="CIF/NIF"';
            Description = 'IRPF';
        }
        field(150; "Nº documento original"; Code[20])
        {
            Caption = 'Original Document No.', Comment = 'ESP="Nº documento original"';
            Description = 'IRPF';
        }
        field(155; "Nº linea retención original"; Integer)
        {
            Caption = 'Original IRPF Line No.', Comment = 'ESP="Nº línea IRPF original"';
            Description = 'IRPF';
        }
        field(160; "Tipo documento original"; Option)
        {
            Caption = 'Original Document Type', Comment = 'ESP="Tipo documento original"';
            Description = 'IRPF';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return';
            OptionMembers = Oferta,Pedido,Factura,Abono,"Pedido abierto","Devolución";
        }
        field(170; "Tipo retención"; Option)
        {
            Caption = 'Withholding Type', Comment = 'ESP="Tipo de retención"';
            Description = 'IRPF';
            OptionCaption = ',Professionals,Rent,Non-resident,Interest';
            OptionMembers = ,Profesionales,Alquiler,"No residente",Intereses;
        }
        field(180; Declarado; Boolean)
        {
            Caption = 'Declared', Comment = 'ESP="Declarado"';
        }
        field(190; "No. mov. original"; Integer)
        {
            Caption = 'Original Movement No.', Comment = 'ESP="Nº mov. original"';
        }
        field(200; "Importe IRPF liberado"; Decimal)
        {
            Caption = 'Released IRPF Amount', Comment = 'ESP="Importe IRPF liberado"';
            CalcFormula = - Sum("G/L Entry".Amount WHERE("Movimiento IRPF liquidado" = FIELD("No. mov. original")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(210; "Importe IRPF liberado Total"; Decimal)
        {
            Caption = 'Total Released IRPF Amount', Comment = 'ESP="Importe IRPF liberado total"';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID', Comment = 'ESP="ID conjunto dimensiones"';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(51009; "Clave IRPF"; Text[50])
        {
            Caption = 'IRPF Key', Comment = 'ESP="Clave IRPF"';
            Description = '(RET): Cálculo de importes retención.';
        }
        field(51010; "Subclave IRPF"; Text[50])
        {
            Caption = 'IRPF Subkey', Comment = 'ESP="Subclave IRPF"';
            Description = '(RET): Cálculo de importes retención.';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Nº mov.")
        {
            Clustered = true;
        }
        key(Key2; Tipo, "Tipo documento", "Nº documento")
        {
            SumIndexFields = Base, Importe;
        }
        key(Key3; "Grupo registro retención")
        {
        }
        key(Key4; Tipo, "Cod. origen", "Grupo registro retención", "Fecha registro")
        {
            SumIndexFields = Base, Importe;
        }
        key(Key5; Tipo, "Tipo retención", "Tipo documento", "Cod. origen", "Fecha registro")
        {
            SumIndexFields = Base, Importe;
        }
        key(Key6; Tipo, "Tipo retención", "Cod. origen", "Grupo registro retención", "Fecha registro")
        {
            SumIndexFields = Base, Importe;
        }
    }

    fieldgroups
    {
    }

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "Nº mov."));
    end;
}
