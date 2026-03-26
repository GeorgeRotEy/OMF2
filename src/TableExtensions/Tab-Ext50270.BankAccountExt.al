tableextension 50270 "Bank Account Ext" extends "Bank Account"
{
    fields
    {
        modify("CCC Bank No.")
        {
            TableRelation = "CCC Cod. Bancos"."CCC Bank No.";
        }
        field(50001; "Main Bank"; Text[50])
        {
            Caption = 'Main Bank', Comment = 'ESP="Banco principal"';
            TableRelation = "Main Bank Table"."Main Bank";
        }
    }
}