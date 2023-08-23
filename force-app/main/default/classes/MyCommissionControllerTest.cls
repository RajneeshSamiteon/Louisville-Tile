@isTest
public class MyCommissionControllerTest {
    
    @testSetup
    public static void testSetup(){
        User user = new User();
        user.LastName = 'Singh';
        user.Alias = 'singh0';
        user.Email = 'raj@sdfx.com';
        user.Username = 'ice.cream@asdf.com';
        user.ProfileId = [SELECT Id FROM Profile WHERE Name =: CommissionCalculatorConstants.REPTYPEAD LIMIT 1].Id;
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LocaleSidKey = 'en_US';
        insert user;
    }
    
    @isTest
    public static void testgetLoggedInUser(){
        Test.startTest();
        User user = MyCommissionController.getLoggedInUser();
        MyCommissionController.MCCommissionData commissionData = MyCommissionController.getMonthlyBreakDown(user);
        Test.stopTest();
    }
}