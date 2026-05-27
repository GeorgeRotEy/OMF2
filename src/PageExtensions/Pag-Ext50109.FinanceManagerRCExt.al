pageextension 50109 "Finance Manager RC Ext" extends "Finance Manager Role Center"
{
    actions
    {
        addafter("Detail Trial Balance")
        {
            action("Main Accounting Book Schools")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Libro mayor OFM Colegios';
                Image = Report;
                RunObject = Report "Main Accounting Book Schools";
                ToolTip = 'Ejecuta el informe Libro mayor OFM Colegios.';
            }
        }
    }
}

pageextension 50110 "Accountant RC Ext" extends "Accountant Role Center"
{
    actions
    {
        addlast("G/L Reports")
        {
            action("Main Accounting Book Schools")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Libro mayor OFM Colegios';
                Image = Report;
                RunObject = Report "Main Accounting Book Schools";
                ToolTip = 'Ejecuta el informe Libro mayor OFM Colegios.';
            }
        }
    }
}

pageextension 50111 "Accounting Manager RC Ext" extends "Accounting Manager Role Center"
{
    actions
    {
        addafter("Detail Account Statement")
        {
            action("Main Accounting Book Schools")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Libro mayor OFM Colegios';
                Image = Report;
                RunObject = Report "Main Accounting Book Schools";
                ToolTip = 'Ejecuta el informe Libro mayor OFM Colegios.';
            }
        }
    }
}
