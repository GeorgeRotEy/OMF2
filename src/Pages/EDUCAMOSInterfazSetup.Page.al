page 50055 "EDUCAMOS Interfaz Setup"
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos
    Caption = 'EDUCAMOS Integration Setup', Comment = 'ESP="Config. integración EDUCAMOS"';
    InsertAllowed = false;
    SourceTable = "EDUCAMOS Setup";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Thirdparty Template Code"; Rec."Thirdparty Template Code")
                {
                    ApplicationArea = All;
                }
                field("Ventanilla Payment Method"; Rec."Ventanilla Payment Method")
                {
                    ApplicationArea = All;
                }
                field("Bank Payment Method"; Rec."Bank Payment Method")
                {
                    ApplicationArea = All;
                }
            }
            group(Authentication)
            {
                Caption = 'Authentication', Comment = 'ESP="Autenticación"';
                group(Token)
                {
                    field("Token URL"; Rec."Token URL")
                    {
                        ApplicationArea = All;
                    }
                    field("Auth Grant"; Rec."Auth Grant")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Authentication code obtained from EDUCAMOS after the first authentication process.', Comment = 'ESP="Código de autenticación obtenido de EDUCAMOS tras el primer proceso de autenticación"';
                    }
                    field("Redirect URI"; Rec."Redirect URI")
                    {
                        ApplicationArea = All;
                    }
                    field("Client Id"; Rec."Client Id")
                    {
                        ApplicationArea = All;
                    }
                    field("Client Secret"; vClientSecret)
                    {
                        ApplicationArea = All;
                        ExtendedDatatype = Masked;

                        trigger OnValidate()
                        begin
                            Rec.SetPassword(vClientSecret);
                            Commit();
                        end;
                    }
                }
                group(API)
                {
                    field("API URL"; Rec."API URL")
                    {
                        ApplicationArea = All;
                    }
                    field("Subscription Key"; vSubscriptionKey)
                    {
                        Caption = 'Subscription Key', Comment = 'ESP="Clave de suscripción"';
                        ToolTip = 'Subscription key taken from the EDUCAMOS APIs website.', Comment = 'ESP="Clave de suscripción sacada de la web de APIs de EDUCAMOS"';
                        ApplicationArea = All;
                        ExtendedDatatype = Masked;

                        trigger OnValidate()
                        begin
                            Rec.SetSubscriptionKey(vSubscriptionKey);
                            Commit();
                        end;
                    }
                    field("API Version"; Rec."API Version")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Test)
            {
                trigger OnAction()
                var
                    clAPIConection: Codeunit "EDUCAMOS API Management";
                begin
                    clAPIConection.Run();
                end;
            }
            action(Log)
            {
                RunObject = page "EDUCAMOS Integration Log";
            }
        }
        area(Promoted)
        {
            actionref(Test_Promoted; Test) { }
            actionref(Log_Promoted; Log) { }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end else begin
            vClientSecret := '*******';
            vSubscriptionKey := '*******';
        end;
    end;

    var
        vClientSecret: Text;
        vSubscriptionKey: Text;
}
