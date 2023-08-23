trigger KerridgeOrderTrigger on Kerridge_Order__c (After update) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            KerridgeOrderTriggerHelper.updateOpportuntity(trigger.newMap);
        }
    }
}