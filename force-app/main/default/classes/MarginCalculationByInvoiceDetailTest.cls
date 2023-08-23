@isTest
public class MarginCalculationByInvoiceDetailTest {
    
    @isTest static void testMarginCalculationByInvoiceDetail(){
        Account acc1 = new Account();
        acc1.Name = 'Test1';
        insert acc1;
        Invoice_Header__c invoiceHeader = new Invoice_Header__c();
        invoiceHeader.Invoice_Date__c = Date.today();
        invoiceHeader.Account__c = acc1.id;
        invoiceHeader.Bill_To_Group__c = 'Dealer';
        invoiceHeader.Invoice__c = '12345';
        insert invoiceHeader; 
        
         List<Invoice_Detail__c> invoiceDetails = new List<Invoice_Detail__c>();
        for(Integer i=1; i<10; i++){
            Invoice_Detail__c invoiceDetail = new Invoice_Detail__c();
            invoiceDetail.Invoice_Header__c = invoiceHeader.Id; 
            invoiceDetail.Invoice_Date__c = Date.today();
            invoiceDetail.Item_Price__c =34343;
            invoiceDetail.Item_cost__c =34343;
            invoiceDetail.Item_Group__c ='Tile';
            invoiceDetail.Invoice__c = '12345';
            invoiceDetails.add(invoiceDetail);
        }
        if(!invoiceDetails.isEmpty()){
        insert invoiceDetails;
        }
        
        String sch = '20 30 8 10 2 ?';
        String jobID = System.schedule('Merge Job', sch, new MarginCalculationByInvoiceDetail());
        
        Test.startTest();
        
        MarginCalculationByInvoiceDetail obj = new MarginCalculationByInvoiceDetail();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}