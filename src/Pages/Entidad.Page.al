page 50148 Entidad
{
    // Page para el informe de power Bi:Aportación de Fondo Comun-> Entidad,filtrado por:
    // Empresa:Provincia Inmaculada
    // Dimension codigo:Entidad
    // Entidad codigo:301..398|401..498

    PageType = List;
    Caption = 'Entity', Comment = 'ESP="Entidad"';
    SourceTable = Entidades;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; Rec.Id)
                {
                }
                field(Codigo; Rec.Codigo)
                {
                }
                field(Nombre; Rec.Nombre)
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
        Rec.DELETEALL();
        Company.RESET();
        Company.SETFILTER(Name, 'PRO-PROVINCIA INMACULADA');
        IF Company.FINDSET() THEN
            REPEAT
                Dimension.RESET();
                Dimension.CHANGECOMPANY(Company.Name);
                Dimension.SETCURRENTKEY(Code);
                Dimension.SETFILTER("Dimension Code", 'ENTIDAD');
                Dimension.SETFILTER(Blocked, 'False');
                Dimension.SETFILTER(Code, '301..398|401..498');
                IF Dimension.FINDSET() THEN
                    REPEAT
                        Rec.INIT();
                        Rec.Id := Rec.Id + 1;
                        Rec.Codigo := Dimension.Code;
                        Rec.Nombre := Dimension.Name;
                        Rec.INSERT();
                    UNTIL Dimension.NEXT() = 0;
            UNTIL Company.NEXT() = 0;
    end;

    var
        Company: Record Company;
        Dimension: Record "Dimension Value";
}
