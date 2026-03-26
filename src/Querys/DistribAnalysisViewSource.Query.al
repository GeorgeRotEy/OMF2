query 50000 "Distrib. Analysis View Source"
{
    Caption = 'Analysis View Source', Comment = 'ESP="Origen vista analítica distribución"';

    elements
    {
        dataitem(Analysis_View; "Analysis View")
        {
            filter(AnalysisViewCode; "Code")
            {
            }
            dataitem(Distribution_Entry; "Distribution Entry")
            {
                SqlJoinType = CrossJoin;
                filter(EntryNo; "Entry No.")
                {
                }
                column(DistrbAccNo; "Distrib. account no.")
                {
                }
                column(BusinessUnitCode; "Business Unit Code")
                {
                }
                column(PostingDate; "Posting date")
                {
                }
                column(DimensionSetID; "Dimension Set Id")
                {
                }
                column(Amount; Amount)
                {
                    Method = Sum;
                }
                column(DebitAmount; "Debit amount")
                {
                    Method = Sum;
                }
                column(CreditAmount; "Credit amount")
                {
                    Method = Sum;
                }
                dataitem(DimSet1; "Dimension Set Entry")
                {
                    DataItemLink = "Dimension Set ID" = Distribution_Entry."Dimension Set Id",
                                                        "Dimension Code" = Analysis_View."Dimension 1 Code";
                    column(DimVal1; "Dimension Value Code")
                    {
                    }
                    dataitem(DimSet2; "Dimension Set Entry")
                    {
                        DataItemLink = "Dimension Set ID" = Distribution_Entry."Dimension Set Id",
                                                            "Dimension Code" = Analysis_View."Dimension 2 Code";
                        column(DimVal2; "Dimension Value Code")
                        {
                        }
                        dataitem(DimSet3; "Dimension Set Entry")
                        {
                            DataItemLink = "Dimension Set ID" = Distribution_Entry."Dimension Set Id",
                                                                "Dimension Code" = Analysis_View."Dimension 3 Code";
                            column(DimVal3; "Dimension Value Code")
                            {
                            }
                            dataitem(DimSet4; "Dimension Set Entry")
                            {
                                DataItemLink = "Dimension Set ID" = Distribution_Entry."Dimension Set Id",
                                                                    "Dimension Code" = Analysis_View."Dimension 4 Code";
                                column(DimVal4; "Dimension Value Code")
                                {
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
