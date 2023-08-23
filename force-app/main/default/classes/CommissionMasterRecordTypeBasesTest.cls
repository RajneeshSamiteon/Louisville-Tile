@isTest
public class CommissionMasterRecordTypeBasesTest {
    @isTest
    private static void testStart(){
        CommissionCalculationDataSetup.createTestSetupData();
        test.startTest(); 
        CommissionMasterRecordTypeBases obj = new CommissionMasterRecordTypeBases();
        Database.executeBatch(obj);
        test.stopTest();
    }
}