table 50033 "Distribution Registers"
{
    Caption = 'Distribution Registers', Comment = 'ESP="Registros de reparto"';

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.', Comment = 'ESP="Número"';
            Editable = false;
        }
        field(2; "From Entry No."; Integer)
        {
            Caption = 'From Entry No.', Comment = 'ESP="Desde nº movimiento"';
            Editable = false;
            TableRelation = "Distribution Entry";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(3; "To Entry No."; Integer)
        {
            Caption = 'To Entry No.', Comment = 'ESP="Hasta nº movimiento"';
            Editable = false;
            TableRelation = "Distribution Entry";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(4; "Creation Date"; Date)
        {
            Caption = 'Creation Date', Comment = 'ESP="Fecha de creación"';
            Editable = false;
        }
        field(5; "Source Code"; Code[10])
        {
            Caption = 'Source Code', Comment = 'ESP="Código origen"';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID', Comment = 'ESP="Usuario"';
            Editable = false;
            TableRelation = User."User Name";
        }
        field(10; Reversed; Boolean)
        {
            Caption = 'Reversed', Comment = 'ESP="Revertido"';
            Editable = false;
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

    trigger OnDelete()
    begin
        //ERROR(Text_DeleteNotAllowed);
    end;

    trigger OnInsert()
    begin
        ERROR(Text_InsertNotAllowed);
    end;

    trigger OnModify()
    begin
        ERROR(Text_UpdateNotAllowed);
    end;

    var
        Text_UpdateNotAllowed: Label 'Update is not allowed for this table', Comment = 'ESP="No se permite modificar esta tabla"';
        Text_DeleteNotAllowed: Label 'Delete is not allowed for this table', Comment = 'ESP="No se permite eliminar en esta tabla"';
        Text_InsertNotAllowed: Label 'Insert is not allowed for this table', Comment = 'ESP="No se permite insertar en esta tabla"';
}
