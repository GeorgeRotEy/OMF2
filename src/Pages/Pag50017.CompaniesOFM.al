namespace OFM.OFM;
using System.Environment;

page 50017 "Companies OFM"
{
    ApplicationArea = All;
    Caption = 'Companies OFM', Comment = 'ESP="Empresas OFM"';
    PageType = List;
    SourceTable = "Company OFM";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                }
                field("Easy Register"; Rec."Easy Register")
                {
                }
                field("School ID"; Rec."School ID")
                {
                }
                field("Entidad ID"; Rec."Entidad ID")
                {
                }
                //GR-add-30-01
                field("Evaluation Company"; Rec."Evaluation Company")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        rlCompany: Record Company;
        rlCompanyOFM: Record "Company OFM";
    begin
        rlCompany.Reset();
        if rlCompany.FindSet() then
            repeat
                if not rlCompanyOFM.Get(rlCompany.Name) then begin
                    rlCompanyOFM.Init();
                    rlCompanyOFM.Name := rlCompany.Name;
                    rlCompanyOFM."Evaluation Company" := rlCompany."Evaluation Company";
                    rlCompanyOFM.Insert();
                end else
                    if rlCompanyOFM.Name <> rlCompany.Name then begin
                        rlCompanyOFM.Name := rlCompany.Name;
                        rlCompanyOFM."Evaluation Company" := rlCompany."Evaluation Company";
                        rlCompanyOFM.Modify();
                    end;
            until rlCompany.Next() = 0;
    end;
}
