public class CommissionUnderTargerMetadataSelector {
    public static list<Commission_under_target__mdt> getCommissionPercentUnderTarget(){
        return [Select Id,Commission_Percentage__c ,Profile_Type__c from Commission_under_target__mdt];
    }
}