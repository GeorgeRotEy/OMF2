table 54000 "Pila Movs. retencion"
{
    // Mód. S2G(ABC) Modelos IRPF

    Caption = 'Pila Movs. retencion';

    fields
    {
        field(1; "Key"; Integer)
        {
            Caption = 'Key', Comment = 'ESP="Clave"';
        }
        field(3; "Fiscal Year"; Text[8])
        {
            Caption = 'Fiscal Year', Comment = 'ESP="Ejercicio fiscal"';
        }
        field(4; "VAT Registration No."; Text[9])
        {
            Caption = 'VAT Registration No.', Comment = 'ESP="NIF/CIF"';
        }
        field(5; "VAT Number"; Text[9])
        {
            Caption = 'VAT Number', Comment = 'ESP="Número IVA"';
        }
        field(7; "Customer/Vendor No."; Text[20])
        {
            Caption = 'Customer/Vendor No.', Comment = 'ESP="Nº Cliente/Proveedor"';
        }
        field(8; "Customer/Vendor Name"; Text[50])
        {
            Caption = 'Customer/Vendor Name', Comment = 'ESP="Nombre Cliente/Proveedor"';
        }
        field(9; "Country Code"; Text[10])
        {
            Caption = 'Country Code', Comment = 'ESP="Código país"';
        }
        field(10; "Resident ID"; Text[1])
        {
            Caption = 'Resident ID', Comment = 'ESP="Indicador residente"';
        }
        field(11; "International VAT No."; Text[20])
        {
            Caption = 'International VAT No.', Comment = 'ESP="Nº IVA internacional"';
        }
        field(12; "Book Type Code"; Text[1])
        {
            Caption = 'Book Type Code', Comment = 'ESP="Código tipo libro"';
        }
        field(13; "Operation Code"; Code[1])
        {
            Caption = 'Operation Code', Comment = 'ESP="Código operación"';
            TableRelation = "Operation Code";
        }
        field(14; "Document Date"; Date)
        {
            Caption = 'Document Date', Comment = 'ESP="Fecha documento"';
        }
        field(15; "Operation Date"; Text[8])
        {
            Caption = 'Operation Date', Comment = 'ESP="Fecha operación"';
        }
        field(16; "RET %"; Decimal)
        {
            Caption = 'VAT %', Comment = 'ESP="% Retención"';
        }
        field(17; Base; Decimal)
        {
            Caption = 'Base', Comment = 'ESP="Base imponible"';
        }
        field(21; "Document No."; Text[40])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº documento"';
        }
        field(22; "Document Type"; Text[30])
        {
            Caption = 'Document Type', Comment = 'ESP="Tipo documento"';
        }
        field(23; "VAT Document No."; Text[18])
        {
            Caption = 'VAT Document No.', Comment = 'ESP="Nº documento IVA"';
        }
        field(24; "Buffer Value 18"; Text[18])
        {
            Caption = 'Buffer Value 18', Comment = 'ESP="Valor buffer 18"';
        }
        field(25; "No. of Registers"; Text[2])
        {
            Caption = 'No. of Registers', Comment = 'ESP="Nº registros"';
        }
        field(27; "Buffer Value 40"; Text[40])
        {
            Caption = 'Buffer Value 40', Comment = 'ESP="Valor buffer 40"';
        }
        field(28; "Property Location"; Option)
        {
            BlankZero = true;
            Caption = 'Property Location', Comment = 'ESP="Ubicación inmueble"';
            OptionCaption = ' ,Property in Spain,Property in Basque / Navarra,Property W/o Tax number,Property outside Spain';
            OptionMembers = " ","Property in Spain","Property in Basque / Navarra","Property W/o Tax number","Property outside Spain";
        }
        field(29; "Property Tax Account No."; Text[25])
        {
            Caption = 'Property Tax Account No.', Comment = 'ESP="Nº cuenta fiscal inmueble"';
        }
        field(30; "EC %"; Decimal)
        {
            Caption = 'EC %', Comment = 'ESP="% Recargo equivalencia"';
        }
        field(31; "EC Amount"; Decimal)
        {
            Caption = 'EC Amount', Comment = 'ESP="Importe recargo equivalencia"';
        }
        field(32; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount', Comment = 'ESP="Importe IVA"';
        }
        field(33; "VAT Amount / EC Amount"; Decimal)
        {
            Caption = 'VAT Amount / EC Amount', Comment = 'ESP="Importe IVA / Recargo equivalencia"';
        }
        field(34; "Amount Including VAT / EC"; Decimal)
        {
            Caption = 'Amount Including VAT / EC', Comment = 'ESP="Importe con IVA / Recargo equivalencia"';
        }
        field(35; Type; Option)
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;
        }
        field(36; "Unrealized VAT Entry No."; Integer)
        {
            Caption = 'Unrealized VAT Entry No.', Comment = 'ESP="Nº mov. IVA no realizado"';
        }
        field(37; "Bank Account Ledger Entry No."; Integer)
        {
            Caption = 'Bank Account Ledger Entry No.', Comment = 'ESP="Nº mov. banco"';
            TableRelation = "Bank Account Ledger Entry";
        }
        field(38; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha registro"';
        }
        field(10705; "VAT Cash Regime"; Boolean)
        {
            Caption = 'VAT Cash Regime', Comment = 'ESP="Régimen especial de caja IVA"';
        }
        field(10706; "Collection Amount"; Decimal)
        {
            Caption = 'Collection Amount', Comment = 'ESP="Importe cobrado"';
        }
        field(51011; Modalidad; Option)
        {
            Caption = 'Modality', Comment = 'ESP="Modalidad IRPF"';
            Description = 'Mód. S2G (ABC) Modelos IRPF';
            OptionCaption = '0,1 - Renta o rendimiento satisfecho de tipo dinerario,2 - Renta o rendimiento satisfecho en especie';
            OptionMembers = "0","1 - Renta o rendimiento satisfecho de tipo dinerario","2 - Renta o rendimiento satisfecho en especie";
        }
        field(51012; Naturaleza; Text[30])
        {
            Caption = 'Nature', Comment = 'ESP="Naturaleza IRPF"';
            Description = 'Mód. S2G (ABC) Modelos IRPF';
        }
        field(51013; Clave; Code[10])
        {
            Caption = 'Key', Comment = 'ESP="Clave IRPF"';
        }
        field(51014; Subclave; Code[10])
        {
            Caption = 'Subkey', Comment = 'ESP="Subclave IRPF"';
        }
        field(51015; Importe; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(51016; Total; Decimal)
        {
            Caption = 'Total', Comment = 'ESP="Total"';
        }
    }

    keys
    {
        key(Key1; "Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'You cannot select a blank option for operation code R. Select another option for the field.';
        Text002: Label 'You cannot insert property tax account no. for selected property location.';

    procedure RemoveDuplicateAmounts()
    var
        VATEntry: Record "VAT Entry";
    begin
        IF NOT "VAT Cash Regime" THEN
            EXIT;

        IF "Document Type" IN
           [FORMAT(VATEntry."Document Type"::Payment),
            FORMAT(VATEntry."Document Type"::Refund),
            FORMAT(VATEntry."Document Type"::Bill)]
        THEN BEGIN
            "VAT Amount" := 0;
            "VAT Amount / EC Amount" := 0;
            "Amount Including VAT / EC" := 0;
            "RET %" := 0;
            Base := 0;
            "EC %" := 0;
            "EC Amount" := 0;
        END;
    end;
}
