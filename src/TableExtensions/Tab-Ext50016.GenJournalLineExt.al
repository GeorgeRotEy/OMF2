tableextension 50016 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Posting concept"; Text[250])
        {
            Caption = 'Posting Concept', Comment = 'ESP="Concepto contable"';
        }
        field(50300; "Budg. Control Status"; Option)
        {
            Caption = 'Budget Control Status', Comment = 'ESP="Estado control ppto."';
            OptionCaption = ' ,Blocked,Unblocked';
            OptionMembers = " ",Blocked,Unblocked;
        }
        field(50301; "Budg. Cont. Doc. No."; Code[20])
        {
            Caption = 'Budget Control Doc. No.', Comment = 'ESP="Nº doc. control ppto."';
        }
        field(51000; "No. mov. retención"; Integer)
        {
            Caption = 'Retention Entry No.', Comment = 'ESP="Nº mov. retención"';
            TableRelation = "Movs. retenciones";
        }
        field(51001; "No. mov. retención a liberar"; Integer)
        {
            Caption = 'Retention Entry No. to Release', Comment = 'ESP="Nº mov. retención a liberar"';
            TableRelation = "Movs. retenciones";
        }
        field(51002; "Es movimiento retención"; Boolean)
        {
            Caption = 'Is Retention Entry', Comment = 'ESP="Es movimiento retención"';
        }
        field(51010; "Banco previsto"; Code[20])
        {
            Caption = 'Expected Bank', Comment = 'ESP="Banco previsto"';
            TableRelation = "Bank Account";
        }
        field(51201; "Base Retención IRPF"; Decimal)
        {
            Caption = 'IRPF Retention Base', Comment = 'ESP="Base retención IRPF"';
        }
        field(51202; "Porcentaje Retención"; Decimal)
        {
            Caption = 'Retention Percentage', Comment = 'ESP="Porcentaje retención"';
        }
        field(51203; "Clave IRPF"; Text[50])
        {
            Caption = 'IRPF Code', Comment = 'ESP="Clave IRPF"';
        }
        field(51204; "Subclave IRPF"; Text[50])
        {
            Caption = 'IRPF Subcode', Comment = 'ESP="Subclave IRPF"';
        }
        field(51205; Residencia; Option)
        {
            Caption = 'Residence', Comment = 'ESP="Residencia"';
            OptionCaption = 'Resident,Non-resident';
            OptionMembers = Residente,"No residente";
        }
        field(51206; "Código IRPF"; Code[20])
        {
            Caption = 'IRPF Code', Comment = 'ESP="Código IRPF"';
            TableRelation = "Grupo registro retención"."Cód. grupo" WHERE("Tipo retención" = CONST(Intereses));
        }
        field(51207; Liquidado; Boolean)
        {
            Caption = 'Settled', Comment = 'ESP="Liquidado"';
            Editable = false;
        }
        field(51208; "Movimiento IRPF liquidado"; Integer)
        {
            Caption = 'Settled IRPF Entry', Comment = 'ESP="Movimiento IRPF liquidado"';
            Editable = false;
        }
        field(51209; "Proveedor IRPF"; Code[20])
        {
            Caption = 'IRPF Vendor', Comment = 'ESP="Proveedor IRPF"';
        }
        field(51210; "Modalidad IRPF"; Option)
        {
            Caption = 'IRPF Type', Comment = 'ESP="Modalidad IRPF"';
            OptionCaption = ' ,1 - Monetary income or yield paid,2 - In-kind income or yield paid';
            OptionMembers = " ","1 - Renta o rendimiento satisfecho de tipo dinerario","2 - Renta o rendimiento satisfecho en especie";
        }
        field(51211; "Skip Retention Entry"; Boolean)
        {
            Caption = 'Skip Retention Entry', Comment = 'ESP="Omitir movimiento retención"';
        }
        field(51212; "Cuota Retencion"; Decimal)
        {
            Caption = 'Retention Amount', Comment = 'ESP="Cuota retención"';
        }
        field(52001; "Destination Company Name"; Text[30])
        {
            Caption = 'Destination Company Name', Comment = 'ESP="Nombre empresa destino"';
            TableRelation = Company;
        }
        field(52002; "Int-MC"; Boolean)
        {
            Caption = 'Int-MC', Comment = 'ESP="Int-MC"';
        }
        field(52003; "Tipo Contrapartida"; Option)
        {
            Caption = 'Bal. Account Type', Comment = 'ESP="Tipo contrapartida"';
            OptionCaption = ',,,Bank Account';
            OptionMembers = ,,,"Bank Account";
        }
        field(52004; "Tipo Movimiento"; Option)
        {
            Caption = 'Transaction Type', Comment = 'ESP="Tipo movimiento"';
            OptionCaption = 'G/L Account,,,Bank Account';
            OptionMembers = "G/L Account",,,"Bank Account";
        }
    }

    trigger OnAfterModify()
    begin
        IF "Budg. Control Status" <> "Budg. Control Status"::" " THEN BEGIN
            "Budg. Control Status" := "Budg. Control Status"::" ";
            MODIFY;
        END;
    end;

    //Intercompany
    // procedure fInsertICTransactionLineByGlAccount()
    // var
    //     rlCompany: Record Company;
    //     rlCompanyInfo: Record "Company Information";
    //     rlICTransactionLine: Record "Intercompany Transaction Line";
    //     vlNextLineNo: Integer;
    //     blFound: Boolean;
    //     rlGlAcc: Record "G/L Account";
    // begin
    //     // Mod. S2G (JMP) 18/04/18 GF008
    //     IF NOT (("Account Type" = "Account Type"::"Bank Account") OR ("Account Type" = "Account Type"::"G/L Account")) OR ("Line No." = 0) THEN
    //         EXIT;

    //     TESTFIELD("Account No.");
    //     TESTFIELD("Bal. Account Type", "Bal. Account Type"::"Bank Account");
    //     TESTFIELD("Bal. Account No.");

    //     //TESTFIELD("Destination Company Name");

    //     rlICTransactionLine.RESET();
    //     rlICTransactionLine.SETRANGE("Table ID", DATABASE::"Gen. Journal Line");
    //     rlICTransactionLine.SETRANGE("Source Doc. No.", "Journal Template Name");
    //     rlICTransactionLine.SETRANGE("Source Doc. Subtype", "Journal Batch Name");
    //     rlICTransactionLine.SETRANGE("Source Doc. Line No.", "Line No.");
    //     IF rlICTransactionLine.FINDLAST() THEN
    //         vlNextLineNo := rlICTransactionLine."Line No." + 10000
    //     ELSE
    //         vlNextLineNo := 10000;

    //     rlICTransactionLine.INIT();
    //     rlICTransactionLine."Table ID" := DATABASE::"Gen. Journal Line";
    //     rlICTransactionLine."Source Doc. No." := "Journal Template Name";
    //     rlICTransactionLine."Source Doc. Subtype" := "Journal Batch Name";
    //     rlICTransactionLine."Source Doc. Line No." := "Line No.";
    //     rlICTransactionLine."Line No." := vlNextLineNo;
    //     rlICTransactionLine."Transaction Type" := rlICTransactionLine."Transaction Type"::"Loan Between Companies";
    //     rlICTransactionLine."Source Company Name" := COMPANYNAME;
    //     rlICTransactionLine."Destination Company Name" := "Destination Company Name";
    //     rlICTransactionLine."Amount %" := 100;

    //     rlICTransactionLine.INSERT(TRUE);

    //     rlICTransactionLine.VALIDATE("Source Company Name", COMPANYNAME);
    //     IF "Destination Company Name" <> '' THEN
    //         rlICTransactionLine."Amount %" := 100 ELSE
    //         rlICTransactionLine."Amount %" := 0;
    //     rlICTransactionLine."Account Type" := rlICTransactionLine."Account Type"::"1";
    //     /*
    //     CLEAR(rlGlAcc);
    //     rlGlAcc.GET("Account No.");
    //     IF rlGlAcc."IC G/L Account No." <> '' THEN
    //       rlICTransactionLine.VALIDATE("Account No.",rlGlAcc."IC G/L Account No.");
    //     */
    //     rlICTransactionLine."Destination Company Name" := "Destination Company Name";
    //     rlICTransactionLine.MODIFY(TRUE);

    //     // Mod. S2G (JMP) 18/04/18 GF008
    // end;

    // procedure fDeleteICTransactionLines()
    // var
    //     rlICTransactionLine: Record "Intercompany Transaction Line";
    // begin
    //     // Mod. S2G (JMP) 18/04/18 GF008
    //     rlICTransactionLine.RESET();
    //     rlICTransactionLine.SETRANGE("Table ID", DATABASE::"Gen. Journal Line");
    //     rlICTransactionLine.SETRANGE("Source Doc. No.", "Journal Template Name");
    //     rlICTransactionLine.SETRANGE("Source Doc. Subtype", "Journal Batch Name");
    //     rlICTransactionLine.SETRANGE("Source Doc. Line No.", "Line No.");
    //     IF NOT rlICTransactionLine.ISEMPTY THEN
    //         rlICTransactionLine.DELETEALL();
    //     // Mod. S2G (JMP) 18/04/18 GF008
    // end;
}
