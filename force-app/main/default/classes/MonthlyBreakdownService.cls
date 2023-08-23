public class MonthlyBreakdownService {
    public static Monthly_Breakdown__c assignMonthlyBreakdownByInvoiceMarginsAndSplitPercentage(Monthly_Breakdown__c monthlyBreakdown, MarginCalculationByInvoiceDetailHelper.InvoiceMargins invoiceMargin, Decimal splitPercentage){
        monthlyBreakdown.Total_Sales__c = invoiceMargin.totalSales;
        monthlyBreakdown.Tile_Sale__c = invoiceMargin.tileSales;
        monthlyBreakdown.Ancillary_Sale__c = invoiceMargin.ancillarySales;
        monthlyBreakdown.Tile_Margin__c  =invoiceMargin.tileMargin;
        monthlyBreakdown.Ancillary_Margin__c = invoiceMargin.ancillaryMargin;
        monthlyBreakdown.Bill_To_Group__c = invoiceMargin.billToGroup;
        monthlyBreakdown.Commission_Split_Percentage__c  = splitPercentage;
        monthlyBreakdown = MonthlyBreakdownUtils.calculateBreakdownMarginPercentages(monthlyBreakdown);
        return monthlyBreakdown;
    }
    public static Monthly_Breakdown__c updateMonthlyBreakdownByInvoiceMarginsAndSplitPercentage(Monthly_Breakdown__c monthlyBreakdown, MarginCalculationByInvoiceDetailHelper.InvoiceMargins invoiceMargin, Decimal splitPercentage){
        monthlyBreakdown.Total_sales__c += invoiceMargin.totalSales;
        monthlyBreakdown.Tile_Sale__c += invoiceMargin.tileSales;
        monthlyBreakdown.ancillary_sale__c += invoiceMargin.ancillarySales;
        monthlyBreakdown.Tile_Margin__c  +=invoiceMargin.tileMargin;
        monthlyBreakdown.Ancillary_Margin__c += invoiceMargin.ancillaryMargin;
        monthlyBreakdown.Bill_To_Group__c = invoiceMargin.billToGroup;
        monthlyBreakdown.Commission_Split_Percentage__c  = splitPercentage;
        monthlyBreakdown = MonthlyBreakdownUtils.calculateBreakdownMarginPercentages(monthlyBreakdown);
        return monthlyBreakdown;
    }
}