public class CommissionTierSelector {
    public static List<Commission_Tier__c> getRetroactiveTiersByCommissionMaster(Set<id> commissionMasterIds,string commissionType){
        return [SELECT id, commission_master__c ,minimal_retroactive__c,lower_Amount__c , profile_type__c from Commission_Tier__c where tier_type__c=: commissionType and commission_master__c IN: commissionMasterIds ORDER BY lower_Amount__c ASC];
    }
    
    public static List<Commission_Tier__c> getCommissionTierByCommissionMasters(Set<Id> commissionMasters){
        return [SELECT Id, Name, Commission_Master__c, Commission_Percentage__c, Lower_Amount__c, 
                Upper_Amount__c, Profile_Type__c, Tier_Type__c, minimal_retroactive__c, Max_Commission_Amount__c FROM Commission_Tier__c
        		WHERE Commission_Master__c IN : commissionMasters ORDER BY Commission_Percentage__c ASC];
    }
}