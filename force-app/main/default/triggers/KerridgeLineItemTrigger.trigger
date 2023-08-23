trigger KerridgeLineItemTrigger on Kerridge_Order_Line__c (before insert) {
    if(Trigger.isbefore){
        if(Trigger.isinsert){
            KerridgeOrderLineItemTriggerHelper.isbeforeInsert(Trigger.new);
        }
    }
}