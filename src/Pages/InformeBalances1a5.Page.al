page 50161 InformeBalances1a5
{
    PageType = List;
    Caption = 'Balance Reports 1 to 5', Comment = 'ESP="Informe balances 1 a 5"';
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
        Rec.SETFILTER("Nº Cuenta", '1* | 2* | 3* | 4* | 5*');
        Rec.SETFILTER(Empresa, '<>ZZ_IS_Consol. Prv_Frat_Col_Exp');
    end;
}
