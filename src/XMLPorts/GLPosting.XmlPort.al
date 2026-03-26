xmlport 50012 "G/L Posting"
{
    Caption = 'G/L Posting', Comment = 'ESP="Movimientos contables"';
    UseDefaultNamespace = true;

    schema
    {
        textelement(ListaMovContabilidad)
        {
            tableelement("G/L Entry"; "G/L Entry")
            {
                XmlName = 'GLPosting';
                fieldelement(FechaRegistro; "G/L Entry"."Posting Date")
                {
                }
                fieldelement(NumCuenta; "G/L Entry"."G/L Account No.")
                {
                }
                fieldelement(ConceptoContable; "G/L Entry"."Posting concept")
                {
                }
                fieldelement(ImporteDebe; "G/L Entry"."Debit Amount")
                {
                }
                fieldelement(ImporteHaber; "G/L Entry"."Credit Amount")
                {
                }
                textelement(NombreCuenta)
                {
                    MaxOccurs = Once;
                }

                trigger OnAfterGetRecord()
                begin
                    IF NOT rGLAcc.GET("G/L Entry"."G/L Account No.") THEN
                        CLEAR(rGLAcc);
                    NombreCuenta := rGLAcc.Name;
                end;

                trigger OnPreXmlItem()
                begin
                    IF vTransactionFilter <> '' THEN BEGIN
                        "G/L Entry".SETCURRENTKEY("Transaction No.");
                        "G/L Entry".SETFILTER("Transaction No.", vTransactionFilter);
                        "G/L Entry".SetRange("Source Code", vEasyRegJnl);
                    END;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }

    var
        vTransactionFilter: Text;
        vEasyRegJnl: Code[10];
        rGLAcc: Record "G/L Account";

    procedure fSetTransactionFilter(pEasyRegJnl: Code[10]; pLastEntry: Integer; pFirstEntry: Integer)
    begin
        vEasyRegJnl := pEasyRegJnl;
        vTransactionFilter := Format(pFirstEntry) + '..' + Format(pLastEntry);
    end;
    // procedure fSetTransactionNo(pTransactionNo: Integer)
    // begin
    //     vTransactionNo := pTransactionNo;
    // end;
}
