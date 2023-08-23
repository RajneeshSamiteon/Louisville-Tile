@isTest
public class MonthlyBreakdownServiceTest {
    @isTest static void testAssignMonthlyBreakdownByInvoiceMarginsAndSplitPercentage(){
        MarginCalculationByInvoiceDetailHelper.InvoiceMargins invoiceMargin = new MarginCalculationByInvoiceDetailHelper.InvoiceMargins();
        Monthly_Breakdown__c monthlyBreakdown = new Monthly_Breakdown__c();
        Decimal splitPercentage = 10;
        Test.startTest();
        MonthlyBreakdownService.assignMonthlyBreakdownByInvoiceMarginsAndSplitPercentage(monthlyBreakdown,invoiceMargin,splitPercentage);
        MonthlyBreakdownService.updateMonthlyBreakdownByInvoiceMarginsAndSplitPercentage(monthlyBreakdown,invoiceMargin,splitPercentage);
        Test.stopTest();
    }
    /*
    @isTest static void testUpdateMonthlyBreakdownByInvoiceMarginsAndSplitPercentage(){
        MarginCalculationByInvoiceDetailHelper.InvoiceMargins invoiceMargin = new MarginCalculationByInvoiceDetailHelper.InvoiceMargins();
        Monthly_Breakdown__c monthlyBreakdown = new Monthly_Breakdown__c();
        Decimal splitPercentage = 10;
        Test.startTest();
        
        Test.stopTest();
    }
*/
}