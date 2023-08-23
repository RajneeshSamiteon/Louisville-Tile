public class EOYSalesCommissionHandler {
    public static list<EOY_sales_commission__c> eOYSalesRepAnD(Map<Id,Monthly_Commission__c> monthlyCommissionByEOYSales,  Map<Id,Eoy_Sales_Commission__c> eoySalesCommissionById,Map<Id,Commission_Master__c> commissionMasterById,Map<Id,List<Commission_Tier__c>> commissionTierByCommissionMaster, Map<Id,Map<String,Decimal>> targetByTypeByCommissionMaster, Map<Id,List<EoY_GP_Target_Bonus__c>> eoyGpTargetBonusByCommissionMaster){
        System.debug('Entring:EOYSalesCommissionHandler.eOYSalesRepAnD => monthlyCommissionByEOYSales==>'+monthlyCommissionByEOYSales+
                     '\neoySalesCommissionById==>'+eoySalesCommissionById+
                     '\ncommissionMasterById==>'+commissionMasterById+ 
                     '\ncommissionTierByCommissionMaster==>'+commissionTierByCommissionMaster+
                     '\ntargetByTypeByCommissionMaster==>'+targetByTypeByCommissionMaster+
                     '\neoyGpTargetBonusByCommissionMaster==>'+eoyGpTargetBonusByCommissionMaster);
      list<EOY_sales_commission__c> eoySalesCommissions = new list<EOY_sales_commission__c>();
        for(EOY_sales_commission__c eoySalesCommission : eoySalesCommissionById.values()){
            if(monthlyCommissionByEOYSales.containsKey(eoySalesCommission.id)){
                eoySalesCommission.Eligible_Margin__c = monthlyCommissionByEOYSales.get(eoySalesCommission.id).Cumulative_Eligible_Margin__c;
                eoySalesCommission.Non_Eligible_Margin__c =  monthlyCommissionByEOYSales.get(eoySalesCommission.id).Cumulative_Total_Margin__c -  monthlyCommissionByEOYSales.get(eoySalesCommission.id).Cumulative_Eligible_Margin__c;
                eoySalesCommission.Total_Sale__c = monthlyCommissionByEOYSales.get(eoySalesCommission.id).Cumulative_Total_Sale__c;
                eoySalesCommission.Total_Margin__c = monthlyCommissionByEOYSales.get(eoySalesCommission.id).Cumulative_Total_Margin__c;
                if(eoySalesCommission.Total_Margin_Without_Split__c != 0){
                    eoySalesCommission.Over_All_Margin_percent__c = ((eoySalesCommission.Total_Margin_Without_Split__c/eoySalesCommission.Total_Sale__c)*100).setScale(2);
                }
                else{
                    eoySalesCommission.Over_All_Margin_percent__c = 0;   
                }
                for(EoY_GP_Target_Bonus__c gpTarget : eoyGpTargetBonusByCommissionMaster.get(eoySalesCommission.Commission_Master__c)){
                    if(eoySalesCommission.Total_Margin__c >= gpTarget.Amount__c) {
                        eoySalesCommission.Bonus__c = gpTarget.Bonus__c;
                    }
                    else{
                        break;
                    }
                }
                eoySalesCommission.Total_Commission__c =  eoySalesCommission.Bonus__c;
                if(eoySalesCommission.Total_Margin__c > commissionMasterById.get(eoySalesCommission.Commission_Master__c).Minimum_Retroactive_Threshold__c){                
                    Decimal nonEligibleAmountCommission =0.0;
                    // nonEligibleAmountCommission =((monthlyCommission.Cumulative_Total_Margin__c-monthlyCommission.cumulative_eligible_margin__c)* commissionMaster.Commission_percent_under_target__c)/100;
                    if(eoySalesCommission.Over_All_Margin_percent__c >= commissionMasterById.get(eoySalesCommission.Commission_Master__c).Target_for_EoY_adjustment__c){
                        for(Commission_Tier__c commissionTier : commissionTierByCommissionMaster.get(eoySalesCommission.Commission_Master__c)){
                            if( eoySalesCommission.Total_Margin__c <= commissionTier.Upper_Amount__c){
                                nonEligibleAmountCommission = (((eoySalesCommission.Total_Margin__c *commissionTier.Commission_Percentage__c)/100) - (monthlyCommissionByEOYSales.get(eoySalesCommission.Id).Total_Commission__c)).setScale(2);
                                break;
                            }
                        }
                    }
                    eoySalesCommission.Total_Commission__c += nonEligibleAmountCommission;
                }
                else{
                    if(eoySalesCommission.Over_All_Margin_percent__c >= commissionMasterById.get(eoySalesCommission.Commission_Master__c).Target_for_EoY_adjustment__c){
                        Decimal marginalTotalCommission =0.0;
                        marginalTotalCommission = (((( eoySalesCommission.Total_Margin__c * commissionMasterById.get(eoySalesCommission.Commission_Master__c).Percent_below_retroactive_EoY_Adj__c)/100) - monthlyCommissionByEOYSales.get(eoySalesCommission.Id).Total_Commission__c)).setScale(2);
                        eoySalesCommission.Total_Commission__c += marginalTotalCommission;
                    }
                }
                eoySalesCommission.Total_Commission__c += monthlyCommissionByEOYSales.get(eoySalesCommission.Id).Total_Commission__c;
                eoySalesCommission.EoY_adjustment__c = eoySalesCommission.Total_Commission__c - monthlyCommissionByEOYSales.get(eoySalesCommission.Id).Total_Commission__c;
                eoySalesCommissions.add(eoySalesCommission);
            }
        }
        System.debug('Exit:EOYSalesCommissionHandler.eOYSalesRepAnD => eoySalesCommissions==>'+eoySalesCommissions);
        return eoySalesCommissions;
    }
    
    public static list<EOY_sales_commission__c> eOYSalesRepDealerAndContractor(Map<Id,Monthly_Commission__c> monthlyCommissionByEOYSales, Map<Id,Eoy_Sales_Commission__c> eoySalesCommissionById,
                                                                               Map<Id,Commission_Master__c> commissionMasterById, Map<Id,List<Commission_Tier__c>> commissionTierByCommissionMaster, 
                                                                               Map<Id,Map<String,Decimal>> targetByTypeByCommissionMaster, Map<Id,List<EoY_GP_Target_Bonus__c>> eoyGpTargetBonusByCommissionMaster,
                                                                               Map<Id,Map<String,Decimal>> eoyMarginTargetByTypeByCommissionMaster){
                                                                                   System.debug('Entring:EOYSalesCommissionHandler.eOYSalesRepDealerAndContractor => monthlyCommissionByEOYSales==>'+monthlyCommissionByEOYSales+
                                                                                                '\neoySalesCommissionById==>'+eoySalesCommissionById+
                                                                                                '\ncommissionMasterById==>'+commissionMasterById+
                                                                                                '\ncommissionTierByCommissionMaster==>'+commissionTierByCommissionMaster+
                                                                                                '\ntargetByTypeByCommissionMaster==>'+targetByTypeByCommissionMaster+
                                                                                                '\neoyGpTargetBonusByCommissionMaster==>'+eoyGpTargetBonusByCommissionMaster);
                                                                                   List<EOY_sales_commission__c> eoySalesCommissions = new List<EOY_sales_commission__c>();
                                                                                   CommissionTierService.CommissionPercent commissionPercent = new CommissionTierService.CommissionPercent();
                                                                                   Map<Id,CommissionTierService.Tiers> tiersByCommissionMaster = CommissionTierService.sepereateCommissionTiers(commissionTierByCommissionMaster);
                                                                                   system.debug('tier Values by commission Master ==>'+JSON.serialize(tiersByCommissionMaster));
                                                                                   for(EOY_sales_commission__c eoySalesCommission : eoySalesCommissionById.values()){
                                                                                       if(monthlyCommissionByEOYSales.containsKey(eoySalesCommission.id)){
                                                                                           Decimal nonEligibleAmountCommission = 0;
                                                                                           Monthly_Commission__c monthlyCommission = monthlyCommissionByEOYSales.get(eoySalesCommission.id);
                                                                                           eoySalesCommission.Total_Sale__c = monthlyCommission.Cumulative_Total_Sale__c;
                                                                                           eoySalesCommission.Total_Margin__c = monthlyCommission.Cumulative_Total_Margin__c;   
                                                                                           eoySalesCommission.Eligible_Dealer_Margin__c = monthlyCommission.Cumulative_Eligible_Dealer_Amount__c;
                                                                                           eoySalesCommission.Non_Eligible_Dealer_Margin__c = monthlyCommission.Cumulative_Non_Eligible_Dealer_Amount__c;
                                                                                           eoySalesCommission.Eligible_Comm_with_Opportunity_Margin__c = monthlyCommission.Cum_Eligible_Comm_W_Opp_Amount__c;
                                                                                           eoySalesCommission.Non_Eligible_Com_with_Opportunity_Margin__c = monthlyCommission.Cum_Non_Eligible_Comm_W_Opp_Amount__c;
                                                                                           eoySalesCommission.Eligible_Comm_w_o_Opportunity_Margin__c = monthlyCommission.Cum_Eligible_Comm_W_O_Opp_Amount__c;
                                                                                           eoySalesCommission.Non_Eligible_Comm_w_o_Opportunity_Margin__c = monthlyCommission.Cum_Non_Eligible_Comm_W_O_Opp_Amount__c;
                                                                                           if(eoySalesCommission.Dealer_Sales__c != 0){
                                                                                               eoySalesCommission.Dealer_Margin_Percent__c = (((eoySalesCommission.Eligible_Dealer_Margin__c+eoySalesCommission.Non_Eligible_Dealer_Margin__c)/eoySalesCommission.Dealer_Sales__c)*100).setScale(2);
                                                                                           }
                                                                                           else{
                                                                                               eoySalesCommission.Dealer_Margin_Percent__c = 0;
                                                                                           }
                                                                                           if(eoySalesCommission.Commercial_Sales__c != 0){
                                                                                               eoySalesCommission.Commercial_Margin_Percent__c = (((eoySalesCommission.Eligible_Comm_with_Opportunity_Margin__c+eoySalesCommission.Non_Eligible_Com_with_Opportunity_Margin__c+eoySalesCommission.Eligible_Comm_w_o_Opportunity_Margin__c+eoySalesCommission.Non_Eligible_Comm_w_o_Opportunity_Margin__c)/eoySalesCommission.Commercial_Sales__c)*100).setScale(2);
                                                                                           }
                                                                                           else{
                                                                                               eoySalesCommission.Commercial_Margin_Percent__c=0;
                                                                                           }
                                                                                           eoySalesCommission.Bonus__c = getBonusAmount(eoySalesCommission,eoyGpTargetBonusByCommissionMaster);
                                                                                           eoySalesCommission.Total_Commission__c =  eoySalesCommission.Bonus__c;
                                                                                           System.debug('eoySalesCommission.Total_Commission__c ::>>>'+eoySalesCommission.Total_Commission__c);
                                                                                           commissionPercent = CommissionTierService.getCommissionPrecentsViaEoySalesCommission(eoySalesCommission, commissionMasterById, tiersByCommissionMaster);
                                                                                           System.debug('commissionPercent :::>>>'+commissionPercent);
                                                                                           if(commissionPercent != NULL){
                                                                                               eoySalesCommission.Commission_On_Non_Eligible_Amount__c = getNonEligibleAmountCommission(eoySalesCommission, commissionPercent, eoyMarginTargetByTypeByCommissionMaster.get(eoySalesCommission.Commission_Master__c));
                                                                                               eoySalesCommission.Total_Commission__c += eoySalesCommission.Commission_On_Non_Eligible_Amount__c;
                                                                                               eoySalesCommission.Total_Commission__c += monthlyCommission.Total_Commission__c;
                                                                                               eoySalesCommission.EoY_adjustment__c = eoySalesCommission.Total_Commission__c - monthlyCommission.Total_Commission__c;
                                                                                               eoySalesCommissions.add(eoySalesCommission);
                                                                                           }
                                                                                       }
                                                                                       
                                                                                   }
                                                                                   System.debug('Exit:EOYSalesCommissionHandler.eOYSalesRepDealerAndContractor => eoySalesCommissions==>'+eoySalesCommissions);
                                                                                   return eoySalesCommissions;
                                                                               }
    
    public static Decimal getBonusAmount(EoY_Sales_Commission__c eoySalesCommission,Map<Id,List<EoY_GP_Target_Bonus__c>> eoyGpTargetBonusByCommissionMaster){
        Decimal bonus = 0;
        for(EoY_GP_Target_Bonus__c eoyGpTargetBonus : eoyGpTargetBonusByCommissionMaster.get(eoySalesCommission.Commission_Master__c)){
            if(eoySalesCommission.Total_Margin__c >= eoyGpTargetBonus.Amount__c) {
                Bonus = eoyGpTargetBonus.Bonus__c;
            }
            else{
                break;
            }
        }
        return bonus;
    }
    
    public static Decimal getNonEligibleAmountCommission(EoY_Sales_Commission__c eoySalesCommission, CommissionTierService.CommissionPercent commissionPercent,Map<String,Decimal> eoyMarginTargetByType){
        Decimal commission=0;
        System.debug('eoyMarginTargetByType.keySet()'+eoyMarginTargetByType);
        if(eoyMarginTargetByType!= null){
            for(String type : eoyMarginTargetByType.keySet()){
                if(type.equalsIgnoreCase(CommissionCalculatorConstants.DEALER) && eoySalesCommission.Dealer_Margin_Percent__c >= eoyMarginTargetByType.get(type)){
                    
                    commission += ((eoySalesCommission.Non_Eligible_Dealer_Margin__c * commissionPercent.dealer)/100).setScale(2);
                    
                }
                else if(type.equalsIgnoreCase(CommissionCalculatorConstants.CONTRACTOR) && eoySalesCommission.Commercial_Margin_Percent__c >= eoyMarginTargetByType.get(type)){
                    
                    commission += ((eoySalesCommission.Non_Eligible_Com_with_Opportunity_Margin__c * commissionPercent.commercialWithOpportunity)/100).setScale(2);
                    commission += ((eoySalesCommission.Non_Eligible_Comm_w_o_Opportunity_Margin__c * commissionPercent.commercialWithoutOpportunity)/100).setScale(2);
                    
                }
            }
        }
        return commission;
    }
}