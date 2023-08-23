@isTest
public class EmployeeRecordMonthlyCommissionTest {
    @isTest
    public static void employeeRecordTest(){
        CommissionCalculationDataSetup.createTestSetupData();
        test.startTest();  
        EmployeeRecordMonthlyCommission obj = new EmployeeRecordMonthlyCommission();
        Database.executeBatch(obj,100);  
        test.stopTest();
        List<Monthly_Commission__c> listMonthlyCommission = [Select Id,Name from Monthly_Commission__c];
        System.assert(!listMonthlyCommission.isEmpty(),'List should not be empty');


    }
}