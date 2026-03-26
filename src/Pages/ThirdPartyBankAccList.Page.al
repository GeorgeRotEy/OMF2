page 50083 "Third Party Bank Acc. List"
{
    // // Mod. S2G 18/12/2017 (JGS) : TER001 ã Terceros.

    Caption = 'Third Party Bank Acc. List', Comment = 'ESP="Lista cuentas bancarias tercero"';
    CardPageID = "Third Party Bank Acc. Card";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Third Party Bank Account";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the postal code of the address.', Comment = 'ESP="Especifica el código postal de la dirección."';
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the country/region code of the address.', Comment = 'ESP="Especifica el código de país o región de la dirección."';
                    Visible = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the telephone number of the bank where the vendor has the bank account.', Comment = 'ESP="Especifica el número de teléfono del banco donde el proveedor tiene la cuenta bancaria."';
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ToolTip = 'Specifies the fax number associated with the address.', Comment = 'ESP="Especifica el número de fax asociado a la dirección."';
                    Visible = false;
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the bank employee regularly contacted in connection with this bank account.', Comment = 'ESP="Especifica el nombre del empleado del banco con el que se contacta habitualmente en relación con esta cuenta bancaria."';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number used by the bank for the bank account.', Comment = 'ESP="Especifica el número que utiliza el banco para la cuenta bancaria."';
                    Visible = false;
                }
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the bank where the vendor has the account.', Comment = 'ESP="Especifica el código SWIFT (código internacional de identificación bancaria) del banco donde el proveedor tiene la cuenta."';
                    Visible = false;
                }
                field(IBAN; Rec.IBAN)
                {
                    ToolTip = 'Specifies the bank account''s international bank account number.', Comment = 'ESP="Especifica el número internacional de cuenta bancaria de la cuenta."';
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the relevant currency code for the bank account.', Comment = 'ESP="Especifica el código de divisa correspondiente a la cuenta bancaria."';
                    Visible = false;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a code that determines the language associated with this bank account.', Comment = 'ESP="Especifica un código que determina el idioma asociado a esta cuenta bancaria."';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}
