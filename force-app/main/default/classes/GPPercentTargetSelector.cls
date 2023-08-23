public class GPPercentTargetSelector {
    
    public static List<GP_Percent_Target__c> getGPPercentTargetByCommissionMasters(Set<Id> commissionMasters) {
        return [SELECT Id, Name, Type__c, Profile_Type__c, Target_Percent__c, Commission_Master__c 
                FROM GP_Percent_Target__c 
                WHERE Commission_Master__c IN : commissionMasters ORDER BY Type__c ASC];
    }
    
}