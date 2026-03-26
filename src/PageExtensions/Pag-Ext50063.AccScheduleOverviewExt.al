pageextension 50063 "Acc. Schedule Overview Ext" extends "Acc. Schedule Overview"
{
    // (FCO) S2G (CSM) 07/04/2020 : Filtro C�digo Origen, para excluir Movs Regularizaci�n.
    //       - NEW VBLE: SourceCodeFilter
    //       - Mostrar esa vble.   OnLookup.  OnValidate
    //       - FUNCTION MODIFY:
    //             . OnOpenPage
    //             . UpdateDimFilterControls
    layout
    {
        modify(CurrentSchedName)
        {
            trigger OnAfterValidate()
            begin
                // (FCO) S2G (CSM) 07/04/2020 : begin
                SourceCodeFilter := '';
                // (FCO) S2G (CSM) 07/04/2020 : end
            end;
        }
        addafter(CostBudgetFilter)
        {
            field(SourceCodeFilter; SourceCodeFilter)
            {
                Caption = 'Source Code Filter';
                ApplicationArea = All;

                trigger OnLookup(var Text: Text): Boolean
                var
                    Result: Boolean;
                begin
                    // (FCO) S2G (CSM) 07/04/2020 : begin.
                    Result := Rec.LookupSourceCodeFilter(Text);
                    IF Result THEN BEGIN
                        Rec.SETFILTER("Source Code Filter", Text);
                        Text := Rec.GETFILTER("Source Code Filter");
                    END;
                    EXIT(Result);
                    // (FCO) S2G (CSM) 07/04/2020 : end.
                end;

                trigger OnValidate()
                begin
                    // (FCO) S2G (CSM) 07/04/2020 : begin.
                    IF SourceCodeFilter = '' THEN
                        Rec.SETRANGE("Source Code Filter")
                    ELSE BEGIN
                        Rec.SETFILTER("Source Code Filter", SourceCodeFilter);
                        Rec."Source Code Filter" := Rec.GETFILTER("Source Code Filter");
                    END;
                    CurrPage.UPDATE;
                    // (FCO) S2G (CSM) 07/04/2020 : end.
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        // (FCO) S2G (CSM) 07/04/2020 : begin
        Rec.SETRANGE("Source Code Filter");
        // (FCO) S2G (CSM) 07/04/2020 : end

        // (FCO) S2G (CSM) 07/04/2020 : begin
        SourceCodeFilter := '';
        // (FCO) S2G (CSM) 07/04/2020 : end

        // (FCO) S2G (CSM) 07/04/2020 : begin
        IF SourceCodeFilter <> '' THEN BEGIN
            Rec.SETFILTER("Source Code Filter", SourceCodeFilter);
            Rec."Source Code Filter" := SourceCodeFilter;
        END;
        // (FCO) S2G (CSM) 07/04/2020 : end
    end;

    var
        SourceCodeFilter: Text;
}
