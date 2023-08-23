public class PriceBookEntrySelector {
    public static List<PricebookEntry> getPriceBooksByProductIdAndPricebookId(Set<Id> productIds){
        return [Select Id,PriceBook2.Name,Pricebook2.Id, Product2Id, Product2.Name, UnitPrice, Name From PricebookEntry WHERE Pricebook2.Name =: Label.pricebook AND IsActive =:true AND Pricebook2.IsActive =:true AND Product2Id IN: productIds];
    }
    public static List<PricebookEntry> getPriceBooksByProductIdsAndPricebookIds(Set<Id> productIds,set<id> pricebookIDs){
        return [Select Id,PriceBook2.Name,Pricebook2.Id, Product2Id, Product2.Name, UnitPrice, Name From PricebookEntry WHERE Pricebook2.id IN:pricebookIDs AND IsActive =:true AND Pricebook2.IsActive =:true AND Product2Id IN: productIds];
    }
    
}