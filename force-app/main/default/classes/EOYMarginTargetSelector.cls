public class EOYMarginTargetSelector {
    public static List<EOY_Margin_Target__c> getEoyMarginTargetByCommissionMaster(Set<Id> commissionMaster){
        return [SELECT Id, Name, Type__c, Target__c, Commission_Master__c, Profile_Type__c 
                FROM EOY_Margin_Target__c WHERE Commission_Master__c IN : commissionMaster];
    }
}