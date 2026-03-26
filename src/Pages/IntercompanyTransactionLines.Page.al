//Intercompany
// page 50017 "Intercompany Transaction Lines"
// {
//     // Mod. S2G (FMR) 20-04-15 Modificación en operación de refacturación
//     //                         Código
//     //                           OnNewRecord

//     AutoSplitKey = true;
//     Caption = 'Intercompany Transaction Lines';
//     DelayedInsert = true;
//     PageType = List;
//     SourceTable = "Intercompany Transaction Line";
//     ApplicationArea = All;

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("Transaction Type"; Rec."Transaction Type")
//                 {
//                     Visible = false;
//                 }
//                 field("Source Company Name"; Rec."Source Company Name")
//                 {
//                     Editable = false;
//                 }
//                 field("Destination Company Name"; Rec."Destination Company Name")
//                 {
//                     Editable = false;
//                 }
//                 field("Source Description"; Rec."Source Description")
//                 {
//                     Visible = false;
//                 }
//                 field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
//                 {
//                     Visible = false;
//                 }
//                 field("Source Bank Acc. No."; Rec."Source Bank Acc. No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Sell-to Customer No."; Rec."Sell-to Customer No.")
//                 {
//                     Visible = false;
//                 }
//                 field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
//                 {
//                     Visible = false;
//                 }
//                 field("Tipo Movimiento"; Rec."Account Type")
//                 {
//                     trigger OnValidate()
//                     begin
//                         //VALIDATE("Account Type","Tipo Movimiento");
//                     end;
//                 }
//                 field("Account No."; Rec."Account No.")
//                 {
//                 }
//                 field("Account Name"; Rec."Account Name")
//                 {
//                     Caption = 'Description';
//                 }
//                 field("Tipo Contrapartida"; Rec."Bal. Account Type")
//                 {
//                     trigger OnValidate()
//                     begin
//                         //VALIDATE("Bal. Account Type","Tipo Contrapartida");
//                     end;
//                 }
//                 field("Bal. Account No."; Rec."Bal. Account No.")
//                 {
//                 }
//                 field("Posting date"; Rec."Posting date")
//                 {
//                     Visible = false;
//                 }
//                 field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
//                 {
//                     Visible = NOT bICGenJournalLineLoanCompanies;
//                 }
//                 field("Amount %"; Rec."Amount %")
//                 {
//                     Editable = false;
//                 }
//                 field("Proportional Alloc. by Estab."; Rec."Proportional Alloc. by Estab.")
//                 {
//                     Visible = NOT bICGenJournalLine;
//                 }
//                 field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
//                 {
//                 }
//                 field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
//                 {
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             systempart(Links; Links)
//             {
//             }
//             systempart(MyNotes; MyNotes)
//             {
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         //"Destination Company Name":='prueba';
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         //fSetVisibleControlsLoan;
//         //"Destination Company Name":='prueba';
//         //PageDiario.RellenaDatos("Source Company Name","Destination Company Name","Posting Date","Source Doc. Line No.","Transaction Type");
//         //VALIDATE("Amount %",100);
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin

//         /*
//         // Mod. S2G (FMR) 20-04-15 Modificación en operación de refacturación.begin
//         "Source Account Type" := xRec."Source Account Type";
//         "Source Account No." := xRec."Source Account No.";
//         "Source Global Dimension 1 Code" := xRec."Source Global Dimension 1 Code";
//         "Amount %" := xRec."Amount %";
//         //"Proportional Alloc. by Centers" := xRec."Proportional Alloc. by Centers";
//         // Mod. S2G (FMR) 20-04-15 Modificación en operación de refacturación.end
//         */

//         /*
//         PageDiario.RellenaDatos("Source Company Name","Destination Company Name","Posting Date","Source Doc. Line No.","Transaction Type");
//         VALIDATE("Amount %",100);
//         */
//     end;

//     trigger OnOpenPage()
//     begin
//         //fSetVisibleControls;
//         //fSetVisibleControlsLoan;
//         Rec.VALIDATE("Amount %", 100);
//     end;

//     var
//         bICGenJournalLine: Boolean;
//         bICGenJournalLineLoanCompanies: Boolean;
//         rICTransaction: Record "Intercompany Transaction Line";
//         rGenJnl: Record "Gen. Journal Line";
//         N: Integer;
//         "Tipo Contrapartida": Option Cuenta,,,Banco;
//         "Tipo Movimiento": Option Cuenta,,,Banco;
//         PageDiario: Page "Payment Journal IC";

//     procedure fSetVisibleControls()
//     begin
//         bICGenJournalLine := Rec.GETFILTER("Table ID") = '81';
//     end;

//     procedure fSetVisibleControlsLoan()
//     begin
//         //bICGenJournalLineLoanCompanies:= ("Transaction Type" = "Transaction Type"::"Loan Between Companies");
//         Rec."Source Company Name" := xRec."Source Company Name";
//         Rec."Buy-from Vendor No." := xRec."Buy-from Vendor No.";
//         Rec."Buy-from Vendor Name" := xRec."Buy-from Vendor Name";
//         Rec."Account Type" := xRec."Account Type";
//         Rec."Account No." := xRec."Account No.";
//         Rec."Account Name" := xRec."Account Name";
//         Rec."Transaction Type" := xRec."Transaction Type";
//         Rec."Posting Date" := xRec."Posting Date";
//         Rec."VAT Prod. Posting Group" := xRec."VAT Prod. Posting Group";
//     end;

//     procedure RellenaDatos(var empresaorigen: Text[50]; var empresadestino: Text[50]; var fecharegistro: Date)
//     begin
//         Rec."Destination Company Name" := empresadestino;
//         Rec."Source Company Name" := empresaorigen;
//         Rec."Posting Date" := fecharegistro;
//         Rec."Account Type" := "Tipo Movimiento";
//         Rec."Bal. Account Type" := "Tipo Contrapartida";
//         Rec."Amount %" := 100;
//         //MODIFY;
//         //CurrPage.UPDATE;
//     end;
// }
