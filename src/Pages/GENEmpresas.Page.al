page 50132 "GEN-Empresas"
{
    PageType = List;
    Caption = 'Companies', Comment = 'ESP="Empresas"';
    SourceTable = "Company OFM";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                }
                field("Entidad ID"; Rec."Entidad ID")
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
        Rec.SETFILTER(Name, 'COM*|TIE*|HOS*|UNI*|EDI*|COL*|FRA*|PRO*');
        /*
        DELETEALL();
        Companies.RESET();
        Companies.SETFILTER(Name, 'COM*|TIE*|HOS*|UNI*|EDI*|COL*|FRA*|PRO*');
        IF Companies.FINDSET() THEN
          REPEAT
            INIT;
            Empresa:=Companies.Name;
            INSERT();
           UNTIL Companies.NEXT=0;
        */
    end;
}
