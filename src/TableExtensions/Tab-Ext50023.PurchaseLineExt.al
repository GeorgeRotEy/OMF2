tableextension 50023 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        modify("Qty. to Invoice")
        {
            trigger OnBeforeValidate()
            begin
                IF "Qty. to Invoice" <> 0 THEN
                    TESTFIELD("Línea IRPF", FALSE);
            end;
        }
        modify("Qty. to Receive")
        {
            trigger OnBeforeValidate()
            begin
                IF "Qty. to Receive" <> 0 THEN
                    TESTFIELD("Línea IRPF", FALSE);
            end;
        }
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                IF "Línea IRPF" THEN
                    CuGestionIRPF.ActualizarImporteIRPF(Rec);
            end;
        }
        field(50110; "Grupo registro IRPF"; Code[10])
        {
            Caption = 'IRPF Posting Group', Comment = 'ESP="Grupo registro IRPF"';
            TableRelation = "Grupo registro retención"."Cód. grupo";
        }
        field(50120; "Línea IRPF"; Boolean)
        {
            Caption = 'IRPF Line', Comment = 'ESP="Línea IRPF"';
            Editable = false;
        }
    }

    trigger OnAfterInsert()
    begin
        rPurchHeader.GET("Document Type", "Document No.");
        IF rPurchHeader."Budg. Control Status" <> rPurchHeader."Budg. Control Status"::" " THEN BEGIN
            rPurchHeader."Budg. Control Status" := rPurchHeader."Budg. Control Status"::" ";
            rPurchHeader.MODIFY();
        END;
    end;

    trigger OnAfterModify()
    begin
        rPurchHeader.GET("Document Type", "Document No.");
        IF rPurchHeader."Budg. Control Status" <> rPurchHeader."Budg. Control Status"::" " THEN BEGIN
            rPurchHeader."Budg. Control Status" := rPurchHeader."Budg. Control Status"::" ";
            rPurchHeader.MODIFY();
        END;
    end;

    trigger OnBeforeDelete()
    begin
        TestStatusOpen;
        TESTFIELD("Línea IRPF", FALSE);
    end;

    var
        CuGestionIRPF: Codeunit "Gestión IRPF";
        rPurchHeader: Record "Purchase Header";
}