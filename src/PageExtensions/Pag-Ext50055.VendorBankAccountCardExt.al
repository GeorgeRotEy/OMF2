pageextension 50055 "Vendor Bank Account Card Ext" extends "Vendor Bank Account Card"
{
    // Mod. S2G 27/12/2017 (JGS) : TER-001 Maestro terceros
    //           Nuevo variable para control de ediciones de campos
    //              AllowModify
    //           Modificación en la función
    //              OnAfterGetRecord
    //              OnNextRecord

    trigger OnAfterGetRecord()
    begin
        //Mod. S2G 27/12/2017 (JGS) : TER-001 Maestro terceros.inicio
        IF Rec."Third Party Reference" <> 0 THEN
            AllowModify := FALSE
        ELSE
            AllowModify := TRUE;
        //Mod. S2G 27/12/2017 (JGS) : TER-001 Maestro terceros.fin
    end;

    // trigger OnNextRecord(Steps: Integer): Integer
    trigger OnAfterGetCurrRecord()
    begin
        //Mod. S2G 27/12/2017 (JGS) : TER-001 Maestro terceros.inicio
        RCustomSetup.RESET();
        RCustomSetup.GET();
        IF NOT RCustomSetup."Omite Third Party" THEN
            ERROR(E0001);
        //Mod. S2G 27/12/2017 (JGS) : TER-001 Maestro terceros.fin
    end;

    var
        AllowModify: Boolean;
        RCustomSetup: Record "General Setup";
        E0001: Label 'No esta permitido la creación de nuevos bancos de cliente, debe de realizarse a traves del maestro de terceros';
}
