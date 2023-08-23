@isTest
public class EoYSalesCommissionSelectorTest {
    @isTest
    static void EoYSalesCommissionSelectorAllTest(){
        list<string> ProfileName = CommissionCalculatorConstants.profileNames;
        
        Id profileId = [SELECT id from profile where Name in :ProfileName limit 1].Id;
        user userObj = new user();
        userObj.lastName = 'Singh';
        userObj.Email = 'Test@gmail.com';
        userObj.ProfileId = profileId;
        userObj.Username = 'akhileshSingh@gmail.com';
        userObj.Alias = 'Singak';
        userObj.TimeZoneSidKey ='America/Yakutat';
        userObj.LocaleSidKey  = 'en_US';
        userObj.EmailEncodingKey  = 'ISO-8859-1';
        userObj.LanguageLocaleKey = 'en_US';
        userObj.Dont_calculate_commission__c  = False ;
        insert userObj;
        
        Set<Id> userIds = new Map<Id, User>([select id from User LIMIT 5]).keySet();
        Set<Id> commissionIds = new Map<Id, EoY_Sales_Commission__c>([select id from EoY_Sales_Commission__c LIMIT 5]).keySet();
        List<EoY_Sales_Commission__c> eoYSalesCommission = EoYSalesCommissionSelector.EoysalesCommissionsByUser(userIds);
        Map<Id,EoY_Sales_Commission__c> eoYSalesCommissionById = EoYSalesCommissionSelector.GetEoysalesCommissions(commissionIds);
        Map<Id,Eoy_Sales_Commission__c> eoYSalesCommissionByIds = EoYSalesCommissionSelector.getEoySalesCommissionById(commissionIds);
        list<EoY_Sales_Commission__c> eoYSalesCommissionList = EoYSalesCommissionSelector.GetEoysalesCommissionsByUserId(userObj.id);
    }
}