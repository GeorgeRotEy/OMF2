page 50061 "Page Employment SSD"
{
    SourceTable = "Employment SSD";
    Caption = 'Employment SSD', Comment = 'ESP="Empleo SSD"';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(DATOS)
            {
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                }
                field("Social Security Number"; Rec."Social Security Number")
                {
                }
                field("Digital Access"; Rec."Digital Access")
                {
                }
            }
            group("SITUACION LABORAL")
            {
                field(Asset; Rec.Asset)
                {
                }
                field("General scheme"; Rec."General scheme")
                {
                }
                field(Freelance; Rec.Freelance)
                {
                }
                field(Dioceses; Rec.Dioceses)
                {
                }
                field(PaySheet; Rec.PaySheet)
                {
                }
                field("Trade-Position"; Rec."Trade-Position")
                {
                }
                field(Share; Rec.Share)
                {
                }
                field(Base; Rec.Base)
                {
                }
                field("Medical insurance amount"; Rec."Medical insurance amount")
                {
                }
                field(Pensioners; Rec.Pensioners)
                {
                }
                field("Work Life"; Rec."Work Life")
                {
                }
            }
            group("SEGURO MEDICO")
            {
                field(Firm; Rec.Firm)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
            }
            group(OBSERVACIONES)
            {
                field(Comments; Rec.Comments)
                {
                }
            }
        }
    }

    actions
    {
    }
}
