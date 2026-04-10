namespace WS;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Purchases.Payables;
using Microsoft.Bank.Ledger;
using Microsoft.EServices.EDocument;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.Ledger;

permissionset 50002 "Web Service"
{
    Assignable = true;
    Permissions = tabledata "G/L Register" = RIMD,
        tabledata "Budget Control Setup" = RIMD,
        tabledata "G/L Entry" = RIMD,
        tabledata "Bank Account Ledger Entry" = RIMD,
        tabledata "Vendor Ledger Entry" = RIMD,
        tabledata "SII Setup" = RIMD,
        tabledata "Fixed Asset" = RIMD,
        tabledata Microsoft.FixedAssets.Ledger."FA Ledger Entry" = RIMD,
        table "G/L Register" = X,
        table "Budget Control Setup" = X,
        table "G/L Entry" = X,
        table "Bank Account Ledger Entry" = X,
        table "Vendor Ledger Entry" = X,
        table "SII Setup" = X,
        table "Fixed Asset" = X;
}