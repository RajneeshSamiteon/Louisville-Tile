@isTest
public class MonthlyBreakdownSelectorTest {
@isTest
    static void testMonthlyBreakdownSelector(){    
        CommissionCalculationDataSetup.createTestSetupData();
    
       Id monthlybrId = [SELECT Id FROM Monthly_Commission__c LIMIT 1 ].id;
          User user = new User();
        user.LastName = 'Kumar';
        user.Alias = 'Aditya0';
        user.Email = 'kumarAditya123@gmail.com';
        user.Username = 'kumarAditya123@asdf.com';
        user.ProfileId = [SELECT Id FROM Profile WHERE Name =: CommissionCalculatorConstants.REPTYPEAD LIMIT 1].Id;
        user.TimeZoneSidKey = 'America/Yakutat';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LocaleSidKey = 'en_US';
        insert user;  
        
        Id userId = [SELECT Id FROM User LIMIT 1 ].id;
      Test.startTest();
        MonthlyBreakdownSelector.getMonthlyBreakDownByMonthlyCommission(new set<id>{monthlybrId});
         MonthlyBreakdownSelector.getMonthlyBreakDownForCurrentLoggedInUser(userId);
        Test.stopTest();
        
        }
}