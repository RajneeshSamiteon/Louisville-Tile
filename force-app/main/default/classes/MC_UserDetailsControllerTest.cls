@isTest
public class MC_UserDetailsControllerTest {
    
    @testSetup
    public static void createTestData() {
        Commission_Master__c commissionMaster = new Commission_Master__c();
        commissionMaster.Name = 'Dummy Commission Master';
        commissionMaster.RecordTypeId = Schema.SObjectType.Commission_Master__c.getRecordTypeInfosByName().get('Sales Representative - A&D').getRecordTypeId();
        insert commissionMaster;
        
        List<Commission_Tier__c> commissionTiers = new List<Commission_Tier__c>();
        for(Integer i=1; i<3; i++) {
            Commission_Tier__c commissionTier = new Commission_Tier__c();
            commissionTier.Commission_Master__c = commissionMaster.Id;
            commissionTier.Profile_Type__c = 'Sales Representative - A&D';
            commissionTier.Tier_Type__c = 'Retroactive';  
            commissionTier.Lower_Amount__c = (10*i);
            if(i>1){
                commissionTier.Upper_Amount__c = 1000;
            }
            else{
                 commissionTier.Upper_Amount__c = 450;
            }
            commissionTier.Commission_Percentage__c = 34;
            commissionTiers.add(commissionTier);
        }
        insert commissionTiers;
        
        EoY_GP_Target_Bonus__c eoyGPTargetBonus = new EoY_GP_Target_Bonus__c();
        eoyGPTargetBonus.Amount__c = 100;
        eoyGPTargetBonus.Bonus__c = 1300;
        eoyGPTargetBonus.Commission_Master__c = commissionMaster.Id;
        eoyGPTargetBonus.Profile_Type__c = 'Sales Representative - A&D';
        insert eoyGPTargetBonus;
        
        GP_Percent_Target__c gpPercentTarget = new GP_Percent_Target__c();
        gpPercentTarget.Commission_Master__c = commissionMaster.Id;
        gpPercentTarget.Profile_Type__c = 'Sales Representative - A&D';
        gpPercentTarget.Target_Percent__c = 34;
        gpPercentTarget.Type__c = 'Ancillary';
        insert gpPercentTarget;
    }
    
    @isTest
    public static void validateCommissionStructure() {
        Test.startTest();
        MC_UserDetailsController.CommissionStructure commissionStructure = MC_UserDetailsController.getCommissionStructureByUserId('Sales Representative - A&D');
        Test.stopTest();
        
        system.assert(commissionStructure != null, 'No Commission Structure found.');
        system.assert(commissionStructure.commissionMaster != null, 'No Commission Master record found.');
        system.assert(commissionStructure.commissionTiers.size() > 0, 'No Commission Tiers record found.');
        system.assertEquals('Retroactive', commissionStructure.commissionTiers[0].Tier_Type__c, 'Expected : Retroactive, Actual : '+commissionStructure.commissionTiers[0].Tier_Type__c);
        system.assert(commissionStructure.eoyBonusTarget.size() > 0, 'No EoY Bonus Target record found.');
        system.assertEquals('Sales Representative - A&D', commissionStructure.eoyBonusTarget[0].Profile_Type__c, 'Expected : Sales Representative - A&D, Actual : '+commissionStructure.eoyBonusTarget[0].Profile_Type__c);
        system.assert(commissionStructure.gpPercentTargets.size() > 0, 'No GP Percent Targets record found.');
        system.assertEquals('Sales Representative - A&D', commissionStructure.gpPercentTargets[0].Profile_Type__c, 'Expected : Sales Representative - A&D, Actual : '+commissionStructure.gpPercentTargets[0].Profile_Type__c);
    }
    
}