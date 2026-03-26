page 50166 NivelesCuentaResultados
{
    PageType = List;
    Caption = 'Income Statement Levels', Comment = 'ESP="Niveles cuenta resultados"';
    SourceTable = NivelesCuentaResultados;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Nivel 1"; Rec."Nivel 1")
                {
                }
                field("Nivel 2"; Rec."Nivel 2")
                {
                }
                field("Nivel 3"; Rec."Nivel 3")
                {
                }
                field("Nivel 4"; Rec."Nivel 4")
                {
                }
                field("Nivel 5"; Rec."Nivel 5")
                {
                }
                field(Cuenta; Rec.Cuenta)
                {
                }
                field("Signo contrario"; Rec."Signo contrario")
                {
                }
                field(Muestra; Rec.Muestra)
                {
                }
            }
        }
    }

    actions
    {
    }
}
