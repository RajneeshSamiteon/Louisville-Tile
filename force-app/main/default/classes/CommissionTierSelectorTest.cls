@isTest
public class CommissionTierSelectorTest {
    @istest static void testMethods(){
        String a = '';
        Test.startTest();
        CommissionTierSelector.getRetroactiveTiersByCommissionMaster(new Set<id>(),a);
        CommissionTierSelector.getCommissionTierByCommissionMasters(new Set<id>());
        Test.stopTest();
    }
}