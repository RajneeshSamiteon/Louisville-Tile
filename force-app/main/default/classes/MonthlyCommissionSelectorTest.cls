@isTest
public class MonthlyCommissionSelectorTest {
@isTest
    static void monthlyCommissionSelectorAllTest(){
               
        Set<Id> eoySaelsCommissions =new Map<Id, EoY_Sales_Commission__c>([select id from EoY_Sales_Commission__c LIMIT 5]).keySet();
        Set<Id> monthlyCommissionIds =new Map<Id, Monthly_Commission__c>([select id from Monthly_Commission__c LIMIT 5]).keySet();
        List<Monthly_Commission__c> monthlyCommissions = MonthlyCommissionSelector.getMonthlyCommissionByEmployee();
        List<Monthly_Commission__c> monthlyCommissionslist = MonthlyCommissionSelector.getMonthlyCommissionByEmployeeAndBreakDown(monthlyCommissionIds);
        List<Monthly_Commission__c> getMonthlyCommissionByEoySalesCommission = MonthlyCommissionSelector.getMonthlyCommissionByEoySalesCommission(eoySaelsCommissions);
        MonthlyCommissionSelector.getdataForFullAnnualCalculation(new List<String>());
    }
}