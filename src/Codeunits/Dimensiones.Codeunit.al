codeunit 50029 Dimensiones
{
    trigger OnRun()
    begin

        Companies.RESET();
        Companies.SETFILTER(Name, 'PRO*|COL*');
        IF Companies.FINDSET() THEN
            REPEAT
                DimensionValue.CHANGECOMPANY(Companies.Name);
                IF DimensionValue.FINDSET() THEN
                    REPEAT
                        // Buscamos por PK (recomiendo PK = Company, Code)
                        DimensionTable.SETRANGE(Company, Companies.Name);
                        DimensionTable.SETRANGE(Code, DimensionValue.Code);
                        IF DimensionTable.FINDSET() THEN BEGIN
                            // Ya existe: actualiza campos susceptibles de cambio
                            DimensionTable.Name := DimensionValue.Name;
                            DimensionTable.MODIFY(TRUE);
                        END ELSE BEGIN
                            // No existe: inserta
                            DimensionTable2.INIT();
                            IF DimensionTable2.FINDLAST() THEN BEGIN
                                DimensionTable2.Id := DimensionTable2.Id + 1;
                                DimensionTable2.Company := Companies.Name;
                                DimensionTable2.Code := DimensionValue.Code;
                                DimensionTable2.Name := DimensionValue.Name;
                                DimensionTable2.INSERT(TRUE);
                            END ELSE BEGIN
                                DimensionTable2.Id := DimensionTable2.Id + 1;
                                DimensionTable2.Company := Companies.Name;
                                DimensionTable2.Code := DimensionValue.Code;
                                DimensionTable2.Name := DimensionValue.Name;
                                DimensionTable2.INSERT(TRUE);
                            END;
                        END;
                    UNTIL DimensionValue.NEXT() = 0;
            UNTIL Companies.NEXT() = 0;
    end;

    var
        DimensionValue: Record "Dimension Value";
        Companies: Record Company;
        DimensionTable: Record DimensionTable;
        DimensionTable2: Record DimensionTable;
}
