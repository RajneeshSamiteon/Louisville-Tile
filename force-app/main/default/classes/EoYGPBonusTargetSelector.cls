public class EoYGPBonusTargetSelector {
  public static List<EoY_GP_Target_Bonus__c> getEoYGPBonusTargetByCommissionMasters(Set<Id> commissionMasters){
        return [SELECT Id, Name, Amount__c, Bonus__c, Commission_Master__c, Profile_Type__c 
                FROM EoY_GP_Target_Bonus__c WHERE Commission_Master__c IN : commissionMasters ORDER BY Amount__c ASC];
    } 
}