page 50075 "Grupos registro retención"
{
    // 25.01.14 DES0005 MIG Showed fields: CLTRET
    Caption = 'Retention Posting Groups', Comment = 'ESP="Grupos registro retención"';
    PageType = Worksheet;
    PopulateAllFields = true;
    SourceTable = "Grupo registro retención";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cód. grupo"; Rec."Cód. grupo")
                {
                }
                field(Descripcion; Rec.Descripcion)
                {
                }
                field("% retención"; Rec."% retención")
                {
                }
                field("Cuenta compras"; Rec."Cuenta compras")
                {
                }
                field("Cuenta ventas"; Rec."Cuenta ventas")
                {
                }
                field("Tipo retención"; Rec."Tipo retención")
                {
                }
                field("Clave IRPF"; Rec."Clave IRPF")
                {
                }
                field("Subclave IRPF"; Rec."Subclave IRPF")
                {
                }
            }
        }
    }

    actions
    {
    }
}
