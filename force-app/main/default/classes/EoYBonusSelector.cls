public class EoYBonusSelector {
  public static List<EOY_Bonus__mdt> getEoyBonusMetadata(){
        return [Select Amount__c,Bonus__c,Profile_Type__c from EOY_Bonus__mdt];
    } 
}