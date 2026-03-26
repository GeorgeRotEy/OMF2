page 50142 "Necrol.Defuncion Doc"
{
    DeleteAllowed = false;
    Caption = 'Obituary Death Doc', Comment = 'ESP="Necrol.Defuncion Doc"';
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = Friar;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("Necrol.Defuncion Name"; Rec."Necrol.Defuncion Name")
            {
                Caption = 'Nombre del archivo CV';
            }
            field("Necrol.Defuncion Doc"; Rec."Necrol.Defuncion Doc")
            {
                ApplicationArea = Basic, Suite;
                ShowCaption = false;
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

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                    InStr: InStream;
                    OutStr: OutStream;
                begin

                    IF Rec."Necrol.Defuncion Name" <> '' THEN
                        IF NOT CONFIRM(OverrideDocQst) THEN
                            EXIT;
                    // FileName := FileManagement.UploadFile('Seleccione fichero', ClientFileName);
                    UploadIntoStream('Seleccione fichero', '', '', ClientFileName, InStr);
                    Clear(Rec."Necrol.Defuncion Doc");
                    Rec."Necrol.Defuncion Doc".CreateOutStream(OutStr);
                    CopyStream(OutStr, InStr);
                    Rec."Necrol.Defuncion Name" := FileManagement.GetFileName(FileName);
                    Rec."Necrol. Defunción" := TRUE;
                    Rec.MODIFY();
                end;
            }
            action(ViewDocument)
            {
                Caption = 'Open', Comment = 'ESP="Abrir documento"';
                Image = Export;

                trigger OnAction()
                var
                    InStr: InStream;
                begin

                    Rec.CALCFIELDS("Publicaciones Doc");

                    if Rec."Necrol.Defuncion Doc".HasValue then begin
                        Rec."Necrol.Defuncion Doc".CreateInStream(InStr);

                        DownloadFromStream(InStr, 'Exportar', '', '', Rec."Necrol.Defuncion Name")
                    end;

                    // //"Necrol.Defuncion Doc".EXPORT('C:\temp\' +  "Necrol.Defuncion Name");
                    // //HYPERLINK('C:\temp\' + "Necrol.Defuncion Name");
                    // //--APA
                    // "Necrol.Defuncion Doc".EXPORT(TEMPORARYPATH + "Necrol.Defuncion Name");
                    // HYPERLINK(TEMPORARYPATH + "Necrol.Defuncion Name");
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
                    Rec.CALCFIELDS("Necrol.Defuncion Doc");
                    CLEAR(Rec."Necrol.Defuncion Doc");
                    CLEAR(Rec."Necrol.Defuncion Name");
                    Rec."Necrol. Defunción" := FALSE;
                    Rec.MODIFY();
                end;
            }
        }
    }

    var
        OverrideDocQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteDocQst: Label 'Are you sure you want to delete the document?';
}
