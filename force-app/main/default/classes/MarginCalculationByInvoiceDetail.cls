public class MarginCalculationByInvoiceDetail implements  Database.Batchable<sObject>,Schedulable{
    /******************************************************
* Batch Class Name : MarginCalculationByInvoiceDetail
* Created By : Samiteon Team
* Purpose :  Class fetches the daily loaded Invoice details 
* and send them to it's helper class for further process.
*******************************************************/
    public String queryCondition;
    public MarginCalculationByInvoiceDetail(){
        queryCondition = 'createddate = TODAY';
    }
    public marginCalculationByInvoiceDetail(String condition){
        queryCondition = condition;
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('QueryLocator:: Limits.getHeapSize()==>'+Limits.getHeapSize());
        System.debug('QueryLocator:: Limits.getLimitHeapSize()==>'+Limits.getLimitHeapSize());
        String query = 'SELECT Id,Invoice__c,Has_Processed_For_Commission__c,Invoice_Header__c,Opportunity__c,Invoice_Date__c,Item_cost__c,Item_Group__c,Item_Price__c,Account__c,Gross_Margin__c,Gross_Margin_percent__c,Bill_To_Group__c FROM Invoice_Detail__c WHERE '+queryCondition;
        system.debug('query==>'+query);
        return Database.getQueryLocator(query);   
    }
    public void execute(Database.BatchableContext BC, List<Invoice_Detail__c> invoiceDetails){
        System.debug('execute.Start:: Limits.getHeapSize()==>'+Limits.getHeapSize());
        System.debug('execute.Start:: Limits.getLimitHeapSize()==>'+Limits.getLimitHeapSize());
        if(!invoiceDetails.isempty()){
        	MarginCalculationByInvoiceDetailHelper marginCalculations = new MarginCalculationByInvoiceDetailHelper();
        	marginCalculations.commissionCalculator(invoiceDetails);
        }
        else{
            ExceptionUtils.createExceptionLogV2('MarginCalculationByInvoiceDetail' ,'Got No record of invice detail','NULL');   
        }
        System.debug('execute.End:: Limits.getHeapSize()==>'+Limits.getHeapSize());
        System.debug('execute.End:: Limits.getLimitHeapSize()==>'+Limits.getLimitHeapSize());
    }
    public void finish(Database.BatchableContext BC){
        
    }
    
    public void execute(SchedulableContext sc){
        MarginCalculationByInvoiceDetail marginCalculationByInvoiceDetail= new MarginCalculationByInvoiceDetail(); 
        database.executeBatch(marginCalculationByInvoiceDetail);
    }
}