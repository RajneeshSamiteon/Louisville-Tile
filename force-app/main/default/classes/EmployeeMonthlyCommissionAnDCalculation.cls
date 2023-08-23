public class EmployeeMonthlyCommissionAnDCalculation {
    public static List<Monthly_Commission__c> monthlyCommissionByUserCalculation(Map<Id,List<Monthly_Commission__c>> monthlyCommissionsByUser, Map<Id,Commission_Master__c> commissionMasterById,Map<Id,List<Commission_Tier__c>> commissionTierByCommissionMaster){
        
        System.debug('Entering:monthlyCommissionByUserCalculation => monthlyCommissionsByUser::'+monthlyCommissionsByUser+
                     '\ncommissionMasterById::'+commissionMasterById+
                     '\ncommissionTierByCommissionMaster::'+commissionTierByCommissionMaster);
        
        List<Monthly_Commission__c> monthlyCommissionsToBeUpdated = new List<Monthly_Commission__c>();
        for(Id userId : monthlyCommissionsByUser.keySet()){
            Monthly_commission__c lastMonthlyCommission = new Monthly_commission__c();
            lastMonthlyCommission = monthlyCommissionsByUser.get(userId)[0];
            lastMonthlyCommission.Total_Commission__c = getTotalCommission(lastMonthlyCommission,commissionMasterById,commissionTierByCommissionMaster);     
            monthlyCommissionsToBeUpdated.add(lastMonthlyCommission);
            
            if(monthlyCommissionsByUser.get(userId).size() > 1){                
                monthlyCommissionsToBeUpdated.add(MonthlyCommissionUtils.updateCurrentMonthViaLastMonth(lastMonthlyCommission, monthlyCommissionsByUser.get(userId)[1]));
            }
        }
        return monthlyCommissionsToBeUpdated;
    }

    public static Decimal getTotalCommission(Monthly_Commission__c lastMonthlyCommission, Map<Id,Commission_Master__c> commissionMasterById,Map<Id,List<Commission_Tier__c>> commissionTierByCommissionMaster){
        Decimal commission = 0;
        if(lastMonthlyCommission.Cumulative_Total_Margin__c <= commissionMasterById.get(lastMonthlyCommission.EoY_Sales_Commission__r.Commission_Master__c).Minimum_Retroactive_Threshold__c){
            Decimal remainingAmount = lastMonthlyCommission.Cumulative_Total_Margin__c;    
            for(Commission_Tier__c commissionTier : commissionTierByCommissionMaster.get(lastMonthlyCommission.EoY_Sales_Commission__r.Commission_Master__c)){
                if(lastMonthlyCommission.Cumulative_Total_Margin__c < commissionTier.Upper_Amount__c) {
                    commission += ((remainingAmount * commissionTier.Commission_Percentage__c)  / 100).setScale(2);
                    break;
                }
                else {
                    commission += (commissionTier.Max_Commission_Amount__c).setScale(2);
                    remainingAmount -= commissionTier.Upper_Amount__c - commissionTier.Lower_Amount__c ;
                }
            }                        
        }
        else{
            for(Commission_Tier__c commissionTier : commissionTierByCommissionMaster.get(lastMonthlyCommission.EoY_Sales_Commission__r.Commission_Master__c)){
                if((lastMonthlyCommission.Cumulative_Total_Margin__c >  commissionTier.Lower_Amount__c) && (lastMonthlyCommission.Cumulative_Total_Margin__c <=  commissionTier.Upper_Amount__c)){
                    commission += ((lastMonthlyCommission.Cumulative_Eligible_Margin__c * commissionTier.Commission_Percentage__c)/100).setScale(2);
                    commission += (((lastMonthlyCommission.Cumulative_Total_Margin__c - lastMonthlyCommission.Cumulative_Eligible_Margin__c)*
                                    commissionMasterById.get(lastMonthlyCommission.EoY_Sales_Commission__r.Commission_Master__c).Commission_percent_under_target__c )/
                                   100).setScale(2);
                }
            }                        
        }
        return commission;
    }
}