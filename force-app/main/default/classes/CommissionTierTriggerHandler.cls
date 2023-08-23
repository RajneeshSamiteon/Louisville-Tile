/*
 * this handler is for separating the marginal and retroactive threshold for every profile.
 * this were genrally update the first retroactive type commission tier record checkbox name minimal retro active__c
*/

public class CommissionTierTriggerHandler {
    public static void commissionTierTriggerHelper(Map<id,Commission_Tier__c> CommissionTiers)
    {
        List<Commission_Tier__c> allCommissionTiers = new List<Commission_Tier__c>(); 
       	Set<id> commissionMasterIds = new Set<id>();
        for(Commission_Tier__c tier : CommissionTiers.values())
        {
            if(tier.commission_master__c != NULL)
            {
                commissionMasterIds.add(tier.commission_master__c);
            }
        }
        String commissionType  =CommissionCalculatorconstants.RETROACTIVE;  // this veriable is for search rectroactive commission tier  the value were stored in the constant class
        allCommissionTiers =CommissionTierSelector.getRetroactiveTiersByCommissionMaster(commissionMasterIds,commissionType);
        Set<id> repeatingCommissionMasterId = new Set<id>();
        for(Commission_Tier__c tier : allCommissionTiers)
        {
            if(repeatingCommissionMasterId.contains(tier.commission_master__c))
            {
                if(tier.minimal_retroactive__c)
                {
                    tier.minimal_retroactive__c = false;
                }
            }
            else
            {
                tier.minimal_retroactive__c = true;
            }
            repeatingCommissionMasterId.add(tier.commission_master__c);
        }
        try {
            update allCommissionTiers;
        } 
        catch(DmlException e) {
            ExceptionUtils.createExceptionLogV2('Commission_Tier__c',e.getMessage(),e.getStackTraceString());
        }
    }
}