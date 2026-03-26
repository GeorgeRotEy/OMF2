page 50010 "imagen fraile"
{
    //TODO-MIG: CameraProvider
    Caption = 'Customer Picture', Comment = 'ESP="Imagen fraile"';
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
            field("Imagen fraile"; Rec."Imagen fraile")
            {
                ShowCaption = false;
                ToolTip = 'Specifies the picture of the customer, for example, a logo.', Comment = 'ESP="Especifica la imagen del cliente, por ejemplo, un logotipo."';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(TakePicture)
            {
                Caption = 'Take', Comment = 'ESP="Tomar fotografía"';
                Image = Camera;
                ToolTip = 'Activate the camera on the device.', Comment = 'ESP="Activar la cámara en el dispositivo."';
                Visible = CameraAvailable;

                // trigger OnAction()
                // var
                //     CameraOptions: DotNet CameraOptions;
                // begin
                //     IF NOT CameraAvailable THEN
                //         EXIT;
                //     CameraOptions := CameraOptions.CameraOptions;
                //     CameraOptions.Quality := 100;
                //     CameraProvider.RequestPictureAsync(CameraOptions);
                // end;
            }
            action(ImportPicture)
            {
                Caption = 'Import', Comment = 'ESP="Importar imagen"';
                Image = Import;

                trigger OnAction()
                var
                    ClientFileName: Text;
                    InStr: InStream;
                begin

                    IF Rec."Imagen fraile".HASVALUE THEN
                        IF NOT CONFIRM(OverrideImageQst) THEN
                            EXIT;

                    // FileName := FileManagement.UploadFile(SelectPictureTxt, ClientFileName);
                    if not UploadIntoStream('Seleccione fichero', '', '', ClientFileName, InStr) then
                        exit;

                    CLEAR(Rec."Imagen fraile");
                    Rec."Imagen fraile".ImportStream(InStr, ClientFileName);
                    Rec.MODIFY(TRUE);
                    // IF FileManagement.DeleteServerFile(FileName) THEN;
                end;
            }
            action(ExportFile)
            {
                Caption = 'Export', Comment = 'ESP="Exportar archivo"';
                Enabled = DeleteExportEnabled;
                Image = Export;

                trigger OnAction()
                var
                    OutStr: OutStream;
                begin

                    Rec.CALCFIELDS("Imagen fraile");

                    if Rec."Imagen fraile".HasValue then
                        Rec."Imagen fraile".ExportStream(OutStr);
                    // DownloadFromStream(InStr, 'Exportar', '', '', Rec."Necrol.Defuncion Name")

                    // NameValueBuffer.DELETEALL();
                    // ExportPath := TEMPORARYPATH + "No. Serie Friar" + FORMAT("Imagen fraile".MEDIAID);
                    // "Imagen fraile".EXPORTFILE(ExportPath);
                    // FileManagement.GetServerDirectoryFilesList(TempNameValueBuffer, TEMPORARYPATH);
                    // TempNameValueBuffer.SETFILTER(Name, STRSUBSTNO('%1*', ExportPath));
                    // TempNameValueBuffer.FINDFIRST();
                    // ToFile := STRSUBSTNO('%1 %2.jpg', "No. Serie Friar", Name);
                    // DOWNLOAD(TempNameValueBuffer.Name, DownloadImageTxt, '', '', ToFile);
                    // IF FileManagement.DeleteServerFile(TempNameValueBuffer.Name) THEN;
                end;
            }
            action(DeletePicture)
            {
                Caption = 'Delete', Comment = 'ESP="Eliminar imagen"';
                Enabled = DeleteExportEnabled;
                Image = Delete;

                trigger OnAction()
                begin
                    IF NOT CONFIRM(DeleteImageQst) THEN
                        EXIT;

                    CLEAR(Rec."Imagen fraile");
                    Rec.MODIFY(TRUE);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    // trigger OnOpenPage()
    // begin
    //     CameraAvailable := CameraProvider.IsAvailable;
    //     IF CameraAvailable THEN
    //         CameraProvider := CameraProvider.Create;
    // end;

    var
        // CameraProvider: DotNet CameraProvider;
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        DeleteExportEnabled: Boolean;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Rec."Imagen fraile".HASVALUE;
    end;

    // trigger CameraProvider::PictureAvailable(PictureName: Text; PictureFilePath: Text)
    // var
    //     File: File;
    //     Instream: InStream;
    // begin
    //     IF (PictureName = '') OR (PictureFilePath = '') THEN
    //         EXIT;

    //     IF "Imagen fraile".HASVALUE THEN
    //         IF NOT CONFIRM(OverrideImageQst) THEN BEGIN
    //             IF ERASE(PictureFilePath) THEN;
    //             EXIT;
    //         END;

    //     File.OPEN(PictureFilePath);
    //     File.CREATEINSTREAM(Instream);

    //     CLEAR("Imagen fraile");
    //     "Imagen fraile".IMPORTSTREAM(Instream, PictureName);
    //     MODIFY(TRUE);

    //     File.CLOSE();
    //     IF ERASE(PictureFilePath) THEN;
    // end;
}
