table 50219 "EDUCAMOS Remesa"
{
    fields
    {
        field(1; calendarioEscolarId; Text[50])
        {
            Caption = 'School Calendar ID', Comment = 'ESP="ID calendario escolar"';
        }
        field(2; remesaId; Text[50])
        {
            Caption = 'Remittance ID', Comment = 'ESP="Id de la remesa"';
        }
        field(3; "ID Remesa BC"; Integer)
        {
            Caption = 'BC Remittance ID', Comment = 'ESP="ID Remesa BC"';
        }
        field(4; descripcion; Text[250])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(5; reducido; Text[100])
        {
            Caption = 'Short Description', Comment = 'ESP="Reducido"';
        }
        field(6; periodoFacturacionId; Text[50])
        {
            Caption = 'Billing Period ID', Comment = 'ESP="Id periodo facturación"';
        }
        field(7; nombrePeriodo; Text[150])
        {
            Caption = 'Period Name', Comment = 'ESP="Nombre del periodo"';
        }
        field(8; pagadorComun; Boolean)
        {
            Caption = 'Common Payer', Comment = 'ESP="Pagador común"';
        }
        field(9; fechaCreacion; DateTime)
        {
            Caption = 'Creation DateTime', Comment = 'ESP="Fecha creación"';
        }
        field(10; fechaEmision; Date)
        {
            Caption = 'Issue Date', Comment = 'ESP="Fecha emisión"';
        }
        field(11; importe; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(12; ordenanteCuentaBancariaId; Text[50])
        {
            Caption = 'Ordering Party Bank Account ID', Comment = 'ESP="Id cuenta bancaria ordenante"';
        }
        field(13; ordenante; Text[150])
        {
            Caption = 'Ordering Party', Comment = 'ESP="Ordenante"';
        }
        field(14; presentador; Text[150])
        {
            Caption = 'Presenter', Comment = 'ESP="Presentador"';
        }
        field(15; datosBancarios; Text[250])
        {
            Caption = 'Bank Data', Comment = 'ESP="Datos bancarios"';
        }
        field(16; fechaCargo; Date)
        {
            Caption = 'Charge Date', Comment = 'ESP="Fecha de cargo"';
        }
        field(17; cuadernoBancario; Text[50])
        {
            Caption = 'Bank Format', Comment = 'ESP="Cuaderno bancario"';
        }
        field(18; esquemaSEPA; Text[50])
        {
            Caption = 'SEPA Scheme', Comment = 'ESP="Esquema SEPA"';
        }
        field(19; textoReciboRecargo; Text[250])
        {
            Caption = 'Surcharge Text', Comment = 'ESP="Texto recibo recargo"';
        }
        field(20; importeRecargo; Decimal)
        {
            Caption = 'Surcharge Amount', Comment = 'ESP="Importe recargo"';
        }
        field(21; numeroRecibosBanco; Integer)
        {
            Caption = 'Bank Receipt Count', Comment = 'ESP="Número recibos banco"';
        }
        field(22; importeTotalBanco; Decimal)
        {
            Caption = 'Total Bank Amount', Comment = 'ESP="Importe total banco"';
        }
        field(23; numeroRecibosVentanilla; Integer)
        {
            Caption = 'Window Receipt Count', Comment = 'ESP="Número recibos ventanilla"';
        }
        field(24; importeTotalVentanilla; Decimal)
        {
            Caption = 'Total Window Amount', Comment = 'ESP="Importe total ventanilla"';
        }
        field(25; esRemitida; Boolean)
        {
            Caption = 'Is Sent', Comment = 'ESP="Es remitida"';
        }
        field(70; "Importation DateTime"; DateTime)
        {
            Caption = 'Import Date/Time', Comment = 'ESP="Fecha y hora de importación"';
        }
        field(71; Processed; Boolean)
        {
            Caption = 'Processed', Comment = 'ESP="Procesado"';
        }
    }

    keys
    {
        key(PK; "ID Remesa BC")
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