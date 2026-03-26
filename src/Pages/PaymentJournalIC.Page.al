//Intercompany
// page 50035 "Payment Journal IC"
// {
//     AutoSplitKey = true;
//     Caption = 'Intercompany Payment Journal';
//     DataCaptionExpression = Rec.DataCaption;
//     PageType = Worksheet;
//     PromotedActionCategories = 'New,Process,Report,Bank,Prepare,Approve';
//     SaveValues = true;
//     SourceTable = "Gen. Journal Line";
//     ApplicationArea = All;

//     layout
//     {
//         area(content)
//         {
//             field(CurrentJnlBatchName; CurrentJnlBatchName)
//             {
//                 Caption = 'Batch Name';
//                 Lookup = true;

//                 trigger OnLookup(var Text: Text): Boolean
//                 begin
//                     CurrPage.SAVERECORD;
//                     GenJnlManagement.LookupName(CurrentJnlBatchName, Rec);
//                     CurrPage.UPDATE(FALSE);
//                 end;

//                 trigger OnValidate()
//                 begin
//                     GenJnlManagement.CheckName(CurrentJnlBatchName, Rec);
//                     CurrentJnlBatchNameOnAfterVali;
//                 end;
//             }
//             repeater(repeater)
//             {
//                 field("Posting date"; Rec."Posting date")
//                 {
//                     Style = Attention;
//                     StyleExpr = HasPmtFileErr;
//                 }
//                 field("Transaction No."; Rec."Transaction No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Document Date"; Rec."Document Date")
//                 {
//                     Style = Attention;
//                     StyleExpr = HasPmtFileErr;
//                     Visible = false;
//                 }
//                 field("Document Type"; Rec."Document Type")
//                 {
//                     Style = Attention;
//                     StyleExpr = HasPmtFileErr;
//                 }
//                 field("Document No."; Rec."Document No.")
//                 {
//                     Style = Attention;
//                     StyleExpr = HasPmtFileErr;
//                 }
//                 field("Bill No."; Rec."Bill No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Incoming Document Entry No."; Rec."Incoming Document Entry No.")
//                 {
//                     Visible = false;

//                     trigger OnAssistEdit()
//                     begin
//                         IF Rec."Incoming Document Entry No." > 0 THEN
//                             HYPERLINK(Rec.GetIncomingDocumentURL);
//                     end;
//                 }
//                 field("External Document No."; Rec."External Document No.")
//                 {
//                 }
//                 field("Applies-to Ext. Doc. No."; Rec."Applies-to Ext. Doc. No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Tipo Movimiento"; Rec."Tipo Movimiento")
//                 {
//                     trigger OnValidate()
//                     begin
//                         Rec.VALIDATE("Account Type", "Tipo Movimiento");
//                     end;
//                 }
//                 field("Account Type"; Rec."Account Type")
//                 {
//                     Visible = false;

//                     trigger OnValidate()
//                     begin
//                         GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
//                     end;
//                 }
//                 field("Account No."; Rec."Account No.")
//                 {
//                     ShowMandatory = true;
//                     Style = Attention;
//                     StyleExpr = HasPmtFileErr;

//                     trigger OnValidate()
//                     begin
//                         GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
//                         Rec.ShowShortcutDimCode(ShortcutDimCode);
//                     end;
//                 }
//                 field("Recipient Bank Account"; Rec."Recipient Bank Account")
//                 {
//                     ShowMandatory = true;
//                     Visible = false;
//                 }
//                 field("Message to Recipient"; Rec."Message to Recipient")
//                 {
//                     Visible = false;
//                 }
//                 field(Description; Rec.Description)
//                 {
//                     Style = Attention;
//                     StyleExpr = HasPmtFileErr;
//                 }
//                 field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Campaign No."; Rec."Campaign No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Currency Code"; Rec."Currency Code")
//                 {
//                     AssistEdit = true;
//                     Visible = false;

//                     trigger OnAssistEdit()
//                     begin
//                         ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
//                         IF ChangeExchangeRate.RUNMODAL() = ACTION::OK THEN
//                             Rec.VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);

//                         CLEAR(ChangeExchangeRate);
//                     end;
//                 }
//                 field("Debit Amount"; Rec."Debit Amount")
//                 {
//                 }
//                 field("Credit Amount"; Rec."Credit Amount")
//                 {
//                 }
//                 field("Payment Method Code"; Rec."Payment Method Code")
//                 {
//                     ShowMandatory = true;
//                     Visible = false;
//                 }
//                 field("Payment Reference"; Rec."Payment Reference")
//                 {
//                     Visible = false;
//                 }
//                 field("Creditor No."; Rec."Creditor No.")
//                 {
//                     Visible = false;
//                 }
//                 field(Amount; Rec.Amount)
//                 {
//                     ShowMandatory = true;
//                     Style = Attention;
//                     StyleExpr = HasPmtFileErr;
//                     Visible = false;
//                 }
//                 field("Tipo Contrapartida"; Rec."Tipo Contrapartida")
//                 {
//                     trigger OnValidate()
//                     begin
//                         Rec.VALIDATE("Bal. Account Type", Rec."Tipo Contrapartida");
//                     end;
//                 }
//                 field("Bal. Account Type"; Rec."Bal. Account Type")
//                 {
//                     Visible = false;
//                 }
//                 field("Bal. Account No."; Rec."Bal. Account No.")
//                 {
//                     trigger OnValidate()
//                     begin
//                         GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
//                         Rec.ShowShortcutDimCode(ShortcutDimCode);
//                     end;
//                 }
//                 field("Destination Company Name"; Rec."Destination Company Name")
//                 {
//                 }
//                 field("Bal. Gen. Posting Type"; Rec."Bal. Gen. Posting Type")
//                 {
//                     Visible = false;
//                 }
//                 field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
//                 {
//                     Visible = true;
//                 }
//                 field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
//                 {
//                     Visible = true;
//                 }
//                 field(ShortcutDimCode3; ShortcutDimCode[3])
//                 {
//                     CaptionClass = '1,2,3';
//                     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
//                                                                   "Dimension Value Type" = CONST(Standard),
//                                                                   Blocked = CONST(false));
//                     Visible = false;

//                     trigger OnValidate()
//                     begin
//                         Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
//                     end;
//                 }
//                 field(ShortcutDimCode4; ShortcutDimCode[4])
//                 {
//                     CaptionClass = '1,2,4';
//                     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
//                                                                   "Dimension Value Type" = CONST(Standard),
//                                                                   Blocked = CONST(false));
//                     Visible = false;

//                     trigger OnValidate()
//                     begin
//                         Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
//                     end;
//                 }
//                 field(ShortcutDimCode5; ShortcutDimCode[5])
//                 {
//                     CaptionClass = '1,2,5';
//                     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
//                                                                   "Dimension Value Type" = CONST(Standard),
//                                                                   Blocked = CONST(false));
//                     Visible = false;

//                     trigger OnValidate()
//                     begin
//                         Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
//                     end;
//                 }
//                 field(ShortcutDimCode6; ShortcutDimCode[6])
//                 {
//                     CaptionClass = '1,2,6';
//                     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
//                                                                   "Dimension Value Type" = CONST(Standard),
//                                                                   Blocked = CONST(false));
//                     Visible = false;

//                     trigger OnValidate()
//                     begin
//                         Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
//                     end;
//                 }
//                 field(ShortcutDimCode7; ShortcutDimCode[7])
//                 {
//                     CaptionClass = '1,2,7';
//                     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
//                                                                   "Dimension Value Type" = CONST(Standard),
//                                                                   Blocked = CONST(false));
//                     Visible = false;

//                     trigger OnValidate()
//                     begin
//                         Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
//                     end;
//                 }
//                 field(ShortcutDimCode8; ShortcutDimCode[8])
//                 {
//                     CaptionClass = '1,2,8';
//                     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
//                                                                   "Dimension Value Type" = CONST(Standard),
//                                                                   Blocked = CONST(false));
//                     Visible = false;

//                     trigger OnValidate()
//                     begin
//                         Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
//                     end;
//                 }
//                 field("Payment Terms Code"; Rec."Payment Terms Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Applied (Yes/No)"; Rec.IsApplied)
//                 {
//                     Caption = 'Applied (Yes/No)';
//                     Visible = false;
//                 }
//                 field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
//                 {
//                     Visible = false;
//                 }
//                 field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
//                 {
//                     StyleExpr = StyleTxt;
//                     Visible = false;
//                 }
//                 field("Applies-to Bill No."; Rec."Applies-to Bill No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Applies-to ID"; Rec."Applies-to ID")
//                 {
//                     StyleExpr = StyleTxt;
//                     Visible = false;
//                 }
//                 field(GetAppliesToDocDueDate; Rec.GetAppliesToDocDueDate)
//                 {
//                     Caption = 'Applies-to Doc. Due Date';
//                     StyleExpr = StyleTxt;
//                     Visible = false;
//                 }
//                 field("Bank Payment Type"; Rec."Bank Payment Type")
//                 {
//                     Visible = false;
//                 }
//                 field("Payment Type"; Rec."Payment Type")
//                 {
//                     Visible = false;
//                 }
//                 field("Statistical Code"; Rec."Statistical Code")
//                 {
//                     Visible = false;
//                 }
//                 field("Check Printed"; Rec."Check Printed")
//                 {
//                     Visible = false;
//                 }
//                 field("Reason Code"; Rec."Reason Code")
//                 {
//                     Visible = false;
//                 }
//                 field(Comment; Rec.Comment)
//                 {
//                     Visible = false;
//                 }
//                 field("Exported to Payment File"; Rec."Exported to Payment File")
//                 {
//                     Visible = false;
//                 }
//                 field(TotalExportedAmount; Rec.TotalExportedAmount)
//                 {
//                     Caption = 'Total Exported Amount';
//                     DrillDown = true;
//                     Visible = false;

//                     trigger OnDrillDown()
//                     begin
//                         Rec.DrillDownExportedAmount
//                     end;
//                 }
//                 field("Has Payment Export Error"; Rec."Has Payment Export Error")
//                 {
//                     Visible = false;
//                 }
//             }
//             group(Group)
//             {
//                 fixed(fixed1)
//                 {
//                     group(group1)
//                     {
//                         field(OverdueWarningText; OverdueWarningText)
//                         {
//                             Style = Unfavorable;
//                             StyleExpr = TRUE;
//                         }
//                     }
//                 }
//                 fixed(fixed2)
//                 {
//                     group("Account Name")
//                     {
//                         Caption = 'Account Name';
//                         field(AccName; AccName)
//                         {
//                             Editable = false;
//                         }
//                     }
//                     group("Bal. Account Name")
//                     {
//                         Caption = 'Bal. Account Name';
//                         field(BalAccName; BalAccName)
//                         {
//                             Caption = 'Bal. Account Name';
//                             Editable = false;
//                         }
//                     }
//                     group(BalanceGroup)
//                     {
//                         Caption = 'Balance';
//                         field(Balance; Balance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
//                         {
//                             AutoFormatType = 1;
//                             Caption = 'Balance';
//                             Editable = false;
//                             Visible = BalanceVisible;
//                         }
//                     }
//                     group(TotalBalanceGroup)
//                     {
//                         Caption = 'Total Balance';
//                         field(TotalBalance; TotalBalance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
//                         {
//                             AutoFormatType = 1;
//                             Caption = 'Total Balance';
//                             Editable = false;
//                             Visible = TotalBalanceVisible;
//                         }
//                     }
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
//             {
//                 ShowFilter = false;
//             }
//             part("Payment File Errors"; "Payment Journal Errors Part")
//             {
//                 Caption = 'Payment File Errors';
//                 SubPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
//                               "Journal Batch Name" = FIELD("Journal Batch Name"),
//                               "Journal Line No." = FIELD("Line No.");
//             }
//             part("Dimension Set Entries FactBox"; "Dimension Set Entries FactBox")
//             {
//                 SubPageLink = "Dimension Set ID" = FIELD("Dimension Set ID");
//                 Visible = false;
//             }
//             part(WorkflowStatusBatch; "Workflow Status FactBox")
//             {
//                 Caption = 'Batch Workflows';
//                 Editable = false;
//                 Enabled = false;
//                 ShowFilter = false;
//                 Visible = ShowWorkflowStatusOnBatch;
//             }
//             part(WorkflowStatusLine; "Workflow Status FactBox")
//             {
//                 Caption = 'Line Workflows';
//                 Editable = false;
//                 Enabled = false;
//                 ShowFilter = false;
//                 Visible = ShowWorkflowStatusOnLine;
//             }
//             systempart(Links; Links)
//             {
//                 Visible = false;
//             }
//             systempart(Notes; Notes)
//             {
//                 Visible = false;
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group("&Line")
//             {
//                 Caption = '&Line';
//                 Image = Line;
//                 action(Dimensions)
//                 {
//                     AccessByPermission = TableData Dimension = R;
//                     Caption = 'Dimensions';
//                     Image = Dimensions;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     ShortCutKey = 'Shift+Ctrl+D';

//                     trigger OnAction()
//                     begin
//                         Rec.ShowDimensions;
//                         CurrPage.SAVERECORD;
//                     end;
//                 }
//                 action("Intercompany Transaction Lines")
//                 {
//                     Caption = 'Intercompany Transaction Lines';
//                     Image = Intercompany;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     RunObject = Page "Intercompany Transaction Lines";
//                     RunPageLink = "Table ID" = CONST(81),
//                                   "Source Doc. No." = FIELD("Journal Template Name"),
//                                   "Source Doc. Subtype" = FIELD("Journal Batch Name"),
//                                   "Source Doc. Line No." = FIELD("Line No.");
//                     RunPageView = SORTING("Table ID", "Source Doc. Type", "Source Doc. No.", "Source Doc. Subtype", "Source Doc. Line No.", "Line No.");

//                     trigger OnAction()
//                     begin
//                         PageIntercompany.RellenaDatos(Rec.Description, Rec."Destination Company Name", Rec."Posting Date");
//                     end;
//                 }
//             }
//             group("P&osting")
//             {
//                 Caption = 'P&osting';
//                 Image = Post;
//                 action(Post)
//                 {
//                     Caption = 'P&ost';
//                     Image = PostOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F9';

//                     trigger OnAction()
//                     begin
//                         CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", Rec);
//                         CurrentJnlBatchName := Rec.GETRANGEMAX("Journal Batch Name");
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action(Preview)
//                 {
//                     Caption = 'Preview Posting';
//                     Image = ViewPostedOrder;

//                     trigger OnAction()
//                     var
//                         GenJnlPost: Codeunit "Gen. Jnl.-Post";
//                     begin
//                         GenJnlPost.Preview(Rec);
//                     end;
//                 }
//                 action("Post and &Print")
//                 {
//                     Caption = 'Post and &Print';
//                     Image = PostPrint;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+F9';

//                     trigger OnAction()
//                     begin
//                         CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print", Rec);
//                         CurrentJnlBatchName := Rec.GETRANGEMAX("Journal Batch Name");
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action(CommentAction)
//                 {
//                     Caption = 'Comments';
//                     Image = ViewComments;
//                     Promoted = true;
//                     PromotedCategory = Category6;
//                     RunObject = Page "Approval Comments";
//                     RunPageLink = "Table ID" = CONST(81),
//                                   "Document Type" = FIELD("Document Type"),
//                                   "Document No." = FIELD("Document No.");
//                     Visible = OpenApprovalEntriesExistForCurrUser;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetCurrRecord()
//     var
//         GenJournalBatch: Record "Gen. Journal Batch";
//     begin

//         StyleTxt := Rec.GetOverdueDateInteractions(OverdueWarningText);
//         GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
//         UpdateBalance;
//         CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

//         IF GenJournalBatch.GET(Rec."Journal Template Name", Rec."Journal Batch Name") THEN
//             ShowWorkflowStatusOnBatch := CurrPage.WorkflowStatusBatch.PAGE.SetFilterOnWorkflowRecord(GenJournalBatch.RECORDID);
//         ShowWorkflowStatusOnLine := CurrPage.WorkflowStatusLine.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);
//     end;

//     trigger OnAfterGetRecord()
//     begin

//         StyleTxt := Rec.GetOverdueDateInteractions(OverdueWarningText);
//         Rec.ShowShortcutDimCode(ShortcutDimCode);
//         HasPmtFileErr := Rec.HasPaymentFileErrors;
//         SetControlAppearance;

//         //
//         Rec."Intercompany Transaction" := TRUE;
//         //
//         Rec."Document Type" := Rec."Document Type"::" ";
//         Rec."Gen. Bus. Posting Group" := '';
//         Rec."Gen. Prod. Posting Group" := '';
//         Rec."VAT Bus. Posting Group" := '';
//         Rec."VAT Prod. Posting Group" := '';
//         Rec."Bal. Gen. Bus. Posting Group" := '';
//         Rec."Bal. Gen. Prod. Posting Group" := '';
//         Rec."Bal. VAT Bus. Posting Group" := '';
//         Rec."Bal. VAT Prod. Posting Group" := '';
//         Rec."Account Type" := "Tipo Movimiento";
//         Rec."Bal. Account Type" := "Tipo Contrapartida";
//     end;

//     trigger OnInit()
//     begin
//         TotalBalanceVisible := TRUE;
//         BalanceVisible := TRUE;
//     end;

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     begin
//         //
//         Rec."Intercompany Transaction" := TRUE;
//         //
//     end;

//     trigger OnModifyRecord(): Boolean
//     begin
//         CheckForPmtJnlErrors;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin

//         HasPmtFileErr := FALSE;
//         UpdateBalance;
//         Rec.SetUpNewLine(xRec, Balance, BelowxRec);
//         CLEAR(ShortcutDimCode);

//         //

//         Rec."Intercompany Transaction" := TRUE;
//         //

//         Rec."Gen. Bus. Posting Group" := '';
//         Rec."Gen. Prod. Posting Group" := '';
//         Rec."VAT Bus. Posting Group" := '';
//         Rec."VAT Prod. Posting Group" := '';
//         Rec."Bal. Gen. Bus. Posting Group" := '';
//         Rec."Bal. Gen. Prod. Posting Group" := '';
//         Rec."Bal. VAT Bus. Posting Group" := '';
//         Rec."Bal. VAT Prod. Posting Group" := '';
//         Rec."Document Type" := Rec."Document Type"::" ";
//         Rec."Account Type" := "Tipo Movimiento";
//         Rec."Bal. Account Type" := "Tipo Contrapartida";
//     end;

//     trigger OnOpenPage()
//     var
//         JnlSelected: Boolean;
//     begin
//         BalAccName := '';

//         IF Rec.IsOpenedFromBatch THEN BEGIN
//             CurrentJnlBatchName := Rec."Journal Batch Name";
//             GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
//             SetControlAppearance;
//             EXIT;
//         END;
//         GenJnlManagement.TemplateSelection(PAGE::"Payment Journal", 4, FALSE, Rec, JnlSelected);
//         IF NOT JnlSelected THEN
//             ERROR('');
//         GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
//         SetControlAppearance;

//         Rec."Account Type" := "Tipo Movimiento";
//         Rec."Bal. Account Type" := "Tipo Contrapartida";
//     end;

//     var
//         Text000Lbl: Label 'Void Check %1?';
//         Text001Lbl: Label 'Void all printed checks?';
//         GenJnlLine: Record "Gen. Journal Line";
//         GenJnlLine2: Record "Gen. Journal Line";
//         GenJnlManagement: Codeunit GenJnlManagement;
//         ReportPrint: Codeunit "Test Report-Print";
//         DocPrint: Codeunit "Document-Print";
//         CheckManagement: Codeunit CheckManagement;
//         GLReconcile: Page Reconciliation;
//         ChangeExchangeRate: Page "Change Exchange Rate";
//         CurrentJnlBatchName: Code[10];
//         AccName: Text[50];
//         BalAccName: Text[50];
//         Balance: Decimal;
//         TotalBalance: Decimal;
//         ShowBalance: Boolean;
//         ShowTotalBalance: Boolean;
//         HasPmtFileErr: Boolean;
//         ShortcutDimCode: array[8] of Code[20];
//         BalanceVisible: Boolean;
//         TotalBalanceVisible: Boolean;
//         StyleTxt: Text;
//         OverdueWarningText: Text;
//         OpenApprovalEntriesExistForCurrUser: Boolean;
//         OpenApprovalEntriesOnJnlBatchExist: Boolean;
//         OpenApprovalEntriesOnJnlLineExist: Boolean;
//         OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
//         OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
//         ShowWorkflowStatusOnBatch: Boolean;
//         ShowWorkflowStatusOnLine: Boolean;
//         "Tipo Contrapartida": Option ,,,Banco;
//         "Tipo Movimiento": Option Cuenta,,,Banco;
//         PageIntercompany: Page "Intercompany Transaction Lines";

//     local procedure CheckForPmtJnlErrors()
//     var
//         BankAccount: Record "Bank Account";
//         BankExportImportSetup: Record "Bank Export/Import Setup";
//     begin
//         IF HasPmtFileErr THEN
//             IF (Rec."Bal. Account Type" = Rec."Bal. Account Type"::"Bank Account") AND BankAccount.GET(Rec."Bal. Account No.") THEN
//                 IF BankExportImportSetup.GET(BankAccount."Payment Export Format") THEN
//                     IF BankExportImportSetup."Check Export Codeunit" > 0 THEN
//                         CODEUNIT.RUN(BankExportImportSetup."Check Export Codeunit", Rec);
//     end;

//     local procedure UpdateBalance()
//     begin
//         GenJnlManagement.CalcBalance(
//           Rec, xRec, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
//         BalanceVisible := ShowBalance;
//         TotalBalanceVisible := ShowTotalBalance;
//     end;

//     local procedure CurrentJnlBatchNameOnAfterVali()
//     begin
//         CurrPage.SAVERECORD;
//         GenJnlManagement.SetName(CurrentJnlBatchName, Rec);
//         CurrPage.UPDATE(FALSE);
//     end;

//     local procedure GetCurrentlySelectedLines(var GenJournalLine: Record "Gen. Journal Line"): Boolean
//     begin
//         CurrPage.SETSELECTIONFILTER(GenJournalLine);
//         EXIT(GenJournalLine.FINDSET);
//     end;

//     local procedure SetControlAppearance()
//     var
//         GenJournalBatch: Record "Gen. Journal Batch";
//         ApprovalsMgmt: Codeunit 1535;
//     begin
//         IF GenJournalBatch.GET(Rec."Journal Template Name", Rec."Journal Batch Name") THEN;
//         OpenApprovalEntriesExistForCurrUser :=
//           ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(GenJournalBatch.RECORDID) OR
//           ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);

//         OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(GenJournalBatch.RECORDID);
//         OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
//         OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist OR OpenApprovalEntriesOnJnlLineExist;

//         OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
//           OpenApprovalEntriesOnJnlBatchExist OR
//           ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries(Rec."Journal Template Name", Rec."Journal Batch Name");
//     end;

//     procedure RellenaDatos(var empresaorigen: Text[50]; var empresadestino: Text[50]; var fecharegistro: Date; Linea: Integer; var Transaccion: Option "Sales Invoicing","Purchase Reinvoicing","Bank Acc. Transfer","Other Company Payment","Loan Between Companies")
//     begin
//         /*
//         GenJnlLine.RESET();
//         GenJnlLine.SETRANGE("Journal Template Name",'PAGOS');
//         GenJnlLine.SETRANGE(GenJnlLine."Intercompany Transaction",GenJnlLine."Intercompany Transaction"::"1");
//         GenJnlLine.SETRANGE("Line No.",Linea);
//         IF GenJnlLine.FINDFIRST() THEN BEGIN
//           empresaorigen:=COMPANYNAME;
//           empresadestino:=GenJnlLine."Destination Company Name";
//           fecharegistro:=GenJnlLine."Posting Date";
//           IF GenJnlLine."Account Type"=GenJnlLine."Account Type"::"G/L Account" THEN
//             Transaccion:=Transaccion::"Loan Between Companies"
//           ELSE
//             Transaccion:=Transaccion::"Bank Acc. Transfer";
//         END;
//         */
//     end;
// }
