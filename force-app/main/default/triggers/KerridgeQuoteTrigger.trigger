trigger KerridgeQuoteTrigger on Kerridge_Quote__c (After insert,After Update,After Delete) {
    if(Trigger.isAfter){
        if(trigger.isInsert){
            KerridgeQuoteTriggerHelper.afterInsertHelper(Trigger.NewMap);
        }
        if(trigger.isUpdate){
            KerridgeQuoteTriggerHelper.afterInsertHelper(Trigger.NewMap);
        }
        if(trigger.isdelete){
            KerridgeQuoteTriggerHelper.afterInsertHelper(Trigger.NewMap);
        }
    }
}