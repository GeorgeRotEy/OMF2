tableextension 50012 "Employee Ext" extends Employee
{
    fields
    {
        field(50000; "User Web"; Code[20])
        {
            Caption = 'Web User', Comment = 'ESP="Usuario web"';
        }
        field(50001; "Password Web"; Text[30])
        {
            Caption = 'Web Password', Comment = 'ESP="Contraseña web"';
        }
    }
}
