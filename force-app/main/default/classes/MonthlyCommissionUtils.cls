public class MonthlyCommissionUtils {
    
    public static Monthly_Commission__c checkIfTargetMetForAnD(Monthly_Commission__c monthlyCommission, Monthly_Breakdown__c monthlyBreakdown, Map<Id,Map<String,Decimal>> targetByTypeByCommissionMaster){
        if(monthlyCommission.Tile_Margin_Percent__c >= (targetByTypeByCommissionMaster.get
                                                        (monthlyBreakdown.Monthly_Commission__r.EoY_Sales_Commission__r.Commission_Master__c).get
                                                        ('Tile'))
           && 
           monthlyCommission.Ancillary_Margin_Percent__c >= (targetByTypeByCommissionMaster.get
                                                             (monthlyBreakdown.Monthly_Commission__r.EoY_Sales_Commission__r.Commission_Master__c).get
                                                             ('Ancillary'))){
                                                                 monthlyCommission.target_met__c= true;
                                                             }
        else {
            monthlyCommission.target_met__c= false;
        }
        return monthlyCommission;
    }
    
    public static Monthly_Commission__c assignEligiblesForMonthlyCommission(Monthly_Commission__c monthlyCommission, Monthly_Breakdown__c monthlyBreakdown){
        if(monthlyBreakdown.account__c != null){
            if(CommissionCalculatorConstants.DEALERGROUP.contains(monthlyBreakdown.Bill_To_Group__c.toUpperCase())){
                monthlyCommission.Eligible_Dealer_Amount__c = monthlyBreakdown.Elgible_Amount__c;
                monthlyCommission.Non_Eligible_Dealer_Amount__c = monthlyBreakdown.Non_Eligible_Amount__c;
                monthlyCommission.Dealer_Sales__c = monthlyBreakdown.Total_sales__c;
                monthlyCommission.Eligible_Comm_with_Opportunity_Amount__c = 0;
                monthlyCommission.Non_Eligible_Com_with_Opportunity_Amount__c = 0;
                monthlyCommission.Eligible_Comm_w_o_Opportunity_Amount__c = 0;
                monthlyCommission.Non_Eligible_Comm_w_o_Opportunity_Amount__c = 0;
                monthlyCommission.Commercial_without_Opportunity_Sales__c = 0;
                monthlyCommission.Commercial_with_Opportunity_Sales__c = 0;
            }
            else{
                monthlyCommission.Eligible_Comm_w_o_Opportunity_Amount__c = monthlyBreakdown.Elgible_Amount__c;
                monthlyCommission.Non_Eligible_Comm_w_o_Opportunity_Amount__c = monthlyBreakdown.Non_Eligible_Amount__c;
                monthlyCommission.Commercial_without_Opportunity_Sales__c = monthlyBreakdown.Total_sales__c;
                monthlyCommission.Eligible_Dealer_Amount__c = 0;
                monthlyCommission.Non_Eligible_Dealer_Amount__c = 0;
                monthlyCommission.Eligible_Comm_with_Opportunity_Amount__c = 0;
                monthlyCommission.Non_Eligible_Com_with_Opportunity_Amount__c = 0;
                monthlyCommission.Dealer_Sales__c = 0;
                monthlyCommission.Commercial_with_Opportunity_Sales__c = 0;
            }
        }
        else{
            monthlyCommission.Eligible_Comm_with_Opportunity_Amount__c = monthlyBreakdown.Elgible_Amount__c;
            monthlyCommission.Non_Eligible_Com_with_Opportunity_Amount__c = monthlyBreakdown.Non_Eligible_Amount__c;
            monthlyCommission.Commercial_with_Opportunity_Sales__c = monthlyBreakdown.Total_sales__c;
            monthlyCommission.Eligible_Dealer_Amount__c = 0;
            monthlyCommission.Non_Eligible_Dealer_Amount__c = 0;
            monthlyCommission.Eligible_Comm_w_o_Opportunity_Amount__c = 0;
            monthlyCommission.Non_Eligible_Comm_w_o_Opportunity_Amount__c = 0;
            monthlyCommission.Dealer_Sales__c = 0;
            monthlyCommission.Commercial_without_Opportunity_Sales__c = 0;
        }
        return monthlyCommission;
    }
    
    public static Monthly_Commission__c updateEligiblesForMonthlyCommission(Monthly_Commission__c monthlyCommission, Monthly_Breakdown__c monthlyBreakdown){
        if(monthlyBreakdown.account__c != null){
            if(CommissionCalculatorConstants.DEALERGROUP.contains(monthlyBreakdown.Bill_To_Group__c.toUpperCase())){
                monthlyCommission.Eligible_Dealer_Amount__c += monthlyBreakdown.Elgible_Amount__c;
                monthlyCommission.Non_Eligible_Dealer_Amount__c += monthlyBreakdown.Non_Eligible_Amount__c;
                monthlyCommission.Dealer_Sales__c += monthlyBreakdown.Total_sales__c;
            }
            else{
                monthlyCommission.Eligible_Comm_w_o_Opportunity_Amount__c += monthlyBreakdown.Elgible_Amount__c;
                monthlyCommission.Non_Eligible_Comm_w_o_Opportunity_Amount__c += monthlyBreakdown.Non_Eligible_Amount__c;
                monthlyCommission.Commercial_without_Opportunity_Sales__c += monthlyBreakdown.Total_sales__c;
            }
        }
        else{
            monthlyCommission.Eligible_Comm_with_Opportunity_Amount__c += monthlyBreakdown.Elgible_Amount__c;
            monthlyCommission.Non_Eligible_Com_with_Opportunity_Amount__c += monthlyBreakdown.Non_Eligible_Amount__c;  
            monthlyCommission.Commercial_with_Opportunity_Sales__c += monthlyBreakdown.Total_sales__c;
        }
        return monthlyCommission;
    }
    
    public static Monthly_Commission__c updateCurrentMonthViaLastMonth(Monthly_Commission__c lastMonthlyCommission, Monthly_Commission__c currentMonthlyCommission){
        if(date.today().Month() != 1){
            currentMonthlyCommission.Previous_Ancillary_Margin__c = lastMonthlyCommission.Cumulative_Ancillary_Margin__c;
            currentMonthlyCommission.Previous_Eligible_Margin__c = lastMonthlyCommission.Cumulative_Eligible_Margin__c;
            currentMonthlyCommission.Previous_Tile_Margin__c = lastMonthlyCommission.Cumulative_Tile_Margin__c;
            currentMonthlyCommission.Previous_Total_Margin__c = lastMonthlyCommission.Cumulative_Total_Margin__c;
            currentMonthlyCommission.Previous_Total_Sale__c = lastMonthlyCommission.Cumulative_Total_Sale__c;
            currentMonthlyCommission.Paid_Commission__c = lastMonthlyCommission.Total_Commission__c;
            currentMonthlyCommission.Total_Commission__c = lastMonthlyCommission.Total_Commission__c;
            currentMonthlyCommission.Pre_eligible_Dealer_Amount__c = lastMonthlyCommission.Cumulative_Eligible_Dealer_Amount__c;
            currentMonthlyCommission.Pre_Eligible_Comm_W_Opp_Amount__c = lastMonthlyCommission.Cum_Eligible_Comm_W_Opp_Amount__c;
            currentMonthlyCommission.Pre_Eligible_Comm_W_O_Opp_Amount__c = lastMonthlyCommission.Cum_Eligible_Comm_W_O_Opp_Amount__c;
            currentMonthlyCommission.Pre_Non_eligible_Dealer_Amount__c = lastMonthlyCommission.Cumulative_Non_Eligible_Dealer_Amount__c;
            currentMonthlyCommission.Pre_Non_Eligible_Comm_W_Opp_Amount__c = lastMonthlyCommission.Cum_Non_Eligible_Comm_W_Opp_Amount__c;
            currentMonthlyCommission.Pre_Non_Eligible_Comm_W_O_Opp_Amount__c = lastMonthlyCommission.Cum_Non_Eligible_Comm_W_O_Opp_Amount__c;
        }  
        else{
            currentMonthlyCommission.Previous_Ancillary_Margin__c = 0;
            currentMonthlyCommission.Previous_Eligible_Margin__c = 0;
            currentMonthlyCommission.Previous_Tile_Margin__c = 0;
            currentMonthlyCommission.Previous_Total_Margin__c = 0;
            currentMonthlyCommission.Previous_Total_Sale__c = 0;
            currentMonthlyCommission.Paid_Commission__c = 0;
            currentMonthlyCommission.Total_Commission__c = 0;
            currentMonthlyCommission.Pre_eligible_Dealer_Amount__c = 0;
            currentMonthlyCommission.Pre_Eligible_Comm_W_Opp_Amount__c = 0;
            currentMonthlyCommission.Pre_Eligible_Comm_W_O_Opp_Amount__c = 0;
            currentMonthlyCommission.Pre_Non_eligible_Dealer_Amount__c = 0;
            currentMonthlyCommission.Pre_Non_Eligible_Comm_W_Opp_Amount__c = 0;
            currentMonthlyCommission.Pre_Non_Eligible_Comm_W_O_Opp_Amount__c = 0;
        }
        return currentMonthlyCommission;
    }
}