/************************************************ 
Batch Class Name :- EmployeeRecordMonthlyCommission
Created By : Samiteon Team 
Purpose :- It will create one record every month of financial year at date 1 for active user for which we have to calculate commission.

****************************/


public class EmployeeRecordMonthlyCommission implements Database.Batchable<sObject>,schedulable{
    
    /****************** 
This method query all the EoY sales Commission of financial year and pass to the execute method 
*********************/
     public string queryCondition;
    public EmployeeRecordMonthlyCommission(){
        queryCondition = 'createdDate = THIS_YEAR AND name like '+'\'%'+Date.Today().Year()+'\'';
    }
     public EmployeeRecordMonthlyCommission(string condition){
        queryCondition = condition;
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'SELECT Id,Name,OwnerId, Bonus__c, Eligible_Margin__c, EoY_adjustment__c, Over_All_Margin_percent__c, Paid_Commission__c, CreatedDate, Total_Commission__c, Total_Margin__c, Employee__c, Commission_Master__c FROM EoY_Sales_Commission__c where '+queryCondition;
        return Database.getQueryLocator(query);  
    }
    /******************* 
This method inserts monthly Commission record of user for whome we have to calculate commission.     
***************************/
    
    public void execute(Database.BatchableContext BC, list<EoY_Sales_Commission__c> eoYSalesCommissions){
        System.debug('eoYSalesCommissions ::'+JSON.serializePretty(eoYSalesCommissions));
        if(!eoYSalesCommissions.isEmpty()){
            try{
                List<Monthly_Commission__c> listMonthlyCommission = new List<Monthly_Commission__c>();
                Map<String,String> eoySalesCommissionByEmployee = new Map<String,String>();
                for(EoY_Sales_Commission__c eoySalesCommission : eoYSalesCommissions){
                    if(eoySalesCommission.Employee__c != null && eoySalesCommission.Id != null){
                        Monthly_Commission__c monthlyCommission = new Monthly_Commission__c();
                        monthlyCommission.Name = eoySalesCommission.Name;
                        monthlyCommission.Employee__c = eoySalesCommission.Employee__c;
                        monthlyCommission.EoY_Sales_Commission__c = eoySalesCommission.Id;
                        listMonthlyCommission.add(monthlyCommission);                    
                    }
                }
               // System.debug('listMonthlyCommission ::>>'+listMonthlyCommission.size());
               // System.debug('listMonthlyCommission ::'+JSON.serializePretty(listMonthlyCommission));
                insert listMonthlyCommission; 
            }
            catch(DmlException e) {
                ExceptionUtils.createExceptionLogV2('Got from EmployeeRecordMonthlyCommission==>',e.getMessage(),e.getStackTraceString());
            }
        }
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
    
    public static void execute(System.SchedulableContext bc){
        Database.executeBatch(new EmployeeRecordMonthlyCommission());
    }
}