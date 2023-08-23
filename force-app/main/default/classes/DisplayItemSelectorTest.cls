@isTest
public class DisplayItemSelectorTest {
@isTest
    static void getDisplayItembBytypeAndAccountIdAndYearTest(){
        Account ac=new Account();
        ac.Name='acc';
        insert ac;
        
        
        Display_Item__c dc= new Display_Item__c();
        dc.Type__c='LVT';
        dc.Account__c=ac.id;
        insert dc;
        
        ID accountId=[Select Id,Account__c From Display_Item__c where Type__c='LVT' AND Account__c =:ac.id limit 1].Account__c;
        Test.startTest();
        List<Display_Item__c> dispalyitems = DisplayItemSelector.getDisplayItembBytypeAndAccountIdAndYear('LVT',new Set<Id>{accountId});
         List<Display_Item__c> dispalyitems2 = DisplayItemSelector.getDisplayItemByIds(new Set<Id>{dc.Id});
        Test.stopTest();
        
    }
    
}