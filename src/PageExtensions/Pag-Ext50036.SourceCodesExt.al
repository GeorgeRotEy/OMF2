pageextension 50036 "Source Codes Ext" extends "Source Codes"
{
    //ADD-GR-020226
    // (FCO) S2G (CSM) 07/04/2020 : Filtro Código Origen, para excluir Movs Regularización.
    //       - New Function: GetSelectionFilter

    procedure GetSelectionFilter(): Text
    var
        SourceCode: Record "Source Code";
        clEYFunctions: Codeunit "EY Functions";
    begin
        // (FCO) S2G (CSM) 07/04/2020 : begin
        CurrPage.SETSELECTIONFILTER(SourceCode);
        EXIT(clEYFunctions.GetSelectionFilterForSourceCode(SourceCode));
        // (FCO) S2G (CSM) 07/04/2020 : end
    end;
}
