table 50200 "EDUCAMOS Remesa"
{
    fields
    {
        field(1; remesaId; Text[50])
        {
            Caption = 'Remittance ID', Comment = 'ESP="Id de la remesa"';
        }
        field(2; "ID Remesa BC"; Text[50])
        {
            Caption = 'BC Remittance ID', Comment = 'ESP="ID Remesa BC"';
        }
        field(3; descripcion; Text[250])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(4; reducido; Text[100])
        {
            Caption = 'Short Description', Comment = 'ESP="Reducido"';
        }
        field(5; periodoFacturacionId; Text[50])
        {
            Caption = 'Billing Period ID', Comment = 'ESP="Id periodo facturación"';
        }
        field(6; nombrePeriodo; Text[150])
        {
            Caption = 'Period Name', Comment = 'ESP="Nombre del periodo"';
        }
        field(7; pagadorComun; Boolean)
        {
            Caption = 'Common Payer', Comment = 'ESP="Pagador común"';
        }
        field(8; fechaCreacion; DateTime)
        {
            Caption = 'Creation DateTime', Comment = 'ESP="Fecha creación"';
        }
        field(9; fechaEmision; Date)
        {
            Caption = 'Issue Date', Comment = 'ESP="Fecha emisión"';
        }
        field(10; importe; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(11; ordenanteCuentaBancariaId; Text[50])
        {
            Caption = 'Ordering Party Bank Account ID', Comment = 'ESP="Id cuenta bancaria ordenante"';
        }
        field(12; ordenante; Text[150])
        {
            Caption = 'Ordering Party', Comment = 'ESP="Ordenante"';
        }
        field(13; presentador; Text[150])
        {
            Caption = 'Presenter', Comment = 'ESP="Presentador"';
        }
        field(14; datosBancarios; Text[250])
        {
            Caption = 'Bank Data', Comment = 'ESP="Datos bancarios"';
        }
        field(15; fechaCargo; Date)
        {
            Caption = 'Charge Date', Comment = 'ESP="Fecha de cargo"';
        }
        field(16; cuadernoBancario; Text[50])
        {
            Caption = 'Bank Format', Comment = 'ESP="Cuaderno bancario"';
        }
        field(17; esquemaSEPA; Text[50])
        {
            Caption = 'SEPA Scheme', Comment = 'ESP="Esquema SEPA"';
        }
        field(18; textoReciboRecargo; Text[250])
        {
            Caption = 'Surcharge Text', Comment = 'ESP="Texto recibo recargo"';
        }
        field(19; importeRecargo; Decimal)
        {
            Caption = 'Surcharge Amount', Comment = 'ESP="Importe recargo"';
        }
        field(20; numeroRecibosBanco; Integer)
        {
            Caption = 'Bank Receipt Count', Comment = 'ESP="Número recibos banco"';
        }
        field(21; importeTotalBanco; Decimal)
        {
            Caption = 'Total Bank Amount', Comment = 'ESP="Importe total banco"';
        }
        field(22; numeroRecibosVentanilla; Integer)
        {
            Caption = 'Window Receipt Count', Comment = 'ESP="Número recibos ventanilla"';
        }
        field(23; importeTotalVentanilla; Decimal)
        {
            Caption = 'Total Window Amount', Comment = 'ESP="Importe total ventanilla"';
        }
        field(24; esRemitida; Boolean)
        {
            Caption = 'Is Sent', Comment = 'ESP="Es remitida"';
        }
        field(40; "Importation DateTime"; DateTime)
        {
            Caption = 'Import Date/Time', Comment = 'ESP="Fecha y hora de importación"';
        }
        field(41; Processed; Boolean)
        {
            Caption = 'Processed', Comment = 'ESP="Procesado"';
        }
    }

    keys
    {
        key(PK; remesaId)
        {
            Clustered = true;
        }
        key(Key2; Processed, ordenante)
        {
        }
    }

    fieldgroups
    {
    }
}