public class PercentUnderRetEoYAdjMetaDataSelector {
    public static list<Percentage_Less_then_retroactive_EOY_adj__mdt> getTargetUnderEOYAdjustment(){
        return [Select Id,Commission_Percentage__c,Profile_Type__c from Percentage_Less_then_retroactive_EOY_adj__mdt];
    }
}