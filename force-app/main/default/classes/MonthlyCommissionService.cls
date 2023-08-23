public class MonthlyCommissionService {
    public static Monthly_Commission__c  assignMonthlyCommissionViaMonthlyBreakdown(Monthly_Breakdown__c monthlyBreakdown, Map<Id,Map<String,Decimal>> targetByTypeByCommissionMaster){
        
        /***********************************************************
* Called from : populateMonthlyCommissionByIdByProfileName
* If a monthly commission doesn't has data then this 
* method will assign monthly breakdown's data to 
* monthly commission.
* also checks if this monthly commission has the eligible
* amount or not and if it meets the GP % Targets.
************************************************************/  
        
        Monthly_Commission__c monthlyCommission = new Monthly_Commission__c();
        monthlyCommission.Id  = monthlyBreakdown.Monthly_Commission__c;
        monthlyCommission.Tile_Sale__c = monthlyBreakdown.Tile_Sale__c;
        monthlyCommission.Ancillary_Sale__c = monthlyBreakdown.Ancillary_Sale__c;
        monthlyCommission.Tile_Margin__c = monthlyBreakdown.Tile_Margin__c;
        monthlyCommission.Ancillary_Margin__c = monthlyBreakdown.Ancillary_Margin__c;
        monthlyCommission.Tile_Margin_Percent__c  = monthlyBreakdown.Tile_Margin_Percentage__c;
        monthlyCommission.Ancillary_Margin_Percent__c = monthlyBreakdown.Ancillary_Margin_Percentage__c;
        monthlyCommission.Total_Invoice_Ancillary_Margin__c = monthlyBreakdown.Total_Invoice_Ancillary_Margin__c;
        monthlyCommission.Total_Invoice_Tile_Margin__c = monthlyBreakdown.Total_Invoice_Tile_Margin__c;
        monthlyCommission.Eligible_margin__c = monthlyBreakdown.Elgible_Amount__c; 
        if(monthlyBreakdown.Monthly_Commission__r.Employee__r.Profile.Name == CommissionCalculatorConstants.REPTYPEAD){
            monthlyCommission = MonthlyCommissionUtils.checkIfTargetMetForAnD(monthlyCommission,monthlyBreakdown,targetByTypeByCommissionMaster);
        }
        else if (monthlyBreakdown.Monthly_Commission__r.Employee__r.Profile.Name.equalsIgnoreCase(CommissionCalculatorConstants.REPTYPEDEALER) ||
                 monthlyBreakdown.Monthly_Commission__r.Employee__r.Profile.Name.equalsIgnoreCase(CommissionCalculatorConstants.REPTYPECONTRACTOR)){
                     monthlyCommission = MonthlyCommissionUtils.assignEligiblesForMonthlyCommission(monthlyCommission, monthlyBreakdown);
                 }
        return monthlyCommission;
    }
    
    public static Monthly_Commission__c updateMonthlyCommissionViaMonthlyBreakdown(Monthly_Commission__c monthlyCommission, Monthly_Breakdown__c monthlyBreakdown, Map<Id,Map<String,Decimal>> targetByTypeByCommissionMaster){
        
        /***********************************************************
* Called from : populateMonthlyCommissionByIdByProfileName
* If a monthly commission already has data then this 
* method will cumulate the monthly commission's data to it.
* also checks if this monthly commission has the eligible
* amount or not and if it meets the GP % Targets.
************************************************************/
        
        monthlyCommission.Tile_margin__c += monthlyBreakdown.Tile_Margin__c;
        monthlyCommission.Ancillary_Margin__c += monthlyBreakdown.Ancillary_Margin__c;
        monthlyCommission.Tile_Sale__c += monthlyBreakdown.Tile_Sale__c;
        monthlyCommission.Ancillary_Sale__c += monthlyBreakdown.Ancillary_Sale__c;
        monthlyCommission.Total_Invoice_Ancillary_Margin__c += monthlyBreakdown.Total_Invoice_Ancillary_Margin__c;
        monthlyCommission.Total_Invoice_Tile_Margin__c += monthlyBreakdown.Total_Invoice_Tile_Margin__c;
        monthlyCommission.Eligible_margin__c += monthlyBreakdown.Elgible_Amount__c;
        if(monthlyCommission.Tile_Sale__c == 0){
            monthlyCommission.Tile_Margin_Percent__c = 0;
        }
        else{
            monthlyCommission.Tile_Margin_Percent__c = ((monthlyCommission.Tile_margin__c / monthlyCommission.Tile_Sale__c) * 100).setScale(2);
        }  
        
        if(monthlyCommission.Ancillary_Sale__c == 0){
            monthlyCommission.Ancillary_Margin_Percent__c = 0;
        }
        else{
            monthlyCommission.Ancillary_Margin_Percent__c = ((monthlyCommission.Ancillary_Margin__c / monthlyCommission.Ancillary_Sale__c) * 100).setScale(2);
        }
        if(monthlyBreakdown.Monthly_Commission__r.Employee__r.Profile.Name == CommissionCalculatorConstants.REPTYPEAD){
            monthlyCommission = MonthlyCommissionUtils.checkIfTargetMetForAnD(monthlyCommission,monthlyBreakdown,targetByTypeByCommissionMaster);
        }
        else if (monthlyBreakdown.Monthly_Commission__r.Employee__r.Profile.Name.equalsIgnoreCase(CommissionCalculatorConstants.REPTYPEDEALER) ||
                 monthlyBreakdown.Monthly_Commission__r.Employee__r.Profile.Name.equalsIgnoreCase(CommissionCalculatorConstants.REPTYPECONTRACTOR)){
                     monthlyCommission = MonthlyCommissionUtils.updateEligiblesForMonthlyCommission(monthlyCommission, monthlyBreakdown);
                 }
        return monthlyCommission;
    }
    
    public static Monthly_Commission__c calculateCumulativeAmount(Monthly_Commission__c monthlyCommission){
        System.debug('monthlyCommission====>'+JSON.serializePretty(monthlyCommission));
        monthlyCommission.Total_Sale__c = monthlyCommission.Tile_Sale__c + monthlyCommission.Ancillary_Sale__c;
        monthlyCommission.Margin__c = monthlyCommission.Total_Invoice_Ancillary_Margin__c + monthlyCommission.Total_Invoice_Tile_Margin__c;
        monthlyCommission.Cumulative_Total_Margin__c = monthlyCommission.Margin__c + monthlyCommission.Previous_Total_Margin__c;
        monthlyCommission.Cumulative_Ancillary_Margin__c = monthlyCommission.Total_Invoice_Ancillary_Margin__c + monthlyCommission.Previous_Ancillary_Margin__c;
        monthlyCommission.Cumulative_Tile_Margin__c = monthlyCommission.Total_Invoice_Tile_Margin__c + monthlyCommission.Previous_Tile_Margin__c;
        monthlyCommission.Cumulative_Total_Sale__c = monthlyCommission.Total_Sale__c + monthlyCommission.Previous_Total_Sale__C;
        monthlyCommission.Cumulative_Eligible_Margin__c = monthlyCommission.Eligible_Margin__c + monthlyCommission.Previous_Eligible_Margin__c;
        monthlyCommission.Cumulative_Eligible_Dealer_Amount__c = monthlyCommission.Eligible_Dealer_Amount__c + monthlyCommission.Pre_eligible_Dealer_Amount__c;
        monthlyCommission.Cum_Eligible_Comm_W_Opp_Amount__c = monthlyCommission.Eligible_Comm_with_Opportunity_Amount__c + monthlyCommission.Pre_Eligible_Comm_W_Opp_Amount__c;
        monthlyCommission.Cum_Eligible_Comm_W_O_Opp_Amount__c = monthlyCommission.Eligible_Comm_w_o_Opportunity_Amount__c + monthlyCommission.Pre_Eligible_Comm_W_O_Opp_Amount__c;
        monthlyCommission.Cumulative_Non_Eligible_Dealer_Amount__c = monthlyCommission.Non_Eligible_Dealer_Amount__c + monthlyCommission.Pre_Non_eligible_Dealer_Amount__c;
        monthlyCommission.Cum_Non_Eligible_Comm_W_Opp_Amount__c = monthlyCommission.Non_Eligible_Com_with_Opportunity_Amount__c + monthlyCommission.Pre_Non_Eligible_Comm_W_Opp_Amount__c;
        monthlyCommission.Cum_Non_Eligible_Comm_W_O_Opp_Amount__c = monthlyCommission.Non_Eligible_Comm_w_o_Opportunity_Amount__c + monthlyCommission.Pre_Non_Eligible_Comm_W_O_Opp_Amount__c;
        
        return monthlyCommission;
    }
}