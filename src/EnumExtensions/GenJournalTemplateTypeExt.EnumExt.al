enumextension 50000 "Gen. Journal Template Type Ext" extends "Gen. Journal Template Type"
{
    // Mod. S2G (EPV) 19/02/18 RSIM Registro Simplificado
    //                         Opción
    //                           Type
    //                             Cash Register

    //Se crean dos para dejar valores en id 50000 y luego eliminamos los 16 y 17
    value(16; "Easy Register") { Caption = 'Registro Simple'; } //Eliminar al ejecutar report regenera
    value(17; "Cash Register") { Caption = 'Caja'; } //Eliminar al ejecutar report regenera
    value(50000; EasyRegister) { Caption = 'Registro Simple'; }
    value(50001; CashRegister) { Caption = 'Caja'; }
}
