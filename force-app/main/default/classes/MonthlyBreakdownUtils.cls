public class MonthlyBreakdownUtils {
    public static Monthly_Breakdown__c calculateBreakdownMarginPercentages(Monthly_Breakdown__c monthlyBreakdown){ 
        decimal totalMargin = monthlyBreakdown.Tile_Margin__c + monthlyBreakdown.Ancillary_Margin__c;             
        if(monthlyBreakdown.Tile_Sale__c == 0){
            monthlyBreakdown.Tile_Margin_Percentage__c  = 0;
        }
        else{
            monthlyBreakdown.Tile_Margin_Percentage__c  = ((monthlyBreakdown.Tile_Margin__c / monthlyBreakdown.Tile_Sale__c) *100).setScale(2);
        }
        if(monthlyBreakdown.ancillary_sale__c == 0){
            monthlyBreakdown.Ancillary_Margin_Percentage__c  = 0;
        }
        else{
            monthlyBreakdown.Ancillary_Margin_Percentage__c  = ((monthlyBreakdown.Ancillary_Margin__c / monthlyBreakdown.ancillary_sale__c) *100).setScale(2);
        }
        if(monthlyBreakdown.Total_Sales__c == 0){
            monthlyBreakdown.Margin_Percentage__c = 0;
        }
        else{
            monthlyBreakdown.Margin_Percentage__c = ((totalMargin / monthlyBreakdown.Total_Sales__c) * 100).setScale(2);
        }
        monthlyBreakdown.Total_Invoice_Tile_Margin__c  = ((monthlyBreakdown.Tile_Margin__c  * monthlyBreakdown.Commission_Split_Percentage__c)/100).setScale(2);
        monthlyBreakdown.Total_Invoice_Ancillary_Margin__c   = ((monthlyBreakdown.Ancillary_Margin__c  * monthlyBreakdown.Commission_Split_Percentage__c)/100).setScale(2);
        monthlyBreakdown.Total_Margin__c = monthlyBreakdown.Total_Invoice_Tile_Margin__c + monthlyBreakdown.Total_Invoice_Ancillary_Margin__c;
        
        return monthlyBreakdown;
    }
}