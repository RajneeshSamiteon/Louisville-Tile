@isTest
public class KerridgeOrderTriggerHelperTest {
@isTest
    public static void updateOpportuntityTest(){
        Map<id,Kerridge_Order__c> kOrderById=new Map<id,Kerridge_Order__c>();
       opportunity opp=new opportunity();
            opp.Name='test';
            opp.CloseDate=date.newInstance(2022, 6, 23);
            opp.StageName='Quoting';
           insert opp;
        Kerridge_Order__c kO=new Kerridge_Order__c();
        kO.Name='KO1';
        kO.Kerridge_Order__c='121';
        kO.Amount_on_Order__c=25;
        kO.OpportunityId__c=opp.Id;
        insert kO;
        Kerridge_Order__c kerridge=[select Id,Amount_on_Order__c,OpportunityId__c from Kerridge_Order__c where Id =:kO.Id];
        kerridge.Amount_on_Order__c=30;
        kOrderById.put(kerridge.id,kerridge);
        update kOrderById.values();
        test.startTest();
        KerridgeOrderTriggerHelper.updateOpportuntity(kOrderById);
        test.stopTest();
        opportunity ops=[select id,Amount_on_Order__c from opportunity where id=:opp.Id];
        system.assertEquals(30, ops.Amount_on_Order__c);
    }
}