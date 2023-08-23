@isTest
public class SalesAndMarketSelectorTest {
    @testSetup static void setUp(){
        Account acc = new Account();
        acc.Name = 'Test';
        acc.Account_Type__c = 'Builders';
        acc.Phone = '9080706050';
        Insert acc;
    }
    
    @isTest static void getAllDealerProfileTest(){
        Id accountId = [Select Id,Name from Account where Name='Test' limit 1].Id;
        List<Sales_And_Market__c> listSalesAndMarket = SalesAndMarketSelector.getAllDealerProfile(new Set<Id>{accountId});
    }
    @isTest static void getSalesAndMarketByAccountIdAndCeatedYearTest(){
        Id accountId = [Select Id,Name from Account where Name='Test' limit 1].Id;
        Date currentDate = date.today(); 
        String currentYear = String.Valueof(currentDate.year());
        List<Sales_And_Market__c> listSalesAndMarket = SalesAndMarketSelector.getSalesAndMarketByAccountIdAndCeatedYear(new Set<Id>{accountId},currentYear);
 
    }
}