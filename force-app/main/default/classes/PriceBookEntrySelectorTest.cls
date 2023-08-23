@isTest
public class PriceBookEntrySelectorTest {
@isTest
    public static void getPriceBooksByProductIdAndPricebookId(){
        set<id> pricebookId=new set<Id>();
        set<id> pricebookByProductid=new set<Id>();
        List<PricebookEntry> pbList=[select id,Product2Id,Pricebook2.Id from PricebookEntry];
        for(PricebookEntry pb:pbList){
            pricebookByProductid.add(pb.Product2Id);
            pricebookId.add(pb.Pricebook2Id);
        }
        List<PricebookEntry> pbs=PriceBookEntrySelector.getPriceBooksByProductIdAndPricebookId(pricebookByProductid);
        List<PricebookEntry> pBooks=PriceBookEntrySelector.getPriceBooksByProductIdsAndPricebookIds(pricebookByProductid,pricebookId);
    }
}