page 50059 "EDUCAMOS Input Data Subform"
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    Caption = 'Content', Comment = 'ESP="Contenido"';
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = "EDUCAMOS Input Data";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(vContent; vContent)
            {
                Editable = false;
                MultiLine = true;
                ShowCaption = false;
            }
            field(bUpdateContent; bUpdateContent)
            {
                Caption = 'Actualizar contenido';

                // trigger OnValidate()
                // begin
                //     CLEAR(TempBlob);

                //     IF NOT bUpdateContent THEN
                //         EXIT;

                //     Rec.CALCFIELDS(Content);

                //     IF NOT Rec.Content.HASVALUE THEN
                //         EXIT;

                //     CR[1] := 10;

                //     TempBlob.Blob := Rec.Content;

                //     /*
                //     WHILE TempBlob.MoreTextLines DO
                //       vContent += TempBlob.ReadTextLine;
                //     */

                //     vContent := TempBlob.ReadAsText(CR, TEXTENCODING::MSDos);
                // end;
                trigger OnValidate()
                var
                    InStr: InStream;
                    Chunk: Text;
                    TextAcc: Text;
                begin
                    if not bUpdateContent then
                        exit;

                    Rec.CalcFields(Content);

                    if not Rec.Content.HasValue then begin
                        vContent := '';
                        exit;
                    end;

                    // Lee el BLOB como texto (UTF-8). Ajusta encoding si tu fuente no es UTF-8.
                    Rec.Content.CreateInStream(InStr, TextEncoding::UTF8);

                    TextAcc := '';
                    while not InStr.EOS do begin
                        InStr.ReadText(Chunk);
                        TextAcc += Chunk;
                    end;

                    vContent := TextAcc;
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        /*
        CALCFIELDS(Content);

        IF NOT Content.HASVALUE THEN
          EXIT;

        CR[1] := 10;
        TempBlob.Blob := Content;
        vContent := TempBlob.ReadAsText(CR, TEXTENCODING::Windows);
        */
    end;

    var
        TempBlob: Codeunit "Temp Blob";
        CR: Text[1];
        vContent: Text;
        bUpdateContent: Boolean;
}
