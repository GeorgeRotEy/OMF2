//Itercompany
// table 50150 "Intercompany Transaction Line"
// {
//     // Mod. S2G (JMP) 16/04/2018 GF008
//     //
//     // Mod. S2G 08/08/2016 (AAS) : INT-MC
//     //                         Nuevo campo
//     //                           50200 "Transfer INT-MC"

//     Caption = 'Intercompany Transaction Line';
//     DataPerCompany = false;

//     fields
//     {
//         field(1; "Table ID"; Integer)
//         {
//             Caption = 'Table ID';
//         }
//         field(2; "Source Doc. Type"; Option)
//         {
//             Caption = 'Source Doc. Type';
//             OptionCaption = '0,1,2,3,4,5,6,7,8';
//             OptionMembers = "0","1","2","3","4","5","6","7","8";
//         }
//         field(3; "Source Doc. No."; Code[20])
//         {
//             Caption = 'Source Doc. No.';
//         }
//         field(4; "Source Doc. Subtype"; Code[10])
//         {
//             Caption = 'Source Doc. Subtype';
//         }
//         field(5; "Source Doc. Line No."; Integer)
//         {
//             Caption = 'Source Doc. Line No.';
//         }
//         field(6; "Transaction Type"; Option)
//         {
//             Caption = 'Transaction Type';
//             OptionCaption = 'Sales Invoicing,Purchase Reinvoicing,Bank Acc. Transfer,Other Company Payment,Loan Between Companies';
//             OptionMembers = "Sales Invoicing","Purchase Reinvoicing","Bank Acc. Transfer","Other Company Payment","Loan Between Companies";
//         }
//         field(7; "Source Company Name"; Text[50])
//         {
//             Caption = 'Source Company Name';
//             TableRelation = Company;

//             trigger OnValidate()
//             begin
//                 IF "Source Company Name" = '' THEN BEGIN
//                     "Buy-from Vendor No." := '';
//                     VALIDATE("Buy-from Vendor No.");
//                 END ELSE
//                     IF "Source Company Name" <> xRec."Source Company Name" THEN BEGIN
//                         rCompanyInfo.CHANGECOMPANY("Source Company Name");
//                         rCompanyInfo.GET;
//                         //rCompanyInfo.TESTFIELD("Group Vendor No.");
//                         //VALIDATE("Buy-from Vendor No.",rCompanyInfo."Group Vendor No.");
//                         IF "Transaction Type" IN ["Transaction Type"::"Bank Acc. Transfer", "Transaction Type"::"Other Company Payment"] THEN BEGIN
//                             //rCompanyInfo.TESTFIELD("Group Bank Acc. No.");
//                             //VALIDATE("Source Bank Acc. No.",rCompanyInfo."Group Bank Acc. No.");
//                         END;
//                     END;
//             end;
//         }
//         field(8; "Sell-to Customer No."; Code[20])
//         {
//             Caption = 'Sell-to Customer No.';
//             TableRelation = Customer;

//             trigger OnValidate()
//             begin
//                 IF "Sell-to Customer No." = '' THEN
//                     "Sell-to Customer Name" := ''
//                 ELSE
//                     IF "Sell-to Customer No." <> xRec."Sell-to Customer No." THEN BEGIN
//                         rCust.GET("Sell-to Customer No.");
//                         "Sell-to Customer Name" := rCust.Name;
//                     END;
//             end;
//         }
//         field(9; "Sell-to Customer Name"; Text[50])
//         {
//             Caption = 'Sell-to Customer Name';
//             Editable = false;
//         }
//         field(10; "Destination Company Name"; Text[30])
//         {
//             Caption = 'Destination Company Name';
//             TableRelation = Company;

//             trigger OnValidate()
//             var
//                 rlBankAcc: Record "Bank Account";
//                 ctSourceBankAccNo: Label 'The Bank Account No. %1 doesn''t exist in %2.';
//             begin
//                 IF "Destination Company Name" = '' THEN BEGIN
//                     "Sell-to Customer No." := '';
//                     VALIDATE("Sell-to Customer No.");
//                 END ELSE
//                     IF "Destination Company Name" <> xRec."Destination Company Name" THEN BEGIN
//                         IF "Source Company Name" = "Destination Company Name" THEN
//                             ERROR(ctSameCompanyError);
//                         rCompanyInfo.CHANGECOMPANY("Destination Company Name");
//                         rCompanyInfo.GET;
//                         //rCompanyInfo.TESTFIELD(rCompanyInfo."Group Customer No.");
//                         //VALIDATE("Sell-to Customer No.",rCompanyInfo."Group Customer No.");
//                         IF "Transaction Type" IN ["Transaction Type"::"Bank Acc. Transfer", "Transaction Type"::"Other Company Payment"] THEN BEGIN
//                             rlBankAcc.RESET;
//                             rlBankAcc.CHANGECOMPANY("Destination Company Name");
//                             IF NOT rlBankAcc.GET("Source Bank Acc. No.") THEN
//                                 ERROR(ctSourceBankAccNo, "Source Bank Acc. No.", "Destination Company Name");
//                         END;
//                     END;
//             end;
//         }
//         field(11; "Buy-from Vendor No."; Code[20])
//         {
//             Caption = 'Buy-from Vendor No.';
//             TableRelation = Vendor;

//             trigger OnValidate()
//             begin
//                 IF "Buy-from Vendor No." = '' THEN
//                     "Buy-from Vendor Name" := ''
//                 ELSE
//                     IF "Buy-from Vendor No." <> xRec."Buy-from Vendor No." THEN BEGIN
//                         rVend.GET("Buy-from Vendor No.");
//                         "Buy-from Vendor Name" := rVend.Name;
//                     END;
//             end;
//         }
//         field(12; "Buy-from Vendor Name"; Text[50])
//         {
//             Caption = 'Buy-from Vendor Name';
//             Editable = false;
//         }
//         field(13; "Amount %"; Decimal)
//         {
//             Caption = '% Importe';
//         }
//         field(14; "Proportional Alloc. by Estab."; Boolean)
//         {
//             Caption = 'Proportional Alloc. by Establishments';
//         }
//         field(15; "Global Dimension 1 Code"; Code[20])
//         {
//             Caption = 'Global Dimension 1 Code';

//             trigger OnLookup()
//             var
//                 rlDimValue: Record "Dimension Value";
//                 flDimValueList: Page "Dimension Value List";
//             begin
//                 /*
//                 rGLSetup.GET;
//                 rGLSetup.TESTFIELD("Global Dimension 1 Code");
//                 TESTFIELD("Destination Company Name");

//                 rlDimValue.RESET;
//                 rlDimValue.CHANGECOMPANY("Destination Company Name");
//                 rlDimValue.SETRANGE("Dimension Code",rGLSetup."Global Dimension 1 Code");
//                 //rlDimValue.SETFILTER("Establishment Company Name",'=%1|=%2',"Destination Company Name",'');
//                 CLEAR(flDimValueList);
//                 //flDimValueList.fSetSkipCompanyFilter;
//                 flDimValueList.LOOKUPMODE(TRUE);
//                 flDimValueList.SETTABLEVIEW(rlDimValue);
//                 IF flDimValueList.RUNMODAL = ACTION::LookupOK THEN BEGIN
//                   flDimValueList.GETRECORD(rlDimValue);
//                   VALIDATE("Global Dimension 1 Code",rlDimValue.Code);
//                 END;
//                 */

//                 rGLSetup.GET;
//                 rGLSetup.TESTFIELD("Global Dimension 1 Code");
//                 TESTFIELD("Destination Company Name");
//                 rlDimValue.RESET;
//                 rGLSetup.CHANGECOMPANY("Destination Company Name");
//                 rGLSetup.GET;
//                 rlDimValue.CHANGECOMPANY("Destination Company Name");
//                 rlDimValue.SETRANGE("Dimension Code", rGLSetup."Global Dimension 1 Code");
//                 IF PAGE.RUNMODAL(0, rlDimValue) = ACTION::LookupOK THEN
//                     VALIDATE("Global Dimension 1 Code", rlDimValue.Code);
//             end;

//             trigger OnValidate()
//             var
//                 rlDimValue: Record "Dimension Value";
//             begin
//                 IF "Global Dimension 1 Code" <> '' THEN
//                     TESTFIELD("Proportional Alloc. by Estab.", FALSE);

//                 rGLSetup.GET;
//                 rGLSetup.TESTFIELD("Global Dimension 1 Code");
//                 TESTFIELD("Destination Company Name");

//                 rlDimValue.RESET;
//                 rlDimValue.CHANGECOMPANY("Destination Company Name");
//                 rlDimValue.SETRANGE("Dimension Code", rGLSetup."Global Dimension 1 Code");
//                 rlDimValue.SETRANGE(Code, "Global Dimension 1 Code");
//                 //rlDimValue.SETFILTER("Establishment Company Name",'=%1|=%2',"Destination Company Name",'');
//                 rlDimValue.FINDFIRST;
//             end;
//         }
//         field(16; "Line No."; Integer)
//         {
//             Caption = 'Line No.';
//         }
//         field(17; "User ID"; Code[50])
//         {
//             Caption = 'User ID';
//             NotBlank = true;
//             TableRelation = User."User Name";
//             ValidateTableRelation = false;

//         }
//         field(18; "Creation Date/Time"; DateTime)
//         {
//             Caption = 'Creation Date/Time';
//         }
//         field(19; "Account Type"; Option)
//         {
//             Caption = 'Account Type';
//             OptionCaption = 'G/L Account,,,Bank Account';
//             OptionMembers = "G/L Account",,,"Bank Account";

//             trigger OnLookup()
//             begin
//                 //SETFILTER("Account Type",'%1%2',"Account Type"::"Bank Account","Account Type"::"G/L Account");
//                 //SETRANGE("Account Type","Account Type"::"Bank Account");
//             end;

//             trigger OnValidate()
//             begin
//                 VALIDATE("Account No.", '');
//             end;
//         }
//         field(20; "Account No."; Code[20])
//         {
//             Caption = 'Account No.';

//             trigger OnLookup()
//             var
//                 rGLAccount: Record "G/L Account";
//                 rBankAccount: Record "Bank Account";
//             begin
//                 TESTFIELD("Destination Company Name");
//                 CASE TRUE OF
//                     "Account Type" = "Account Type"::"G/L Account":
//                         BEGIN
//                             rGLAccount.RESET;
//                             rGLAccount.CHANGECOMPANY("Destination Company Name");
//                             rGLAccount.SETRANGE("Account Type", rGLAccount."Account Type"::Posting);
//                             IF PAGE.RUNMODAL(0, rGLAccount) = ACTION::LookupOK THEN
//                                 VALIDATE("Account No.", rGLAccount."No.");
//                         END;
//                     "Account Type" = "Account Type"::"Bank Account":
//                         BEGIN
//                             rBankAccount.RESET;
//                             rBankAccount.CHANGECOMPANY("Destination Company Name");
//                             IF PAGE.RUNMODAL(0, rBankAccount) = ACTION::LookupOK THEN
//                                 VALIDATE("Account No.", rBankAccount."No.");
//                         END;
//                 END;
//             end;

//             trigger OnValidate()
//             var
//                 rlGLAcc: Record "G/L Account";
//                 rlItem: Record Item;
//                 rlFA: Record "Fixed Asset";
//                 rlRes: Record Resource;
//                 rlCharge: Record "Item Charge";
//             begin
//                 IF "Account No." = '' THEN
//                     "Account Name" := ''
//                 ELSE BEGIN
//                     CASE TRUE OF
//                         ("Account Type" = "Account Type"::"G/L Account") AND rlGLAcc.GET("Account No."):
//                             "Account Name" := rlGLAcc.Name;
//                         //("Account Type" = "Account Type"::"2") AND rlItem.GET("Account No."):"Account Name" := rlItem.Description;
//                         ("Account Type" = "Account Type"::"Bank Account") AND rlRes.GET("Account No."):
//                             "Account Name" := rlRes.Name;
//                     //("Account Type" = "Account Type"::"4") AND rlFA.GET("Account No."):"Account Name" := rlFA.Description;
//                     //("Account Type" = "Account Type"::"5") AND rlCharge.GET("Account No."):"Account Name" := rlCharge.Description;
//                     END;
//                 END;
//             end;
//         }
//         field(21; "Account Name"; Text[50])
//         {
//             Caption = 'Account Name';
//         }
//         field(22; Quantity; Decimal)
//         {
//             Caption = 'Quantity';
//             DecimalPlaces = 0 : 5;

//             trigger OnValidate()
//             begin
//                 VALIDATE("Unit Amount");
//             end;
//         }
//         field(23; "Unit Amount"; Decimal)
//         {
//             Caption = 'Unit Amount';

//             trigger OnValidate()
//             var
//                 rlGLSetup: Record "General Ledger Setup";
//             begin
//                 rlGLSetup.GET;
//                 rlGLSetup.TESTFIELD("Amount Rounding Precision");
//                 Amount := ROUND(Quantity * "Unit Amount", rlGLSetup."Amount Rounding Precision");
//             end;
//         }
//         field(24; Amount; Decimal)
//         {
//             Caption = 'Amount';
//         }
//         field(25; "External Document No."; Code[20])
//         {
//             Caption = 'External Document No.';
//         }
//         field(26; "VAT Prod. Posting Group"; Code[10])
//         {
//             Caption = 'VAT Prod. Posting Group';
//             TableRelation = "VAT Product Posting Group";
//         }
//         field(27; "Posting Date"; Date)
//         {
//             Caption = 'Posting Date';
//         }
//         field(28; "Source Bank Acc. No."; Code[20])
//         {
//             Caption = 'Source Bank Acc. No.';
//             Description = 'Traspasos bancos - Cta. cte. empresa origen';
//             TableRelation = "Bank Account";
//         }
//         field(29; "Bal. Account No."; Code[20])
//         {
//             Caption = 'Destination Bank Acc. No.';
//             Description = 'Traspasos bancos - Banco empresa destino';

//             trigger OnLookup()
//             var
//                 rBankAccount: Record "Bank Account";
//                 ctTransactionTypeError: Label 'No es posible indicar un Nº banco destino para este tipo de operación';
//                 rGLAccount: Record "G/L Account";
//             begin
//                 //TESTFIELD("Transaction Type","Transaction Type"::"Bank Acc. Transfer");
//                 IF NOT ("Transaction Type" IN ["Transaction Type"::"Bank Acc. Transfer", "Transaction Type"::"Loan Between Companies"]) THEN
//                     ERROR(ctTransactionTypeError);

//                 TESTFIELD("Destination Company Name");
//                 CASE TRUE OF
//                     "Bal. Account Type" = "Account Type"::"G/L Account":
//                         BEGIN
//                             rGLAccount.RESET;
//                             rGLAccount.CHANGECOMPANY("Destination Company Name");
//                             rGLAccount.SETRANGE("Account Type", rGLAccount."Account Type"::Posting);
//                             IF PAGE.RUNMODAL(0, rGLAccount) = ACTION::LookupOK THEN
//                                 VALIDATE("Bal. Account No.", rGLAccount."No.");
//                         END;
//                     "Bal. Account Type" = "Account Type"::"Bank Account":
//                         BEGIN
//                             rBankAccount.RESET;
//                             rBankAccount.CHANGECOMPANY("Destination Company Name");
//                             IF PAGE.RUNMODAL(0, rBankAccount) = ACTION::LookupOK THEN
//                                 VALIDATE("Bal. Account No.", rBankAccount."No.");
//                         END;
//                 END;
//             end;

//             trigger OnValidate()
//             var
//                 ctTransactionTypeError: Label 'No es posible indicar un Nº banco destino para este tipo de operación';
//             begin
//                 //TESTFIELD("Transaction Type","Transaction Type"::"Bank Acc. Transfer");
//                 IF NOT ("Transaction Type" IN ["Transaction Type"::"Bank Acc. Transfer", "Transaction Type"::"Loan Between Companies"]) THEN
//                     ERROR(ctTransactionTypeError);

//                 TESTFIELD("Destination Company Name");
//             end;
//         }
//         field(30; "Source Account Type"; Option)
//         {
//             Caption = 'Source Account Type';
//             Description = 'Mod. S2G (FMR) 16-04-15 Modificación en operación de refacturación';
//             OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
//             OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
//         }
//         field(31; "Source Account No."; Code[20])
//         {
//             Caption = 'Source Account No.';
//             Description = 'Mod. S2G (FMR) 16-04-15 Modificación en operación de refacturación';
//             TableRelation = IF ("Source Account Type" = CONST("G/L Account")) "G/L Account"
//             ELSE IF ("Source Account Type" = CONST(Item)) Item
//             ELSE IF ("Source Account Type" = CONST(Resource)) Resource
//             ELSE IF ("Source Account Type" = CONST("Fixed Asset")) "Fixed Asset"
//             ELSE IF ("Source Account Type" = CONST("Charge (Item)")) "Item Charge";

//             trigger OnValidate()
//             var
//                 rlGLAcc: Record "G/L Account";
//                 rlItem: Record Item;
//                 rlFA: Record "Fixed Asset";
//                 rlRes: Record Resource;
//                 rlCharge: Record "Item Charge";
//             begin
//             end;
//         }
//         field(32; "Source Global Dimension 1 Code"; Code[20])
//         {
//             Caption = 'Source Global Dimension 1 Code';
//             Description = 'Mod. S2G (FMR) 16-04-15 Modificación en operación de refacturación';
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

//             trigger OnLookup()
//             var
//                 rlDimValue: Record "Dimension Value";
//                 flDimValueList: Page "Dimension Value List";
//             begin
//                 rGLSetup.GET;
//                 rGLSetup.TESTFIELD("Global Dimension 1 Code");
//                 TESTFIELD("Destination Company Name");

//                 rlDimValue.RESET;
//                 rlDimValue.CHANGECOMPANY("Destination Company Name");
//                 rlDimValue.SETRANGE("Dimension Code", rGLSetup."Global Dimension 1 Code");
//                 //rlDimValue.SETRANGE("Establishment Company Name","Destination Company Name");
//                 CLEAR(flDimValueList);
//                 //flDimValueList.fSetSkipCompanyFilter;
//                 flDimValueList.LOOKUPMODE(TRUE);
//                 flDimValueList.SETTABLEVIEW(rlDimValue);
//                 IF flDimValueList.RUNMODAL = ACTION::LookupOK THEN BEGIN
//                     flDimValueList.GETRECORD(rlDimValue);
//                     VALIDATE("Global Dimension 1 Code", rlDimValue.Code);
//                 END;
//             end;
//         }
//         field(50000; "Global Dimension 2 Code"; Code[20])
//         {
//             Caption = 'Global Dimension 2 Code';

//             trigger OnLookup()
//             var
//                 rlDimValue: Record "Dimension Value";
//                 flDimValueList: Page "Dimension Value List";
//             begin

//                 rGLSetup.GET;
//                 rGLSetup.TESTFIELD("Global Dimension 2 Code");
//                 TESTFIELD("Destination Company Name");
//                 rlDimValue.RESET;
//                 rGLSetup.CHANGECOMPANY("Destination Company Name");
//                 rGLSetup.GET;
//                 rlDimValue.CHANGECOMPANY("Destination Company Name");
//                 rlDimValue.SETRANGE("Dimension Code", rGLSetup."Global Dimension 2 Code");
//                 IF PAGE.RUNMODAL(0, rlDimValue) = ACTION::LookupOK THEN
//                     VALIDATE("Global Dimension 2 Code", rlDimValue.Code);

//                 /*
//                 rlDimValue.RESET;
//                 rlDimValue.CHANGECOMPANY("Destination Company Name");
//                 rlDimValue.SETRANGE("Dimension Code",rGLSetup."Global Dimension 2 Code");
//                 CLEAR(flDimValueList);
//                 flDimValueList.LOOKUPMODE(TRUE);
//                 flDimValueList.SETTABLEVIEW(rlDimValue);
//                 IF flDimValueList.RUNMODAL = ACTION::LookupOK THEN BEGIN
//                   flDimValueList.GETRECORD(rlDimValue);
//                   VALIDATE("Global Dimension 2 Code",rlDimValue.Code);
//                 END;
//                 */
//             end;

//             trigger OnValidate()
//             var
//                 rlDimValue: Record "Dimension Value";
//             begin

//                 rGLSetup.GET;
//                 rGLSetup.TESTFIELD("Global Dimension 2 Code");
//                 TESTFIELD("Destination Company Name");

//                 rlDimValue.RESET;
//                 rlDimValue.CHANGECOMPANY("Destination Company Name");
//                 rlDimValue.SETRANGE("Dimension Code", rGLSetup."Global Dimension 2 Code");
//                 rlDimValue.SETRANGE(Code, "Global Dimension 2 Code");
//                 rlDimValue.FINDFIRST;
//             end;
//         }
//         field(50001; "Source Description"; Text[50])
//         {
//             Caption = 'Source Description';
//             Editable = false;
//         }
//         field(50200; "Transfer Int-MC"; Boolean)
//         {
//             Description = 'Mod. S2G 08/08/2016 (AAS) : INT-MC';
//         }
//         field(51000; "Código retención IRPF"; Code[20])
//         {
//             Caption = 'Código retención IRPF';
//             Description = 'RET001 - Registro de retenciones';
//         }
//         field(51004; "Código retención garantía"; Code[20])
//         {
//             Caption = 'Código retención garantía';
//             Description = 'RET001 - Registro de retenciones';
//         }
//         field(51009; "Código retención otros"; Code[20])
//         {
//             Caption = 'Código retención otros';
//             Description = 'RET001 - Registro de retenciones';

//             trigger OnValidate()
//             var
//                 vlPorcentaje: Decimal;
//                 vlLibre: Boolean;
//             begin
//             end;
//         }
//         field(51013; "Bal. Account Type"; Option)
//         {
//             Caption = 'Bal. Account Type';
//             Description = 'GF008';
//             OptionCaption = 'G/L Account,,,Bank Account';
//             OptionMembers = "G/L Account",,,"Bank Account";

//             trigger OnValidate()
//             begin
//                 VALIDATE("Bal. Account No.", '');
//             end;
//         }
//     }

//     keys
//     {
//         key(Key1; "Table ID", "Source Doc. Type", "Source Doc. No.", "Source Doc. Subtype", "Source Doc. Line No.", "Line No.")
//         {
//             Clustered = true;
//         }
//         key(Key2; "Buy-from Vendor No.")
//         {
//         }
//         key(Key3; "Sell-to Customer No.")
//         {
//         }
//     }

//     fieldgroups
//     {
//     }

//     trigger OnInsert()
//     begin
//         "User ID" := USERID;
//         "Creation Date/Time" := CURRENTDATETIME;
//     end;

//     var
//         rGLSetup: Record "General Ledger Setup";
//         rCompanyInfo: Record "Company Information";
//         rCust: Record Customer;
//         rVend: Record Vendor;
//         ctSameCompanyError: Label 'You cannot perform this sort of transaction inside same company';
// }
