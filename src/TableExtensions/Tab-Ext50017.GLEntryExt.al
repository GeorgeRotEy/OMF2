tableextension 50017 "G/L Entry Ext" extends "G/L Entry"
{
    fields
    {
        field(50000; "Posting concept"; Text[250])
        {
            Caption = 'Posting Concept', Comment = 'ESP="Concepto contable"';
        }
        field(50001; "Source Description"; Text[101])
        {
            Caption = 'Source Description', Comment = 'ESP="Descripción origen"';
        }
        field(50002; "Shortcut Dimension 3"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3', Comment = 'ESP="Dimensión acceso directo 3"';
            TableRelation = "Dimension Value".Code
                where("Global Dimension No." = const(3));
        }
        field(50003; "Shortcut Dimension 4"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4', Comment = 'ESP="Dimensión acceso directo 4"';
            TableRelation = "Dimension Value".Code
                where("Global Dimension No." = const(4));
        }
        field(50004; "Shortcut Dimension 5"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5', Comment = 'ESP="Dimensión acceso directo 5"';
            TableRelation = "Dimension Value".Code
                where("Global Dimension No." = const(5));
        }
        field(50005; "Shortcut Dimension 6"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6', Comment = 'ESP="Dimensión acceso directo 6"';
            TableRelation = "Dimension Value".Code
                where("Global Dimension No." = const(6));
        }
        field(50030; "Third Party No."; Code[20])
        {
            Caption = 'Third Party No.', Comment = 'ESP="Nº tercero"';
            TableRelation = "Third Party";
        }
        field(51000; "No. mov. retención"; Integer)
        {
            Caption = 'Retention Entry No.', Comment = 'ESP="Nº mov. retención"';

            trigger OnLookup()
            begin
                cFuncionesRET.fVerMovimientoRetención("No. mov. retención");
            end;
        }
        field(51001; "Base Retención IRPF"; Decimal)
        {
            Caption = 'IRPF Retention Base', Comment = 'ESP="Base retención IRPF"';
        }
        field(51002; "Porcentaje Retención"; Decimal)
        {
            Caption = 'Retention Percentage', Comment = 'ESP="Porcentaje retención"';
        }
        field(51003; "Clave IRPF"; Text[50])
        {
            Caption = 'IRPF Code', Comment = 'ESP="Clave IRPF"';
        }
        field(51004; "Subclave IRPF"; Text[50])
        {
            Caption = 'IRPF Subcode', Comment = 'ESP="Subclave IRPF"';
        }
        field(51005; Residencia; Option)
        {
            Caption = 'Residence', Comment = 'ESP="Residencia"';
            OptionCaption = 'Resident,Non-resident';
            OptionMembers = Residente,"No residente";
        }
        field(51006; "Código IRPF"; Code[20])
        {
            Caption = 'IRPF Code', Comment = 'ESP="Código IRPF"';

            trigger OnLookup()
            begin
                Clear(cFuncionesRET);
                cFuncionesRET.fLookupCódigoretención("Código IRPF", 0);
            end;
        }
        field(51007; Liquidado; Boolean)
        {
            Caption = 'Settled', Comment = 'ESP="Liquidado"';
            Editable = false;
        }
        field(51008; "Movimiento IRPF liquidado"; Integer)
        {
            Caption = 'Settled IRPF Entry', Comment = 'ESP="Movimiento IRPF liquidado"';
            Editable = false;
        }
        field(51009; "Proveedor IRPF"; Code[20])
        {
            Caption = 'IRPF Vendor', Comment = 'ESP="Proveedor IRPF"';
        }
        field(51010; "Modalidad IRPF"; Option)
        {
            Caption = 'IRPF Type', Comment = 'ESP="Modalidad IRPF"';
            OptionCaption = ' ,1 - Monetary income or yield paid,2 - In-kind income or yield paid';
            OptionMembers = " ","1 - Renta o rendimiento satisfecho de tipo dinerario","2 - Renta o rendimiento satisfecho en especie";
        }
    }

    var
        cFuncionesRET: Codeunit "Gestión IRPF";
}
