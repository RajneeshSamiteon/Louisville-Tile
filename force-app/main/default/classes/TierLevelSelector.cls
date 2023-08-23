public class TierLevelSelector {
    public static List<Tier_Levels__mdt > getTierLevel(){
        return [Select Id,Profile_Type__c,Lower_limit__c,Tier_Type__c,Upper_limit__c,Commission_Percentage__c from Tier_Levels__mdt];
    }
}