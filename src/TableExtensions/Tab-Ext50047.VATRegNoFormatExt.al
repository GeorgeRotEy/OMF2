tableextension 50047 "VAT Reg. No. Format Ext" extends "VAT Registration No. Format"
{
    //(CR002) S2G (RBM-R) 29-08-18: Validaci�n de CIF en Terceros

    var
        Text006: Label 'This VAT registration number has already been entered for the following contacts:\ %1', Comment = 'ESP="Este nº reg. IVA se ha introducido ya para los siguientes terceros:\ %1"';

    procedure fCheckThirdParty(VATRegNo: Text[20]; Number: Code[20])
    var
        ThirdParty: Record "Third Party";
        Check: Boolean;
        Finish: Boolean;
        t: Text[250];
    begin
        //(CR002) S2G (RBM-R) 29-08-18: Validación de CIF en Terceros
        Check := TRUE;
        t := '';
        ThirdParty.SETCURRENTKEY("VAT Registration No.");
        ThirdParty.SETRANGE("VAT Registration No.", VATRegNo);
        ThirdParty.SETFILTER("No.", '<>%1', Number);
        IF ThirdParty.FIND('-') THEN BEGIN
            Check := FALSE;
            Finish := FALSE;
            REPEAT
                IF ThirdParty."No." <> Number THEN
                    IF t = '' THEN
                        t := ThirdParty."No."
                    ELSE
                        IF STRLEN(t) + STRLEN(ThirdParty."No.") + 5 <= MAXSTRLEN(t) THEN
                            t := t + ', ' + ThirdParty."No."
                        ELSE BEGIN
                            t := t + '...';
                            Finish := TRUE;
                        END;
            UNTIL (ThirdParty.NEXT() = 0) OR Finish;
        END;
        IF Check = FALSE THEN
            MESSAGE(Text006, t);
    end;

    procedure fCheckAltaTerceros(VATRegNo: Text[20]; Number: Code[20])
    var
        AltaTerceros: Record "Alta Terceros";
        Check: Boolean;
        Finish: Boolean;
        t: Text[250];
    begin
        //(CJ02) S2G (JDT) 28-10-19: Validación de CIF en Alta Terceros
        Check := TRUE;
        t := '';
        AltaTerceros.SETCURRENTKEY("VAT Registration No.");
        AltaTerceros.SETRANGE("VAT Registration No.", VATRegNo);
        AltaTerceros.SETFILTER("No.", '<>%1', Number);
        IF AltaTerceros.FIND('-') THEN BEGIN
            Check := FALSE;
            Finish := FALSE;
            REPEAT
                IF AltaTerceros."No." <> Number THEN
                    IF t = '' THEN
                        t := AltaTerceros."No."
                    ELSE
                        IF STRLEN(t) + STRLEN(AltaTerceros."No.") + 5 <= MAXSTRLEN(t) THEN
                            t := t + ', ' + AltaTerceros."No."
                        ELSE BEGIN
                            t := t + '...';
                            Finish := TRUE;
                        END;
            UNTIL (AltaTerceros.NEXT() = 0) OR Finish;
        END;
        IF Check = FALSE THEN
            MESSAGE(Text006, t);
    end;
}
