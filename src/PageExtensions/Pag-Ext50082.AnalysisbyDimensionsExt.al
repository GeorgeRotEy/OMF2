//TODO-MIG
// pageextension 50082 "Analysis by Dimensions Ext" extends "Analysis by Dimensions"
// {
//     // Mod. S2G (CPA) <ANA001> Reparto anal�tico
//     //   (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n.
//     //       - NEW VBLE: SourceCodeFilter
//     //       - Mostrar esa vble.  C�digo OnValidate y OnLookup.

//     //TODO-MIG
//     // //Mod. S2G (CPA) <ANA001> Reparto anal�tico.Begin
//     // ELSE IF DistrAccountSource THEN
//     //                LineDimCode := DistrAcc.TABLECAPTION
//     //              //Mod. S2G (CPA) <ANA001> Reparto anal�tico.end

//     //TODO-MIG
//     // // (FCO) S2G (CSM) 07/04/2020 : begin
//     //                              MatrixForm.LoadFCO(SourceCodeFilter);
//     //                              // (FCO) S2G (CSM) 07/04/2020 : end

//     //TODO-MIG
//     // //Mod. S2G (CPA) <ANA001> Reparto anal�tico.Begin
//     //                        END ELSE IF DistrAccountSource THEN BEGIN
//     //                          DistrAccList.LOOKUPMODE(TRUE);
//     //                          IF NOT (DistrAccList.RUNMODAL() = ACTION::LookupOK) THEN
//     //                            EXIT(FALSE);

//     //                          Text := DistrAccList.GetSelectionFilter;
//     //Mod. S2G (CPA) <ANA001> Reparto anal�tico.End

//     //TODO-MIG
//     //Código de ValidateAnalysisViewCode

//     //TODO-MIG
//     //Código de GetAccountCaption
//     layout
//     {
//         addafter(Dim4Filter)
//         {
//             field(SourceCodeFilter; SourceCodeFilter)
//             {
//                 Caption = 'Source Code Filter';
//                 ApplicationArea = All;

//                 trigger OnLookup(var Text: Text): Boolean
//                 var
//                     SourceCodes: Page "Source Codes";
//                 begin
//                     // (FCO) S2G (CSM) 07/04/2020 : begin
//                     SourceCodes.LOOKUPMODE(TRUE);
//                     IF NOT (SourceCodes.RUNMODAL() = ACTION::LookupOK) THEN
//                         EXIT(FALSE);

//                     Text := SourceCodes.GetSelectionFilter;
//                     SourceCodeFilter := Text;
//                     Rec.SETFILTER("Source Code Filter", Text);
//                     Rec."Source Code Filter" := Rec.GETFILTER("Source Code Filter");
//                     // (FCO) S2G (CSM) 07/04/2020 : end
//                 end;

//                 trigger OnValidate()
//                 var
//                     GLAcc: Record "G/L Account";
//                 begin
//                     // (FCO) S2G (CSM) 07/04/2020 : begin.
//                     IF SourceCodeFilter = '' THEN
//                         Rec.SETRANGE("Source Code Filter")
//                     ELSE BEGIN
//                         Rec.SETFILTER("Source Code Filter", SourceCodeFilter);
//                         Rec."Source Code Filter" := Rec.GETFILTER("Source Code Filter");
//                     END;
//                     CurrPage.UPDATE;
//                     // (FCO) S2G (CSM) 07/04/2020 : end.
//                 end;
//             }
//         }
//     }
//     actions
//     {
//         addafter("Next Set")
//         {
//             action("Linea Etapa")
//             {
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     LineDimCode := 'ETAPA';
//                     IF (UPPERCASE(LineDimCode) = UPPERCASE(ColumnDimCode)) AND (LineDimCode <> '') THEN BEGIN
//                         ColumnDimCode := '';
//                         ValidateColumnDimCode;
//                     END;
//                     ValidateLineDimCode;
//                     IF LineDimOption = LineDimOption::Period THEN
//                         SETCURRENTKEY("Period Start")
//                     ELSE
//                         SETCURRENTKEY(Code);
//                     CurrPage.UPDATE;

//                     ColumnDimCode := 'ACTIVIDAD';
//                     IF (UPPERCASE(LineDimCode) = UPPERCASE(ColumnDimCode)) AND (LineDimCode <> '') THEN BEGIN
//                         LineDimCode := '';
//                         ValidateLineDimCode;
//                     END;
//                     ValidateColumnDimCode;

//                     CurrPage.UPDATE;
//                     CreateCaptionSet(Rec, Step::First, 32, PrimaryKeyFirstColInSet, ColumnCaptions, ColumnsSet);
//                 end;
//             }
//             action("Linea Cuenta")
//             {
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     LineDimCode := 'Cuenta';
//                     IF (UPPERCASE(LineDimCode) = UPPERCASE(ColumnDimCode)) AND (LineDimCode <> '') THEN BEGIN
//                         ColumnDimCode := '';
//                         ValidateColumnDimCode;
//                     END;
//                     ValidateLineDimCode;
//                     IF LineDimOption = LineDimOption::Period THEN
//                         SETCURRENTKEY("Period Start")
//                     ELSE
//                         SETCURRENTKEY(Code);
//                     CurrPage.UPDATE;

//                     ColumnDimCode := 'ACTIVIDAD';
//                     IF (UPPERCASE(LineDimCode) = UPPERCASE(ColumnDimCode)) AND (LineDimCode <> '') THEN BEGIN
//                         LineDimCode := '';
//                         ValidateLineDimCode;
//                     END;
//                     ValidateColumnDimCode;

//                     CurrPage.UPDATE;
//                     CreateCaptionSet(Rec, Step::First, 32, PrimaryKeyFirstColInSet, ColumnCaptions, ColumnsSet);
//                 end;
//             }
//         }
//     }

//     var
//         DistrAccountSource: Boolean;
//         BusUnitSource: Boolean;
//         SourceCodeFilter: Text;
// }
