public class CommissionTierUtils {

    public static Decimal determineCommissionpercent(Decimal margin, List<Commission_Tier__c> tiers){
        Decimal commissionPercent;
        for(Commission_Tier__c tier : tiers){
            if(margin >= tier.Lower_Amount__c){
                commissionPercent = tier.Commission_Percentage__c;
            }
        }
        return commissionPercent;
    }
}