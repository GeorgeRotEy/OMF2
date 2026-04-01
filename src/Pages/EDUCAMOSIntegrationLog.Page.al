page 50054 "EDUCAMOS Integration Log"
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos

    Caption = 'Log', Comment = 'ESP="Log"';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "EDUCAMOS Integration Log";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Rec.Indentation;
                IndentationControls = "Entry no.";
                ShowAsTree = true;
                field("Entry No."; Rec."Entry No.")
                {
                    Style = StrongAccent;
                    StyleExpr = Rec.Indentation = 0;
                }
                field("Log Status"; Rec."Log Status")
                {
                    Style = StrongAccent;
                    StyleExpr = Rec.Indentation = 0;
                }
                field("Log Text"; Rec."Log Text")
                {
                    Style = StrongAccent;
                    StyleExpr = Rec.Indentation = 0;
                }
                field("Process DateTime"; Rec."Process DateTime")
                {
                    Style = StrongAccent;
                    StyleExpr = Rec.Indentation = 0;
                }
                field("Extra info"; Rec."Extra info")
                {
                    Style = StrongAccent;
                    StyleExpr = Rec.Indentation = 0;
                }
            }
            group("Errores LOG")
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(test)
            {
                Image = TestFile;

                trigger OnAction()
                var
                //"Codeunit": Codeunit "JSON WS Management con fichero";
                begin
                    //Codeunit.test;
                end;
            }
            action(ViewDocument)
            {
                ApplicationArea = All;
                Caption = 'Open', Comment = 'ESP="Abrir"';
                Image = Export;
                ToolTip = 'Export the document to a file.', Comment = 'ESP="Exportar el documento a un archivo."';

                trigger OnAction()
                var
                    NameValueBuffer: Record "Name/Value Buffer";
                    TempNameValueBuffer: Record "Name/Value Buffer" temporary;
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                    timeLocal: Time;
                    MyFile: File;
                    outstream: OutStream;
                    InStr: InStream;
                    XMLText: Text;
                begin
                    Rec.CALCFIELDS("Errores Doc");
                    IF Rec."Errores Doc".HASVALUE THEN BEGIN
                        Rec."Errores Doc".CreateInStream(InStr);
                        DownloadFromStream(InStr, 'Exportar', '', '', Rec."Errores Name");
                    END;
                end;
            }
            action(ProcesarRemesas)
            {
                Caption = 'Procesar remesas pendientes', Comment = 'ESP="Procesar remesas pendientes"';
                Image = JobSalesInvoice;

                trigger OnAction()
                var
                    rlCompanyOFM: Record "Company OFM";
                    vSchoolID: Integer;
                    EDUCAMOSInterface: Codeunit "EDUCAMOS Interface";
                    txtDialog2: Label 'Cargando datos...\\Importando Remesas @1@@@@@@\\Importando Remesas Recibo @2@@@@@@\\Importando Alumnos Concepto @3@@@@@@\\Importando Concepto Descuento @4@@@@@@';
                    Error005: Label 'Se debe informar un ID de colegio en la empresa. No se procesó ninguna remesa';
                    Window: Dialog;
                begin
                    //Recorrer las remesas no procesadas
                    rlCompanyOFM.RESET;
                    rlCompanyOFM.SETRANGE(Name, COMPANYNAME);
                    IF rlCompanyOFM.FINDFIRST THEN BEGIN
                        vSchoolID := rlCompanyOFM."School ID";
                        EDUCAMOSInterface.fProcessRemesa(vSchoolID);
                    END
                    ELSE BEGIN
                        EDUCAMOSInterface.fSetLog(3, Error005, '', 1);
                        EXIT;
                    END;
                end;
            }

            action(ImportarDesdeEducamos)
            {
                Caption = 'Importar desde Educamos';
                ApplicationArea = All;
                Image = Refresh;

                trigger OnAction()
                var
                    cuJSON: Codeunit "JSON Webservices Management";
                    EDUInterface: Codeunit "EDUCAMOS Interface";
                    TempBlob: Codeunit "Temp Blob";
                    OutS: OutStream;
                    Ok: Boolean;
                begin
                    Clear(cuJSON);

                    // Si revienta con ERROR, lo atrapamos y lo metemos al LOG con "Errores Doc"
                    if not TryRunImport(cuJSON, Ok) then begin
                        TempBlob.CreateOutStream(OutS);
                        OutS.WriteText(GetLastErrorText());

                        EDUInterface.fSetLogWithResponse(3, 'ERROR en importación: ' + CopyStr(GetLastErrorText(), 1, 250), CompanyName, 0, TempBlob);
                        Error('La importación ha fallado. Revisa el LOG para ver el detalle.');
                    end;

                    if Ok then
                        Message('Importación finalizada. Revisa el LOG y/o Input Data.')
                    else begin
                        Commit(); // <- IMPRESCINDIBLE: si no, el ERROR revierte el LOG
                        Error('La importación ha fallado. Revisa el LOG para ver el detalle.');
                    end;
                end;
            }

            // action(ImportarFacturasTPVAuto)
            // {
            //     Caption = 'Importar Facturas TPV (Auto)';
            //     ApplicationArea = All;
            //     Image = Import;

            //     trigger OnAction()
            //     var
            //         cuJSON: Codeunit "JSON Webservices Management";
            //         Ok: Boolean;
            //     begin
            //         Clear(cuJSON);
            //         Ok := cuJSON.ImportFacturasTPV();

            //         if Ok then
            //             Message('Importación FacturasTPV (Auto) finalizada. Revisa el LOG y/o Input Data.')
            //         else begin
            //             Commit();
            //             Error('La importación ha fallado. Revisa el LOG para ver el detalle.');
            //         end;
            //     end;
            // }
        }
    }

    [TryFunction]
    local procedure TryRunImport(var cuJSON: Codeunit "JSON Webservices Management"; var Ok: Boolean)
    begin
        Ok := cuJSON.Code();
    end;

    trigger OnAfterGetRecord()
    begin
        Rec."Errores Name" := FORMAT(TODAY, 0, 4) + FORMAT(TIME) + '.txt';
    end;
}
