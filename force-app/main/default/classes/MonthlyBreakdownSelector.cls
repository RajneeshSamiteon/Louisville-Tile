public class MonthlyBreakdownSelector {
    public static List<monthly_breakdown__c> getMonthlyBreakDownByMonthlyCommission(set<id> monthlyCommissions){
        return [SELECT Id, Name, Account__c, Opportunity__c, Tile_Margin_Percentage__c,tile_margin_target_met__c,
                monthly_commission__r.employee__r.profile.name,ancillary_margin_target_met__c,Bill_To_Group__c,
                Ancillary_Margin_Percentage__c, Commission_Split_Percentage__c, Opportunity__r.name,Account__r.name,Total_Invoice_Tile_Margin__c,Tile_margin__c,Total_Margin_without_Split__c, 
                Total_Invoice_Ancillary_Margin__c, Total_Margin__c, Met_Margin__c,Elgible_Amount__c,Ancillary_Margin__c,
                Monthly_Commission__c ,tile_sale__c, ancillary_sale__c,Monthly_Commission__r.Name,Total_sales__c,Non_Eligible_Amount__c, 
                Monthly_Commission__r.Employee__c,Monthly_Commission__r.EoY_Sales_Commission__r.Commission_Master__c,Margin_Percentage__c  FROM Monthly_Breakdown__c 
                WHERE Monthly_Commission__c in : monthlyCommissions];
    }
    public static List<monthly_breakdown__c> getMonthlyBreakDownForCurrentLoggedInUser(id UserID){
        return [SELECT Id, Name, Account__c, Opportunity__c,Opportunity__r.name,Account__r.name, Tile_Margin_Percentage__c,
                monthly_commission__r.employee__r.profile.name, Bill_To_Group__c,
                Ancillary_Margin_Percentage__c, Commission_Split_Percentage__c, Total_Invoice_Tile_Margin__c,Tile_margin__c, 
                Total_Invoice_Ancillary_Margin__c, Total_Margin__c, Met_Margin__c,Elgible_Amount__c,Ancillary_Margin__c,createdDate,
                Monthly_Commission__c ,tile_sale__c, ancillary_sale__c,Monthly_Commission__r.Name,Total_sales__c, 
                Monthly_Commission__r.Employee__c,Monthly_Commission__r.EoY_Sales_Commission__r.Commission_Master__c FROM Monthly_Breakdown__c WHERE monthly_commission__r.employee__c =:UserID];
    }
    
}