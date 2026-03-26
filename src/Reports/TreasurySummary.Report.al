report 50011 "Treasury Summary"
{
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/TreasurySummary.rdlc';
    Caption = 'Extracto de tesorería', Comment = 'ESP="Extracto de tesorería"';
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            CalcFields = "Net Change";
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE("No." = FILTER('570*|572*|4*'),
                                      "Account Type" = CONST(Posting));
            RequestFilterFields = "Date Filter";
            column(No_GLAccount; "G/L Account"."No.")
            {
            }
            column(Name_GLAccount; "G/L Account".Name)
            {
            }
            column(NetChange_GLAccount; "G/L Account"."Net Change")
            {
            }
            column(Logo; rCompanyInfo.Picture)
            {
            }

            trigger OnAfterGetRecord()
            begin
                vTotal += "G/L Account"."Net Change";
            end;

            trigger OnPreDataItem()
            begin
                rCompanyInfo.GET();
                rCompanyInfo.CALCFIELDS(Picture);

                vTotal := 0;
            end;
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        rCompanyInfo: Record "Company Information";
        vTotal: Decimal;
}
