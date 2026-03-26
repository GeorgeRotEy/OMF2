pageextension 50000 "Company Info Ext" extends "Company Information"
{
    //Mód. S2G (SEG) 21/12/2017
    //   Nuevo campo : -ExtensionTelf
    //                 -Name 2

    layout
    {
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("CNAE Description")
        {
            field(ExtensionTelf; Rec.ExtensionTelf)
            {
                ApplicationArea = All;
            }
        }
        addafter(Picture)
        {
            group(Logos)
            {
                Caption = 'Logos';

                field(SelloEntidad; Rec.SelloEntidad)
                {
                    ApplicationArea = All;
                }
                field(LogoAzul; Rec.LogoAzul)
                {
                    ApplicationArea = All;
                }
                field(LogoColegio; Rec.LogoColegio)
                {
                    ApplicationArea = All;
                }
                field(SelloProvincia; Rec.SelloProvincia)
                {
                    ApplicationArea = All;
                }
                field(LogoNegro; Rec.LogoNegro)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}