table 50027 "Analytical Distribution Setup"
{
    Caption = 'Analytical Distribution Setup', Comment = 'ESP="Configuración de distribución analítica"';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary key', Comment = 'ESP="Clave primaria"';
        }
        field(2; "No Series Assignment"; Code[10])
        {
            Caption = 'No Series Assignment', Comment = 'ESP="Nº serie asignación"';
            TableRelation = "No. Series";
        }
        field(3; "Transfer start date"; Date)
        {
            Caption = 'Transfer start date', Comment = 'ESP="Fecha inicio traspaso"';

            trigger OnValidate()
            begin
                IF xRec."Transfer start date" <> 0D THEN
                    //ERROR(Text50001)
                    MESSAGE(Text50003)
                ELSE
                    IF NOT CONFIRM(Text50002, FALSE) THEN
                        ERROR('');
            end;
        }
        field(4; "No Series Distribution"; Code[10])
        {
            Caption = 'No Series Distribution', Comment = 'ESP="Nº serie reparto"';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text50001: Label 'It cannot be changed. Assignment initiated.', Comment = 'ESP="No se puede cambiar. Asignación iniciada."';
        Text50002: Label 'Do you want continue? The date cannot be changed afterwards', Comment = 'ESP="¿Desea continuar? La fecha no podrá cambiarse después."';
        Text50003: Label 'It cannot be changed. Assignment initiated.', Comment = 'ESP="No se puede cambiar. Asignación iniciada."';
}
