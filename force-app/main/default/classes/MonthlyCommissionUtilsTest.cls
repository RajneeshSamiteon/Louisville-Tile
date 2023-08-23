@isTest
public class MonthlyCommissionUtilsTest {
    @testSetup
    public static void testSetup(){
        Account acc = new Account();
       	acc.name = 'Test Account';
        insert acc;
        Opportunity opp = new Opportunity();
        opp.name = 'Test Opp';
        opp.CloseDate = date.today();
        opp.StageName = 'Sold';
        opp.AccountId = acc.id;
        insert opp;
        Monthly_Commission__c monthlyCommission = new Monthly_Commission__c();
        
        Monthly_Breakdown__c monthlyBreakdown = new Monthly_Breakdown__c();
        
    }
    
    @isTest static void assignEligiblesForMonthlyCommissionTest(){
        Account acc = [SELECT id from Account limit 1];
        Opportunity opp = [SELECT id from Opportunity limit 1];
        Monthly_Commission__c monthlyCommission = new Monthly_Commission__c();        
        Monthly_Breakdown__c monthlyBreakdown = new Monthly_Breakdown__c();
        monthlyBreakdown.account__c = acc.id;
        monthlyBreakdown.Opportunity__c = opp.id;
        monthlyBreakdown.Bill_To_Group__c = 'Dealer';
        monthlyBreakdown.Elgible_Amount__c = 0;
        monthlyBreakdown.Non_Eligible_Amount__c = 0;
        monthlyBreakdown.Total_sales__c = 0;
        
        Test.startTest();
        monthlyCommission = MonthlyCommissionUtils.assignEligiblesForMonthlyCommission(monthlyCommission,monthlyBreakdown);
        monthlyBreakdown.Bill_To_Group__c = 'Abc';
        monthlyCommission = MonthlyCommissionUtils.assignEligiblesForMonthlyCommission(monthlyCommission,monthlyBreakdown);
        monthlyBreakdown.account__c = null;
        monthlyCommission = MonthlyCommissionUtils.assignEligiblesForMonthlyCommission(monthlyCommission,monthlyBreakdown);
        Test.stopTest();
    }
    @isTest static void updateEligiblesForMonthlyCommissionTest(){
        Account acc = [SELECT id from Account limit 1];
        Opportunity opp = [SELECT id from Opportunity limit 1];
        Monthly_Commission__c monthlyCommission = new Monthly_Commission__c();  
        monthlyCommission.Eligible_Dealer_Amount__c = 0;
        monthlyCommission.Non_Eligible_Dealer_Amount__c= 0;
        monthlyCommission.Dealer_Sales__c= 0;
        monthlyCommission.Eligible_Comm_w_o_Opportunity_Amount__c= 0;
        monthlyCommission.Non_Eligible_Comm_w_o_Opportunity_Amount__c = 0;
        monthlyCommission.Commercial_without_Opportunity_Sales__c = 0;
        
        
        monthlyCommission.Eligible_Comm_with_Opportunity_Amount__c = 0;
        monthlyCommission.Non_Eligible_Com_with_Opportunity_Amount__c = 0;  
        monthlyCommission.Commercial_with_Opportunity_Sales__c= 0;
        Monthly_Breakdown__c monthlyBreakdown = new Monthly_Breakdown__c();
        monthlyBreakdown.account__c = acc.id;
        monthlyBreakdown.Opportunity__c = opp.id;
        monthlyBreakdown.Bill_To_Group__c = 'Dealer';
        monthlyBreakdown.Elgible_Amount__c = 0;
        monthlyBreakdown.Non_Eligible_Amount__c = 0;
        monthlyBreakdown.Total_sales__c = 0;
        
        Test.startTest();
        monthlyCommission = MonthlyCommissionUtils.updateEligiblesForMonthlyCommission(monthlyCommission,monthlyBreakdown);
        monthlyBreakdown.Bill_To_Group__c = 'Abc';
        monthlyCommission = MonthlyCommissionUtils.updateEligiblesForMonthlyCommission(monthlyCommission,monthlyBreakdown);
        monthlyBreakdown.account__c = null;
        monthlyCommission = MonthlyCommissionUtils.updateEligiblesForMonthlyCommission(monthlyCommission,monthlyBreakdown);
        Test.stopTest();
    }

}