pageextension 50003 "User Setup Ext" extends "User Setup"
{
    // // Mod. S2G 31/01/2018 (JGS) : Permisos por usuario.
    //         Nuevos campos
    //               Advance Chart
    //               Name ID
    // // Mod. S2G 04/02/2018 (JGS) : Permisos por usuario.
    //         Nuevos campos
    //               Crear proveedores
    //               Saldo Global
    //               Colegios
    //               Fraternidades
    //
    // Mod. S2G (RBM-R) GF-007: Control Presupuestario

    layout
    {
        addafter("Time Sheet Admin.")
        {
            field("Advance Chart"; Rec."Advance Chart")
            {
                ApplicationArea = All;
            }
            field("Name ID"; Rec."Name ID")
            {
                ApplicationArea = All;
            }
            field("Crear proveedores"; Rec."Crear proveedores")
            {
                ApplicationArea = All;
            }
            field("Saldo Global"; Rec."Saldo Global")
            {
                ApplicationArea = All;
            }
            field("Advance Chart Colegio"; Rec."Advance Chart Colegio")
            {
                ApplicationArea = All;
            }
            field("Advance Chart Fraternidad"; Rec."Advance Chart Fraternidad")
            {
                ApplicationArea = All;
            }
            field("Create dimension"; Rec."Create dimension")
            {
                ApplicationArea = All;
            }
            field("Unblock Budget Control"; Rec."Unblock Budget Control")
            {
                ApplicationArea = All;
            }
            field("Allow Delete All Invoices"; Rec."Allow Delete All Invoices")
            {
                ApplicationArea = All;
            }
        }
    }
}
