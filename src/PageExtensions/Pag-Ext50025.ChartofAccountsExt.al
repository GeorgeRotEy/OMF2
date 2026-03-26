pageextension 50025 "Chart of Accounts Ext" extends "Chart of Accounts"
{
    //GR-02022026
    // Mod. S2G 16/12/2017 (JGS) : GF001 ã Plan de cuentas corporativo.

    // Mod. S2G 10/02/2018 (JGS) : Modificacion permisos colegios.begin
    //            Trigger
    //                OnOpenPage

    // IF UserSetup.GET(USERID)THEN BEGIN
    //   IF NOT UserSetup."Advance Chart Colegio" THEN  BEGIN
    //     Rec.FILTERGROUP(2);
    //     Rec.SETFILTER("No.",'<>%1&<>%2&<>%3&<>%4&<>%5&<>%6&<>%7&<>%8&<>%9','6051','6052','6053','6054','6055','6056','6057','6059','605');
    //     Rec.FILTERGROUP(0);
    //   END;
    // END;

    // Mod. S2G (RBM-R) GF-007: Control Presupuestario
    layout
    {
        modify("Balance at Date")
        {
            Visible = false;
        }
        addafter("Balance at Date")
        {
            field("Balance at Date OFM"; Rec."Balance at Date OFM")
            {
                ApplicationArea = All;
            }
        }
        addafter("Default Deferral Template Code")
        {
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
            }
            field("Budget Control Not Applied"; Rec."Budget Control Not Applied")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(IndentChartOfAccounts)
        {
            action("Traer &cuentas corporativas")
            {
                Caption = 'Bring &corporate accounts', Comment = 'ESP="Traer &cuentas corporativas"';
                Image = ApplyEntries;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // Mod. S2G 07/12/2017 (CSM) : GF001 ã begin
                    cFuncionesPLC.fTraerCuentasCorporativas();
                    // Mod. S2G 07/12/2017 (CSM) : GF001 ã end
                end;
            }
        }
        addafter("G/L Register")
        {
            action("Transfer to Distribution")
            {
                Caption = 'Transfer to Distribution', Comment = 'ESP="Transferir a reparto"';
                Image = Task;
                RunObject = Report "Copy GLAccount to Distribute";
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Mod. S2G 10/02/2018 (JGS) : Modificacion permisos colegios.begin
        IF UserSetup.GET(USERID) THEN
            IF NOT UserSetup."Advance Chart Colegio" THEN BEGIN
                Rec.FILTERGROUP(2);
                //Rec.SETFILTER("No.",TextFiltroCuenta,'6050001','6051001','6052001','6053001','6054001','6055001','6056001','6057001','6059001','6050','6051','6052','6053');
                Rec.SETFILTER("No.", '<>%1', '605*');
                Rec.FILTERGROUP(0);
            END;
        // Mod. S2G 10/02/2018 (JGS) : Modificacion permisos colegios.end
    end;

    var
        cFuncionesPLC: Codeunit "Functions S2G";
        UserSetup: Record "User Setup";
}
