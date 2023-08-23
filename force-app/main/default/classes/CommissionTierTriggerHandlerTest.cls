@isTest
public class CommissionTierTriggerHandlerTest {
  @testSetup
    public static void testSetup(){
        Commission_Master__c cm = new Commission_Master__c();
        cm.Name = 'demo commision master';
        insert cm;
        System.debug('the commission master : '+cm);
        
        List<Commission_Tier__c> commissionTiers = new List<Commission_Tier__c>();
        
        Commission_Tier__c ct = new Commission_Tier__c();
        ct.Commission_Master__c = cm.Id;
        ct.Lower_Amount__c = 10;
        ct.Upper_Amount__c = 5000;
        ct.minimal_retroactive__c = false;
        ct.Tier_Type__c = 'Retroactive';
        commissionTiers.add(ct);
        
        Commission_Tier__c ct1 = new Commission_Tier__c();
        ct1.Commission_Master__c = cm.Id;
        ct1.Lower_Amount__c = 10;
        ct1.Upper_Amount__c = 5000;
        ct1.minimal_retroactive__c = true;
        ct1.Tier_Type__c = 'Retroactive';
        commissionTiers.add(ct1);
        
        insert commissionTiers;
        System.debug('the commission tier : '+commissionTiers);
        
    }

    public static Map<Id,Commission_Tier__c> getCommisionTier(){
        Map<Id,Commission_Tier__c> CommissionTier = new Map<id,Commission_Tier__c>([SELECT Id, Commission_Master__c, Lower_Amount__c, Upper_Amount__c, minimal_retroactive__c 
                                                                                    FROM Commission_Tier__c]);
        System.debug('the commission tier : '+CommissionTier);
        return CommissionTier;
    }
    @isTest
    public static void validatecommissionTierTriggerHelper(){
        Test.startTest();
        CommissionTierTriggerHandler.commissionTierTriggerHelper(getCommisionTier());
        Test.stopTest();
    }
}