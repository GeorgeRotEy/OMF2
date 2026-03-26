page 50127 "DNI Doc"
{
    //TODO-MIG: CameraProvider
    AutoSplitKey = true;
    Caption = 'VAT Register', Comment = 'ESP="Documento DNI"';
    DeleteAllowed = false;
    InsertAllowed = true;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = Friar;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("DNI Doc"; Rec."DNI Doc")
            {
                ApplicationArea = Basic, Suite;
                ShowCaption = false;
                ToolTip = 'Specifies the picture that has been inserted for the item.', Comment = 'ESP="Especifica la imagen que se ha insertado para el artículo."';
            }
            field("DNI File Name"; Rec."DNI File Name")
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
                Caption = 'Import', Comment = 'ESP="Importar"';
                Image = Import;

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
                    CLEAR(Rec."DNI Doc");
                    Rec."DNI Doc".CreateOutStream(OutStr);
                    CopyStream(OutStr, InStr);
                    Rec."DNI File Name" := FileManagement.GetFileName(FileName);
                    Rec.MODIFY();
                end;
            }
            action(ViewDocument)
            {
                Caption = 'Open', Comment = 'ESP="Abrir"';
                Image = Export;
                ToolTip = 'Export the document to a file.', Comment = 'ESP="Exportar el documento a un archivo."';

                trigger OnAction()
                var
                    InStr: InStream;
                begin
                    Rec.CALCFIELDS("DNI Doc");

                    if Rec."DNI Doc".HasValue then begin
                        Rec."DNI Doc".CreateInStream(InStr);

                        DownloadFromStream(InStr, 'Exportar', '', '', Rec."DNI File Name")
                    end;
                    // //"DNI Doc".EXPORT('C:\temp\' +  "DNI File Name");
                    // //HYPERLINK('C:\temp\' + "DNI File Name");
                    // //--APA
                    // "DNI Doc".EXPORT(TEMPORARYPATH + "DNI File Name");
                    // HYPERLINK(TEMPORARYPATH + "DNI File Name");
                    // //++APA
                end;
            }
            action(DeletePicture)
            {
                Caption = 'Delete', Comment = 'ESP="Eliminar"';
                Image = Delete;
                ToolTip = 'Delete the record.', Comment = 'ESP="Eliminar el registro."';

                trigger OnAction()
                begin
                    IF NOT CONFIRM(DeleteImageQst) THEN
                        EXIT;
                    Rec.CALCFIELDS("DNI Doc");
                    CLEAR(Rec."DNI Doc");
                    CLEAR(Rec."DNI File Name");
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
        OverrideDocQst: Label 'The existing document will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';

    // trigger CameraProvider::PictureAvailable(PictureName: Text; PictureFilePath: Text)
    // var
    //     File: File;
    //     Instream: InStream;
    // begin
    // end;
}
