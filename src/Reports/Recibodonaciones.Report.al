report 50001 "Recibo donaciones"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Recibodonaciones.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Donation; Donation)
        {
            column(DonationThird; Donation.Third)
            {
            }
            column(Name_ThirdParty; rgThirdParty.Name)
            {
            }
            column(Address_ThirdParty; rgThirdParty.Address)
            {
            }
            column(City_ThirdParty; rgThirdParty.City)
            {
            }
            column(PostCode_ThirdParty; rgThirdParty."Post Code")
            {
            }
            column(County_ThirdParty; rgThirdParty.County)
            {
            }
            column(VATRegistrationNo_ThirdParty; rgThirdParty."VAT Registration No.")
            {
            }
            column(Name_CompanyInfo; rgCompanyInformation.Name)
            {
            }
            column(Name2_CompanyInfo; rgCompanyInformation."Name 2")
            {
            }
            column(Address_CompanyInfo; rgCompanyInformation.Address)
            {
            }
            column(NIF_CompanyInfo; rgCompanyInformation."VAT Registration No.")
            {
            }
            column(City_CompanyInfo; rgCompanyInformation.City)
            {
            }
            column(CP_CompanyInfo; rgCompanyInformation."Post Code")
            {
            }
            column(Postingdate_Donation; Donation."Posting date")
            {
            }
            column(Amount_Donation; Donation.Amount)
            {
            }
            column(RegInterno_Donation; Donation."Registro interno")
            {
                IncludeCaption = true;
            }
            column(Picture; rgCompanyInformation.Picture)
            {
            }
            column(SelloEntidad; rgCompanyInformation.SelloEntidad)
            {
            }
            column(Phone_CompanyInfo; rgCompanyInformation."Phone No.")
            {
            }
            column(County_CompanyInfo; rgCompanyInformation.County)
            {
            }
            column(Letratotal; Letra[1] + Letra[2])
            {
            }
            column(FechaEmision; FechaEmision)
            {
            }

            trigger OnAfterGetRecord()
            begin
                FormatNoText(Letra, Donation.Amount, '');

                IF rgThirdParty.GET(Donation.Third) THEN;
                //rgCompanyInformation.GET();
            end;

            trigger OnPreDataItem()
            begin
                rgCompanyInformation.GET();
                rgCompanyInformation.CALCFIELDS(Picture);
                rgCompanyInformation.CALCFIELDS(SelloEntidad);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field("Fecha Emisión"; FechaEmision)
                {
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF FechaEmision = 0D THEN
            FechaEmision := TODAY;
    end;

    var
        rgThirdParty: Record "Third Party";
        rgCompanyInformation: Record "Company Information";
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        Text1100700: Label '<decimals>';
        Text1100701: Label 'MILLONES ';
        Text1100702: Label 'UN MILLÛN ';
        Text1100703: Label 'MIL ';
        Text1100704: Label 'CIEN ';
        Text1100705: Label 'CIENTO ';
        Text1100706: Label 'DOSCIENTOS ';
        Text1100707: Label 'TRESCIENTOS ';
        Text1100708: Label 'CUATROCIENTOS ';
        Text1100709: Label 'QUINIENTOS ';
        Text1100710: Label 'SEISCIENTOS ';
        Text1100711: Label 'SETECIENTOS ';
        Text1100712: Label 'OCHOCIENTOS ';
        Text1100713: Label 'NOVECIENTOS ';
        Text1100714: Label 'DOSCIENTOS ';
        Text1100715: Label 'TRESCIENTOS ';
        Text1100716: Label 'CUATROCIENTOS ';
        Text1100717: Label 'QUINIENTOS ';
        Text1100718: Label 'SEISCIENTOS ';
        Text1100719: Label 'SETECIENTOS ';
        Text1100720: Label 'OCHOCIENTOS ';
        Text1100721: Label 'NOVECIENTOS ';
        Text1100722: Label 'DIEZ ';
        Text1100723: Label 'ONCE ';
        Text1100724: Label 'DOCE ';
        Text1100725: Label 'TRECE ';
        Text1100726: Label 'CATORCE ';
        Text1100727: Label 'QUINCE ';
        Text1100728: Label 'DIECI';
        Text1100729: Label 'VEINTE ';
        Text1100730: Label 'VEINTI';
        Text1100731: Label 'TREINTA ';
        Text1100732: Label 'TREINTA Y ';
        Text1100733: Label 'CUARENTA ';
        Text1100734: Label 'CUARENTA Y ';
        Text1100735: Label 'CINCUENTA ';
        Text1100736: Label 'CINCUENTA Y ';
        Text1100737: Label 'SESENTA ';
        Text1100738: Label 'SESENTA Y ';
        Text1100739: Label 'SETENTA ';
        Text1100740: Label 'SETENTA Y ';
        Text1100741: Label 'OCHENTA ';
        Text1100742: Label 'OCHENTA Y ';
        Text1100743: Label 'NOVENTA ';
        Text1100744: Label 'NOVENTA Y ';
        Text1100745: Label 'UN ';
        Text1100746: Label 'UNO ';
        Text1100747: Label 'DOS ';
        Text1100748: Label 'TRES ';
        Text1100749: Label 'CUATRO ';
        Text1100750: Label 'CINCO ';
        Text1100751: Label 'SEIS ';
        Text1100752: Label 'SIETE ';
        Text1100753: Label 'OCHO ';
        Text1100754: Label 'NUEVE ';
        Text1100755: Label ' CÉNTIMOS';
        Text1100756: Label ' CÉNTIMOS';
        Text1100757: Label 'MILÉSIMAS';
        Text1100758: Label 'DIEZMILÉSIMAS';
        Text1100759: Label ' CÉNTIMO';
        Text1100760: Label ' CÉNTIMO';
        Text1100761: Label 'MILÉSIMA';
        Text1100762: Label 'DIEZMILÉSIMA';
        Text1100765: Label 'CERO';
        Text1100767: Label 'CON ';
        Text1100768: Label '%1 is too big to be text-formatted';
        HundMilion: Integer;
        Remainder: Integer;
        TenMilion: Integer;
        UnitsMilion: Integer;
        HundThousands: Integer;
        TenThousands: Integer;
        UnitsThousands: Integer;
        Units: Integer;
        DecimalPlaces: Integer;
        Decimals: Integer;
        DecimalString: Text[15];
        DecimalText: array[2] of Text[80];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        Letra: array[2] of Text[80];
        FechaEmision: Date;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        Tens: Integer;
        Hundreds: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF No > 999999999 THEN
            ERROR(Text1100768, No);

        IF ROUND(No, 1, '<') = 0 THEN
            AddToNoText(NoText, NoTextIndex, Text1100765);

        HundMilion := ROUND(No, 1, '<') DIV 100000000;
        Remainder := ROUND(No, 1, '<') MOD 100000000;
        TenMilion := Remainder DIV 10000000;
        Remainder := Remainder MOD 10000000;
        UnitsMilion := Remainder DIV 1000000;
        Remainder := Remainder MOD 1000000;
        HundThousands := Remainder DIV 100000;
        Remainder := Remainder MOD 100000;
        TenThousands := Remainder DIV 10000;
        Remainder := Remainder MOD 10000;
        UnitsThousands := Remainder DIV 1000;
        Remainder := Remainder MOD 1000;
        Hundreds := Remainder DIV 100;
        Remainder := Remainder MOD 100;
        Tens := Remainder DIV 10;
        Units := Remainder MOD 10;
        DecimalPlaces := STRLEN(FORMAT(No, 0, Text1100700));
        IF DecimalPlaces > 0 THEN BEGIN
            DecimalPlaces := DecimalPlaces - 1;
            Decimals := (No - ROUND(No, 1, '<')) * POWER(10, DecimalPlaces);
            IF DecimalPlaces = 1 THEN
                Decimals := Decimals * 10;
            DecimalString := TextNoDecimals(DecimalPlaces);
        END;

        AddToNoText(NoText, NoTextIndex, TextHundMilion(HundMilion, TenMilion, UnitsMilion, TRUE));
        AddToNoText(NoText, NoTextIndex, TextTenUnitsMilion(HundMilion, TenMilion, UnitsMilion, TRUE));
        AddToNoText(NoText, NoTextIndex, TextHundThousands(HundThousands, TenThousands, UnitsThousands, FALSE));
        AddToNoText(NoText, NoTextIndex, TextTenUnitsThousands(HundThousands, TenThousands, UnitsThousands, FALSE));
        AddToNoText(NoText, NoTextIndex, TextHundreds(Hundreds, Tens, Units, FALSE));
        AddToNoText(NoText, NoTextIndex, TextTensUnits(Tens, Units, FALSE));
        IF DecimalPlaces > 0 THEN BEGIN
            FormatNoText(DecimalText, Decimals, CurrencyCode);
            AddToNoText(
                    NoText, NoTextIndex, Text1100767 + DecimalText[1] + DecimalString);
        END;
        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; AddText: Text[80])
    var
        Text1100764: Label '%1 \results in a written number which is too long.';
    begin
        WHILE STRLEN(NoText[NoTextIndex] + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text1100764, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + AddText, '<');
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    procedure TextHundMilion(Hundreds: Integer; Ten: Integer; Units: Integer; Masc: Boolean): Text[250]
    begin
        IF Hundreds <> 0 THEN
            EXIT(TextHundreds(Hundreds, Ten, Units, TRUE));
    end;

    procedure TextTenUnitsMilion(Hundreds: Integer; Ten: Integer; Units: Integer; Masc: Boolean): Text[250]
    begin
        IF (Hundreds <> 0) AND (Ten = 0) AND (Units = 0) THEN
            EXIT(Text1100701);
        IF (Hundreds = 0) AND (Ten = 0) AND (Units = 1) THEN
            EXIT(Text1100702);
        IF (Ten <> 0) OR (Units <> 0) THEN
            EXIT(TextTensUnits(Ten, Units, Masc) + Text1100701);
    end;

    procedure TextHundThousands(Hundreds: Integer; Ten: Integer; Units: Integer; Masc: Boolean): Text[250]
    begin
        IF Hundreds <> 0 THEN
            EXIT(TextHundreds(Hundreds, Ten, Units, Masc))
    end;

    procedure TextTenUnitsThousands(Hundreds: Integer; Ten: Integer; Units: Integer; Masc: Boolean): Text[250]
    begin
        IF (Hundreds <> 0) AND (Ten = 0) AND (Units = 0) THEN
            EXIT(Text1100703);
        IF (Hundreds = 0) AND (Ten = 0) AND (Units = 1) THEN
            EXIT(Text1100703);
        IF (Ten <> 0) OR (Units <> 0) THEN
            EXIT(TextTensUnits(Ten, Units, Masc) + Text1100703);
    end;

    procedure TextHundreds(Hundreds: Integer; Tens: Integer; Units: Integer; Masc: Boolean): Text[250]
    begin
        IF Hundreds = 0 THEN
            EXIT('');
        IF Masc THEN
            CASE Hundreds OF
                1:
                    IF (Tens = 0) AND (Units = 0) THEN
                        EXIT(Text1100704)
                    ELSE
                        EXIT(Text1100705);
                2:
                    EXIT(Text1100706);
                3:
                    EXIT(Text1100707);
                4:
                    EXIT(Text1100708);
                5:
                    EXIT(Text1100709);
                6:
                    EXIT(Text1100710);
                7:
                    EXIT(Text1100711);
                8:
                    EXIT(Text1100712);
                9:
                    EXIT(Text1100713);
            END
        ELSE
            CASE Hundreds OF
                1:
                    IF (Tens = 0) AND (Units = 0) THEN
                        EXIT(Text1100704)
                    ELSE
                        EXIT(Text1100705);
                2:
                    EXIT(Text1100714);
                3:
                    EXIT(Text1100715);
                4:
                    EXIT(Text1100716);
                5:
                    EXIT(Text1100717);
                6:
                    EXIT(Text1100718);
                7:
                    EXIT(Text1100719);
                8:
                    EXIT(Text1100720);
                9:
                    EXIT(Text1100721);
            END;
    end;

    procedure TextTensUnits(Tens: Integer; Units: Integer; Masc: Boolean): Text[250]
    begin
        CASE Tens OF
            0:
                EXIT(TextUnits(Units, Masc));
            1:
                CASE Units OF
                    0:
                        EXIT(Text1100722);
                    1:
                        EXIT(Text1100723);
                    2:
                        EXIT(Text1100724);
                    3:
                        EXIT(Text1100725);
                    4:
                        EXIT(Text1100726);
                    5:
                        EXIT(Text1100727);
                    ELSE
                        EXIT(Text1100728 + TextUnits(Units, Masc));
                END;
            2:
                IF Units = 0 THEN
                    EXIT(Text1100729)
                ELSE
                    EXIT(Text1100730 + TextUnits(Units, Masc));
            3:
                IF Units = 0 THEN
                    EXIT(Text1100731)
                ELSE
                    EXIT(Text1100732 + TextUnits(Units, Masc));
            4:
                IF Units = 0 THEN
                    EXIT(Text1100733)
                ELSE
                    EXIT(Text1100734 + TextUnits(Units, Masc));
            5:
                IF Units = 0 THEN
                    EXIT(Text1100735)
                ELSE
                    EXIT(Text1100736 + TextUnits(Units, Masc));
            6:
                IF Units = 0 THEN
                    EXIT(Text1100737)
                ELSE
                    EXIT(Text1100738 + TextUnits(Units, Masc));
            7:
                IF Units = 0 THEN
                    EXIT(Text1100739)
                ELSE
                    EXIT(Text1100740 + TextUnits(Units, Masc));
            8:
                IF Units = 0 THEN
                    EXIT(Text1100741)
                ELSE
                    EXIT(Text1100742 + TextUnits(Units, Masc));
            9:
                IF Units = 0 THEN
                    EXIT(Text1100743)
                ELSE
                    EXIT(Text1100744 + TextUnits(Units, Masc));
        END;
    end;

    procedure TextUnits(Units: Integer; Masc: Boolean): Text[250]
    begin
        CASE Units OF
            0:
                EXIT('');
            1:
                IF Masc THEN
                    EXIT(Text1100745)
                ELSE
                    EXIT(Text1100746);
            2:
                EXIT(Text1100747);
            3:
                EXIT(Text1100748);
            4:
                EXIT(Text1100749);
            5:
                EXIT(Text1100750);
            6:
                EXIT(Text1100751);
            7:
                EXIT(Text1100752);
            8:
                EXIT(Text1100753);
            9:
                EXIT(Text1100754);
        END;
    end;

    procedure TextNoDecimals(NoDecimals: Integer): Text[15]
    begin
        IF Decimals > 1 THEN
            CASE NoDecimals OF
                0:
                    EXIT('');
                1:
                    EXIT(Text1100755);
                2:
                    EXIT(Text1100756);
                3:
                    EXIT(Text1100757);
                4:
                    EXIT(Text1100758);
            END
        ELSE
            CASE NoDecimals OF
                0:
                    EXIT('');
                1:
                    EXIT(Text1100759);
                2:
                    EXIT(Text1100760);
                3:
                    EXIT(Text1100761);
                4:
                    EXIT(Text1100762);
            END;
    end;
}
