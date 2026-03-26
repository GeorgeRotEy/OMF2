table 50008 "Reports Generation"
{
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple

    fields
    {
        field(1; "Custom Report"; Option)
        {
            Caption = 'Informe';
            OptionCaption = '1-Diario contable extendido,1.1-Diario contable,2-Libro mayor - Cuentas de 1 a 5,3-Libro mayor - Cuentas de Gestión,4-Balance de sumas y saldos - Cuentas de 1 a 5,5-Balance de sumas y saldos - Cuentas de Gestión,5.1-Balance de sumas y saldos - Cuentas de Gestión con arrendamientos,6-Estudio del presupuesto,7-Preparar presupuesto para próximo ejercicio';
            OptionMembers = "1-Diario contable extendido","1.1-Diario contable","2-Libro mayor - Cuentas de 1 a 5","3-Libro mayor - Cuentas de Gestión","4-Balance de sumas y saldos - Cuentas de 1 a 5","5-Balance de sumas y saldos - Cuentas de Gestión","5.1-Balance de sumas y saldos - Cuentas de Gestión con arrendamientos","6-Estudio del presupuesto","7-Preparar presupuesto para próximo ejercicio";
        }
        field(2; "Report ID"; Integer)
        {
            Caption = 'ID Informe';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Report"));
        }
        field(3; "Report name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Report),
                                                    "Object ID" = FIELD("Report ID")));
            FieldClass = FlowField;
            Caption = 'Nombre informe';
            Editable = false;
        }
        field(4; "Format to export"; Option)
        {
            Caption = 'Formato a exportar';
            OptionMembers = Excel,PDF,Ambos;
        }
        field(5; "Email to export"; Text[250])
        {
            Caption = 'Emails a exportar';
        }
    }

    keys
    {
        key(Key1; "Custom Report")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure openReportPDF() pReturnValue: Boolean
    begin
        vParameters := '';

        vParameters := REPORT.RUNREQUESTPAGE("Report ID");
        IF vParameters = '' THEN
            ERROR('Proceso cancelado por el usuario.');
        vReportName := FORMAT("Custom Report") + '.pdf';
        vPosGuionMedio := STRPOS(vReportName, '-');
        vReportName := COPYSTR(vReportName, vPosGuionMedio + 1);

        cTempBlob.CREATEOUTSTREAM(vOutStr);
        REPORT.SAVEAS("Report ID", vParameters, REPORTFORMAT::PDF, vOutStr);
        cTempBlob.CREATEINSTREAM(vInStr);

        // Transfer the content from the temporary file on the
        // server to a file on the client.
        pReturnValue := DOWNLOADFROMSTREAM(
          vInStr,
          'Save file to client',
          '',
          'PDF File *.pdf| *.pdf',
          vReportName);
    end;

    procedure openReportEXCEL() pReturnValue: Boolean
    begin
        vParameters := '';

        vParameters := REPORT.RUNREQUESTPAGE("Report ID");
        IF vParameters = '' THEN
            ERROR('Proceso cancelado por el usuario.');
        vReportName := FORMAT("Custom Report") + '.xlsx';
        vPosGuionMedio := STRPOS(vReportName, '-');
        vReportName := COPYSTR(vReportName, vPosGuionMedio + 1);

        cTempBlob.CREATEOUTSTREAM(vOutStr);
        REPORT.SAVEAS("Report ID", vParameters, REPORTFORMAT::Excel, vOutStr);
        cTempBlob.CREATEINSTREAM(vInStr);

        // Transfer the content from the temporary file on the
        // server to a file on the client.
        pReturnValue := DOWNLOADFROMSTREAM(
          vInStr,
          'Save file to client',
          '',
          'Excel File *.xlsx| *.xlsx',
          vReportName);
    end;

    var
        vReportName: Text;
        vPosGuionMedio: Integer;
        cTempBlob: Codeunit "Temp Blob";
        vParameters: Text;
        vOutStr: OutStream;
        vInStr: InStream;
}
