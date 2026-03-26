tableextension 50020 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                rlVendor: Record Vendor;
            begin
                if rlVendor.Get("No.") then begin
                    VALIDATE("Control IRPF", rlVendor."Control IRPF");
                    VALIDATE("Grupo registro IRPF", rlVendor."Grupo registro IRPF");
                end;
            end;
        }
        field(50100; "Control IRPF"; Option)
        {
            Caption = 'IRPF Control', Comment = 'ESP="Control IRPF"';
            OptionCaption = ' ,Obligatorio,Opcional';
            OptionMembers = " ",Obligatorio,Opcional;
        }
        field(50110; "Grupo registro IRPF"; Code[10])
        {
            Caption = 'IRPF Posting Group', Comment = 'ESP="Grupo registro IRPF"';
            TableRelation = IF ("Control IRPF" = FILTER(<> ' ')) "Grupo registro retención"."Cód. grupo";
        }
        field(50300; "Budg. Control Status"; Option)
        {
            Caption = 'Budget Control Status', Comment = 'ESP="Estado control ppto."';
            OptionCaption = ' ,Blocked,Unblocked';
            OptionMembers = " ",Blocked,Unblocked;
        }
    }

    procedure fBloquearRegistro()
    begin
        rPurchaseLine.SETRANGE("Document Type", Rec."Document Type");
        rPurchaseLine.SETRANGE("Document No.", Rec."No.");
        IF NOT rPurchaseLine.FINDFIRST() THEN
            ERROR(Text080, "Document Type", "No.");
    end;

    var
        rPurchaseLine: Record "Purchase Line";
        Text080: Label 'Debe rellenar al menos una línea en %1 %2';
}