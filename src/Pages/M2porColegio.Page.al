page 50168 "M2 por Colegio"
{
    PageType = List;
    Caption = 'M2 by School', Comment = 'ESP="M2 por Colegio"';
    SourceTable = "Alumnos por Colegio";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID Colegio"; Rec."ID Colegio")
                {
                    trigger OnValidate()
                    begin
                        rCompanyOFM.RESET();
                        rCompanyOFM.SETRANGE("School ID", Rec."ID Colegio");
                        IF rCompanyOFM.FINDFIRST() THEN
                            Rec.VALIDATE(Empresa, rCompanyOFM.Name)
                    end;
                }
                field(Empresa; Rec.Empresa)
                {
                    trigger OnValidate()
                    begin
                        IF rCompanyOFM.GET(Rec.Empresa) THEN
                            Rec.VALIDATE("ID Colegio", rCompanyOFM."School ID")
                    end;
                }
                field("Año"; Rec."Año")
                {
                }
                field("Nº Alumnos"; Rec."Nº Alumnos")
                {
                }
                field(m2; Rec.m2)
                {
                }
                field("Año construccion"; Rec."Año construccion")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        rCompanyOFM: Record "Company OFM";
}
