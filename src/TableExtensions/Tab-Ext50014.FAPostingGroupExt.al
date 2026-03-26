tableextension 50014 "FA Posting Group Ext" extends "FA Posting Group"
{
    fields
    {
        field(50000; "Related Straight-Line %"; Decimal)
        {
            Caption = 'Related Straight-Line %', Comment = 'ESP="Porcentaje lineal relacionado"';
            MinValue = 0;
        }
    }
}
