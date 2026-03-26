page 50084 "Business Group Setup"
{
    // // Mod. S2G 18/12/2017 (JGS) : TER001 ã Terceros.

    Caption = 'Business Group Setup', Comment = 'ESP="Configuración grupo empresarial"';
    PageType = Card;
    SourceTable = "Business Group Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Terceros)
            {
                field("Last Third Party No."; Rec."Last Third Party No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}
