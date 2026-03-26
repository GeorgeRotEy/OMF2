report 50008 "Copy GLAccount to Distribute"
{
    Caption = 'Copy GLAccount to Distribute', Comment = 'ESP="Copiar cuenta contable a distribuir"';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            trigger OnAfterGetRecord()
            begin
                rDistributionSchedule.INIT();
                rDistributionSchedule."No." := "G/L Account"."No.";
                rDistributionSchedule.Name := "G/L Account".Name;
                rDistributionSchedule.Totaling := "G/L Account".Totaling;
                rDistributionSchedule.Blocked := "G/L Account".Blocked;
                rDistributionSchedule."Last date modified" := TODAY;
                rDistributionSchedule."Modified by" := USERID();
                rDistributionSchedule.Indentation := "G/L Account".Indentation;
                rDistributionSchedule."Dimension filter 1" := "G/L Account"."Global Dimension 1 Filter";
                rDistributionSchedule."Dimension filter 2" := "G/L Account"."Global Dimension 2 Filter";

                //
                rDistributionSchedule."Interval of GC accounts" := "G/L Account"."No.";
                //

                rDistributionSchedule.INSERT(TRUE);
            end;

            trigger OnPreDataItem()
            begin
                //"G/L Account".SETRANGE("Incluir en reparto analítico",TRUE);
                "G/L Account".SETFILTER("No.", vFiltroCuenta);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(vFiltroCuenta; vFiltroCuenta)
                    {
                        Caption = 'Account filter', Comment = 'ESP="Filtro cuenta"';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        rDistributionSchedule: Record "Schedule of Distrib. Accounts";
        vFiltroCuenta: Text;
}
