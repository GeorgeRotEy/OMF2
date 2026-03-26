page 50011 Picture
{
    Caption = 'Picture', Comment = 'ESP="Imagen"';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    PopulateAllFields = false;
    ShowFilter = false;
    SourceTable = "Company Information";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(Picture; Rec.Picture)
            {
                Editable = false;
                ShowCaption = false;
            }
        }
    }

    actions
    {
    }
}
