report 50026 "Modelo 193"
{
    Caption = 'Make 193 Model', Comment = 'ESP="Generar modelo 193"';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number);
            dataitem("Movs. retenciones"; "Movs. retenciones")
            {
                trigger OnAfterGetRecord()
                begin
                    rtPilaMovs.RESET();
                    rtPilaMovs.SETRANGE("VAT Registration No.", "Movs. retenciones"."CIF/NIF");
                    rtPilaMovs.SETRANGE(Clave, "Movs. retenciones"."Clave IRPF");
                    rtPilaMovs.SETRANGE(Subclave, "Movs. retenciones"."Subclave IRPF");
                    IF NOT rtPilaMovs.FINDFIRST() THEN
                        fCreateTempPila("Movs. retenciones")
                    ELSE
                        fActualizaTempPila("Movs. retenciones");
                end;

                trigger OnPreDataItem()
                begin
                    "Movs. retenciones".SETRANGE(Tipo, "Movs. retenciones".Tipo::Compra);
                    "Movs. retenciones".SETRANGE("Tipo retención", "Movs. retenciones"."Tipo retención"::Intereses);
                    "Movs. retenciones".SETFILTER("Tipo documento", '%1|%2', "Movs. retenciones"."Tipo documento"::"Fact. Registrada", "Movs. retenciones"."Tipo documento"::"Abono Registrado");
                    "Movs. retenciones".SETFILTER("Fecha registro", '%1..%2', FromDate, ToDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Counter += 1;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE(Number, 1, 2);
                Counter := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESP="Opciones"';
                    field(FiscalYear; FiscalYear)
                    {
                        Caption = 'Fiscal Year', Comment = 'ESP="Ejercicio fiscal"';
                        Numeric = true;
                        ShowMandatory = true;
                        ToolTip = 'Fiscal Year must be 4 digits without spaces or special characters.', Comment = 'ESP="El ejercicio fiscal debe tener 4 dígitos sin espacios ni caracteres especiales."';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            FiscalYearText := FiscalYear;
                            IF STRLEN(FiscalYearText) <> MAXSTRLEN(FiscalYearText) THEN
                                ERROR(WrongFiscalYearFormatErr, MAXSTRLEN(FiscalYearText));

                            IF NOT EVALUATE(NumFiscalYear, FiscalYear) OR (NumFiscalYear < 0) THEN
                                ERROR(WrongFiscalYearFormatErr, MAXSTRLEN(FiscalYearText));
                        end;
                    }
                    group(Period)
                    {
                        Caption = 'Period', Comment = 'ESP="Periodo"';
                    }
                    field(ContactName; ContactName)
                    {
                        Caption = 'Contact Name', Comment = 'ESP="Nombre contacto"';
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field(ContactTelephone; ContactTelephone)
                    {
                        Caption = 'Telephone Number', Comment = 'ESP="Número teléfono"';
                        Numeric = true;
                        ShowMandatory = true;
                        ToolTip = 'Contact Telephone must be 9 digits without spaces or special characters.', Comment = 'ESP="El teléfono de contacto debe tener 9 dígitos sin espacios ni caracteres especiales."';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            IF STRLEN(ContactTelephone) <> MAXSTRLEN(ContactTelephone) THEN
                                ERROR(WrongContactTelephoneFormatErr, MAXSTRLEN(ContactTelephone));
                        end;
                    }
                    field(DeclarationNum; DeclarationNum)
                    {
                        Caption = 'Declaration Number', Comment = 'ESP="Número declaración"';
                        Numeric = true;
                        ShowMandatory = true;
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            WHILE STRLEN(DeclarationNum) < MAXSTRLEN(DeclarationNum) DO
                                DeclarationNum := '0' + DeclarationNum;
                        end;
                    }
                    field(ElectronicCode; ElectronicCode)
                    {
                        Caption = 'Electronic Code', Comment = 'ESP="Código electrónico"';
                        ShowMandatory = true;
                        ToolTip = 'Electronic Code must be 16 digits without spaces or special characters.', Comment = 'ESP="El código electrónico debe tener 16 dígitos sin espacios ni caracteres especiales."';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            IF STRLEN(ElectronicCode) <> MAXSTRLEN(ElectronicCode) THEN
                                ERROR(WrongElectronicCodeErr, MAXSTRLEN(ElectronicCode));
                        end;
                    }
                    field(DeclarationMediaType; DeclarationMediaType)
                    {
                        Caption = 'Declaration Media Type', Comment = 'ESP="Tipo soporte declaración"';
                        OptionCaption = 'Telematic,CD-R', Comment = 'ESP="Telemática,CD-R"';
                        ApplicationArea = All;
                    }
                    field(ReplaceDeclaration; ReplaceDeclaration)
                    {
                        Caption = 'Replacement Declaration', Comment = 'ESP="Declaración sustitutiva"';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            ReplaceDeclarationOnPush;
                        end;
                    }
                    field(PrevDeclarationNum; PrevDeclareNum)
                    {
                        Caption = 'Previous Declaration Number', Comment = 'ESP="Número declaración anterior"';
                        Enabled = PrevDeclarationNumEnable;
                        Numeric = true;
                        ToolTip = 'Previous Declaration Number must be 13 digits without spaces or special characters.', Comment = 'ESP="El número de declaración anterior debe tener 13 dígitos sin espacios ni caracteres especiales."';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            IF (STRLEN(PrevDeclareNum) <> MAXSTRLEN(PrevDeclareNum)) OR (STRPOS(PrevDeclareNum, ' ') <> 0) THEN
                                ERROR(WrongPreviousDeclarationNoErr, MAXSTRLEN(PrevDeclareNum));
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            PrevDeclarationNumEnable := TRUE;
            IF FiscalYear = '' THEN
                FiscalYear := FORMAT(DATE2DMY(WORKDATE, 3));
            IF Month = 0 THEN
                Month := 1;
        end;

        trigger OnOpenPage()
        begin
            PrevDeclarationNumEnable := ReplaceDeclaration;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        CreateFileHeader;
        WritePilaToText(rtPilaMovs);
        // OutFile.CLOSE();
        DownloadFile;
    end;

    trigger OnPreReport()
    begin
        IntegerCounter := 0;
        CompanyInfo.GET();
        IF CompanyInfo."VAT Registration No." = '' THEN
            ERROR(MissingVATRegistrationNoErr);
        IF FiscalYear = '0000' THEN
            ERROR(IncorrectFiscalYearErr);
        IF STRLEN(ContactTelephone) <> MAXSTRLEN(ContactTelephone) THEN
            ERROR(WrongContactTelephoneFormatErr, MAXSTRLEN(ContactTelephone));
        IF ContactName = '' THEN
            ERROR(MissingContactNameErr);
        IF ContactTelephone = '' THEN
            ERROR(MissingTelephoneNoErr);
        IF (DeclarationNum = '') OR (DeclarationNum = '0000') THEN
            ERROR(MissingDeclarationNoErr);
        IF ElectronicCode = '' THEN
            ERROR(MissingElectronicCodeErr);
        IF ReplaceDeclaration AND (PrevDeclareNum = '') THEN
            ERROR(MissingPreviousDeclaraionNoErr);
        IF GLAccFilterString = '' THEN
            GLAccFilterString := GetFilterStringFromColumn(ColumnGLAcc, TRUE);

        // ServerTempFileName := FileMgt.ServerTempFileName('txt');

        CalcDaysinMonth;
        PeriodText := GetMonthText;
        IF GPPGFilterString = '' THEN
            GPPGFilterString := GetFilterStringFromColumn(ColumnGPPG, FALSE);
        CompanyVATRegNo := FORMAT(CompanyInfo."VAT Registration No.");
        WHILE STRLEN(CompanyVATRegNo) < 9 DO
            CompanyVATRegNo := '0' + CompanyVATRegNo;

        CalcTotals;

        TotalBaseAmtText := FormatTextAmt(TotalBaseAmount, TRUE);
        TotalVATAmtText := FormatTextAmt(TotalVATAmount, TRUE);
        TotalInvAmtText := FormatTextAmt(TotalInvoiceAmount, TRUE);
        IF (TotalBaseAmount <> 0) OR
           (TotalVATAmount <> 0) OR
           (TotalInvoiceAmount <> 0) OR
           (NoofRecords <> 0) OR
           CheckCashCollectables
        THEN BEGIN
            CLEAR(OutFile);
            // OutFile.TEXTMODE := TRUE;
            // OutFile.WRITEMODE := TRUE;
            // OutFile.CREATE(ServerTempFileName);
            // OutFile.CREATEOUTSTREAM(Outstr);
            TempBlob.CreateOutStream(OutStr);
        END ELSE
            ERROR(NoRecordsFoundErr);

        FileHeaderCreated := FALSE;
    end;

    var
        Customer: Record Customer;
        CompanyInfo: Record "Company Information";
        VATBuffer: Record "Sales/Purch. Book VAT Buffer" temporary;
        VATBuffer2: Record "Sales/Purch. Book VAT Buffer";
        Vendor: Record Vendor;
        TempDeclarationLines: Record "340 Declaration Line" temporary;
        TempDetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry" temporary;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        OutFile: File;
        DeclarationNum: Text[4];
        FileName: Text;
        ContactName: Text[30];
        BookTypeCode: Text[1];
        OperationCode: Text[1];
        ColumnGPPG: Text[1024];
        TotalNoofRecords: Text[9];
        GPPGFilterString: Text[1024];
        PrevDeclareNumText: Text[13];
        TotalBaseAmtText: Text[18];
        TotalVATAmtText: Text[18];
        TotalInvAmtText: Text[18];
        PeriodText: Text[2];
        CompanyVATRegNo: Text[9];
        NoofRegistersText: Text[2];
        FiscalYearText: Text[4];
        OperationDateText: Text[8];
        ResidentIDText: Text[1];
        VATNoPermanentResidentCountry: Text[20];
        ColumnGLAcc: Text[1024];
        GLAccFilterString: Text[250];
        CountryCode: Code[10];
        ServerTempFileName: Text[1024];
        FiscalYear: Code[4];
        ContactTelephone: Code[9];
        PrevDeclareNum: Code[13];
        ElectronicCode: Code[16];
        IncorrectFiscalYearErr: Label 'Incorrect Fiscal Year.', Comment = 'ESP="Ejercicio fiscal incorrecto."';
        NumFiscalYear: Integer;
        Counter: Integer;
        TotalBaseAmount: Decimal;
        TotalInvoiceAmount: Decimal;
        TotalVATAmount: Decimal;
        DeclarationMediaType: Option Telematic,"CD-R";
        Month: Option;
        ReplaceDeclaration: Boolean;
        FromDate: Date;
        ToDate: Date;
        FileExportedMsg: Label '193 Declaration has been exported successfully under %1.', Comment = 'ESP="La declaración 193 se ha exportado correctamente en %1."';
        NoofRecords: Integer;
        IntegerCounter: Integer;
        MinPaymentAmount: Decimal;
        NoOfAccounts: Integer;
        FilterArray: array[50] of Text[250];
        FileHeaderCreated: Boolean;

        PrevDeclarationNumEnable: Boolean;
        FileFilterTxt: Label 'Text files (*.txt)|*.txt|All files (*.*)|*.*', Comment = 'ESP="Archivos de texto (*.txt)|*.txt|Todos los archivos (*.*)|*.*"';
        FileNameTxt: Label 'Declaration 193 year %1 month %2.txt', Comment = 'ESP="Declaración 193 año %1 mes %2.txt"';
        MissingContactNameErr: Label 'Contact Name must be entered.', Comment = 'ESP="Debe introducirse el nombre del contacto."';
        MissingDeclarationNoErr: Label 'Declaration Number must be entered.', Comment = 'ESP="Debe introducirse el número de declaración."';
        MissingElectronicCodeErr: Label 'Electronic Code must be entered.', Comment = 'ESP="Debe introducirse el código electrónico."';
        MissingPreviousDeclaraionNoErr: Label 'Please specify the Previous Declaration No. if this is a replacement declaration.', Comment = 'ESP="Indique el nº de declaración anterior si se trata de una declaración sustitutiva."';
        MissingVATRegistrationNoErr: Label 'Please specify the VAT Registration No. of your Company in the Company Information window.', Comment = 'ESP="Indique el nº de registro de IVA de su empresa en la ventana Información de empresa."';
        NoRecordsFoundErr: Label 'No records were found to be included in the declaration. The process has been aborted. No file will be created.', Comment = 'ESP="No se encontraron registros para incluir en la declaración. El proceso se ha cancelado. No se creará ningún archivo."';
        WrongContactTelephoneFormatErr: Label 'Contact Telephone must be %1 digits without spaces or special characters.', Comment = 'ESP="El teléfono de contacto debe tener %1 dígitos sin espacios ni caracteres especiales."';
        WrongElectronicCodeErr: Label 'Electronic Code must be %1 digits without spaces or special characters.', Comment = 'ESP="El código electrónico debe tener %1 dígitos sin espacios ni caracteres especiales."';
        WrongFiscalYearFormatErr: Label 'Fiscal Year must be %1 digits without spaces or special characters.', Comment = 'ESP="El ejercicio fiscal debe tener %1 dígitos sin espacios ni caracteres especiales."';
        WrongPreviousDeclarationNoErr: Label 'Previous Declaration Number must be %1 digits without spaces or special characters.', Comment = 'ESP="El número de declaración anterior debe tener %1 dígitos sin espacios ni caracteres especiales."';
        MissingTelephoneNoErr: Label 'Contact Telephone must be entered.', Comment = 'ESP="Debe introducirse el teléfono de contacto."';
        rMovRetencion: Record "Movs. retenciones";
        rtPilaMovs: Record "Pila Movs. retencion" temporary;
        VATEntry: Record "VAT Entry";

    local procedure CalcDaysinMonth()
    begin
        IF NOT EVALUATE(NumFiscalYear, FiscalYear) THEN
            ERROR(IncorrectFiscalYearErr);

        FromDate := DMY2DATE(1, Month, NumFiscalYear);
        //ToDate := CALCDATE('<CM>',FromDate);
        ToDate := DMY2DATE(31, 12, NumFiscalYear);
    end;

    local procedure CreateFileHeader()
    var
        DeclarationMT: Text[1];
        ReplacementText: Text[1];
        DeclareNumText: Text[13];
        Txt1: Text[500];
    begin
        FileHeaderCreated := TRUE;
        CASE DeclarationMediaType OF
            DeclarationMediaType::Telematic:
                DeclarationMT := 'T';
            DeclarationMediaType::"CD-R":
                DeclarationMT := 'C';
        END;

        IF ReplaceDeclaration THEN BEGIN
            ReplacementText := 'S';
            PrevDeclareNumText := FORMAT(PrevDeclareNum);
        END ELSE BEGIN
            ReplacementText := ' ';
            PrevDeclareNumText := '0000000000000';
        END;

        TotalNoofRecords := FORMAT(NoofRecords);
        WHILE STRLEN(TotalNoofRecords) < MAXSTRLEN(TotalNoofRecords) DO
            TotalNoofRecords := '0' + TotalNoofRecords;
        DeclareNumText := '193' + FiscalYear + PeriodText + DeclarationNum;

        Txt1 :=
          '1' + '193' + FiscalYear + CompanyVATRegNo +
          PADSTR(FormatTextName(CompanyInfo.Name), 40, ' ') +
          DeclarationMT + CONVERTSTR(FORMAT(ContactTelephone, 9), ' ', '0') +
          PADSTR(FormatTextName(ContactName), 40, ' ') +
          DeclareNumText + PADSTR('', 1, ' ') + ReplacementText + PrevDeclareNumText + PeriodText +
          TotalNoofRecords + TotalBaseAmtText + TotalVATAmtText + TotalInvAmtText +
          PADSTR('', 199, ' ') + ElectronicCode;
        Txt1 := PADSTR(Txt1, 500, ' ');

        Outstr.WRITETEXT(Txt1);
    end;

    local procedure GetMonthText(): Text[2]
    var
        MonthNo: Integer;
    begin
        MonthNo := Month;
        IF MonthNo < 10 THEN
            EXIT('0' + FORMAT(MonthNo));
        EXIT(FORMAT(MonthNo));
    end;

    procedure FormatTextAmt(Amt: Decimal; Total: Boolean): Text[18]
    var
        Sign: Text[1];
        MaxLength: Integer;
    begin
        IF Amt < 0 THEN
            Sign := 'N'
        ELSE
            Sign := ' ';
        IF Total THEN
            MaxLength := 17
        ELSE
            MaxLength := 13;

        EXIT(Sign + FormatNumber(ROUND(Amt * 100, 1), MaxLength));
    end;

    local procedure FormatDate(PostingDate: Date): Text[8]
    begin
        IF PostingDate <> 0D THEN
            EXIT(FORMAT(PostingDate, 8, '<Year4><Month,2><Day,2>'));
        EXIT('00000000');
    end;

    local procedure FormatNumber(Number: Integer; Length: Integer): Text[30]
    begin
        EXIT(CONVERTSTR(FORMAT(Number, Length, '<Integer>'), ' ', '0'));
    end;

    local procedure FormatTextName(NameString: Text[50]) Result: Text[50]
    var
        TempString: Text[50];
        TempString1: Text[1];
    begin
        CLEAR(Result);
        TempString := CONVERTSTR(UPPERCASE(NameString), 'ÁÀÉÈÍÌÓÒÚÙÑÜÇ()"&´ÄËÏÖ¹Ü$''ºª', 'AAEEIIOOUUÐUÃ     AEIOOU    ');
        IF STRLEN(TempString) > 0 THEN
            REPEAT
                TempString1 := COPYSTR(TempString, 1, 1);
                IF TempString1 IN ['A' .. 'Z', '0' .. '9'] THEN
                    Result := Result + TempString1
                ELSE
                    Result := Result + ' ';
                TempString := DELSTR(TempString, 1, 1);
            UNTIL STRLEN(TempString) = 0;

        EXIT(Result);
    end;

    local procedure FindEUCountryRegionCode(CountryCode: Code[10]): Code[10]
    var
        Country: Record "Country/Region";
    begin
        IF Country.GET(CountryCode) THEN
            EXIT(Country."EU Country/Region Code");

        EXIT('');
    end;

    local procedure GetNoOfRegsText(): Text[2]
    var
        NoOfRegs: Integer;
    begin
        IF OperationCode IN ['C', '2'] THEN
            NoOfRegs := VATBuffer.COUNT
        ELSE
            NoOfRegs := 1;
        EXIT(FormatNumber(NoOfRegs, 2));
    end;

    local procedure GetFilterStringFromColumn(Columns: Text[1024]; IsGLAccount: Boolean) FilterString: Text[250]
    var
        ColumnCode: Text[1024];
        Position: Integer;
        AndOrFilterChar: Text[1];
        EmptyNotEqualFilterChar: Text[2];
    begin
        ColumnCode := Columns;
        FilterString := '';
        IF IsGLAccount THEN BEGIN
            EmptyNotEqualFilterChar := '';
            AndOrFilterChar := '|';
        END ELSE BEGIN
            EmptyNotEqualFilterChar := '<>';
            AndOrFilterChar := '&';
        END;
        REPEAT
            Position := STRPOS(ColumnCode, ';');
            IF ColumnCode <> '' THEN BEGIN
                IF Position <> 0 THEN BEGIN
                    FilterString := FilterString + EmptyNotEqualFilterChar + COPYSTR(ColumnCode, 1, Position - 1);
                    ColumnCode := COPYSTR(ColumnCode, Position + 1);
                END ELSE BEGIN
                    FilterString := FilterString + EmptyNotEqualFilterChar + COPYSTR(ColumnCode, 1);
                    ColumnCode := '';
                END;
                IF ColumnCode <> '' THEN
                    FilterString := FilterString + AndOrFilterChar;
            END;
        UNTIL ColumnCode = '';
    end;

    local procedure CalcTotals()
    begin
        CLEAR(rMovRetencion);
        rMovRetencion.SETRANGE(Tipo, rMovRetencion.Tipo::Compra);
        rMovRetencion.SETRANGE("Tipo retención", rMovRetencion."Tipo retención"::Profesionales);
        rMovRetencion.SETFILTER("Tipo documento", '%1|%2', rMovRetencion."Tipo documento"::"Fact. Registrada", rMovRetencion."Tipo documento"::"Abono Registrado");
        rMovRetencion.SETFILTER("Fecha registro", '%1..%2', FromDate, ToDate);
        IF rMovRetencion.FINDSET() THEN
            REPEAT
                TotalBaseAmount += rMovRetencion.Base;
                TotalInvoiceAmount += rMovRetencion.Base + rMovRetencion.Importe;
                TotalVATAmount += rMovRetencion.Importe;
                NoofRecords += 1;
            UNTIL rMovRetencion.NEXT() = 0;
    end;

    local procedure GetPropertyLocation(PropertyLocation: Option): Text[1]
    begin
        EXIT(FORMAT(PropertyLocation));
    end;

    local procedure CreateTempDeclarationLines(VatNumber: Text[9]; No: Code[20]; Name: Text[50]; DocumentDate: Date; DocumentNo: Text[40]; DocumentType: Text[30]; BufferValue18: Text[18]; BufferValue40: Text[40]; UnrealizedVATEntryNo: Integer; TransactionNo: Integer; PostingDate: Date; VATCashRegime: Boolean)
    begin
        IntegerCounter += 1;
        TempDeclarationLines.INIT();
        TempDeclarationLines.Key := IntegerCounter;
        TempDeclarationLines."Fiscal Year" := FiscalYear;
        TempDeclarationLines."VAT Registration No." := CompanyVATRegNo;
        TempDeclarationLines."VAT Number" := PADSTR(VatNumber, 9, ' ');
        TempDeclarationLines."Customer/Vendor No." := No;
        TempDeclarationLines."Customer/Vendor Name" := Name;
        TempDeclarationLines."Country Code" := PADSTR(CountryCode, 2, ' ');
        TempDeclarationLines."Resident ID" := ResidentIDText;
        TempDeclarationLines."International VAT No." := VATNoPermanentResidentCountry;
        TempDeclarationLines."Book Type Code" := BookTypeCode;
        TempDeclarationLines."Operation Code" := OperationCode;
        TempDeclarationLines."Document Date" := DocumentDate;
        TempDeclarationLines."Operation Date" := OperationDateText;
        TempDeclarationLines."Posting Date" := PostingDate;
        TempDeclarationLines."VAT %" := VATBuffer2."VAT %";
        TempDeclarationLines.Base := VATBuffer2.Base;
        TempDeclarationLines."Document No." := DocumentNo;
        TempDeclarationLines."Document Type" := DocumentType;
        TempDeclarationLines."VAT Document No." := PADSTR(VATEntry."Document No.", 18, ' ');
        TempDeclarationLines."Buffer Value 18" := BufferValue18;
        TempDeclarationLines."No. of Registers" := NoofRegistersText;
        TempDeclarationLines."Buffer Value 40" := BufferValue40;
        TempDeclarationLines."EC %" := VATBuffer2."EC %";
        TempDeclarationLines."EC Amount" := VATBuffer2."EC Amount";
        TempDeclarationLines."VAT Amount" := VATBuffer2.Amount - VATBuffer."EC Amount";
        TempDeclarationLines."VAT Amount / EC Amount" := VATBuffer2.Amount;
        TempDeclarationLines."Amount Including VAT / EC" := VATBuffer2.Base + VATBuffer2.Amount;
        TempDeclarationLines."Collection Amount" := VATBuffer2.Base + VATBuffer2.Amount;
        TempDeclarationLines.Type := VATEntry.Type;
        TempDeclarationLines."Unrealized VAT Entry No." := UnrealizedVATEntryNo;
        TempDeclarationLines."Bank Account Ledger Entry No." := FindPaymentInformation(TransactionNo);
        TempDeclarationLines."VAT Cash Regime" := VATCashRegime;
        TempDeclarationLines.fRemoveDuplicateAmounts;
        TempDeclarationLines.INSERT();
    end;

    local procedure RetrieveGLAccount(StringFilter: Text[250]) NoOfAcc: Integer
    var
        CommaPos: Integer;
        j: Integer;
    begin
        CommaPos := 1;
        j := 1;
        WHILE CommaPos <> 0 DO BEGIN
            CommaPos := STRPOS(StringFilter, '|');
            IF CommaPos = 0 THEN
                FilterArray[j] := StringFilter
            ELSE BEGIN
                FilterArray[j] := COPYSTR(StringFilter, 1, CommaPos - 1);
                StringFilter := DELSTR(StringFilter, 1, CommaPos);
            END;
            j += 1;
        END;
        NoOfAcc := j - 1;
    end;

    local procedure IsCashAccount(GLAccountNo: Text[20]): Boolean
    var
        i: Integer;
    begin
        FOR i := 1 TO NoOfAccounts DO
            IF GLAccountNo = FilterArray[i] THEN
                EXIT(TRUE);
        EXIT(FALSE);
    end;

    procedure InsertTextWithReplace(OriginalText: Text[1024]; TextToInsert: Text[1024]; Position: Integer) Result: Text[1024]
    var
        StrLength: Integer;
        OrigStrLength: Integer;
    begin
        OrigStrLength := STRLEN(OriginalText);
        StrLength := STRLEN(TextToInsert);

        IF OrigStrLength < (Position + StrLength - 1) THEN
            OriginalText := PADSTR(OriginalText, Position + StrLength - 1, ' ');

        Result := DELSTR(OriginalText, Position, StrLength);
        Result := INSSTR(Result, TextToInsert, Position);
    end;

    local procedure UpdateCustomerCashBuffer(CustomerNo: Code[20]; OperationYear: Integer; OperationAmount: Decimal)
    var
        CustomerCashBuffer: Record "Customer Cash Buffer";
        Customer: Record Customer;
    begin
        IF OperationYear < 2012 THEN
            EXIT;
        Customer.GET(CustomerNo);

        IF CustomerCashBuffer.GET(Customer."VAT Registration No.", FORMAT(OperationYear)) THEN BEGIN
            CustomerCashBuffer."Operation Amount" += OperationAmount;
            CustomerCashBuffer.MODIFY();
        END ELSE BEGIN
            CustomerCashBuffer.INIT();
            CustomerCashBuffer."VAT Registration No." := Customer."VAT Registration No.";
            CustomerCashBuffer."Operation Year" := FORMAT(OperationYear);
            CustomerCashBuffer."Operation Amount" := OperationAmount;
            CustomerCashBuffer.INSERT();
        END;
    end;

    local procedure IdentifyCashPaymentsFromGL(CustLedgerEntryParam: Record "Cust. Ledger Entry"): Boolean
    var
        GLEntryLoc: Record "G/L Entry";
    begin
        GLEntryLoc.RESET();
        GLEntryLoc.SETCURRENTKEY("Transaction No.");
        GLEntryLoc.SETRANGE("Transaction No.", CustLedgerEntryParam."Transaction No.");
        GLEntryLoc.SETRANGE("Document No.", CustLedgerEntryParam."Document No.");
        GLEntryLoc.SETRANGE("Document Type", GLEntryLoc."Document Type"::Payment);
        IF GLEntryLoc.FINDSET() THEN
            REPEAT
                IF IsCashAccount(GLEntryLoc."G/L Account No.") THEN
                    EXIT(TRUE);
            UNTIL GLEntryLoc.NEXT() = 0;
        EXIT(FALSE);
    end;

    procedure InitializeRequest(NewFiscalYear: Code[4]; NewMonth: Integer; NewContactName: Text[30]; NewTelephoneNumber: Code[9]; NewDeclarationNumber: Text[4]; NewElectronicCode: Code[16]; NewDeclarationMediaType: Option Telematic,"CD-R"; NewReplacementDeclaration: Boolean; NewPreviousDeclarationNumber: Code[13]; NewFileName: Text[1024]; NewGLAccount: Text[20]; NewMinPaymentAmount: Decimal)
    begin
        FiscalYear := NewFiscalYear;
        Month := NewMonth;
        MinPaymentAmount := NewMinPaymentAmount;
        ColumnGLAcc := NewGLAccount;
        ContactName := NewContactName;
        ContactTelephone := NewTelephoneNumber;
        DeclarationNum := NewDeclarationNumber;
        ElectronicCode := NewElectronicCode;
        DeclarationMediaType := NewDeclarationMediaType;
        ReplaceDeclaration := NewReplacementDeclaration;
        PrevDeclareNum := NewPreviousDeclarationNumber;
        FileName := NewFileName;
    end;

    local procedure PopulateAppliedPayments()
    var
        CustomerCashBuffer: Record "Customer Cash Buffer";
        OperationYear: Integer;
    begin
        NoOfAccounts := RetrieveGLAccount(GLAccFilterString);
        IF GLAccFilterString <> '' THEN BEGIN
            Customer.RESET();
            Customer.SETCURRENTKEY("VAT Registration No.");
            Customer.SETFILTER("VAT Registration No.", '<>%1', '');
            IF Customer.FINDSET() THEN
                REPEAT
                    IF CheckCustomerPayment(Customer."No.") THEN
                        ExecuteCustomerPayments(Customer."No.");
                UNTIL Customer.NEXT() = 0;
        END;

        IF CustomerCashBuffer.FINDSET() THEN
            REPEAT
                Customer.SETRANGE("VAT Registration No.", CustomerCashBuffer."VAT Registration No.");
                Customer.FINDFIRST();
                EVALUATE(OperationYear, CustomerCashBuffer."Operation Year");
                IF OperationYear <> NumFiscalYear THEN
                    GetAffectedYearInvoiceAndBill(Customer."No.", OperationYear);
            UNTIL CustomerCashBuffer.NEXT() = 0;

        CustomerCashBuffer.RESET();
        CustomerCashBuffer.SETFILTER("Operation Amount", '>=%1', MinPaymentAmount);
        NoofRecords := NoofRecords + CustomerCashBuffer.COUNT;
    end;

    local procedure FormatPaymentAmount(PaymentAmount: Decimal): Text[15]
    var
        AmtText: Text[15];
    begin
        PaymentAmount := PaymentAmount * 100;
        AmtText := CONVERTSTR(FORMAT(PaymentAmount), ' ', '0');
        AmtText := DELCHR(AmtText, '=', '.,');

        WHILE STRLEN(AmtText) < 15 DO
            AmtText := '0' + AmtText;
        EXIT(AmtText);
    end;

    local procedure CheckCashCollectables(): Boolean
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SETFILTER("Document Type", '%1|%2', CustLedgerEntry."Document Type"::" ", CustLedgerEntry."Document Type"::Payment);
        CustLedgerEntry.SETRANGE("Document Date", FromDate, ToDate);
        CustLedgerEntry.SETRANGE(Reversed, FALSE);
        EXIT(NOT CustLedgerEntry.ISEMPTY);
    end;

    local procedure CombineEUCountryAndVATRegNo(EUCountryRegionCode: Code[10]; VATRegistrationNo: Code[20]): Code[20]
    begin
        IF STRPOS(VATRegistrationNo, EUCountryRegionCode) <> 0 THEN
            EXIT(VATRegistrationNo);

        EXIT(EUCountryRegionCode + VATRegistrationNo);
    end;

    local procedure GetResidentIDText(RegionCountryCode: Code[10])
    begin
        IF RegionCountryCode = CompanyInfo."Country/Region Code" THEN
            ResidentIDText := '1'
        ELSE
            IF FindEUCountryRegionCode(RegionCountryCode) <> '' THEN
                ResidentIDText := '2'
            ELSE
                ResidentIDText := '6';
    end;

    local procedure GetVATNoPermnentResidntCntry(RegionCountryCode: Code[10]; VATRegistrationNo: Code[20])
    var
        EUCountryRegionCode: Code[10];
    begin
        IF RegionCountryCode <> CompanyInfo."Country/Region Code" THEN BEGIN
            EUCountryRegionCode := FindEUCountryRegionCode(RegionCountryCode);
            IF EUCountryRegionCode <> '' THEN
                VATNoPermanentResidentCountry :=
                  PADSTR(CombineEUCountryAndVATRegNo(EUCountryRegionCode, VATRegistrationNo), 20, ' ')
            ELSE
                VATNoPermanentResidentCountry := PADSTR('', 20, ' ');
        END ELSE
            VATNoPermanentResidentCountry := PADSTR('', 20, ' ');
    end;

    local procedure GetVATNumber(RegionCountryCode: Code[10]; VATRegistrationNo: Code[20]): Text[9]
    begin
        IF RegionCountryCode = CompanyInfo."Country/Region Code" THEN
            EXIT(PADSTR(VATRegistrationNo, 9, ' '));
        EXIT('');
    end;

    local procedure CheckCustomerPayment(CustomerNo: Code[20]): Boolean
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SETCURRENTKEY("Document Type", "Customer No.", "Posting Date", "Currency Code");
        CustLedgerEntry.SETFILTER("Document Type", '%1|%2', CustLedgerEntry."Document Type"::" ", CustLedgerEntry."Document Type"::Payment);
        CustLedgerEntry.SETRANGE("Customer No.", CustomerNo);
        CustLedgerEntry.SETRANGE("Document Date", FromDate, ToDate);
        IF CustLedgerEntry.FINDSET() THEN
            REPEAT
                IF CheckCustLedgEntryExists(CustLedgerEntry) THEN
                    EXIT(TRUE);
            UNTIL CustLedgerEntry.NEXT() = 0;
    end;

    local procedure ExecuteCustomerPayments(CustomerNo: Code[20])
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SETCURRENTKEY("Document Type", "Customer No.", "Posting Date", "Currency Code");
        CustLedgerEntry.SETFILTER("Document Type", '%1|%2', CustLedgerEntry."Document Type"::" ", CustLedgerEntry."Document Type"::Payment);
        CustLedgerEntry.SETRANGE("Customer No.", CustomerNo);
        CustLedgerEntry.SETRANGE("Document Date", DMY2DATE(1, 1, NumFiscalYear), ToDate);
        IF CustLedgerEntry.FINDSET() THEN
            REPEAT
                IF CheckCustLedgEntryExists(CustLedgerEntry) THEN
                    FillBufferFromPaymentCustLE(CustLedgerEntry, 0);
            UNTIL CustLedgerEntry.NEXT() = 0;
    end;

    local procedure FillBufferFromPaymentCustLE(CustLedgerEntry: Record "Cust. Ledger Entry"; InvoiceEntryNo: Integer)
    begin
        IF (CustLedgerEntry."Bal. Account Type" = CustLedgerEntry."Bal. Account Type"::"G/L Account") AND
           (CustLedgerEntry."Bal. Account No." <> '')
        THEN BEGIN
            IF IsCashAccount(CustLedgerEntry."Bal. Account No.") THEN
                CalculateAppliedAmounts(CustLedgerEntry."Entry No.", CustLedgerEntry."Customer No.", InvoiceEntryNo)
        END ELSE
            IF ((CustLedgerEntry."Bal. Account No." = '') OR
                (CustLedgerEntry."Bal. Account Type" <> CustLedgerEntry."Bal. Account Type"::"G/L Account"))
            THEN
                IF IdentifyCashPaymentsFromGL(CustLedgerEntry) THEN
                    CalculateAppliedAmounts(CustLedgerEntry."Entry No.", CustLedgerEntry."Customer No.", InvoiceEntryNo);
    end;

    local procedure CalculateAppliedAmounts(PaymentEntryNo: Integer; CustomerNo: Code[20]; InvoiceEntryNo: Integer)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
        DtldCustLedgEntry.SETRANGE("Applied Cust. Ledger Entry No.", PaymentEntryNo);
        DtldCustLedgEntry.SETRANGE(Unapplied, FALSE);
        IF InvoiceEntryNo <> 0 THEN
            DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", InvoiceEntryNo);
        IF DtldCustLedgEntry.FINDSET() THEN
            REPEAT
                IF DtldCustLedgEntry."Cust. Ledger Entry No." <> DtldCustLedgEntry."Applied Cust. Ledger Entry No." THEN
                    IF CustLedgerEntry.GET(DtldCustLedgEntry."Cust. Ledger Entry No.") THEN
                        UpdateCustomerCashBuffer(
                          CustomerNo, DATE2DMY(CustLedgerEntry."Document Date", 3), -DtldCustLedgEntry."Amount (LCY)");
            UNTIL DtldCustLedgEntry.NEXT() = 0
        ELSE BEGIN
            DtldCustLedgEntry.SETRANGE("Applied Cust. Ledger Entry No.");
            DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", PaymentEntryNo);
            DtldCustLedgEntry.SETRANGE("Entry Type", DtldCustLedgEntry."Entry Type"::Application);
            IF DtldCustLedgEntry.FINDSET() THEN
                REPEAT
                    IF CustLedgerEntry.GET(DtldCustLedgEntry."Applied Cust. Ledger Entry No.") THEN
                        UpdateCustomerCashBuffer(
                          CustomerNo, DATE2DMY(CustLedgerEntry."Document Date", 3), DtldCustLedgEntry."Amount (LCY)");
                UNTIL DtldCustLedgEntry.NEXT() = 0;
        END;
    end;

    local procedure GetAffectedYearInvoiceAndBill(CustomerNo: Code[20]; AffectedYear: Integer)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SETCURRENTKEY("Document Type", "Customer No.", "Posting Date", "Currency Code");
        CustLedgerEntry.SETFILTER(
          "Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::Bill);
        CustLedgerEntry.SETRANGE("Customer No.", CustomerNo);
        CustLedgerEntry.SETRANGE("Document Date", DMY2DATE(1, 1, AffectedYear), DMY2DATE(31, 12, AffectedYear));
        IF CustLedgerEntry.FINDSET() THEN
            REPEAT
                GetAppliedPaymentsFromInvBill(CustLedgerEntry."Entry No.");
            UNTIL CustLedgerEntry.NEXT() = 0;
    end;

    local procedure GetAppliedPaymentsFromInvBill(InvoiceEntryNo: Integer)
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        DtldCustLedgEntry.SETRANGE("Applied Cust. Ledger Entry No.", InvoiceEntryNo);
        DtldCustLedgEntry.SETRANGE("Entry Type", DtldCustLedgEntry."Entry Type"::Application);
        DtldCustLedgEntry.SETFILTER("Posting Date", '<%1', DMY2DATE(1, 1, NumFiscalYear));
        DtldCustLedgEntry.SETRANGE(Unapplied, FALSE);
        IF DtldCustLedgEntry.FINDSET() THEN
            REPEAT
                IF DtldCustLedgEntry."Cust. Ledger Entry No." <> DtldCustLedgEntry."Applied Cust. Ledger Entry No." THEN
                    IF CustLedgerEntry.GET(DtldCustLedgEntry."Cust. Ledger Entry No.") THEN
                        FillBufferFromPaymentCustLE(CustLedgerEntry, InvoiceEntryNo);
            UNTIL DtldCustLedgEntry.NEXT() = 0
        ELSE BEGIN
            DtldCustLedgEntry.SETRANGE("Applied Cust. Ledger Entry No.");
            DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", InvoiceEntryNo);
            IF DtldCustLedgEntry.FINDSET() THEN
                REPEAT
                    IF DtldCustLedgEntry."Cust. Ledger Entry No." <> DtldCustLedgEntry."Applied Cust. Ledger Entry No." THEN
                        IF CustLedgerEntry.GET(DtldCustLedgEntry."Applied Cust. Ledger Entry No.") THEN
                            FillBufferFromPaymentCustLE(CustLedgerEntry, InvoiceEntryNo);
                UNTIL DtldCustLedgEntry.NEXT() = 0;
        END;
    end;

    procedure GetServerFileName(var ServerFileName: Text[1024])
    begin
        ServerFileName := ServerTempFileName;
    end;

    local procedure CheckCustLedgEntryExists(CustLedgerEntry: Record "Cust. Ledger Entry"): Boolean
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ApplDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Payment THEN
            EXIT(TRUE);
        DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
        DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
        IF DtldCustLedgEntry.FINDFIRST() THEN BEGIN
            ApplDtldCustLedgEntry.SETRANGE("Transaction No.", DtldCustLedgEntry."Transaction No.");
            ApplDtldCustLedgEntry.SETFILTER("Cust. Ledger Entry No.", '<>%1', DtldCustLedgEntry."Cust. Ledger Entry No.");
            ApplDtldCustLedgEntry.SETRANGE("Document Type", ApplDtldCustLedgEntry."Document Type"::Bill);
            EXIT(ApplDtldCustLedgEntry.ISEMPTY);
        END;
    end;

    local procedure AddPaymentMethod(var DeclarationLine: Record "340 Declaration Line"; var txt: Text[1024]; CollectionPaymentMethodUsed: Text[1])
    var
        InsertPosition: Integer;
    begin
        IF DeclarationLine.Type = DeclarationLine.Type::Sale THEN
            InsertPosition := 466
        ELSE
            InsertPosition := 371;

        CollectionPaymentMethodUsed := PADSTR(CollectionPaymentMethodUsed, 1, ' ');
        txt := InsertTextWithReplace(txt, CollectionPaymentMethodUsed, InsertPosition);
    end;

    local procedure AreDatesInSamePeriod(Date1: Date; Date2: Date): Boolean
    begin
        EXIT(CALCDATE('<CM>', Date1) = CALCDATE('<CM>', Date2));
    end;

    local procedure FindCustPaymentMethod(DocVATEntry: Record "VAT Entry"): Text[30]
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        CustLedgerEntry.SETRANGE("Transaction No.", DocVATEntry."Transaction No.");
        IF CustLedgerEntry.FINDFIRST() THEN BEGIN
            CASE CustLedgerEntry."Document Type" OF
                CustLedgerEntry."Document Type"::Invoice:
                    IF SalesInvHeader.GET(CustLedgerEntry."Document No.") THEN
                        EXIT(SalesInvHeader."Payment Method Code");
                CustLedgerEntry."Document Type"::"Credit Memo":
                    IF SalesCrMemoHeader.GET(CustLedgerEntry."Document No.") THEN
                        EXIT(SalesCrMemoHeader."Payment Method Code");
            END;
            IF Customer.GET(CustLedgerEntry."Customer No.") THEN
                EXIT(Customer."Payment Method Code");
        END;
    end;

    local procedure FindVendPaymentMethod(DocVATEntry: Record "VAT Entry"): Text[30]
    var
        Vendor: Record Vendor;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        VendorLedgerEntry.SETRANGE("Transaction No.", DocVATEntry."Transaction No.");
        IF VendorLedgerEntry.FINDFIRST() THEN BEGIN
            CASE VendorLedgerEntry."Document Type" OF
                VendorLedgerEntry."Document Type"::Invoice:
                    IF PurchInvHeader.GET(VendorLedgerEntry."Document No.") THEN
                        EXIT(PurchInvHeader."Payment Method Code");
                VendorLedgerEntry."Document Type"::"Credit Memo":
                    IF PurchCrMemoHdr.GET(VendorLedgerEntry."Document No.") THEN
                        EXIT(PurchCrMemoHdr."Payment Method Code");
            END;
            IF Vendor.GET(VendorLedgerEntry."Vendor No.") THEN
                EXIT(Vendor."Payment Method Code");
        END;
    end;

    local procedure FindPaymentInformation(TransactionNo: Integer): Integer
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        BankAccountLedgerEntry.SETRANGE("Transaction No.", TransactionNo);
        IF BankAccountLedgerEntry.FINDFIRST() THEN
            EXIT(BankAccountLedgerEntry."Entry No.");

        EXIT(0);
    end;

    local procedure FindAppliedToDocumentNo(UnrealizedVATEntry: Record "VAT Entry"): Code[20]
    begin
        IF UnrealizedVATEntry.Type = UnrealizedVATEntry.Type::Sale THEN
            EXIT(UnrealizedVATEntry."Document No.");

        IF UnrealizedVATEntry.Type = UnrealizedVATEntry.Type::Purchase THEN
            EXIT(UnrealizedVATEntry."External Document No.");
    end;

    local procedure SkipUnappliedCustLedgEntry(TransactionNo: Integer)
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        UnappliedDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry.SETCURRENTKEY("Transaction No.");
        DtldCustLedgEntry.SETRANGE("Transaction No.", TransactionNo);
        DtldCustLedgEntry.SETRANGE("Entry Type", DtldCustLedgEntry."Entry Type"::Application);
        IF DtldCustLedgEntry.FINDFIRST() THEN
            IF DtldCustLedgEntry.Unapplied THEN BEGIN
                UnappliedDtldCustLedgEntry.GET(DtldCustLedgEntry."Unapplied by Entry No.");
                IF AreDatesInSamePeriod(UnappliedDtldCustLedgEntry."Posting Date", DtldCustLedgEntry."Posting Date") THEN
                    CurrReport.SKIP;
            END;
    end;

    local procedure SkipUnappliedVendLedgEntry(TransactionNo: Integer)
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        UnappliedDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry.SETCURRENTKEY("Transaction No.");
        DtldVendLedgEntry.SETRANGE("Transaction No.", TransactionNo);
        DtldVendLedgEntry.SETRANGE("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
        IF DtldVendLedgEntry.FINDFIRST() THEN
            IF DtldVendLedgEntry.Unapplied THEN BEGIN
                UnappliedDtldVendLedgEntry.GET(DtldVendLedgEntry."Unapplied by Entry No.");
                IF AreDatesInSamePeriod(UnappliedDtldVendLedgEntry."Posting Date", DtldVendLedgEntry."Posting Date") THEN
                    CurrReport.SKIP;
            END;
    end;

    local procedure SkipZeroCustLedgEntry(TransactionNo: Integer)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.SETRANGE("Transaction No.", TransactionNo);
        IF CustLedgEntry.FINDFIRST() THEN BEGIN
            CustLedgEntry.CALCFIELDS("Original Amount");
            IF CustLedgEntry."Original Amount" = 0 THEN
                CurrReport.SKIP;
        END;
    end;

    local procedure SkipZeroVendLedgEntry(TransactionNo: Integer)
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry.SETRANGE("Transaction No.", TransactionNo);
        IF VendLedgEntry.FINDFIRST() THEN BEGIN
            VendLedgEntry.CALCFIELDS("Original Amount");
            IF VendLedgEntry."Original Amount" = 0 THEN
                CurrReport.SKIP;
        END;
    end;

    local procedure ReplaceDeclarationOnPush()
    begin
        PrevDeclarationNumEnable := ReplaceDeclaration;
    end;

    local procedure CheckVLEApplication(VATEntry: Record "VAT Entry"): Boolean
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        CheckVendLedgEntry: Record "Vendor Ledger Entry";
        UnrealizedVendLedgEntry: Integer;
    begin
        FilterVendLedgerEntryByVATEntry(VendorLedgerEntry, VATEntry);
        UnrealizedVendLedgEntry := GetUnrealizedInvoiceVLENo(VATEntry."Unrealized VAT Entry No.");

        IF VendorLedgerEntry.FINDSET() THEN
            REPEAT
                DtldVendLedgEntry.RESET();
                DtldVendLedgEntry.SETRANGE(Unapplied, FALSE);
                DtldVendLedgEntry.SETRANGE("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
                DtldVendLedgEntry.SETRANGE("Applied Vend. Ledger Entry No.", VendorLedgerEntry."Entry No.");
                IF UnrealizedVendLedgEntry <> 0 THEN
                    DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", UnrealizedVendLedgEntry);

                IF DtldVendLedgEntry.FINDSET() THEN
                    REPEAT
                        IF (DtldVendLedgEntry."Vendor Ledger Entry No." <> DtldVendLedgEntry."Applied Vend. Ledger Entry No.") AND
                           CheckVendLedgEntry.GET(DtldVendLedgEntry."Vendor Ledger Entry No.")
                        THEN BEGIN
                            IF ExistDtldVLE(DtldVendLedgEntry."Vendor Ledger Entry No.", DtldVendLedgEntry."Applied Vend. Ledger Entry No.") THEN
                                EXIT(FALSE);
                            InsertTempDtldVLE(DtldVendLedgEntry."Vendor Ledger Entry No.", DtldVendLedgEntry."Applied Vend. Ledger Entry No.");
                            EXIT(TRUE);
                        END;
                    UNTIL DtldVendLedgEntry.NEXT() = 0
                ELSE BEGIN
                    DtldVendLedgEntry.SETRANGE("Applied Vend. Ledger Entry No.");
                    DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendorLedgerEntry."Entry No.");
                    IF UnrealizedVendLedgEntry <> 0 THEN
                        DtldVendLedgEntry.SETRANGE("Applied Vend. Ledger Entry No.", UnrealizedVendLedgEntry);

                    IF DtldVendLedgEntry.FINDSET() THEN
                        REPEAT
                            IF CheckVendLedgEntry.GET(DtldVendLedgEntry."Applied Vend. Ledger Entry No.") THEN BEGIN
                                IF ExistDtldVLE(DtldVendLedgEntry."Applied Vend. Ledger Entry No.", DtldVendLedgEntry."Vendor Ledger Entry No.") THEN
                                    EXIT(FALSE);
                                InsertTempDtldVLE(DtldVendLedgEntry."Applied Vend. Ledger Entry No.", DtldVendLedgEntry."Vendor Ledger Entry No.");
                                EXIT(TRUE);
                            END;
                        UNTIL DtldVendLedgEntry.NEXT() = 0;
                END;
            UNTIL VendorLedgerEntry.NEXT() = 0;

        EXIT(TRUE);
    end;

    local procedure GetUnrealizedInvoiceVLENo(VATEntryNo: Integer): Integer
    var
        VATEntry: Record "VAT Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        IF NOT VATEntry.GET(VATEntryNo) THEN
            EXIT(0);
        FilterVendLedgerEntryByVATEntry(VendLedgEntry, VATEntry);
        IF VendLedgEntry.FINDFIRST() THEN
            EXIT(VendLedgEntry."Entry No.");
        EXIT(0);
    end;

    local procedure FilterVendLedgerEntryByVATEntry(var VendLedgEntry: Record "Vendor Ledger Entry"; VATEntry: Record "VAT Entry")
    begin
        VendLedgEntry.SETRANGE("Vendor No.", VATEntry."Bill-to/Pay-to No.");
        VendLedgEntry.SETRANGE("Posting Date", VATEntry."Posting Date");
        VendLedgEntry.SETRANGE("Document Type", VATEntry."Document Type");
        VendLedgEntry.SETRANGE("Document No.", VATEntry."Document No.");
        VendLedgEntry.SETRANGE("Transaction No.", VATEntry."Transaction No.");
    end;

    local procedure HasBeenRealized(VATEntryNo: Integer): Boolean
    var
        UnrealizedVATEntry: Record "VAT Entry";
    begin
        UnrealizedVATEntry.SETRANGE("Unrealized VAT Entry No.", VATEntryNo);
        EXIT(NOT UnrealizedVATEntry.ISEMPTY);
    end;

    local procedure ExistDtldVLE(VLENo: Integer; AppliedVLENo: Integer): Boolean
    begin
        TempDetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.", VLENo);
        TempDetailedVendorLedgEntry.SETRANGE("Applied Vend. Ledger Entry No.", AppliedVLENo);
        EXIT(NOT TempDetailedVendorLedgEntry.ISEMPTY);
    end;

    local procedure InsertTempDtldVLE(VLENo: Integer; AppliedVLENo: Integer)
    begin
        TempDetailedVendorLedgEntry.INIT();
        IF TempDetailedVendorLedgEntry.FINDLAST() THEN;
        TempDetailedVendorLedgEntry."Entry No." += 1;
        TempDetailedVendorLedgEntry."Vendor Ledger Entry No." := VLENo;
        TempDetailedVendorLedgEntry."Applied Vend. Ledger Entry No." := AppliedVLENo;
        TempDetailedVendorLedgEntry.INSERT();
    end;

    local procedure DownloadFile()
    begin
        TempBlob.CreateInStream(InStr);
        // Testability: FileName is initialized if this report is invoked from tests
        IF FileName = '' THEN BEGIN
            FileName := STRSUBSTNO(FileNameTxt, FiscalYear, Month);
            // IF DOWNLOAD(ServerTempFileName, '', '', FileFilterTxt, FileName) AND FileManagement.CanRunDotNetOnClient THEN
            IF DownloadFromStream(InStr, '', '', FileFilterTxt, FileName) THEN
                MESSAGE(FileExportedMsg, FileName);
        END ELSE
            // FileManagement.CopyServerFile(ServerTempFileName, FileName, TRUE);
            MESSAGE(FileExportedMsg, FileName);
    end;

    local procedure CheckIncludeVATEntry(VATEntry: Record "VAT Entry"): Boolean
    begin
        EXIT(
NOT ((VATEntry."Document Type" IN [VATEntry."Document Type"::Invoice, VATEntry."Document Type"::"Credit Memo",
                    VATEntry."Document Type"::"Finance Charge Memo", VATEntry."Document Type"::Reminder]) AND
(VATEntry."Unrealized Base" <> 0) AND NOT VATEntry."VAT Cash Regime") AND
NOT (VATEntry."Document Type" = VATEntry."Document Type"::" "))
        // Invoices, Credit Memos, Finance Charge Memos and Reminders with unrealized base and are not in the VAT Cash Regime should not be shown, only their payment
    end;

    local procedure fCreateTempPila(pMovsRetenciones: Record "Movs. retenciones")
    begin

        IF Vendor.GET(pMovsRetenciones."Cod. origen") THEN;

        IntegerCounter += 1;
        rtPilaMovs.INIT();
        rtPilaMovs.Key := IntegerCounter;
        rtPilaMovs."Fiscal Year" := FiscalYear;
        rtPilaMovs."VAT Registration No." := CompanyVATRegNo;
        rtPilaMovs."VAT Number" := PADSTR(pMovsRetenciones."CIF/NIF", 9, ' ');
        rtPilaMovs."Customer/Vendor No." := pMovsRetenciones."Cod. origen";
        rtPilaMovs."Customer/Vendor Name" := Vendor.Name;
        rtPilaMovs."Country Code" := PADSTR(CountryCode, 2, ' ');
        rtPilaMovs."Resident ID" := ResidentIDText;
        rtPilaMovs."International VAT No." := VATNoPermanentResidentCountry;
        rtPilaMovs."Posting Date" := pMovsRetenciones."Fecha registro";
        rtPilaMovs.Base := pMovsRetenciones.Base;
        rtPilaMovs.Importe := pMovsRetenciones.Importe;
        rtPilaMovs.Total := pMovsRetenciones.Base + pMovsRetenciones.Importe;
        rtPilaMovs."Document No." := pMovsRetenciones."Nº documento";
        rtPilaMovs."Document Type" := FORMAT(pMovsRetenciones."Tipo documento");
        rtPilaMovs."VAT Document No." := PADSTR(pMovsRetenciones."Nº documento", 18, ' ');
        rtPilaMovs.Clave := pMovsRetenciones."Clave IRPF";
        rtPilaMovs.Subclave := pMovsRetenciones."Subclave IRPF";
        rtPilaMovs."No. of Registers" := NoofRegistersText;
        rtPilaMovs.Type := VATEntry.Type;
        rtPilaMovs.INSERT();
    end;

    local procedure fActualizaTempPila(pMovsRetenciones: Record "Movs. retenciones")
    begin
        IF Vendor.GET(pMovsRetenciones."Cod. origen") THEN;

        rtPilaMovs.Base += pMovsRetenciones.Base;
        rtPilaMovs.Importe += pMovsRetenciones.Importe;
        rtPilaMovs.Total += pMovsRetenciones.Base + pMovsRetenciones.Importe;
        rtPilaMovs.MODIFY();
    end;

    local procedure WritePilaToText(var rPilaMovs: Record "Pila Movs. retencion")
    var
        txt: Text[500];
    begin
        rPilaMovs.RESET();
        IF rPilaMovs.FINDSET() THEN
            REPEAT
                txt := '2193' + FiscalYearText + rPilaMovs."VAT Registration No." + rPilaMovs."VAT Number" + PADSTR('', 9, ' ') +
                  PADSTR(FormatTextName(rPilaMovs."Customer/Vendor Name"), 40, ' ') + rPilaMovs."Resident ID" + rPilaMovs.Clave + rPilaMovs.Subclave + FormatTextAmt(rPilaMovs.Base, FALSE) + FormatTextAmt(rPilaMovs.Importe, FALSE);

                txt := PADSTR(txt, 500, ' ');

                Outstr.WRITETEXT;
                Outstr.WRITETEXT(txt);
            UNTIL rPilaMovs.NEXT() = 0;
    end;
}
