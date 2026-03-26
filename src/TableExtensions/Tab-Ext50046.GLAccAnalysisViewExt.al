tableextension 50046 "G/L Acc.(Analysis View) Ext" extends "G/L Account (Analysis View)"
{
    //Mod. S2G (CPA) <ANA001> - Ampliado el tipo con el valor Ditrs. Account

    fields
    {
        modify("No.")
        {
            TableRelation = IF ("Account Source" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Account Source" = CONST("Cash Flow Account")) "Cash Flow Account"
            ELSE IF ("Account Source" = FILTER("Distr. Account")) "Schedule of Distrib. Accounts";
        }
    }
}
