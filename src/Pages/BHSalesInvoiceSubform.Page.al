page 50045 "BH.Sales Invoice Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines', Comment = 'ESP="Líneas"';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = FILTER(Invoice));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.', Comment = 'ESP="Especifica el tipo de entidad que se contabilizará para esta línea de venta, como Artículo, Recurso o Cuenta de G/L."';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate;

                        IF xRec."No." <> '' THEN
                            RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.', Comment = 'ESP="Especifica el número de una cuenta de contabilidad, artículo, recurso, coste adicional o activo fijo, dependiendo del contenido del campo Tipo."';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate;
                        UpdateEditableOnRow;
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        IF xRec."No." <> '' THEN
                            RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies a description of the entry, which is based on the contents of the Type and No. fields.', Comment = 'ESP="Especifica una descripción del movimiento, basada en el contenido de los campos Tipo y Nº."';

                    trigger OnValidate()
                    begin
                        UpdateEditableOnRow;

                        IF Rec."No." = xRec."No." THEN
                            EXIT;

                        NoOnAfterValidate;
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        IF xRec."No." <> '' THEN
                            RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = NOT RowIsText;
                    Enabled = NOT RowIsText;
                    ShowMandatory = Rec."No." <> '';
                    ToolTip = 'Specifies how many units are being sold.', Comment = 'ESP="Especifica cuántas unidades se están vendiendo."';

                    trigger OnValidate()
                    begin
                        ValidateAutoReserve;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = NOT RowIsText;
                    Enabled = NOT RowIsText;
                    ShowMandatory = Rec."No." <> '';
                    ToolTip = 'Specifies how many units are being sold.', Comment = 'ESP="Especifica cuántas unidades se están vendiendo."';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = NOT RowIsText;
                    Enabled = NOT RowIsText;
                    ToolTip = 'Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.', Comment = 'ESP="Especifica el importe neto (antes de restar el importe del descuento de la factura) que debe pagarse por los artículos de la línea."';
                    Visible = true;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
            }
            group(Group1)
            {
                group(Group2)
                {
                    field(TotalSalesLine_LineAmount; TotalSalesLine."Line Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code, TotalSalesHeader."Prices Including VAT");
                        Caption = 'Subtotal Excl. VAT', Comment = 'ESP="Subtotal sin IVA"';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.', Comment = 'ESP="Especifica la suma del valor del campo Importe línea sin IVA en todas las líneas del documento."';
                    }
                    field("Invoice Discount Amount"; InvoiceDiscountAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(Rec.FIELDCAPTION("Inv. Discount Amount"), Currency.Code);
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount amount that is deducted from the value in the Total Incl. VAT field. You can enter or change the amount manually.', Comment = 'ESP="Especifica un importe de descuento que se deduce del valor en el campo Total con IVA. Puede introducir o cambiar el importe manualmente."';

                        trigger OnValidate()
                        begin
                            ValidateInvoiceDiscountAmount;
                        end;
                    }
                    field("Invoice Disc. Pct."; InvoiceDiscountPct)
                    {
                        ApplicationArea = Basic, Suite;
                        DecimalPlaces = 0 : 2;
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.', Comment = 'ESP="Especifica un porcentaje de descuento que se concede si se cumplen los criterios que haya configurado para el cliente."';

                        trigger OnValidate()
                        begin
                            InvoiceDiscountAmount := ROUND(TotalSalesLine."Line Amount" * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
                            ValidateInvoiceDiscountAmount;
                        end;
                    }
                }
                group(Group3)
                {
                    field("Total Amount Excl. VAT"; TotalSalesLine.Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                        DrillDown = false;
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.', Comment = 'ESP="Especifica la suma del valor en el campo Importe línea sin IVA en todas las líneas del documento menos cualquier importe de descuento en el campo Importe de descuento de factura."';
                    }
                    field("Total VAT Amount"; VATAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                        Editable = false;
                        ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.', Comment = 'ESP="Especifica la suma de los importes de IVA en todas las líneas del documento."';
                    }
                    field("Total Amount Incl. VAT"; TotalSalesLine."Amount Including VAT")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.', Comment = 'ESP="Especifica la suma del valor en el campo Importe línea con IVA en todas las líneas del documento menos cualquier importe de descuento en el campo Importe de descuento de factura."';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = 'Line',
                Comment = 'ESP="Línea"';
                Image = Line;
                group("F&unctions")
                {
                    Caption = 'Functions',
                Comment = 'ESP="Funciones"';
                    Image = "Action";
                    action("Get &Price")
                    {
                        AccessByPermission = TableData "Price List Line" = R;
                        Caption = 'Get &Price',
                        Comment = 'ESP="Obtener &precio"';
                        Ellipsis = true;
                        Image = Price;

                        trigger OnAction()
                        begin
                            ShowPrices
                        end;
                    }
                    action("Get Li&ne Discount")
                    {
                        AccessByPermission = TableData "Price List Line" = R;
                        Caption = 'Get Li&ne Discount', Comment = 'ESP="Obtener descuento de línea"';
                        Ellipsis = true;
                        Image = LineDiscount;

                        trigger OnAction()
                        begin
                            ShowLineDisc
                        end;
                    }
                    action("E&xplode BOM")
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        Caption = 'E&xplode BOM', Comment = 'ESP="Desglosar L.M. (Lista de Materiales)"';
                        Image = ExplodeBOM;

                        trigger OnAction()
                        begin
                            ExplodeBOM;
                        end;
                    }
                    action(InsertExtTexts)
                    {
                        AccessByPermission = TableData "Extended Text Header" = R;
                        ApplicationArea = Suite;
                        Caption = 'Insert &Ext. Texts', Comment = 'ESP="Insertar textos extendidos"';
                        Image = Text;
                        Scope = Repeater;
                        ToolTip = 'Insert the extended item description that is set up for the item on the sales document line.', Comment = 'ESP="Insertar la descripción extendida del artículo que está configurada para el artículo en la línea del documento de venta."';

                        trigger OnAction()
                        begin
                            InsertExtendedText(TRUE);
                        end;
                    }
                    action(GetShipmentLines)
                    {
                        AccessByPermission = TableData "Sales Shipment Header" = R;
                        Caption = 'Get Shipment Lines', Comment = 'ESP="Obtener líneas de envío"';
                        Ellipsis = true;
                        Image = Shipment;

                        trigger OnAction()
                        begin
                            GetShipment;
                        end;
                    }
                }
                group("Item Availability by")
                {
                    Caption = 'Get Shipment Lines', Comment = 'ESP="Obtener líneas de envío"';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        Caption = 'Event', Comment = 'ESP="Evento"';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            SalesAvailMgmt.ShowItemAvailabilityFromSalesLine(Rec, vItemAvailType::"Event")
                        end;
                    }
                    action(Period)
                    {
                        Caption = 'Period', Comment = 'ESP="Período"';
                        Image = Period;

                        trigger OnAction()
                        begin
                            SalesAvailMgmt.ShowItemAvailabilityFromSalesLine(Rec, vItemAvailType::Period)
                        end;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant', Comment = 'ESP="Variante"';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            SalesAvailMgmt.ShowItemAvailabilityFromSalesLine(Rec, vItemAvailType::Variant)
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData Location = R;
                        Caption = 'Location', Comment = 'ESP="Ubicación"';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            SalesAvailMgmt.ShowItemAvailabilityFromSalesLine(Rec, vItemAvailType::Location)
                        end;
                    }
                    action("BOM Level")
                    {
                        Caption = 'BOM Level', Comment = 'ESP="Nivel de L.M."';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            SalesAvailMgmt.ShowItemAvailabilityFromSalesLine(Rec, vItemAvailType::BOM)
                        end;
                    }
                }
                group("Related Information")
                {
                    Caption = 'Related Information', Comment = 'ESP="Información relacionada"';
                    action(Dimensions)
                    {
                        AccessByPermission = TableData Dimension = R;
                        ApplicationArea = Suite;
                        Caption = 'Dimensions', Comment = 'ESP="Dimensiones"';
                        Image = Dimensions;
                        Scope = Repeater;
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', Comment = 'ESP="Ver o editar dimensiones, como área, proyecto o departamento, que se pueden asignar a documentos de ventas y compras para distribuir costes y analizar el historial de transacciones."';
                        trigger OnAction()
                        begin
                            Rec.ShowDimensions;
                        end;
                    }
                    action("Co&mments")
                    {
                        Caption = 'Comments', Comment = 'ESP="Comentarios"';
                        Image = ViewComments;

                        trigger OnAction()
                        begin
                            Rec.ShowLineComments;
                        end;
                    }
                    action("Item Charge &Assignment")
                    {
                        AccessByPermission = TableData "Item Charge" = R;
                        Caption = 'Item Charge &Assignment', Comment = 'ESP="Asignación de cargos de artículo"';
                        Image = ItemCosts;

                        trigger OnAction()
                        begin
                            Rec.ShowItemChargeAssgnt;
                        end;
                    }
                    action("Item &Tracking Lines")
                    {
                        Caption = 'Item Tracking Lines', Comment = 'ESP="Líneas de seguimiento de artículo"';
                        ;
                        Image = ItemTrackingLines;
                        ShortCutKey = 'Shift+Ctrl+I';

                        trigger OnAction()
                        begin
                            Rec.OpenItemTrackingLines;
                        end;
                    }
                    action(DeferralSchedule)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Deferral Schedule', Comment = 'ESP="Calendario de diferimiento"';
                        Enabled = Rec."Deferral Code" <> '';
                        Image = PaymentPeriod;
                        ToolTip = 'View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.', Comment = 'ESP="Ver o editar el calendario de diferimiento que determina cómo los ingresos generados con este documento de venta se difieren a diferentes períodos contables cuando el documento se registra."';

                        trigger OnAction()
                        begin
                            TotalSalesHeader.GET(Rec."Document Type", Rec."Document No.");
                            Rec.ShowDeferrals(TotalSalesHeader."Posting Date", TotalSalesHeader."Currency Code");
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalculateTotals;
        UpdateEditableOnRow;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        IF (Rec.Quantity <> 0) AND Rec.ItemExists(Rec."No.") THEN BEGIN
            COMMIT;
            IF NOT ReserveSalesLine.DeleteLineConfirm(Rec) THEN
                EXIT(FALSE);
            ReserveSalesLine.DeleteLine(Rec);
        END;
    end;

    trigger OnInit()
    begin
        SalesSetup.GET();
        Currency.InitRoundingPrecision;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        IF ApplicationAreaMgmt.IsFoundationEnabled THEN
            Rec.Type := Rec.Type::Item;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF ApplicationAreaMgmt.IsFoundationEnabled THEN
            Rec.Type := Rec.Type::Item
        ELSE
            Rec.InitType;
        CLEAR(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        Location: Record Location;
    begin
        IF Location.READPERMISSION THEN
            LocationCodeVisible := NOT Location.ISEMPTY;
    end;

    var
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        Currency: Record Currency;
        SalesSetup: Record "Sales & Receivables Setup";
        ApplicationAreaMgmt: Codeunit "Application Area Mgmt. Facade";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        // ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesAvailMgmt: Codeunit "Sales Availability Mgt.";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        DocumentTotals: Codeunit "Document Totals";
        vItemAvailType: Enum "Item Availability Type";
        VATAmount: Decimal;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        ShortcutDimCode: array[8] of Code[20];
        UpdateAllowedVar: Boolean;
        Text000Lbl: Label 'Unable to run this function while in View mode.', Comment = 'ESP="No se puede ejecutar esta función en modo vista."';
        LocationCodeVisible: Boolean;
        InvDiscAmountEditable: Boolean;
        RowIsText: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;

    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)", Rec);
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.GET(Rec."Document Type", Rec."Document No.");
        SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
        CurrPage.UPDATE(FALSE);
    end;

    procedure CalcInvDisc()
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount", Rec);
    end;

    procedure ExplodeBOM()
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM", Rec);
    end;

    procedure GetShipment()
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Get Shipment", Rec);
    end;

    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        IF TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            COMMIT;
            TransferExtendedText.InsertSalesExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdatePage(TRUE);
    end;

    procedure UpdatePage(SetSaveRecord: Boolean)
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure ShowPrices()
    begin
        TotalSalesHeader.GET(Rec."Document Type", Rec."Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(TotalSalesHeader, Rec);
    end;

    procedure ShowLineDisc()
    begin
        TotalSalesHeader.GET(Rec."Document Type", Rec."Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(TotalSalesHeader, Rec);
    end;

    procedure SetUpdateAllowed(UpdateAllowed: Boolean)
    begin
        UpdateAllowedVar := UpdateAllowed;
    end;

    procedure UpdateAllowed(): Boolean
    begin
        IF UpdateAllowedVar = FALSE THEN BEGIN
            MESSAGE(Text000Lbl);
            EXIT(FALSE);
        END;
        EXIT(TRUE);
    end;

    local procedure NoOnAfterValidate()
    var
        ApplicationAreaMgmt: Codeunit "Application Area Mgmt. Facade";
    begin
        IF ApplicationAreaMgmt.IsFoundationEnabled THEN
            Rec.TESTFIELD(Type, Rec.Type::Item);
        InsertExtendedText(FALSE);

        IF (Rec.Type = Rec.Type::"Charge (Item)") AND (Rec."No." <> xRec."No.") AND (xRec."No." <> '') THEN
            CurrPage.SAVERECORD;
    end;

    local procedure UpdateEditableOnRow()
    var
        SalesLine: Record "Sales Line";
    begin
        RowIsText := (Rec."No." = '') AND (Rec.Description <> '');
        IF NOT RowIsText THEN
            UnitofMeasureCodeIsChangeable := Rec.CanEditUnitOfMeasureCode
        ELSE
            UnitofMeasureCodeIsChangeable := FALSE;

        IF TotalSalesHeader."No." <> '' THEN BEGIN
            SalesLine.SETRANGE("Document No.", TotalSalesHeader."No.");
            SalesLine.SETRANGE("Document Type", TotalSalesHeader."Document Type");
            IF NOT SalesLine.ISEMPTY THEN
                InvDiscAmountEditable :=
                  SalesCalcDiscByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") AND CurrPage.EDITABLE;
        END;
    end;

    local procedure ValidateAutoReserve()
    begin
        IF Rec.Reserve = Rec.Reserve::Always THEN BEGIN
            CurrPage.SAVERECORD;
            Rec.AutoReserve;
        END;
    end;

    local procedure GetTotalSalesHeader()
    begin
        IF NOT TotalSalesHeader.GET(Rec."Document Type", Rec."Document No.") THEN
            CLEAR(TotalSalesHeader);
        IF Currency.Code <> TotalSalesHeader."Currency Code" THEN
            IF NOT Currency.GET(TotalSalesHeader."Currency Code") THEN BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision;
            END;
    end;

    local procedure CalculateTotals()
    begin
        GetTotalSalesHeader;
        TotalSalesHeader.CALCFIELDS("Recalculate Invoice Disc.");

        IF SalesSetup."Calc. Inv. Discount" AND (Rec."Document No." <> '') AND (TotalSalesHeader."Customer Posting Group" <> '') AND
           TotalSalesHeader."Recalculate Invoice Disc."
        THEN
            IF Rec.FIND THEN
                CalcInvDisc;

        DocumentTotals.CalculateSalesTotals(TotalSalesLine, VATAmount, Rec);
        InvoiceDiscountAmount := TotalSalesLine."Inv. Discount Amount";
        InvoiceDiscountPct := SalesCalcDiscByType.GetCustInvoiceDiscountPct(Rec);
    end;

    local procedure RedistributeTotalsOnAfterValidate()
    begin
        CurrPage.SAVERECORD;

        TotalSalesHeader.GET(Rec."Document Type", Rec."Document No.");
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
        CurrPage.UPDATE;
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        Rec.ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        CurrPage.SAVERECORD;
    end;
}
