pageextension 50091 "Analysis by Dims Matrix Ext" extends "Analysis by Dimensions Matrix"
{
    // Mod. S2G (CPA) <ANA001> Reparto anal�tico
    //   (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n.
    //       - NEW FUNCTION: LoadFCO
    //       - FUNCTION MODIFY: SetCommonFilters

    //TODO-MIG
    // // (FCO) S2G (CSM) 07/04/2020 : begin
    //     IF SourceCodeFilter <> '' THEN
    //       SETFILTER("Source Code", SourceCodeFilter);
    //     // (FCO) S2G (CSM) 07/04/2020 : end

    //TODO-MIG
    // //Mod. S2G (CPA) <ANA001> Reparto anal�tico.Begin
    //     AnalysisView."Account Source"::"Analytic Distribution Account":
    //       GLAccountSource := FALSE;
    //     //Mod. S2G (CPA) <ANA001> Reparto anal�tico.End

    PROCEDURE LoadFCO(NewSourceCodeFilter: Text);
    BEGIN
        // (FCO) S2G (CSM) 07/04/2020 : begin
        //TODO-MIGSourceCodeFilter := NewSourceCodeFilter;
        // (FCO) S2G (CSM) 07/04/2020 : end
    END;
}
