page 50149 MovContabilidad4
{
    // Page para el informe de power Bi:Aportación de Fondo Comun-> Movimientos presupuestarios,filtrado por:
    // Empresa:Provincia Inmaculada
    // Numero de cuenta:5500001
    // Entidad codigo:301..398|401..498
    // Actividad codigo:6310|6320|6330

    PageType = List;
    Caption = 'Accounting Movements 4', Comment = 'ESP="MovContabilidad4"';
    SourceTable = TablaMovContabilidad4;
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
                field("Nº Cuenta"; Rec."Nº Cuenta")
                {
                }
                field("Fecha registro"; Rec."Fecha registro")
                {
                }
                field(Importe; Rec.Importe)
                {
                }
                field("Entidad Codigo"; Rec."Entidad Codigo")
                {
                }
                field("Actividad Codigo"; Rec."Actividad Codigo")
                {
                }
            }
        }
    }

    actions
    {
    }
}
