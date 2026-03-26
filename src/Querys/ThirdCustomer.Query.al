query 50001 ThirdCustomer
{
    Caption = 'Third Customer', Comment = 'ESP="Tercero cliente"';
    elements
    {
        dataitem(Customer; Customer)
        {
            column(No; "No.")
            {
            }
            column(Third_Party_No; "Third Party No.")
            {
            }
        }
    }
}
