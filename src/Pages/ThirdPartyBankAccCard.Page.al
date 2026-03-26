page 50082 "Third Party Bank Acc. Card"
{
    // // Mod. S2G 18/12/2017 (JGS) : TER001 ã Terceros.

    Caption = 'Third Party Bank Acc. Card', Comment = 'ESP="Ficha cuenta bancaria tercero"';
    PageType = Card;
    SourceTable = "Third Party Bank Account";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the address of the bank where the vendor has the bank account.', Comment = 'ESP="Especifica la dirección del banco donde el proveedor tiene la cuenta bancaria."';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies additional address information.', Comment = 'ESP="Especifica información adicional de la dirección."';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code.', Comment = 'ESP="Especifica el código postal."';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the city of the bank where the vendor has the bank account.', Comment = 'ESP="Especifica la ciudad del banco donde el proveedor tiene la cuenta bancaria."';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region of the address.', Comment = 'ESP="Especifica el país o región de la dirección."';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the telephone number of the bank where the vendor has the bank account.', Comment = 'ESP="Especifica el número de teléfono del banco donde el proveedor tiene la cuenta bancaria."';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the bank employee regularly contacted in connection with this bank account.', Comment = 'ESP="Especifica el nombre del empleado del banco con el que se contacta habitualmente en relación con esta cuenta bancaria."';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the relevant currency code for the bank account.', Comment = 'ESP="Especifica el código de divisa correspondiente a la cuenta bancaria."';
                }
                field("Transit No."; Rec."Transit No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a bank identification number of your own choice.', Comment = 'ESP="Especifica un número de identificación bancaria de su elección."';
                }
                field("Use For Electronic Payments"; Rec."Use For Electronic Payments")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Determines if this vendor bank account to be used for electronic payments.', Comment = 'ESP="Determina si esta cuenta bancaria del proveedor debe utilizarse para pagos electrónicos."';

                    trigger OnValidate()
                    begin
                        //UseForElectronicPaymentsOnPush;
                    end;
                }
            }
            group(Communication)
            {
                Caption = 'Communication', Comment = 'ESP="Comunicación"';
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the fax number of the bank where the vendor has the bank account.', Comment = 'ESP="Especifica el número de fax del banco donde el proveedor tiene la cuenta bancaria."';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the email address associated with the bank account.', Comment = 'ESP="Especifica la dirección de correo electrónico asociada a la cuenta bancaria."';
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the home page address associated with the bank account.', Comment = 'ESP="Especifica la dirección de la página web asociada a la cuenta bancaria."';
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer', Comment = 'ESP="Transferencia"';
                field("CCC Bank No."; Rec."CCC Bank No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the bank account code. This code is the first part of the Codigo Cuenta Cliente (CCC) number.', Comment = 'ESP="Especifica el código de la cuenta bancaria. Este código es la primera parte del número Código Cuenta Cliente (CCC)."';
                }
                field("CCC Bank Branch No."; Rec."CCC Bank Branch No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the four-digit bank office number. This number is the second part of the Codigo Cuenta Cliente (CCC) number.', Comment = 'ESP="Especifica el número de cuatro dígitos de la oficina bancaria. Este número es la segunda parte del número Código Cuenta Cliente (CCC)."';
                }
                field("CCC Control Digits"; Rec."CCC Control Digits")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the two-digit account control code. This number is the third part of the Codigo Cuenta Cliente (CCC) number.', Comment = 'ESP="Especifica el código de control de la cuenta de dos dígitos. Este número es la tercera parte del número Código Cuenta Cliente (CCC)."';
                }
                field("CCC Bank Account No."; Rec."CCC Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the company''s bank account code.', Comment = 'ESP="Especifica el código de la cuenta bancaria de la empresa."';
                }
                field("CCC No."; Rec."CCC No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Codigo Cuenta Cliente (CCC) number.', Comment = 'ESP="Especifica el número Código Cuenta Cliente (CCC)."';
                }
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the bank where the vendor has the account.', Comment = 'ESP="Especifica el código SWIFT (código internacional de identificación bancaria) del banco donde el proveedor tiene la cuenta."';
                }
                field(IBAN; Rec.IBAN)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the bank account''s international bank account number.', Comment = 'ESP="Especifica el número internacional de cuenta bancaria de la cuenta."';
                }
                field("Bank Clearing Standard"; Rec."Bank Clearing Standard")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the format standard to be used in bank transfers if you use the Bank Clearing Code field to identify you as the sender.', Comment = 'ESP="Especifica el formato estándar que se utilizará en las transferencias bancarias si usa el campo Código de compensación bancaria para identificarse como remitente."';
                }
                field("Bank Clearing Code"; Rec."Bank Clearing Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code for bank clearing that is required according to the format standard you selected in the Bank Clearing Standard field.', Comment = 'ESP="Especifica el código de compensación bancaria requerido según el formato estándar que haya seleccionado en el campo Estándar de compensación bancaria."';
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
