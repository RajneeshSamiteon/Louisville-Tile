public class TargetForEoYAdjustmentMetadataSelector{
    public static List<Target_for_EoY_adjustment__mdt> getEoYAdjustmentTarget(){
       return [Select Id,Commission_Percentage__c,Profile_Type__c from Target_for_EoY_adjustment__mdt];
    }
}