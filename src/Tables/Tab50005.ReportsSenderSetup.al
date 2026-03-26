table 50005 "Reports Sender Setup"
{
    // Mod. S2G (RBM-R) GF-006: Envío de informes
    // KPMG.GRL New Day of the month field
    // TEMS-363 APAREJA Añadir el campo ShoRowNo

    Caption = 'Report Delivery', Comment = 'ESP="Envío de informes"';

    fields
    {
        field(1; "Acc. Schedule Name"; Code[10])
        {
            Caption = 'Account Schedule Name', Comment = 'ESP="Nombre esquema de cuentas"';
            TableRelation = "Acc. Schedule Name".Name;
        }
        field(2; "Column Layout Name"; Code[10])
        {
            Caption = 'Column Layout Name', Comment = 'ESP="Nombre plantilla de columnas"';
            TableRelation = "Column Layout Name".Name;
        }
        field(5; Email; Text[250])
        {
            Caption = 'Email', Comment = 'ESP="Correo electrónico"';
        }
        field(6; Active; Boolean)
        {
            Caption = 'Active', Comment = 'ESP="Activo"';
        }
        field(7; "Day of the month"; Integer)
        {
            Caption = 'Day of the Month', Comment = 'ESP="Día del mes"';

            trigger OnValidate()
            var
                DayOfTheMonthError: Label 'Day %1 does not exist as a day of any month';
            begin
                IF ("Day of the month" > 31) THEN
                    ERROR(DayOfTheMonthError, FORMAT("Day of the month"));
            end;
        }
        field(8; ShowRowNo; Boolean)
        {
            Caption = 'Show Row No.', Comment = 'ESP="Mostrar nº de fila"';
            Description = 'TEMS-363';
        }
    }

    keys
    {
        key(Key1; Active, "Acc. Schedule Name", "Column Layout Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
