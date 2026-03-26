table 50300 "Budget Control Setup"
{
    // Mod. S2G (RBM-R) GF-007: Control Presupuestario

    Caption = 'Config. Control presupuestario';

    fields
    {
        field(1; "Primary key"; Code[10])
        {
            Caption = 'Primary Key', Comment = 'ESP="Clave primaria"';
        }
        field(2; "Message %"; Decimal)
        {
            Caption = 'Message %', Comment = 'ESP="% Mensaje"';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Message %" > 100 THEN
                    ERROR('');

                "Warning %" := 0;
                "Error %" := 0;
            end;
        }
        field(3; "Warning %"; Decimal)
        {
            Caption = 'Warning %', Comment = 'ESP="% Aviso"';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Warning %" > 100 THEN
                    ERROR('');

                IF ("Warning %" <= "Message %") OR ("Message %" = 0) THEN
                    ERROR(Error001, FIELDCAPTION("Warning %"), "Message %");
                "Error %" := 0;
            end;
        }
        field(4; "Error %"; Decimal)
        {
            Caption = 'Error %', Comment = 'ESP="% Error"';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Error %" > 100 THEN
                    ERROR('');

                IF "Warning %" = 0 THEN
                    ERROR(Error001, FIELDCAPTION("Warning %"), "Message %");

                IF "Error %" <= "Warning %" THEN
                    ERROR(Error001, FIELDCAPTION("Error %"), "Warning %");
            end;
        }
        field(5; "Email Address Message"; Text[250])
        {
            Caption = 'Message Email Address', Comment = 'ESP="Email mensaje"';
        }
        field(6; "Email Address Warning"; Text[250])
        {
            Caption = 'Warning Email Address', Comment = 'ESP="Email aviso"';
        }
        field(7; "Email Address Error"; Text[250])
        {
            Caption = 'Error Email Address', Comment = 'ESP="Email error"';
        }
        field(8; "Global Dim. 1 Control"; Boolean)
        {
            CaptionClass = '1,1,1';
            Caption = 'Control Global Dimension 1', Comment = 'ESP="Control Dimensión global 1"';
        }
        field(9; "Global Dim. 2 Control"; Boolean)
        {
            CaptionClass = '1,1,2';
            Caption = 'Control Global Dimension 2', Comment = 'ESP="Control Dimensión global 2"';
        }
        field(10; "Control Start Date"; Date)
        {
            Caption = 'Control Start Date', Comment = 'ESP="Fecha inicio control"';

            trigger OnValidate()
            begin
                IF ("Control End Date" <> 0D) AND ("Control End Date" < "Control Start Date") THEN
                    ERROR(Error001, FIELDCAPTION("Control End Date"), "Control Start Date");
            end;
        }
        field(11; "Control End Date"; Date)
        {
            Caption = 'Control End Date', Comment = 'ESP="Fecha fin control"';

            trigger OnValidate()
            begin
                IF "Control End Date" = 0D THEN
                    EXIT;

                IF "Control Start Date" = 0D THEN
                    ERROR(Error001, FIELDCAPTION("Control Start Date"), 0);

                IF ("Control End Date" <> 0D) AND ("Control End Date" < "Control Start Date") THEN
                    ERROR(Error001, FIELDCAPTION("Control End Date"), "Control Start Date");
            end;
        }
    }

    keys
    {
        key(Key1; "Primary key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Control presupuestario (%1)';
        Text002: Label 'Operación desbloqueada';
        ErrorText: Label 'Se ha superado el %1% presupuestado para la cuenta %2';
        ErrorText2: Label 'Se ha intentado superar el %1% presupuestado para la cuenta %2 "%6"\     -Presupuestado: %3 \     -Realizado: %4 \     -En esta operación: %5 \\Por favor, hable con Administración para desbloquear la operación';
        ErrorText3: Label 'Se ha intentado superar el %1% presupuestado para la cuenta %2 "%6"<p><li>Presupuestado: %3 <p><li>Realizado: %4 <p><li>En esta operación: %5 <p><p>Por favor, hable con Administración para desbloquear la operación<p><br>Administración provincial<br>Provincia de la Inmaculada Concepción OFM<br>C/Duque de Sesto, 9, 28009';
        ErrorText4: Label 'Se ha superado el %1% presupuestado para la cuenta %2 "%6"<p><li>Presupuestado: %3 <p><li>Realizado: %4 <p><br>Administración provincial<br>Provincia de la Inmaculada Concepción OFM<br>C/Duque de Sesto, 9, 28009';
        Error001: Label 'Se debe indicar un %1 mayor a %2';
        rGLSetup: Record "General Ledger Setup";
        rDimension: Record Dimension;
        Left: Text;
        Right: Text;
        Error002: Label 'La operación está bloqueada porque se superó el %1% de lo presupuestado para esta cuenta.\Contacte con Administración para desbloquear la operación';
        Error003: Label 'No tiene permisos para realizar esta tarea';

    procedure fCheckBudget_GenJnlLine(var pGenJnlLine: Record "Gen. Journal Line"; var pMessage: Text): Boolean
    var
        rlSourceCodeSetup: Record "Source Code Setup";
        rlBanckAcc: Record "Bank Account";
        rlBankAccPostGr: Record "Bank Account Posting Group";
        rlCustomer: Record Customer;
        rlCustPostGr: Record "Customer Posting Group";
        rlVendor: Record Vendor;
        rlVendPostGr: Record "Vendor Posting Group";
        vAccount: Code[20];
        blError: Boolean;
    begin
        IF NOT GET THEN
            EXIT(TRUE);
        rlSourceCodeSetup.GET;

        IF pGenJnlLine."Source Code" <> rlSourceCodeSetup."General Journal" THEN
            EXIT(TRUE);
        IF pGenJnlLine."Budg. Control Status" = pGenJnlLine."Budg. Control Status"::Unblocked THEN
            EXIT(TRUE);

        IF pGenJnlLine."Budg. Control Status" = pGenJnlLine."Budg. Control Status"::Blocked THEN BEGIN
            pMessage := STRSUBSTNO(Error002, "Error %");
            EXIT(FALSE);
        END;

        IF (pGenJnlLine."Posting Date" < "Control Start Date") OR (pGenJnlLine."Posting Date" > "Control End Date") THEN
            EXIT(TRUE);

        blError := FALSE;

        CASE pGenJnlLine."Account Type" OF
            pGenJnlLine."Account Type"::"G/L Account":
                BEGIN
                    IF NOT fCompareAmounts(pGenJnlLine."Account No.", pGenJnlLine.Amount, pMessage, pGenJnlLine."Shortcut Dimension 1 Code", pGenJnlLine."Shortcut Dimension 2 Code") THEN
                        blError := TRUE;
                END;
            pGenJnlLine."Account Type"::Customer:
                BEGIN
                    rlCustomer.GET(pGenJnlLine."Account No.");
                    rlCustPostGr.GET(rlCustomer."Customer Posting Group");
                    IF NOT fCompareAmounts(rlCustPostGr."Receivables Account", pGenJnlLine.Amount, pMessage, pGenJnlLine."Shortcut Dimension 1 Code", pGenJnlLine."Shortcut Dimension 2 Code") THEN
                        blError := TRUE;
                END;
            pGenJnlLine."Account Type"::Vendor:
                BEGIN
                    rlVendor.GET(pGenJnlLine."Account No.");
                    rlVendPostGr.GET(rlVendor."Vendor Posting Group");
                    IF NOT fCompareAmounts(rlVendPostGr."Payables Account", pGenJnlLine.Amount, pMessage, pGenJnlLine."Shortcut Dimension 1 Code", pGenJnlLine."Shortcut Dimension 2 Code") THEN
                        blError := TRUE;
                END;
            pGenJnlLine."Account Type"::"Bank Account":
                BEGIN
                    rlBanckAcc.GET(pGenJnlLine."Account No.");
                    rlBankAccPostGr.GET(rlBanckAcc."Bank Acc. Posting Group");
                    IF NOT fCompareAmounts(rlBankAccPostGr."G/L Account No.", pGenJnlLine.Amount, pMessage, pGenJnlLine."Shortcut Dimension 1 Code", pGenJnlLine."Shortcut Dimension 2 Code") THEN
                        blError := TRUE;
                END;
        END;

        IF blError THEN BEGIN
            pGenJnlLine."Budg. Control Status" := pGenJnlLine."Budg. Control Status"::Blocked;
            pGenJnlLine.MODIFY;

            COMMIT;
            EXIT(FALSE);
        END;

        IF pGenJnlLine."Bal. Account No." <> '' THEN BEGIN
            CASE pGenJnlLine."Bal. Account Type" OF
                pGenJnlLine."Bal. Account Type"::"G/L Account":
                    BEGIN
                        IF fCompareAmounts(pGenJnlLine."Bal. Account No.", -pGenJnlLine.Amount, pMessage, pGenJnlLine."Shortcut Dimension 1 Code", pGenJnlLine."Shortcut Dimension 2 Code") THEN
                            EXIT(TRUE)
                        ELSE
                            blError := TRUE;
                    END;
                pGenJnlLine."Bal. Account Type"::Customer:
                    BEGIN
                        rlCustomer.GET(pGenJnlLine."Bal. Account No.");
                        rlCustPostGr.GET(rlCustomer."Customer Posting Group");
                        IF fCompareAmounts(rlCustPostGr."Receivables Account", -pGenJnlLine.Amount, pMessage, pGenJnlLine."Shortcut Dimension 1 Code", pGenJnlLine."Shortcut Dimension 2 Code") THEN
                            EXIT(TRUE)
                        ELSE
                            blError := TRUE;
                    END;
                pGenJnlLine."Bal. Account Type"::Vendor:
                    BEGIN
                        rlVendor.GET(pGenJnlLine."Bal. Account No.");
                        rlVendPostGr.GET(rlVendor."Vendor Posting Group");
                        IF fCompareAmounts(rlVendPostGr."Payables Account", -pGenJnlLine.Amount, pMessage, pGenJnlLine."Shortcut Dimension 1 Code", pGenJnlLine."Shortcut Dimension 2 Code") THEN
                            EXIT(TRUE)
                        ELSE
                            blError := TRUE;
                    END;
                pGenJnlLine."Bal. Account Type"::"Bank Account":
                    BEGIN
                        rlBanckAcc.GET(pGenJnlLine."Bal. Account No.");
                        rlBankAccPostGr.GET(rlBanckAcc."Bank Acc. Posting Group");
                        IF fCompareAmounts(rlBankAccPostGr."G/L Account No.", -pGenJnlLine.Amount, pMessage, pGenJnlLine."Shortcut Dimension 1 Code", pGenJnlLine."Shortcut Dimension 2 Code") THEN
                            EXIT(TRUE)
                        ELSE
                            blError := TRUE;
                    END;
            END;
        END;

        IF blError THEN BEGIN
            pGenJnlLine."Budg. Control Status" := pGenJnlLine."Budg. Control Status"::Blocked;
            pGenJnlLine.MODIFY;

            COMMIT;
            EXIT(FALSE);
        END;

        EXIT(TRUE);
    end;

    procedure fCheckBudget_Sales(var pSalesHeader: Record "Sales Header"; pSalesLine: Record "Sales Line"; var pMessage: Text): Boolean
    var
        rlGenPostSetup: Record "General Posting Setup";
        blError: Boolean;
    begin
        IF NOT GET THEN
            EXIT(TRUE);

        IF NOT (pSalesHeader."Document Type" IN [pSalesHeader."Document Type"::Invoice, pSalesHeader."Document Type"::"Credit Memo"]) THEN
            EXIT(TRUE);

        IF pSalesHeader."Budg. Control Status" = pSalesHeader."Budg. Control Status"::Unblocked THEN
            EXIT(TRUE);

        IF pSalesHeader."Budg. Control Status" = pSalesHeader."Budg. Control Status"::Blocked THEN BEGIN
            pMessage := STRSUBSTNO(Error002, "Error %");
            EXIT(FALSE);
        END;

        IF (pSalesHeader."Posting Date" < "Control Start Date") OR (pSalesHeader."Posting Date" > "Control End Date") THEN
            EXIT(TRUE);

        blError := FALSE;

        CASE pSalesLine.Type OF
            pSalesLine.Type::"G/L Account":
                BEGIN
                    IF NOT fCompareAmounts(pSalesLine."No.", pSalesLine.Amount, pMessage, pSalesLine."Shortcut Dimension 1 Code", pSalesLine."Shortcut Dimension 2 Code") THEN
                        blError := TRUE;
                END;
            pSalesLine.Type::Item:
                BEGIN
                    IF rlGenPostSetup.GET(pSalesLine."Gen. Bus. Posting Group", pSalesLine."Gen. Prod. Posting Group") THEN BEGIN
                        IF NOT fCompareAmounts(rlGenPostSetup."Sales Account", pSalesLine.Amount, pMessage, pSalesLine."Shortcut Dimension 1 Code", pSalesLine."Shortcut Dimension 2 Code") THEN
                            blError := TRUE;
                    END;
                END;
        END;

        IF blError THEN BEGIN
            pSalesHeader."Budg. Control Status" := pSalesHeader."Budg. Control Status"::Blocked;
            pSalesHeader.MODIFY;

            COMMIT;
            EXIT(FALSE);
        END;

        EXIT(TRUE);
    end;

    procedure fCheckBudget_Purchase(var pPurchHeader: Record "Purchase Header"; pPurchLine: Record "Purchase Line"; var pMessage: Text): Boolean
    var
        rlGenPostSetup: Record "General Posting Setup";
        blError: Boolean;
    begin
        IF NOT GET THEN
            EXIT(TRUE);

        IF NOT (pPurchHeader."Document Type" IN [pPurchHeader."Document Type"::Invoice, pPurchHeader."Document Type"::"Credit Memo"]) THEN
            EXIT(TRUE);

        IF pPurchHeader."Budg. Control Status" = pPurchHeader."Budg. Control Status"::Unblocked THEN
            EXIT(TRUE);

        IF pPurchHeader."Budg. Control Status" = pPurchHeader."Budg. Control Status"::Blocked THEN BEGIN
            pMessage := STRSUBSTNO(Error002, "Error %");
            EXIT(FALSE);
        END;

        IF (pPurchHeader."Posting Date" < "Control Start Date") OR (pPurchHeader."Posting Date" > "Control End Date") THEN
            EXIT(TRUE);

        blError := FALSE;

        CASE pPurchLine.Type OF
            pPurchLine.Type::"G/L Account":
                BEGIN
                    IF NOT fCompareAmounts(pPurchLine."No.", pPurchLine.Amount, pMessage, pPurchLine."Shortcut Dimension 1 Code", pPurchLine."Shortcut Dimension 2 Code") THEN
                        blError := TRUE;
                END;
            pPurchLine.Type::Item:
                BEGIN
                    IF rlGenPostSetup.GET(pPurchLine."Gen. Bus. Posting Group", pPurchLine."Gen. Prod. Posting Group") THEN BEGIN
                        IF NOT fCompareAmounts(rlGenPostSetup."Sales Account", pPurchLine.Amount, pMessage, pPurchLine."Shortcut Dimension 1 Code", pPurchLine."Shortcut Dimension 2 Code") THEN
                            blError := TRUE;
                    END;
                END;
        END;

        IF blError THEN BEGIN
            pPurchHeader."Budg. Control Status" := pPurchHeader."Budg. Control Status"::Blocked;
            pPurchHeader.MODIFY;

            COMMIT;
            EXIT(FALSE);
        END;

        EXIT(TRUE);
    end;

    local procedure fCompareAmounts(pAccount: Code[20]; pRealAmount: Decimal; var pMessage: Text; pDim1: Code[20]; pDim2: Code[20]): Boolean
    var
        rlGLBudgetName: Record "G/L Budget Name";
        rlGLBudgetEntry: Record "G/L Budget Entry";
        rlGLAccount: Record "G/L Account";
        dlBudgAmount: Decimal;
        dlRealAmount: Decimal;
        vMessage: Text;
    begin
        //IF COMPANYNAME <> '(NO TOCAR) Pruebas S2G' THEN
        //  EXIT(TRUE);

        IF (rlGLAccount.GET(pAccount)) AND (rlGLAccount."Budget Control Not Applied") THEN
            EXIT(TRUE);

        rlGLBudgetName.RESET;
        rlGLBudgetName.SETCURRENTKEY(Active);
        rlGLBudgetName.SETRANGE(Active, TRUE);
        IF NOT rlGLBudgetName.FINDFIRST THEN
            EXIT(TRUE);

        dlBudgAmount := 0;

        rlGLBudgetEntry.RESET;
        rlGLBudgetEntry.SETCURRENTKEY("Budget Name", "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Budget Dimension 1 Code", "Budget Dimension 2 Code", "Budget Dimension 3 Code", "Budget Dimension 4 Code", Date);
        rlGLBudgetEntry.SETRANGE("Budget Name", rlGLBudgetName.Name);
        rlGLBudgetEntry.SETRANGE("G/L Account No.", pAccount);
        IF Rec."Global Dim. 1 Control" THEN
            rlGLBudgetEntry.SETRANGE("Global Dimension 1 Code", pDim1);
        IF Rec."Global Dim. 2 Control" THEN
            rlGLBudgetEntry.SETRANGE("Global Dimension 2 Code", pDim2);
        rlGLBudgetEntry.SETRANGE(Date, "Control Start Date", "Control End Date");
        IF rlGLBudgetEntry.FINDSET THEN
            REPEAT
                dlBudgAmount += rlGLBudgetEntry.Amount;
            UNTIL rlGLBudgetEntry.NEXT = 0;

        IF dlBudgAmount = 0 THEN
            EXIT(TRUE);

        rlGLAccount.RESET;
        rlGLAccount.SETRANGE("No.", pAccount);
        //rlGLAccount.SETFILTER("Date Filter", '%1..%2', "Control Start Date", "Control End Date");
        rlGLAccount.SETRANGE("Date Filter", "Control Start Date", "Control End Date");
        IF Rec."Global Dim. 1 Control" THEN
            rlGLAccount.SETFILTER("Global Dimension 1 Code", pDim1);
        IF Rec."Global Dim. 2 Control" THEN
            rlGLAccount.SETFILTER("Global Dimension 2 Code", pDim2);
        rlGLAccount.CALCFIELDS("Net Change");
        dlRealAmount := rlGLAccount."Net Change";

        dlRealAmount += pRealAmount;

        IF ABS(dlRealAmount) > (ABS(dlBudgAmount) * "Error %" / 100) THEN BEGIN
            pMessage := STRSUBSTNO(ErrorText2, "Error %", pAccount, dlBudgAmount, dlRealAmount - pRealAmount, pRealAmount, rlGLAccount.Name);
            vMessage := STRSUBSTNO(ErrorText3, "Error %", pAccount, dlBudgAmount, dlRealAmount - pRealAmount, pRealAmount, rlGLAccount.Name);
            fSendEmail(3, dlBudgAmount, dlRealAmount, pAccount, vMessage);
            EXIT(FALSE);
        END ELSE BEGIN
            IF ABS(dlRealAmount) > (ABS(dlBudgAmount) * "Warning %" / 100) THEN BEGIN
                pMessage := STRSUBSTNO(ErrorText, "Warning %", pAccount);
                vMessage := STRSUBSTNO(ErrorText4, "Warning %", pAccount, dlBudgAmount, dlRealAmount - pRealAmount, pRealAmount, rlGLAccount.Name);
                fSendEmail(2, dlBudgAmount, dlRealAmount, pAccount, vMessage);
                EXIT(TRUE);
            END ELSE BEGIN
                IF ABS(dlRealAmount) > (ABS(dlBudgAmount) * "Message %" / 100) THEN BEGIN
                    pMessage := STRSUBSTNO(ErrorText, "Message %", pAccount);
                    vMessage := STRSUBSTNO(ErrorText4, "Message %", pAccount, dlBudgAmount, dlRealAmount - pRealAmount, pRealAmount, rlGLAccount.Name);
                    fSendEmail(1, dlBudgAmount, dlRealAmount, pAccount, vMessage);
                    EXIT(TRUE);
                END;
            END;
        END;

        EXIT(TRUE);
    end;

    //TODO-MIG: Testear
    local procedure fSendEmail(pType: Integer; pBudgAmount: Decimal; pRealAmount: Decimal; pGLAccount: Code[20]; pBody: Text)
    var
        clEmailMessage: Codeunit "Email Message";
        clEmail: Codeunit Email;
        SendTo: Text;
    begin
        SendTo := '';
        CASE pType OF
            1:
                SendTo := "Email Address Message";
            2:
                SendTo := "Email Address Warning";
            3:
                SendTo := "Email Address Error";
        END;

        IF SendTo <> '' THEN BEGIN
            clEmailMessage.Create(SendTo, COMPANYNAME, pBody);
            clEmail.Send(clEmailMessage);
            // SMTPMail.CreateMessage(SMTPSetup."User ID", SMTPSetup."User ID", SendTo, COMPANYNAME, pBody, TRUE);
            // SMTPMail.Send;
        END;
    end;

    procedure fUnblockPosting(pType: Integer; pDimKey: array[3] of Text)
    var
        rlUserSetup: Record "User Setup";
        rlGenJournalLine: Record "Gen. Journal Line";
        rlSalesHeader: Record "Sales Header";
        rlPurchHeader: Record "Purchase Header";
    begin
        IF NOT (rlUserSetup.GET(USERID) AND rlUserSetup."Unblock Budget Control") THEN
            ERROR(Error003);

        CASE pType OF
            1:  //Diario
                BEGIN
                    rlGenJournalLine.GET(pDimKey[1], pDimKey[2], pDimKey[3]);
                    IF rlGenJournalLine."Budg. Control Status" = rlGenJournalLine."Budg. Control Status"::Blocked THEN BEGIN
                        rlGenJournalLine."Budg. Control Status" := rlGenJournalLine."Budg. Control Status"::Unblocked;
                        rlGenJournalLine.MODIFY;
                    END;
                END;
            2:  //Doc. venta
                BEGIN
                    rlSalesHeader.GET(pDimKey[1], pDimKey[2]);
                    IF rlSalesHeader."Budg. Control Status" = rlSalesHeader."Budg. Control Status"::Blocked THEN BEGIN
                        rlSalesHeader."Budg. Control Status" := rlSalesHeader."Budg. Control Status"::Unblocked;
                        rlSalesHeader.MODIFY;
                    END;
                END;
            3:  //Doc. compra
                BEGIN
                    rlPurchHeader.GET(pDimKey[1], pDimKey[2]);
                    IF rlPurchHeader."Budg. Control Status" = rlPurchHeader."Budg. Control Status"::Blocked THEN BEGIN
                        rlPurchHeader."Budg. Control Status" := rlPurchHeader."Budg. Control Status"::Unblocked;
                        rlPurchHeader.MODIFY;
                    END;
                END;
        END;

        MESSAGE(Text002);
    end;
}
