/******************************
Batch Class Name :- EmployeeRecordEoYSalesCommission 
Created By : Samiteon Team
Purpose :- It will create one record to financial year at Jan for active user for which we have to calculate EoY Sales commission.
*******************************/
public class EmployeeRecordEoYSalesCommission implements Database.Batchable<sObject>,Schedulable{
    
    /*******
It will query all the active user on the profile bases and pass to the execute method.
********/
    public Database.QueryLocator start(Database.BatchableContext BC) {
        try{
            List<String> profileNames = CommissionCalculatorConstants.PROFILENAMES;
            Boolean dontCalculateCommission = false;
            String userListOnProfileBasis = 'SELECT Id, Name, Profile.Name FROM User WHERE Profile.Name In : profileNames AND IsActive=true AND Dont_calculate_commission__c =:dontCalculateCommission';
            return Database.getQueryLocator(userListOnProfileBasis);   
        }
        catch(DmlException e) {
            ExceptionUtils.createExceptionLogV2('EmployeeRecordEoYSalesCommission',e.getMessage(),e.getStackTraceString());
            return null;
        }
    }
    
    /*******   
It will create the record of sales rep for which we have to calculate commission 
*******/
    public void execute(Database.BatchableContext BC, list<User> userListOnProfileBasis){
        System.debug('--userListOnProfileBasis--\n'+JSON.serializePretty(userListOnProfileBasis));
        try {
            List<EoY_Sales_Commission__c> eoySalesCommissions = new List<EoY_Sales_Commission__c>();
            
            Map<String,Commission_Master__c> commissionMasterProfileBases = new Map<String,Commission_Master__c>();
            List<Commission_Master__c> commissionMasters = CommissionMasterSelector.getCommissionMasterRecordTypeBases();
            for(Commission_Master__c commissionMaster : commissionMasters){
                commissionMasterProfileBases.put(commissionMaster.recordType.Name,commissionMaster); 
            }
            System.debug('commissionMasterProfileBases :::>>'+commissionMasterProfileBases);
            for(User user : userListOnProfileBasis){
                if(commissionMasterProfileBases.containsKey(user.profile.Name)) {
                    EoY_Sales_Commission__c salesCommissionEoY = new EoY_Sales_Commission__c();
                    if(user.profile.Name == commissionMasterProfileBases.get(user.profile.Name).RecordType.Name){
                        salesCommissionEoY.Employee__c = user.Id;
                        salesCommissionEoY.Commission_Master__c = commissionMasterProfileBases.get(user.profile.Name).Id;
                    }
                    eoySalesCommissions.add(salesCommissionEoY);
                }
            }
            System.debug('eoySalesCommissions ::'+JSON.serialize(eoySalesCommissions));
            insert eoySalesCommissions;
        } 
        catch(DmlException e) {
            ExceptionUtils.createExceptionLogV2('EoY_Sales_Commission__c',e.getMessage(),e.getStackTraceString());
        }
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
    
    public static void execute(System.SchedulableContext bc){
        Database.executeBatch(new EmployeeRecordEoYSalesCommission()); 
    }
    
}