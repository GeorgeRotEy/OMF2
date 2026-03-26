page 50085 "Third Party Company Subform"
{
    // // Mod. S2G 18/12/2017 (JGS) : TER001 ã Terceros.
    //
    // // Mod. S2G 05/02/2018 (JGS) : Crear proveedor.
    //              Triger OnOpenPage

    Caption = 'Third Party Company Subform', Comment = 'ESP="Subformulario empresa tercero"';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Company OFM";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                    Editable = false;
                }
                field(CustEnabled; bCustEnabled)
                {
                    Caption = 'Cliente habilitado';

                    trigger OnValidate()
                    begin
                        OnValidateEnabled(bCustEnabled, 0);
                    end;
                }
                field(CustNo; vCustNo)
                {
                    Caption = 'Nº cliente';
                    Editable = false;
                }
                field(VendEnabled; bVendEnabled)
                {
                    Caption = 'Proveed. habilitado';
                    Visible = vShow;

                    trigger OnValidate()
                    begin
                        OnValidateEnabled(bVendEnabled, 1);
                    end;
                }
                field(VendNo; vVendNo)
                {
                    Caption = 'Nº proveedor';
                    Editable = false;
                    Visible = vShow;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IF vThirdPartyNo = '' THEN BEGIN
            vCustNo := '';
            vVendNo := '';
        END ELSE BEGIN
            ThirdParty.CheckThirdPartyEnabled(Rec.Name, 0, vThirdPartyNo, bCustEnabled, vCustNo);
            ThirdParty.CheckThirdPartyEnabled(Rec.Name, 1, vThirdPartyNo, bVendEnabled, vVendNo);
        END;
        CurrPage.UPDATE(FALSE);
    end;

    trigger OnOpenPage()
    begin
        // Mod. S2G 05/02/2018 (JGS) : Crear proveedor.
        IF UserSetup.GET(USERID) THEN
            IF UserSetup."Crear proveedores" THEN
                vShow := TRUE
            ELSE
                vShow := FALSE;
        // Mod. S2G 05/02/2018 (JGS) : Crear proveedor.
        FillInTable;
    end;

    var
        TestCompanyPreffix: Label 'ZZ';
        ThirdParty: Record "Third Party";
        bCustEnabled: Boolean;
        bVendEnabled: Boolean;
        vCustNo: Code[20];
        vVendNo: Code[20];
        vThirdPartyNo: Code[20];
        UserSetup: Record "User Setup";
        vShow: Boolean;

    local procedure FillInTable()
    var
        CompanyOFM: Record "Company OFM";
    begin
        Rec.RESET();
        Rec.DELETEALL();

        CompanyOFM.RESET();
        CompanyOFM.SETRANGE("Evaluation Company", FALSE);
        IF CompanyOFM.FINDFIRST() THEN
            REPEAT
                IF UPPERCASE(COPYSTR(CompanyOFM.Name, 1, 2)) <> TestCompanyPreffix THEN BEGIN
                    Rec.INIT();
                    Rec := CompanyOFM;
                    Rec.INSERT();
                END;
            UNTIL CompanyOFM.NEXT() = 0;
    end;

    procedure SetThirdPartyNo(pThirdPartyNo: Code[20])
    begin
        vThirdPartyNo := pThirdPartyNo;
    end;

    local procedure OnValidateEnabled(pEnabled: Boolean; pThirdPartyType: Option Customer,Vendor)
    var
        ThirdParty: Record "Third Party";
        CustVendNo: Code[20];
        FunctionsS2g: Codeunit "Functions S2G";
    begin
        ThirdParty.GET(vThirdPartyNo);
        IF pEnabled THEN BEGIN
            FunctionsS2g.EnableCustVendBasedOnThirdParty(ThirdParty, pThirdPartyType, CustVendNo, Rec.Name);
            IF pThirdPartyType = 0 THEN
                vCustNo := CustVendNo
            ELSE
                vVendNo := CustVendNo;
        END ELSE BEGIN
            FunctionsS2g.DisableCustVendFromThirdParty(ThirdParty, pThirdPartyType, Rec.Name);
            IF pThirdPartyType = 0 THEN
                vCustNo := ''
            ELSE
                vVendNo := '';
        END;
        CurrPage.UPDATE(FALSE);
    end;
}
