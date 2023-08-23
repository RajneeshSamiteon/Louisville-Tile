public class MonthlyCommissionSelector {
    public static list<monthly_commission__c> getdataForFullAnnualCalculation(List<String>names){
        return [SELECT Id, CreatedDate , Name,EoY_Sales_Commission__c, Actual_Commission_Earned__c, Ancillary_Margin_Percent__c, Ancillary_Margin__c, 
                Ancillary_Sale__c, Cost__c, Cumulative_Ancillary_Margin__c, Cumulative_Eligible_Margin__c, Cumulative_Tile_Margin__c, Cumulative_Total_Margin__c, 
                Cumulative_Total_Sale__c, Date__c, Eligible_Margin__c, Employee__c, Margin__c, Month__c, Not_Elligible_Margin__c, Paid_Commission__c, 
                Previous_Ancillary_Margin__c, Previous_Eligible_Margin__c, Previous_Tile_Margin__c, Previous_Total_Margin__c, Previous_Total_Sale__c, Price__c, 
                Target_Met__c, Tile_Margin_Percent__c, Tile_Margin__c, Tile_Sale__c, Total_Commission__c, Total_Invoice_Ancillary_Margin__c, 
                Total_Invoice_Tile_Margin__c, Total_Sale__c, Payable_Commission__c, Total_Margin_Without_Split__c, Total_Sale_After_Split__c, 
                Commercial_W_O_Opportunity_Commission__c, Commercial_with_Opportunity_Commission__c, Commercial_with_Opportunity_Sales__c, 
                Commercial_without_Opportunity_Sales__c, Cum_Eligible_Comm_W_O_Opp_Amount__c, Cum_Eligible_Comm_W_Opp_Amount__c, 
                Cum_Non_Eligible_Comm_W_O_Opp_Amount__c, Cum_Non_Eligible_Comm_W_Opp_Amount__c, Cumulative_Eligible_Dealer_Amount__c, 
                Cumulative_Non_Eligible_Dealer_Amount__c, Dealer_Commission__c, Dealer_Sales__c, Eligible_Comm_w_o_Opportunity_Amount__c, 
                Eligible_Comm_with_Opportunity_Amount__c, Eligible_Dealer_Amount__c, Non_Eligible_Com_with_Opportunity_Amount__c, 
                Non_Eligible_Comm_w_o_Opportunity_Amount__c, Non_Eligible_Dealer_Amount__c, Pre_Eligible_Comm_W_O_Opp_Amount__c, 
                Pre_Eligible_Comm_W_Opp_Amount__c, Pre_Non_Eligible_Comm_W_O_Opp_Amount__c, Pre_Non_Eligible_Comm_W_Opp_Amount__c, 
                employee__r.name, employee__r.profile.name, EoY_Sales_Commission__r.Commission_Master__c,
                Pre_Non_eligible_Dealer_Amount__c, Pre_eligible_Dealer_Amount__c, Total_Commercial_Sales__c FROM Monthly_Commission__c
                Where name in: names];
            }
    public static List<Monthly_Commission__c> getMonthlyCommissionByEmployee(){
        return [Select Id,Name,Employee__c,EoY_Sales_Commission__c,Ancillary_Margin__c,Ancillary_Margin_Percent__c,Cost__c,Date__c,Eligible_Margin__c,
                Margin__c,Month__c,Not_Elligible_Margin__c,Total_Commission__c,Price__c,Target_Met__c,Tile_Margin__c,Tile_Margin_Percent__c from Monthly_Commission__c
                where createdDate = LAST_YEAR];                                 	
    }
    public static List<Monthly_Commission__c> getMonthlyCommissionByEmployeeAndBreakDown(set<id> monthlyCommissionIds){
        return [Select Id,CreatedDate, Ancillary_Margin_Percent__c, Ancillary_Margin__c, Cost__c, Date__c, Eligible_Margin__c, Margin__c, Month__c, 
                Not_Elligible_Margin__c, Price__c, Target_Met__c, Tile_Margin_Percent__c, Tile_Margin__c, EoY_Sales_Commission__c, Employee__c, Tile_Sale__c, 
                Ancillary_Sale__c, Total_Invoice_Ancillary_Margin__c, Total_Invoice_Tile_Margin__c, Paid_Commission__c, Total_Commission__c, Previous_Eligible_Margin__c, 
                Previous_Tile_Margin__c, Previous_Ancillary_Margin__c, Previous_Total_Margin__c, Cumulative_Tile_Margin__c, Cumulative_Ancillary_Margin__c, 
                Cumulative_Eligible_Margin__c, Cumulative_Total_Margin__c, Payable_Commission__c, Previous_Total_Sale__c, Cumulative_Total_Sale__c, 
                Total_Sale__c  from Monthly_Commission__c where createdDate = THIS_YEAR AND Id in: monthlyCommissionIds];                                 	
    }
    public static List<Monthly_Commission__c> getMonthlyCommissionByEoySalesCommission(Set<id> eoySaelsCommissions){
        return [Select Id,name,CreatedDate, Ancillary_Margin_Percent__c, Ancillary_Margin__c,Actual_Commission_Earned__c, Cost__c, Date__c, Eligible_Margin__c, Margin__c, Month__c, 
                Not_Elligible_Margin__c, Price__c, Target_Met__c, Tile_Margin_Percent__c, Tile_Margin__c, EoY_Sales_Commission__c, Employee__c, Tile_Sale__c, 
                Ancillary_Sale__c, Total_Invoice_Ancillary_Margin__c, Total_Invoice_Tile_Margin__c, Paid_Commission__c, Total_Commission__c, Previous_Eligible_Margin__c, 
                Previous_Tile_Margin__c, Previous_Ancillary_Margin__c, Previous_Total_Margin__c, Cumulative_Tile_Margin__c, Cumulative_Ancillary_Margin__c, 
                Cumulative_Eligible_Margin__c, Cumulative_Total_Margin__c, Payable_Commission__c, Previous_Total_Sale__c, Cumulative_Total_Sale__c, 
                Total_Sale__c  from Monthly_Commission__c where createdDate = THIS_YEAR AND eoy_sales_commission__c in: eoySaelsCommissions];                                 	
    }
}