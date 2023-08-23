public class CommissionMasterSelector {
    
    public Static List<Commission_Master__c> getCommissionMasterRecordTypeBases(){
        return [SELECT Id, Name, Minimum_Retroactive_Threshold__c, Percent_below_retroactive_EoY_Adj__c, Target_for_EoY_adjustment__c, 
                Commission_percent_under_target__c, RecordTypeId,recordType.Name,Commercial_without_Opportunity__c 
                FROM Commission_Master__c 
                WHERE CreatedDate = THIS_YEAR];
    }

    public static Map<Id,Commission_Master__c> getCommissionMasterById(Set<Id> commissionMasters){
        return new Map<Id,Commission_Master__c>([SELECT Id, Name, Minimum_Retroactive_Threshold__c, Percent_below_retroactive_EoY_Adj__c, 
                                                 Target_for_EoY_adjustment__c, Commission_percent_under_target__c, RecordTypeId,recordType.Name,Commercial_without_Opportunity__c 
                                                 FROM Commission_Master__c 
                                                 WHERE Id IN : commissionMasters]);
    }
    
    public static Commission_Master__c getCommissionMasterByRecordType(Id recordType){
        return [SELECT Id, Name, Minimum_Retroactive_Threshold__c, Percent_below_retroactive_EoY_Adj__c, 
                Target_for_EoY_adjustment__c, Commission_percent_under_target__c, RecordTypeId,Commercial_without_Opportunity__c FROM Commission_Master__c 
                WHERE RecordTypeId = :recordType ORDER BY CreatedDate DESC][0];
    }
    public static Map<Id,Commission_Master__c> getCommissionMaster(Set<Id> commissionMasters){
        Map<Id,Commission_Master__c> commissionMasterById = new Map<Id,Commission_Master__c>([SELECT Id, Name, Minimum_Retroactive_Threshold__c, Percent_below_retroactive_EoY_Adj__c, 
                                                                                              Target_for_EoY_adjustment__c, Commission_percent_under_target__c, RecordTypeId,recordType.Name,Commercial_without_Opportunity__c FROM Commission_Master__c 
                                                                                              WHERE Id IN : commissionMasters ANd CreatedDate = THIS_YEAR]);
        return commissionMasterById;
    }
}