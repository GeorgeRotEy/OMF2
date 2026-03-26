tableextension 50001 "User Setup Ext" extends "User Setup"
{
    fields
    {
        field(50000; "Advance Chart"; Boolean)
        {
            Caption = 'Advanced Chart',
            Comment = 'ESP="Gráfico avanzado"';
        }
        field(50001; "Name ID"; Text[30])
        {
            Caption = 'User Full Name',
            Comment = 'ESP="Nombre completo del usuario"';
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("User ID")));
            FieldClass = FlowField;
        }
        field(50002; "Crear proveedores"; Boolean)
        {
            Caption = 'Create Vendors',
            Comment = 'ESP="Permite crear proveedores"';
        }
        field(50003; "Saldo Global"; Boolean)
        {
            Caption = 'Global Balance',
            Comment = 'ESP="Saldo global"';
        }
        field(50004; "Advance Chart Fraternidad"; Boolean)
        {
            Caption = 'Advanced Chart Fraternidad',
            Comment = 'ESP="Gráfico avanzado para Fraternidad"';
        }
        field(50005; "Advance Chart Colegio"; Boolean)
        {
            Caption = 'Advanced Chart School',
            Comment = 'ESP="Gráfico avanzado para colegio"';
        }
        field(50006; "Create dimension"; Boolean)
        {
            Caption = 'Create Dimension',
            Comment = 'ESP="Permite crear dimensiones"';
        }
        field(50007; "Unblock Budget Control"; Boolean)
        {
            Caption = 'Unblock Budget Control',
            Comment = 'ESP="Control presupuestario"';
        }
        field(50008; "Allow Delete All Invoices"; Boolean)
        {
            Caption = 'Allow Deleting All Invoices',
            Comment = 'ESP="Eliminar todas las facturas"';
        }
    }
}