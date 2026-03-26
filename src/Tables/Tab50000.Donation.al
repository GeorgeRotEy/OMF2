table 50000 Donation
{
    // //Mód S2G (JGS) 18/12/17 Creacion de la tabla para registro de donaciones.
    //
    // //Mód S2G (SEG) 03/01/18 Modificación trigger OnInsert.

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.',
            Comment = 'ESP="Número"';
        }
        field(2; Post; Boolean)
        {
            Caption = 'Post',
            Comment = 'ESP="Registrar"';
        }
        field(3; "Posting date"; Date)
        {
            Caption = 'Posting Date',
            Comment = 'ESP="Fecha de registro"';
        }
        field(4; Donor; Text[50])
        {
            CalcFormula = Lookup("Third Party".Name WHERE("No." = FIELD(Third)));
            Caption = 'Donor',
            Comment = 'ESP="Donante"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount',
            Comment = 'ESP="Importe"';
        }
        field(6; Description; Text[250])
        {
            Caption = 'Description',
            Comment = 'ESP="Descripción"';
        }
        field(7; "Dimension budget"; Code[20])
        {
            Caption = 'Budget Dimension',
            Comment = 'ESP="Dimensión presupuestaria"';
            TableRelation = "Dimension Value" WHERE("Dimension Code" = CONST('PARTIDA PRESUPUESTAR'));
        }
        field(8; Third; Code[10])
        {
            Caption = 'Third Party',
            Comment = 'ESP="Tercero"';
            TableRelation = "Third Party"."No.";
        }
        field(9; "Registro interno"; Date)
        {
            Caption = 'System Log Date',
            Comment = 'ESP="Registro interno del sistema"';
            Description = 'S2G (JMP) 03/01/18';
        }
        field(10; "User ID"; Code[50])
        {
            Caption = 'User ID',
            Comment = 'ESP="Identificador de usuario"';
            Description = 'S2G (JMP) 03/01/18';
        }
        field(11; "No. Series"; Code[20])
        {
            Caption = 'No. Series',
            Comment = 'ESP="Serie de numeración"';
            Description = 'S2G (JMP) 03/01/18';
            TableRelation = "No. Series";
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
        // Mod S2G (SEG) 03/01/18 BEGIN
        IF "No." = '' THEN BEGIN
            GLSetup.GET;
            GLSetup.TESTFIELD("Nº Serie Donaciones");
            NoSeriesMgt.AreRelated(GLSetup."Nº Serie Donaciones", "No. Series");
        END;
        // Mod S2G (SEG) 03/01/18 END
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        GLSetup: Record "General Ledger Setup";
}
