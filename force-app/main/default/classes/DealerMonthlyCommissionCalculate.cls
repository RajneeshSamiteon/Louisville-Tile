public class DealerMonthlyCommissionCalculate {
    public static List<Monthly_Commission__c> calculateMonthlyCommissiorOfReps(Map<Id,List<Monthly_Commission__c>> monthlyCommissionsByUser, Map<Id,Commission_Master__c> commissionMasterById, Map<Id,List<Commission_Tier__c>> commissionTierByCommissionMaster){
        System.debug('Entering:DealerMonthlyCommissionCalculate.calculateMonthlyCommissiorOfReps => monthlyCommissionsByUser::'+monthlyCommissionsByUser+
                     '\ncommissionMasterById::'+commissionMasterById+
                     '\ncommissionTierByCommissionMaster::'+commissionTierByCommissionMaster);
        Decimal commission;
        CommissionTierService.CommissionPercent commissionPercent = new CommissionTierService.CommissionPercent();
        List<Monthly_Commission__c> monthlyCommissionsToBeUpdated = new List<Monthly_Commission__c>();
        Map<Id,CommissionTierService.Tiers> tiersByCommissionMaster = CommissionTierService.sepereateCommissionTiers(commissionTierByCommissionMaster);
        for(Id userId: monthlyCommissionsByUser.keySet()){
            Monthly_commission__c lastMonthlyCommission = new Monthly_commission__c();
            lastMonthlyCommission = monthlyCommissionsByUser.get(userId)[0];
            commission = 0;
            commissionPercent = CommissionTierService.getCommissionPrecents(lastMonthlyCommission, commissionMasterById, tiersByCommissionMaster);
            lastMonthlyCommission.Dealer_Commission__c = ((lastMonthlyCommission.Cumulative_Eligible_Dealer_Amount__c * commissionPercent.dealer)/100).setScale(2);
            lastMonthlyCommission.Commercial_with_Opportunity_Commission__c = ((lastMonthlyCommission.Cum_Eligible_Comm_W_Opp_Amount__c * commissionPercent.commercialWithOpportunity)/100).setScale(2);
            lastMonthlyCommission.Commercial_W_O_Opportunity_Commission__c = ((lastMonthlyCommission.Cum_Eligible_Comm_W_O_Opp_Amount__c * commissionPercent.commercialWithoutOpportunity)/100).setScale(2);
            lastMonthlyCommission.Total_Commission__c =  lastMonthlyCommission.Dealer_Commission__c + lastMonthlyCommission.Commercial_with_Opportunity_Commission__c + lastMonthlyCommission.Commercial_W_O_Opportunity_Commission__c;
            monthlyCommissionsToBeUpdated.add(lastMonthlyCommission);  

            if(monthlyCommissionsByUser.get(userId).size() > 1){                
                monthlyCommissionsToBeUpdated.add(MonthlyCommissionUtils.updateCurrentMonthViaLastMonth(lastMonthlyCommission, monthlyCommissionsByUser.get(userId)[1]));
            }
        }
        System.debug('Entering:DealerMonthlyCommissionCalculate.calculateMonthlyCommissiorOfReps => monthlyCommissionsToBeUpdated::'+
                    JSON.serializePretty(monthlyCommissionsToBeUpdated));
        return monthlyCommissionsToBeUpdated; 
    }
}