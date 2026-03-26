table 50006 "Aux plan corporativo"
{
    // // Mod. S2G 16/12/2017 (JGS) : GF001 ã Plan de cuentas corporativo.

    Caption = 'Corporate Auxiliary Plan', Comment = 'ESP="Plan auxiliar corporativo"';
    LookupPageID = 50043;

    fields
    {
        field(1; "Nº"; Text[20])
        {
            Caption = 'No.', Comment = 'ESP="Número"';
            NotBlank = true;
            Numeric = true;

            trigger OnValidate()
            var
                TestNo: Integer;
            begin
            end;
        }
        field(2; Nombre; Text[50])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(3; Alias; Code[50])
        {
            Caption = 'Search Name', Comment = 'ESP="Nombre de búsqueda"';
        }
        field(4; "Tipo mov."; Option)
        {
            Caption = 'Account Type', Comment = 'ESP="Tipo de movimiento"';
            OptionCaption = 'Posting,Heading', Comment = 'ESP="Movimiento,Encabezado"';
            OptionMembers = Posting,Heading;

            trigger OnValidate()
            var
                GLEntry: Record "G/L Entry";
                GLBudgetEntry: Record "G/L Budget Entry";
            begin
            end;
        }
        field(9; "Comercial/Balance"; Option)
        {
            Caption = 'Income/Balance', Comment = 'ESP="Comercial / Balance"';
            OptionCaption = 'Income Statement,Balance Sheet,Capital', Comment = 'ESP="Pérdidas y ganancias,Balance,Capital"';
            OptionMembers = "Income Statement","Balance Sheet",Capital;
        }
        field(10; "Debe/Haber"; Option)
        {
            Caption = 'Debit/Credit', Comment = 'ESP="Debe / Haber"';
            OptionCaption = 'Both,Debit,Credit', Comment = 'ESP="Ambos,Debe,Haber"';
            OptionMembers = Both,Debit,Credit;
        }
        field(14; "Entrada directa"; Boolean)
        {
            Caption = 'Direct Posting', Comment = 'ESP="Entrada directa"';
            InitValue = true;
        }
        field(19; Indentar; Integer)
        {
            Caption = 'Indentation', Comment = 'ESP="Indentación"';
            MinValue = 0;
        }
        field(34; Sumatorio; Text[250])
        {
            Caption = 'Totaling', Comment = 'ESP="Sumatorio"';
            // propiedades no soportadas comentadas
        }
        field(40; "Cta. consol. debe"; Code[20])
        {
            Caption = 'Consol. Debit Acc.', Comment = 'ESP="Cuenta de consolidación debe"';

            trigger OnValidate()
            var
                ConflictGLAcc: Record "G/L Account";
            begin
            end;
        }
        field(41; "Cta. consol. haber"; Code[20])
        {
            Caption = 'Consol. Credit Acc.', Comment = 'ESP="Cuenta de consolidación haber"';

            trigger OnValidate()
            var
                ConflictGLAcc: Record "G/L Account";
            begin
            end;
        }
        field(43; "Tipo IVA"; Option)
        {
            Caption = 'Gen. Posting Type', Comment = 'ESP="Tipo de IVA"';
            OptionCaption = ' ,Purchase,Sale', Comment = 'ESP=" ,Compra,Venta"';
            OptionMembers = " ",Purchase,Sale;
        }
        field(10700; "Cta. regularización"; Code[20])
        {
            Caption = 'Income Stmt. Bal. Acc.', Comment = 'ESP="Cuenta de regularización"';
        }
        field(52000; "Existe en plan"; Boolean)
        {
            Caption = 'Exists in Plan', Comment = 'ESP="Existe en el plan"';
            Description = 'GF001-Indica si la cuenta ya está en el plan de cuentas de la empresa';
        }
        field(90000; "Acción"; Option)
        {
            Caption = 'Action', Comment = 'ESP="Acción"';
            OptionCaption = ' ,Bring', Comment = 'ESP=" ,Traer"';
            OptionMembers = " ",Traer;
        }
        field(3010551; "Nº tipo coste"; Text[20])
        {
            Caption = 'Cost Type No.', Comment = 'ESP="Nº tipo de coste"';
            Editable = false;
            TableRelation = "Cost Type";
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "Nº")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
