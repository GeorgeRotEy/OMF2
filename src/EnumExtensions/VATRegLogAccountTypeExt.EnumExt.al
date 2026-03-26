enumextension 50001 "VAT Reg. Log Account Type Ext" extends "VAT Registration Log Account Type"
{
    value(4; ThirdParty) { Caption = 'Tercero'; } //Eliminar al ejecutar report regenera
    value(50000; "Third Party") { Caption = 'Tercero'; }
    value(50001; PostThirdParty) { Caption = 'Alta Terceros'; }
}
