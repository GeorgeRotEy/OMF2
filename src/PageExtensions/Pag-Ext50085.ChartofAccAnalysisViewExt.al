pageextension 50085 "Chart of Acc Analysis View Ext" extends "Chart of Accs. (Analysis View)"
{
    //GR-02022026
    // Mód. S2G (CPA) <ANA001> 22-11-17 - Contabilidad analítica

    procedure InsertTempDistrAccAnalysisViews(var DistrAcc: Record "Schedule of Distrib. Accounts")
    begin
        IF DistrAcc.FIND('-') THEN
            REPEAT
                Rec.INIT();
                Rec."No." := DistrAcc."No.";
                Rec.Name := DistrAcc.Name;
                Rec."Account Type" := DistrAcc.Type;
                Rec.Blocked := DistrAcc.Blocked;
                Rec."New Page" := FALSE;// DistrAcc."New Page";
                Rec."No. of Blank Lines" := 0;//DistrAcc."No. of Blank Lines";
                Rec.Indentation := 0;//DistrAcc.Indentation;
                Rec."Last Date Modified" := DistrAcc."Last date modified";
                Rec.Totaling := DistrAcc.Totaling;
                Rec.Comment := FALSE;//.Comment;
                Rec."Account Source" := Rec."Account Source"::"Distribution Account";
                Rec.INSERT();
            UNTIL DistrAcc.NEXT() = 0;
    end;
}
