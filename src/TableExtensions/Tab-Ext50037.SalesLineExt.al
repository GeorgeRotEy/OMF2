tableextension 50037 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        modify("Qty. to Invoice")
        {
            trigger OnBeforeValidate()
            begin
                IF "Qty. to Invoice" <> 0 THEN
                    TESTFIELD("IRPF Line", FALSE);
            end;
        }
        modify("Qty. to Ship")
        {
            trigger OnBeforeValidate()
            begin
                IF "Qty. to Invoice" <> 0 THEN
                    TESTFIELD("IRPF Line", FALSE);
            end;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                IF "IRPF Line" THEN
                    CuGestionIRPF.ActualizarImporteIRPFVtas(Rec);
            end;
        }
        field(50110; "IRPF Posting Group"; Code[10])
        {
            Caption = 'IRPF Posting Group', Comment = 'ESP="Grupo registro IRPF"';
            TableRelation = "Grupo registro retención"."Cód. grupo";

            trigger OnValidate()
            var
                RecCabVenta: Record "Sales Header";
            begin
                if "IRPF Posting Group" <> '' then begin
                    TestField("IRPF Line", false);

                    RecCabVenta.Get("Document Type", "Document No.");
                    RecCabVenta.TestField(Status, RecCabVenta.Status::Open);
                    RecCabVenta.TestField("Control IRPF");
                end;
            end;
        }
        field(50120; "IRPF Line"; Boolean)
        {
            Caption = 'IRPF Line', Comment = 'ESP="Línea IRPF"';
        }
        field(52000; "Last modification datetime"; DateTime)
        {
            Caption = 'Last Modification Datetime', Comment = 'ESP="Fecha hora última modificación"';
        }
        field(52001; "Last modification user"; Code[50])
        {
            Caption = 'Last Modification User', Comment = 'ESP="Usuario última modificación"';
        }
    }

    var
        CuGestionIRPF: Codeunit "Gestión IRPF";
        rSalesHeader: Record "Sales Header";

    trigger OnBeforeDelete()
    begin
        TestField("IRPF Line", false);
    end;

    trigger OnAfterInsert()
    begin
        if rSalesHeader.Get("Document Type", "Document No.") then begin
            if rSalesHeader."Budg. Control Status" <> rSalesHeader."Budg. Control Status"::" " then begin
                rSalesHeader."Budg. Control Status" := rSalesHeader."Budg. Control Status"::" ";
                rSalesHeader.Modify();
            end;

            if not "IRPF Line" and not "System-Created Entry" then
                if rSalesHeader."Grupo registro IRPF" <> '' then
                    Validate("IRPF Posting Group", rSalesHeader."Grupo registro IRPF");
        end;

        "Last modification datetime" := CurrentDateTime;
        "Last modification user" := USERID();
    end;

    trigger OnAfterModify()
    begin
        if rSalesHeader.Get("Document Type", "Document No.") then
            if rSalesHeader."Budg. Control Status" <> rSalesHeader."Budg. Control Status"::" " then begin
                rSalesHeader."Budg. Control Status" := rSalesHeader."Budg. Control Status"::" ";
                rSalesHeader.Modify();
            end;

        "Last modification datetime" := CurrentDateTime;
        "Last modification user" := USERID();
    end;
}
