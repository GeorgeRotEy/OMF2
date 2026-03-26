pageextension 50029 "G/L Account List Ext" extends "G/L Account List"
{
    // Mod. S2G 10/02/2018 (JGS) : Modificacion permisos colegios.

    trigger OnOpenPage()
    begin
        // Mod. S2G 10/02/2018 (JGS) : Modificacion permisos colegios.begin
        IF UserSetup.GET(USERID) THEN
            IF NOT UserSetup."Advance Chart Colegio" THEN BEGIN
                Rec.FILTERGROUP(2);
                //Rec.SETFILTER("No.",'<>%1&<>%2&<>%3&<>%4&<>%5&<>%6&<>%7&<>%8&<>%9','6050001','6051001','6052001','6053001','6054001','6055001','6056001','6057001','6059001');
                Rec.SETFILTER("No.", '<>%1', '605*');
                Rec.FILTERGROUP(0);
            END;
        // Mod. S2G 10/02/2018 (JGS) : Modificacion permisos colegios.end
    end;

    var
        UserSetup: Record "User Setup";
}
