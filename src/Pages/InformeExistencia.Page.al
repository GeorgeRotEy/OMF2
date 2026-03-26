page 50151 InformeExistencia
{
    // oEmpresas que sean explotaciones (tiendas, revistas, hospederías, etc) y de pro-explotaciones.
    // oCuentas de la 30..01 a la 3290..01 (Como las que salen en la foto de arriba)
    // oTenemos que traer los siguientes campos:
    // EmpresaNº CuentaNombre cuentaImporteFecha registro

    PageType = List;
    Caption = 'Inventory Report', Comment = 'ESP="Informe existencia"';
    SourceTable = InformeExistencia;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.id)
                {
                }
                field(Empresa; Rec.Empresa)
                {
                }
                field("Nombre Cuenta"; Rec."Nombre Cuenta")
                {
                }
                field("Nº Cuenta"; Rec."Nº Cuenta")
                {
                }
                field("Fecha registro"; Rec."Fecha registro")
                {
                }
                field(Importe; Rec.Importe)
                {
                }
            }
        }
    }

    actions
    {
    }
}
