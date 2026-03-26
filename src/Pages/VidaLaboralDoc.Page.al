page 50128 "Vida Laboral Doc"
{
    //TODO-MIG: CameraProvider

    Caption = 'Working Life', Comment = 'ESP="Vida Laboral"';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = Friar;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("Vida Laboral Doc"; Rec."Vida Laboral Doc")
            {
                ApplicationArea = Basic, Suite;
                ShowCaption = false;
                ToolTip = 'Specifies the picture that has been inserted for the item.', Comment = 'ESP="Especifica la imagen que se ha insertado para el artículo."';
            }
            field("Vida Laboral File Name"; Rec."Vida Laboral File Name")
            {
                Caption = 'Nombre del Archivo';
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
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                    InStr: InStream;
                    OutStr: OutStream;
                begin

                    IF Rec."DNI File Name" <> '' THEN
                        IF NOT CONFIRM(OverrideDocQst) THEN
                            EXIT;
                    // FileName := FileManagement.UploadFile('Seleccione fichero', ClientFileName);
                    UploadIntoStream('Seleccione fichero', '', '', ClientFileName, InStr);
                    CLEAR(Rec."Vida Laboral Doc");
                    Rec."Vida Laboral Doc".CreateOutStream(OutStr);
                    CopyStream(OutStr, InStr);
                    Rec."Vida Laboral File Name" := FileManagement.GetFileName(FileName);
                    Rec."Vida Laboral" := TRUE;
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
                    Rec.CALCFIELDS("Vida Laboral Doc");

                    if Rec."Vida Laboral Doc".HasValue then begin
                        Rec."Vida Laboral Doc".CreateInStream(InStr);

                        DownloadFromStream(InStr, 'Exportar', '', '', Rec."Vida Laboral File Name")
                    end;
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
                    Rec.CALCFIELDS("Vida Laboral Doc");
                    CLEAR(Rec."Vida Laboral Doc");
                    CLEAR(Rec."Vida Laboral File Name");
                    Rec."Vida Laboral" := FALSE;
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
    // var
    //     File: File;
    //     Instream: InStream;
    // begin
    // end;
}
