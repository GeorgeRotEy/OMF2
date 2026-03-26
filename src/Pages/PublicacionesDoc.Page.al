page 50144 "Publicaciones Doc"
{
    //TODO-MIG: CameraProvider
    DeleteAllowed = false;
    Caption = 'Publications Doc', Comment = 'ESP="Publicaciones Doc"';
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = false;
    SourceTable = Friar;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("Publicaciones Doc"; Rec."Publicaciones Doc")
            {
                ApplicationArea = Basic, Suite;
                ShowCaption = false;
                ToolTip = 'Specifies the picture that has been inserted for the item.', Comment = 'ESP="Especifica la imagen que se ha insertado para el artículo."';
            }
            field("Publicaciones File Name"; Rec."Publicaciones File Name")
            {
                Caption = 'Nombre del archivo CV';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportDocument)
            {
                Caption = 'Import', Comment = 'ESP="Importar documento"';
                Image = Import;
                ToolTip = 'Import a picture file.', Comment = 'ESP="Importar un archivo de imagen."';

                trigger OnAction()
                var
                    FileName: Text;
                    FileManagement: Codeunit "File Management";
                    ClientFileName: Text;
                    InStr: InStream;
                    OutStr: OutStream;
                begin

                    IF Rec."Publicaciones File Name" <> '' THEN
                        IF NOT CONFIRM(OverrideDocQst) THEN
                            EXIT;

                    // FileName := FileManagement.UploadFile('Seleccione fichero', ClientFileName);
                    UploadIntoStream('Seleccione fichero', '', '', ClientFileName, InStr);
                    Clear(Rec."Publicaciones Doc");
                    Rec."Publicaciones Doc".CreateOutStream(OutStr);
                    CopyStream(OutStr, InStr);
                    Rec."Publicaciones File Name" := FileManagement.GetFileName(FileName);
                    Rec."Publicaciones check" := TRUE;
                    Rec.MODIFY();
                end;
            }
            action(ViewDocument)
            {
                Caption = 'Open', Comment = 'ESP="Abrir documento"';
                Image = Export;
                ToolTip = 'Export the document to a file.', Comment = 'ESP="Exportar el documento a un archivo."';

                trigger OnAction()
                var
                    InStr: InStream;
                begin

                    Rec.CALCFIELDS("Publicaciones Doc");

                    if Rec."Publicaciones Doc".HasValue then begin
                        Rec."Publicaciones Doc".CreateInStream(InStr);

                        DownloadFromStream(InStr, 'Exportar', '', '', Rec."Publicaciones File Name")
                    end;

                    // //"Publicaciones Doc".EXPORT('C:\temp\' +  "Publicaciones File Name");
                    // //HYPERLINK('C:\temp\' + "Publicaciones File Name");
                    // //--APA
                    // "Publicaciones Doc".EXPORT(TEMPORARYPATH + "Publicaciones File Name");
                    // HYPERLINK(TEMPORARYPATH + "Publicaciones File Name");
                    // //++APA
                end;
            }
            action(DeletePicture)
            {
                Caption = 'Delete', Comment = 'ESP="Eliminar documento"';
                Image = Delete;
                ToolTip = 'Delete the record.', Comment = 'ESP="Eliminar el registro."';

                trigger OnAction()
                begin
                    IF NOT CONFIRM(DeleteDocQst) THEN
                        EXIT;

                    Rec.CALCFIELDS("Publicaciones Doc");
                    CLEAR(Rec."Publicaciones Doc");
                    CLEAR(Rec."Publicaciones File Name");
                    Rec."Publicaciones check" := FALSE;

                    Rec.MODIFY();
                end;
            }
        }
    }

    // trigger OnOpenPage()
    // begin
    //     CameraAvailable := CameraProvider.IsAvailable;
    //     IF CameraAvailable THEN
    //         CameraProvider := CameraProvider.Create;
    // end;

    var
        OverrideDocQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteDocQst: Label 'Are you sure you want to delete the document?';

    // trigger CameraProvider::PictureAvailable(PictureName: Text; PictureFilePath: Text)
    // begin
    // end;
}
