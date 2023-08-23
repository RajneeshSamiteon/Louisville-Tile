@isTest
public class CommissionMasterSelectorTest {
   @istest
     static void testCommissionMasterSelector(){
        
        Id recordTypeId = Schema.SObjectType.Commission_Master__c.getRecordTypeInfosByName().get('Sales Representative - A&D').getRecordTypeId();
        Commission_Master__c commissionMaster = new Commission_Master__c();
        commissionMaster.Name = 'Test';
        commissionMaster.RecordTypeId = recordTypeId;
        commissionMaster.Percent_below_retroactive_EoY_Adj__c = 1;
        commissionMaster.Commission_percent_under_target__c = 1;
        commissionMaster.Target_for_EoY_adjustment__c = 35;
        insert commissionMaster;
     Id Commission_MasterId = [SELECT Id From  Commission_Master__c LIMIT 1].Id;
          Id commission_MasterRecordTypeId = [SELECT RecordTypeId From  Commission_Master__c LIMIT 1].RecordTypeId;
        // System.assertEquals(expected, actual, msg)
        Test.startTest();
        CommissionMasterSelector.getCommissionMasterRecordTypeBases();
         CommissionMasterSelector.getCommissionMasterById(new Set<Id>{commission_MasterId});
           CommissionMasterSelector.getCommissionMaster(new Set<Id>{commission_MasterId});
         CommissionMasterSelector.getCommissionMasterByRecordType(commission_MasterRecordTypeId);
        Test.stopTest();
    }
}