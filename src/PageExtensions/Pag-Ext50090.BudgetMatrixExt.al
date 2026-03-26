pageextension 50090 "Budget Matrix Ext" extends "Budget Matrix"
{
    // (CR001) S2G (RBM-R) 09-08-18: Comentarios en presupuestos
    // (CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple

    layout
    {
        addafter(TotalBudgetedAmount)
        {
            //TODO-MIG
            // field("Comentario ppto."; Rec.fGetBudgetComment(GLBudgetName.Name))
            // {
            //     ApplicationArea = All;
            // }
            field(vLastYearBudget; vLastYearBudget)
            {
                CaptionClass = fGetName;
                Editable = false;
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
        vLastYearBudget := 0;
        vLastYearReal := 0;
        Rec.fCalculateNewFields(Rec.Code, vLastYearBudget, vLastYearReal);
        //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin
    end;

    local procedure fGetName(): Text
    begin
        //(CR001) S2G (RBM-R) 09-08-18: Comentarios en presupuestos
        //EXIT(STRSUBSTNO(Text003, DATE2DMY(TODAY, 3)-1));
        EXIT(Text004Lbl);
    end;

    var
        vLastYearBudget: Decimal;
        vLastYearReal: Decimal;
        Text004Lbl: Label 'Presupuesto anterior';
}
