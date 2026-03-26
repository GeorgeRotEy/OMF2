tableextension 50013 "Excel Buffer Ext" extends "Excel Buffer"
{
    fields
    {
        field(50000; "Font Color"; Integer)
        {
            Caption = 'Font Color', Comment = 'ESP="Color fuente"';
        }
        field(50001; "Font Size"; Integer)
        {
            Caption = 'Font Size', Comment = 'ESP="Tamaño fuente"';
        }
        field(50002; "BackGround Color"; Integer)
        {
            Caption = 'Background Color', Comment = 'ESP="Color fondo"';
        }
        field(50003; "Font Name"; Text[100])
        {
            Caption = 'Font Name', Comment = 'ESP="Nombre fuente"';
        }
    }

    // var
    //     CustomFontPool: DotNet Dictionary_Of_T_U;
    //     bFromTemplate: Boolean;

    // local procedure fGetCustomCellDecorator(IsBold: Boolean; IsItalic: Boolean; IsUnderlined: Boolean; IsDoubleUnderlined: Boolean; Color: Integer; FontSize: Integer; var Decorator: DotNet CellDecorator; BackgroundColor: Integer; FontName: Text[100])
    // var
    //     BaseDecorator: DotNet CellDecorator;
    //     CustomColor: DotNet Color;
    //     CustomFontSize: DotNet FontSize;
    //     CustomBGColor: DotNet BackgroundColor;
    //     FontSizeValue: DotNet DoubleValue;
    //     CustomFont: DotNet Font;
    //     HexColor: DotNet HexBinaryValue;
    //     Fonts: DotNet Fonts;
    //     FontIndex: Text;
    //     CustomCellFill: DotNet Fill;
    //     CustomCellPatternFill: DotNet PatternFill;
    //     HexBackGroundColour: Text;
    //     CustomFontName: DotNet FontName;
    //     XMLStringValue: DotNet StringValue;
    // begin
    //     //(1.8) S2G (RBM-R) 24-03-20: Modificaciones presupuestos (Plantilla exportación ppto)
    //     GetCellDecorator(IsBold, IsItalic, IsUnderlined, IsDoubleUnderlined, BaseDecorator);
    //     Decorator := BaseDecorator;

    //     // Handle Extension
    //     //(OFM-02) KPMG (GRL) 20-12-20: Modificaciones presupuesto (Plantilla exportacion ppto).Inicio
    //     //IF (Color <> 0) OR (FontSize <> 0) THEN BEGIN
    //     IF (Color <> 0) OR (FontSize <> 0) OR (BackgroundColor <> 0) OR (FontName <> '') THEN BEGIN
    //         //(OFM-02) KPMG (GRL) 20-12-20: Modificaciones presupuesto (Plantilla exportacion ppto).Fin
    //         FontIndex := STRSUBSTNO('%1|%2|%3|%4|%5', IsBold, IsItalic, IsUnderlined, Color, FontSize);
    //         CustomFont := BaseDecorator.Font.CloneNode(TRUE);

    //         // Color
    //         IF Color <> 0 THEN BEGIN
    //             CustomColor := CustomColor.Color;
    //             CASE Color OF
    //                 3:
    //                     CustomColor.Rgb := HexColor.HexBinaryValue('00FF0000'); // Red
    //                 5:
    //                     CustomColor.Rgb := HexColor.HexBinaryValue('001B1BC3'); // Blue
    //                 10:
    //                     CustomColor.Rgb := HexColor.HexBinaryValue('0022B400'); // Green
    //                                                                             //(OFM-02) KPMG (GRL) 20-12-20: Modificaciones presupuesto (Plantilla exportacion ppto).Inicio
    //                 11:
    //                     CustomColor.Rgb := HexColor.HexBinaryValue('00FFFFFF'); // White
    //                 12:
    //                     CustomColor.Rgb := HexColor.HexBinaryValue('00465678'); // Dark Blue
    //                 13:
    //                     CustomColor.Rgb := HexColor.HexBinaryValue('004C68A2'); // Middle Blue
    //                                                                             //(OFM-02) KPMG (GRL) 20-12-20: Modificaciones presupuesto (Plantilla exportacion ppto).Fin
    //             END;
    //             CustomFont.Color := CustomColor;
    //         END;

    //         // Font Size
    //         IF FontSize <> 0 THEN BEGIN
    //             CustomFontSize := CustomFontSize.FontSize;
    //             CustomFontSize.Val := FontSizeValue.DoubleValue(FontSize);
    //             CustomFont.FontSize := CustomFontSize;
    //         END;

    //         //(OFM-02) KPMG (GRL) 20-12-20: Modificaciones presupuesto (Plantilla exportacion ppto).Inicio
    //         //Background Color
    //         IF BackgroundColor <> 0 THEN BEGIN
    //             HexBackGroundColour := '';
    //             CASE BackgroundColor OF
    //                 1:
    //                     HexBackGroundColour := '00FF0000'; // Red
    //                 2:
    //                     HexBackGroundColour := '001B1BC3'; // Blue
    //                 3:
    //                     HexBackGroundColour := '0022B400'; // Green
    //                                                        //(OFM-02) KPMG (GRL) 20-12-20: Modificaciones presupuesto (Plantilla exportacion ppto).Inicio
    //                 4:
    //                     HexBackGroundColour := '004C68A2'; // Dark Blue
    //                 5:
    //                     HexBackGroundColour := '00F2F2F2'; // Light Gray
    //                 6:
    //                     HexBackGroundColour := '0097B1D7'; // Middel Blue
    //                 7:
    //                     HexBackGroundColour := '00C6DAF8'; // Light Blue
    //                 8:
    //                     HexBackGroundColour := '00578335'; // Dark Green
    //                                                        //(OFM-02) KPMG (GRL) 20-12-20: Modificaciones presupuesto (Plantilla exportacion ppto).Fin
    //             END;

    //             // FOR MORE COLORS REFER - http://www.mathsisfun.com/numbers/color-wheel-interactive.html
    //             // APPEND 00 on the Result Found above & Add one more option in case statement.

    //             CustomCellFill := Decorator.Fill.CloneNode(TRUE);
    //             CustomCellPatternFill := CustomCellPatternFill.PatternFill(
    //                                         '<x:patternFill xmlns:x="http://schemas.openxmlformats.org/spreadsheetml/2006/main" ' + 'patternType="' + 'solid' + '">' +
    //                                         '<x:fgColor rgb="' + HexBackGroundColour + '" /></x:patternFill>');
    //             CustomCellFill.PatternFill := CustomCellPatternFill;
    //             Decorator.Fill := CustomCellFill;
    //         END;

    //         //Font Name
    //         IF FontName <> '' THEN BEGIN
    //             CustomFont := CustomFont.Font;
    //             CustomFontName := CustomFontName.FontName;
    //             CustomFontName.Val := XMLStringValue.StringValue("Font Name");
    //             CustomFont.FontName := CustomFontName;
    //         END;

    //         //(OFM-02) KPMG (GRL) 20-12-20: Modificaciones presupuesto (Plantilla exportacion ppto).Inicio

    //         Fonts := XlWrkBkWriter.Workbook.WorkbookPart.WorkbookStylesPart.Stylesheet.Fonts;
    //         fAddFontToCollection(Fonts, CustomFont, FontIndex);

    //         Decorator.Font := CustomFont;
    //     END;
    // end;

    // procedure fAddFontToCollection(_Fonts: DotNet Fonts; var _CustomFont: DotNet OpenXmlElement; _Index: Text)
    // var
    //     i: Integer;
    //     Arr: DotNet Array;
    //     TempFont: DotNet OpenXmlElement;
    // begin
    //     //(1.8) S2G (RBM-R) 24-03-20: Modificaciones presupuestos (Plantilla exportación ppto)
    //     IF ISNULL(CustomFontPool) THEN
    //         CustomFontPool := CustomFontPool.Dictionary();

    //     IF CustomFontPool.TryGetValue(_Index, TempFont) THEN BEGIN
    //         // Already in Collection
    //         _CustomFont := TempFont;
    //         EXIT;
    //     END ELSE BEGIN

    //         // OpenXML Element Array
    //         Arr := Arr.CreateInstance(GETDOTNETTYPE(_CustomFont), 1);
    //         Arr.SetValue(_CustomFont, 0);

    //         _Fonts.Append(Arr);
    //         _Fonts.Count.Value := _Fonts.Count.Value + 1;

    //         CustomFontPool.Add(_Index, _CustomFont);
    //     END;
    // end;

    // procedure fFromTemplate()
    // begin
    //     //(1.8) S2G (RBM-R) 24-03-20: Modificaciones presupuestos (Plantilla exportación ppto)
    //     bFromTemplate := TRUE;

    //     // ATD 18-12-20: Inclusión de función AddColumnNer para poder modificar background color, font color y font size del Excel.
    // end;

    // local procedure AddColumnNew(Value: Variant; IsFormula: Boolean; CommentText: Text[1000]; IsBold: Boolean; IsItalics: Boolean; IsUnderline: Boolean; NumFormat: Text[30]; FontSize: Integer; BGColour: Integer; FontColor: Integer; CellType: Option)
    // begin
    //     IF CurrentRow < 1 THEN
    //         NewRow;

    //     CurrentCol := CurrentCol + 1;
    //     INIT;
    //     VALIDATE("Row No.", CurrentRow);
    //     VALIDATE("Column No.", CurrentCol);
    //     IF IsFormula THEN
    //         SetFormula(FORMAT(Value))
    //     ELSE
    //         "Cell Value as Text" := FORMAT(Value);
    //     Comment := CommentText;
    //     Bold := IsBold;
    //     Italic := IsItalics;
    //     Underline := IsUnderline;
    //     NumberFormat := NumFormat;
    //     "Cell Type" := CellType;
    //     "Font Size" := FontSize;
    //     "BackGround Color" := BGColour;
    //     "Font Color" := FontColor;
    //     INSERT();
    // end;
}
