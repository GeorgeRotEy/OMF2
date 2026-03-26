page 50076 "Movs. retenciones"
{
    Editable = false;
    Caption = 'Retention Entries', Comment = 'ESP="Movs. retenciones"';
    PageType = Worksheet;
    SourceTable = "Movs. retenciones";
    //SourceTableView = WHERE(No. mov. contabilidad=    ApplicationArea = All;
    ApplicationArea = All;
    UsageCategory = Lists;
    //FILTER(<>0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Nº mov."; Rec."Nº mov.")
                {
                }
                field("Grupo registro retención"; Rec."Grupo registro retención")
                {
                }
                field("% retención"; Rec."% retención")
                {
                }
                field("Fecha registro"; Rec."Fecha registro")
                {
                }
                field("Tipo documento"; Rec."Tipo documento")
                {
                }
                field("Nº documento"; Rec."Nº documento")
                {
                }
                field("Nº linea IRPF"; Rec."Nº linea IRPF")
                {
                }
                field(Tipo; Rec.Tipo)
                {
                }
                field(Base; Rec.Base)
                {
                }
                field(Importe; Rec.Importe)
                {
                }
                field("Importe calculado"; Rec."Importe calculado")
                {
                }
                field("Id. usuario"; Rec."Id. usuario")
                {
                }
                field("Cod. origen"; Rec."Cod. origen")
                {
                }
                field("Cod. auditoría"; Rec."Cod. auditoría")
                {
                }
                field("Nº documento externo"; Rec."Nº documento externo")
                {
                }
                field("Fecha emision documento"; Rec."Fecha emision documento")
                {
                }
                field("CIF/NIF"; Rec."CIF/NIF")
                {
                }
                field("Nº documento original"; Rec."Nº documento original")
                {
                }
                field("Nº linea retención original"; Rec."Nº linea retención original")
                {
                }
                field("Tipo documento original"; Rec."Tipo documento original")
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
