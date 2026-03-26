page 50087 "Third Party Statistics FactBox"
{
    // // Mod. S2G 18/12/2017 (JGS) : TER001 ã Terceros.
    //
    // // Mod. S2G 05/02/2018 (JGS) : Saldo Global Fact BOX.

    Caption = 'Third Party Statistics', Comment = 'ESP="Estadísticas tercero"';
    PageType = CardPart;
    SourceTable = "Third Party";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                Caption = 'Third Party No.';
                ToolTip = 'Specifies the number of the third party. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.', Comment = 'ESP="Especifica el número del tercero. El campo se rellena automáticamente a partir de una serie numérica definida o se introduce manualmente porque ha habilitado la introducción manual de números en la configuración de la serie numérica."';
                Visible = ShowThirdPartyNo;

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            group(Company)
            {
                Caption = 'Company', Comment = 'ESP="Empresa"';
                field("Company Cust. Balance (LCY)"; Rec."Company Cust. Balance (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    HideValue = DateFilterSet;
                    ToolTip = 'Specifies your expected sales income from the customer in LCY based on ongoing sales orders.', Comment = 'ESP="Especifica sus ingresos esperados por ventas del cliente en divisa local basados en pedidos de venta en curso."';
                }
                field("Company Vend. Balance (LCY)"; Rec."Company Vend. Balance (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Company Vend. Balance (LCY)';
                    HideValue = DateFilterSet;
                    ToolTip = 'Specifies your expected sales income from the customer in LCY based on ongoing sales orders where items have been shipped.', Comment = 'ESP="Especifica sus ingresos esperados por ventas del cliente en divisa local basados en pedidos de venta en curso cuyos artículos ya se han enviado."';
                }
                field("Company G/L Balance"; Rec."Company G/L Balance")
                {
                    ApplicationArea = Basic, Suite;
                    HideValue = DateFilterSet;
                    ToolTip = 'Specifies your expected sales income from the customer in LCY based on unpaid sales invoices.', Comment = 'ESP="Especifica sus ingresos esperados por ventas del cliente en divisa local basados en facturas de venta impagadas."';
                }
                field("Company Cust. Net Change (LCY)"; Rec."Company Cust. Net Change (LCY)")
                {
                }
                field("Company Vend. Net Change (LCY)"; Rec."Company Vend. Net Change (LCY)")
                {
                }
                field("Company G/L Net Change"; Rec."Company G/L Net Change")
                {
                }
            }
            group(Global)
            {
                Caption = 'Global', Comment = 'ESP="Global"';
                Visible = ShowGlobal;
                field(ThirdPartyLedgEntries_CalcGlobalCustBalance;
                ThirdPartyLedgEntries.CalcGlobalCustBalance(Rec."No.", TRUE))
                {
                    Caption = 'Global Customer Balance (LCY)', Comment = 'ESP="Saldo global de cliente (LCY)"';
                    Editable = false;
                    Visible = ShowGlobal;
                }
                field(ThirdPartyLedgEntries_CalcGlobalVendBalance;
                ThirdPartyLedgEntries.CalcGlobalVendBalance(Rec."No.", TRUE))
                {
                    Caption = 'Global Vendor Balance (LCY)', Comment = 'ESP="Saldo global de proveedor (LCY)"';
                    Editable = false;
                    Visible = ShowGlobal;
                }
                field(ThirdPartyLedgEntries_CalcGlobalGLBalance;
                ThirdPartyLedgEntries.CalcGlobalGLBalance(Rec."No."))
                {
                    Caption = 'Global G/L Balance', Comment = 'ESP="Saldo global de contabilidad (G/L)"';
                    Editable = false;
                    Visible = ShowGlobal;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec.FILTERGROUP(4);
        DateFilterSet := Rec.GETFILTER("Date Filter") <> '';
    end;

    trigger OnInit()
    begin
        // Mod. S2G 05/02/2018 (JGS) : Saldo Global Fact BOX.
        IF UserSetup.GET(USERID) THEN
            IF UserSetup."Saldo Global" THEN
                ShowGlobal := TRUE
            ELSE
                ShowGlobal := FALSE;
        // Mod. S2G 05/02/2018 (JGS) : Saldo Global Fact BOX.
        ShowThirdPartyNo := TRUE;
    end;

    var
        ThirdPartyLedgEntries: Page "Third Party Ledger Entries";
        ShowThirdPartyNo: Boolean;
        DateFilterSet: Boolean;
        ShowGlobal: Boolean;
        UserSetup: Record "User Setup";

    local procedure ShowDetails()
    begin
        PAGE.RUN(PAGE::"Customer Card", Rec);
    end;

    procedure SetThirdPartyNoVisibility(Visible: Boolean)
    begin
        ShowThirdPartyNo := Visible;
    end;
}
