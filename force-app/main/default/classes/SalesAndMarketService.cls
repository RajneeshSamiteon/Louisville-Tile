public without sharing class SalesAndMarketService {
    public static Sales_And_Market__c getSalesAndMarketDetails(Sales_And_Market__c salesAndMarketDetails){ 
        Sales_And_Market__c saleAndMarket=new SalesAndMarketSelector().getsalesMarketsbysalesMarketIds(new Set<Id>{salesAndMarketDetails.Id})[0];
        saleAndMarket.Avg_Home_value_Sell_Price__c=salesAndMarketDetails.Avg_Home_value_Sell_Price__c;
        saleAndMarket.Home_Builder_Type__c=salesAndMarketDetails.Home_Builder_Type__c;
        saleAndMarket.category__c=salesAndMarketDetails.category__c;
        saleAndMarket.Homes_Built_Annually__c=salesAndMarketDetails.Homes_Built_Annually__c;
        saleAndMarket.Selections_Made__c=salesAndMarketDetails.Selections_Made__c;
        saleAndMarket.LTD_Tile_Ancillary_Sales__c=salesAndMarketDetails.LTD_Tile_Ancillary_Sales__c;
        saleAndMarket.LTD_Tile_Sales__c=salesAndMarketDetails.LTD_Tile_Sales__c;
        saleAndMarket.LTD_Ancillary_Sales__c=salesAndMarketDetails.LTD_Ancillary_Sales__c;
        return saleAndMarket;
    }
}