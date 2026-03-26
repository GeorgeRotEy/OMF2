pageextension 50002 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    // Mod. S2G 16/12/2017 (JGS) : GF001 � Plan de cuentas corporativo.
    layout
    {
        addafter("Bank Account Nos.")
        {
            field("Nº Serie Donaciones"; Rec."Nº Serie Donaciones")
            {
                ApplicationArea = All;
            }
        }
        addafter("Shortcut Dimension 8 Code")
        {
            field("Dim. Partida Presupuestaria"; Rec."Dim. Partida Presupuestaria")
            {
                ApplicationArea = All;
            }
            field("Dimension Actividad"; Rec."Dimension Actividad")
            {
                ApplicationArea = All;
            }
            field("Dimension Etapa"; Rec."Dimension Etapa")
            {
                ApplicationArea = All;
            }
        }
        addafter(Application)
        {
            group(Other)
            {
                Caption = 'Other', Comment = 'ESP="Otros"';

                field("Tipo gestión plan de cuentas"; Rec."Tipo gestión plan de cuentas")
                {
                    ApplicationArea = All;
                }
            }
            group("Cuentas Registro Simple Nominas")
            {
                Caption = 'Cuentas Registro Simple Nóminas';
                group(Group1)
                {
                    ShowCaption = false;
                    field("Cta. IRPF"; Rec."Cta. IRPF")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. Importe Líquido"; Rec."Cta. Importe Líquido")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. debe S.S. Empresa"; Rec."Cta. debe S.S. Empresa")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. haber S.S. Empleado"; Rec."Cta. haber S.S. Empleado")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. debe S.S. Empleado"; Rec."Cta. debe S.S. Empleado")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. haber S.S. Empresa"; Rec."Cta. haber S.S. Empresa")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. Personal cocina y comedor"; Rec."Cta. Personal cocina y comedor")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. Personal vigilancia/Rec."; Rec."Cta. Personal vigilancia/Rec.")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. Personal limpieza"; Rec."Cta. Personal limpieza")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. Personal bibloteca"; Rec."Cta. Personal bibloteca")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. Personal enfermería"; Rec."Cta. Personal enfermería")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. Otro Personal Colaborador"; Rec."Cta. Otro Personal Colaborador")
                    {
                        ApplicationArea = All;
                    }
                }
                group(IT)
                {
                    Caption = 'Temporary Disability', Comment = 'ESP="Incapacidad temporal"';
                    field("Cta. debe IT"; Rec."Cta. debe IT")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. haber IT Pers. Vig./Rec."; Rec."Cta. haber IT Pers. Vig./Rec.")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. haber IT Pers. C/C"; Rec."Cta. haber IT Pers. C/C")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. haber IT Pers. limpieza"; Rec."Cta. haber IT Pers. limpieza")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. haber IT Pers. enfermeria"; Rec."Cta. haber IT Pers. enfermeria")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. haber IT Pers. bibloteca"; Rec."Cta. haber IT Pers. bibloteca")
                    {
                        ApplicationArea = All;
                    }
                    field("Cta. haber IT Otro colaborador"; Rec."Cta. haber IT Otro colaborador")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
}
