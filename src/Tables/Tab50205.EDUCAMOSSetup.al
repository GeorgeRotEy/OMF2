table 50205 "EDUCAMOS Setup" //EDUCAMOS
{
    // Mod. S2G (RBM-R) IN-001: Interfaz Educamos
    // (2.1) S2G (RBM-R) 13-04-20: Abono de recibos anulados
    fields
    {
        field(1; "Primary key"; Code[10])
        {
            Caption = 'Primary Key', Comment = 'ESP="Clave primaria"';
        }
        field(2; "Token URL"; Text[250])
        {
            Caption = 'Token URL', Comment = 'ESP="URL Token"';
        }
        field(3; "API URL"; Text[250])
        {
            Caption = 'Web Service URL', Comment = 'ESP="URL API"';
        }
        field(5; "Thirdparty Template Code"; Code[10]) //No cambiar ID
        {
            Caption = 'Third Party Template Code', Comment = 'ESP="Cód. plantilla tercero"';
            TableRelation = "Config. Template Header" WHERE("Table ID" = CONST(18));
        }
        field(6; "Ventanilla Payment Method"; Code[10]) //No cambiar ID
        {
            Caption = 'Ventanilla Payment Method', Comment = 'ESP="Cód. forma pago Ventanilla"';
            TableRelation = "Payment Method";
        }
        field(7; "Bank Payment Method"; Code[10]) //No cambiar ID
        {
            Caption = 'Bank Payment Method', Comment = 'ESP="Cód. forma pago Banco"';
            TableRelation = "Payment Method";
        }
        field(8; "API Version"; Text[30])
        {
            Caption = 'API Version', Comment = 'ESP="Versión API"';
        }
        field(9; "Client Id"; Text[150])
        {
            Caption = 'Client ID';
        }
        field(10; "Redirect URI"; Text[250])
        {
            Caption = 'Redirect URI';
        }
        field(11; "Auth Grant"; Code[150])
        {
            Caption = 'Auth Grant';
        }
    }

    keys
    {
        key(Key1; "Primary key")
        {
            Clustered = true;
        }
    }

    procedure SetPassword(pNewPassword: Text[215])
    var
        EncryptionManagement: Codeunit "Cryptography Management";
        vlNewPassword: Text;
    begin
        //Eliminamos la contraseña antigua si existe
        if IsolatedStorage.Contains(GetStorageKey(), DataScope::Module) then
            IsolatedStorage.Delete(GetStorageKey(), DataScope::Module);
        //Encripta la contraseña si es posible
        if EncryptionManagement.IsEncryptionEnabled() and EncryptionManagement.IsEncryptionPossible() then
            vlNewPassword := EncryptionManagement.EncryptText(pNewPassword);
        //Establece una nueva contraseña asociada al GUID generado en GetStorageKey
        IsolatedStorage.Set(GetStorageKey(), vlNewPassword, DataScope::Module);
    end;

    procedure GetPassword(): Text
    var
        EncryptionManagement: Codeunit "Cryptography Management";
        PasswordTxt: Text;
    begin
        //Comprueba si la contraseña está asociada por la clave
        if IsolatedStorage.Contains(GetStorageKey(), DataScope::Module) then begin
            //Recupera la contraseña existente
            IsolatedStorage.Get(GetStorageKey(), DataScope::Module, PasswordTxt);
            //Desencripta la contraseña si es posible
            if EncryptionManagement.IsEncryptionEnabled() and EncryptionManagement.IsEncryptionPossible() then
                PasswordTxt := EncryptionManagement.Decrypt(PasswordTxt);
            //Devuelve la contraseña
            exit(PasswordTxt);
        end;
    end;

    local procedure GetStorageKey(): Text
    var
        StorageKeyTxt: Label '82ec00c8-f1da-4e9f-b5fa-735c3fd8f3db', Locked = true;
    begin
        exit(StorageKeyTxt);
    end;

    procedure SetSubscriptionKey(pNewPassword: Text[215])
    var
        EncryptionManagement: Codeunit "Cryptography Management";
        vlNewPassword: Text;
    begin
        //Eliminamos la contraseña antigua si existe
        if IsolatedStorage.Contains(GetStorageSubscriptionKey(), DataScope::Module) then
            IsolatedStorage.Delete(GetStorageSubscriptionKey(), DataScope::Module);
        //Encripta la contraseña si es posible
        if EncryptionManagement.IsEncryptionEnabled() and EncryptionManagement.IsEncryptionPossible() then
            vlNewPassword := EncryptionManagement.EncryptText(pNewPassword);
        //Establece una nueva contraseña asociada al GUID generado en GetStorageKey
        IsolatedStorage.Set(GetStorageSubscriptionKey(), vlNewPassword, DataScope::Module);
    end;

    procedure GetSubscriptionKey(): Text
    var
        EncryptionManagement: Codeunit "Cryptography Management";
        PasswordTxt: Text;
    begin
        //Comprueba si la contraseña está asociada por la clave
        if IsolatedStorage.Contains(GetStorageSubscriptionKey(), DataScope::Module) then begin
            //Recupera la contraseña existente
            IsolatedStorage.Get(GetStorageSubscriptionKey(), DataScope::Module, PasswordTxt);
            //Desencripta la contraseña si es posible
            if EncryptionManagement.IsEncryptionEnabled() and EncryptionManagement.IsEncryptionPossible() then
                PasswordTxt := EncryptionManagement.Decrypt(PasswordTxt);
            //Devuelve la contraseña
            exit(PasswordTxt);
        end;
    end;

    local procedure GetStorageSubscriptionKey(): Text
    var
        StorageKeyTxt: Label 'ff1debf3-14e1-40a6-ac26-641d4b6d3172', Locked = true;
    begin
        exit(StorageKeyTxt);
    end;
}
