public class GPPercentTargetMetadataSelector {
 public static List<GP_Percentage_target__mdt> getGpPercentTargetMetadata(){
        return [Select Id,Profile_Type__c,Commission_Percentage__c,Product_Type__c from GP_Percentage_target__mdt ];
    }
}