tableextension 50098 "General Ledger Setup S2G Ext" extends "General Ledger Setup"
{
    fields
    {
        field(51000; "Tipo gestión plan de cuentas"; Option)
        {
            Caption = 'Chart of Accounts Management Type', Comment = 'ESP="Tipo gestión plan de cuentas"';
            OptionCaption = 'Independent,Corporate';
            OptionMembers = Independiente,Corporativo;

            trigger OnValidate()
            begin
                cFuncionesPLC.fTipoGestionPlanCuentas(Rec);
            end;
        }
        field(51001; "Nº Serie Donaciones"; Code[20])
        {
            Caption = 'Donations No. Series', Comment = 'ESP="Nº serie donaciones"';
            TableRelation = "No. Series";
        }
        field(51002; "Dim. Partida Presupuestaria"; Code[20])
        {
            Caption = 'Budget Item Dimension', Comment = 'ESP="Dim. partida presupuestaria"';
            TableRelation = Dimension;
        }
        field(51004; "Cta. IRPF"; Code[20])
        {
            Caption = 'IRPF Account', Comment = 'ESP="Cta. IRPF"';
            TableRelation = "G/L Account";
        }
        field(51005; "Cta. Importe Líquido"; Code[20])
        {
            Caption = 'Net Amount Account', Comment = 'ESP="Cta. importe líquido"';
            TableRelation = "G/L Account";
        }
        field(51006; "Cta. debe S.S. Empresa"; Code[20])
        {
            Caption = 'Company S.S. Debit Account', Comment = 'ESP="Cta. debe S.S. empresa"';
            TableRelation = "G/L Account";
        }
        field(51007; "Cta. haber S.S. Empresa"; Code[20])
        {
            Caption = 'Company S.S. Credit Account', Comment = 'ESP="Cta. haber S.S. empresa"';
            TableRelation = "G/L Account";
        }
        field(51008; "Cta. debe S.S. Empleado"; Code[20])
        {
            Caption = 'Employee S.S. Debit Account', Comment = 'ESP="Cta. debe S.S. empleado"';
            TableRelation = "G/L Account";
        }
        field(51009; "Cta. haber S.S. Empleado"; Code[20])
        {
            Caption = 'Employee S.S. Credit Account', Comment = 'ESP="Cta. haber S.S. empleado"';
            TableRelation = "G/L Account";
        }
        field(51010; "Cta. Personal cocina y comedor"; Code[20])
        {
            Caption = 'Kitchen and Dining Staff Account', Comment = 'ESP="Cta. personal cocina y comedor"';
            TableRelation = "G/L Account";
        }
        field(51011; "Cta. Personal vigilancia/Rec."; Code[20])
        {
            Caption = 'Security/Reception Staff Account', Comment = 'ESP="Cta. personal vigilancia/rec."';
            TableRelation = "G/L Account";
        }
        field(51012; "Cta. Personal limpieza"; Code[20])
        {
            Caption = 'Cleaning Staff Account', Comment = 'ESP="Cta. personal limpieza"';
            TableRelation = "G/L Account";
        }
        field(51013; "Cta. Personal bibloteca"; Code[20])
        {
            Caption = 'Library Staff Account', Comment = 'ESP="Cta. personal bibloteca"';
            TableRelation = "G/L Account";
        }
        field(51014; "Cta. Personal enfermería"; Code[20])
        {
            Caption = 'Nursing Staff Account', Comment = 'ESP="Cta. personal enfermería"';
            TableRelation = "G/L Account";
        }
        field(51015; "Cta. Otro Personal Colaborador"; Code[20])
        {
            Caption = 'Other Collaborating Staff Account', Comment = 'ESP="Cta. otro personal colaborador"';
            TableRelation = "G/L Account";
        }
        field(51016; "Dimension Actividad"; Code[20])
        {
            Caption = 'Activity Dimension', Comment = 'ESP="Dimensión actividad"';
            AccessByPermission = TableData "Dimension Combination" = R;
            TableRelation = Dimension;
        }
        field(51017; "Dimension Etapa"; Code[20])
        {
            Caption = 'Stage Dimension', Comment = 'ESP="Dimensión etapa"';
            AccessByPermission = TableData "Dimension Combination" = R;
            TableRelation = Dimension;
        }
        field(51018; "Cta. debe IT"; Code[20])
        {
            Caption = 'IT Debit Account', Comment = 'ESP="Cta. debe IT"';
            TableRelation = "G/L Account";
        }
        field(51019; "Cta. haber IT Pers. Vig./Rec."; Code[20])
        {
            Caption = 'IT Credit Account Sec./Rec. Staff', Comment = 'ESP="Cta. haber IT pers. vig./rec."';
            TableRelation = "G/L Account";
        }
        field(51021; "Cta. haber IT Pers. C/C"; Code[20])
        {
            Caption = 'IT Credit Account K/D Staff', Comment = 'ESP="Cta. haber IT pers. C/C"';
            TableRelation = "G/L Account";
        }
        field(51023; "Cta. haber IT Pers. limpieza"; Code[20])
        {
            Caption = 'IT Credit Account Cleaning Staff', Comment = 'ESP="Cta. haber IT pers. limpieza"';
            TableRelation = "G/L Account";
        }
        field(51025; "Cta. haber IT Pers. enfermeria"; Code[20])
        {
            Caption = 'IT Credit Account Nursing Staff', Comment = 'ESP="Cta. haber IT pers. enfermería"';
            TableRelation = "G/L Account";
        }
        field(51027; "Cta. haber IT Pers. bibloteca"; Code[20])
        {
            Caption = 'IT Credit Account Library Staff', Comment = 'ESP="Cta. haber IT pers. bibloteca"';
            TableRelation = "G/L Account";
        }
        field(51029; "Cta. haber IT Otro colaborador"; Code[20])
        {
            Caption = 'IT Credit Account Other Collaborator', Comment = 'ESP="Cta. haber IT otro colaborador"';
            TableRelation = "G/L Account";
        }
    }

    var
        cFuncionesPLC: Codeunit "Functions S2G";
}
