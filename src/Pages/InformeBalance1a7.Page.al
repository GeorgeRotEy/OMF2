page 50165 InformeBalance1a7
{
    PageType = List;
    Caption = 'Balance Report 1 to 7', Comment = 'ESP="Informe balance 1 a 7"';
    SourceTable = InformeBalances;
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
                field(Descripcion; Rec.Descripcion)
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
                field("Nº mov"; Rec."Nº mov")
                {
                }
                field("Account Name"; Rec."Account Name")
                {
                }
                field("Debe Amount"; Rec."Debe Amount")
                {
                }
                field("Haber Amount"; Rec."Haber Amount")
                {
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                }
                field("Actividad Codigo"; Rec."Actividad Codigo")
                {
                }
                field("Entidad Codigo"; Rec."Entidad Codigo")
                {
                }
                field("Entidad Nombre"; Rec."Entidad Nombre")
                {
                }
                field("Actividad Nombre"; Rec."Actividad Nombre")
                {
                }
                field("Servicio Codigo"; Rec."Servicio Codigo")
                {
                }
                field("Servicio Nombre"; Rec."Servicio Nombre")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SETFILTER(Empresa, '<>ZZ_IS_Consol. Prv_Frat_Col_Exp');
    end;
}
