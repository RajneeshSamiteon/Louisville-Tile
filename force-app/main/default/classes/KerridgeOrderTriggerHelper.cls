public class KerridgeOrderTriggerHelper {
    
    public static void updateOpportuntity(Map<Id,Kerridge_Order__c> kerridgeOrder){
        Map<Id,Opportunity> mapOfOpportunityById=new Map<Id,Opportunity>();
        set<Id> opportuntityIds=new set<Id>();
        for(Kerridge_Order__c ko:kerridgeOrder.values()){
            if(ko.OpportunityId__c !=null){
                opportuntityIds.add(ko.OpportunityId__c); 
            }
        }
        Map<Id,Kerridge_Order__c> mapOfkerridgeOrderById=new Map<Id,Kerridge_Order__c>();
         List<AggregateResult> result = [select OpportunityId__c,Sum(Amount_on_Order__c)totalAmt from Kerridge_Order__c where OpportunityId__c In:opportuntityIds group by OpportunityId__c];
            for(AggregateResult agr:result){
            Opportunity opp=new Opportunity();
            opp.Id=(Id)agr.get('OpportunityId__c');
            opp.Amount_on_Order__c=(Decimal)agr.get('totalAmt');
            mapOfOpportunityById.put((Id)agr.get('OpportunityId__c'),opp);
        }
        if(!mapOfOpportunityById.isEmpty()){
                update mapOfOpportunityById.values();
         
        } 
    }

}