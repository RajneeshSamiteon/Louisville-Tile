public class EoYGpPercentTargetMetadataSelector{
    public static List<EoY_Gp_Percent_Target__mdt> getEoYGpPerrcentTarget(){
        return [Select Profile_Type__c,Target__c,Type__c from EoY_Gp_Percent_Target__mdt];
    }
}