trigger CaseTrigger on Case (Before insert, Before update,after insert,after update,after delete){
   if(trigger.isBefore){
        system.debug('trigger on Opportunity isBefore');
        if(trigger.isInsert){
            system.debug('trigger on Opportunity isInsert');
            CaseTriggerHelper.beforeInsertHandler(trigger.new,null);
        }
        
        if(trigger.isUpdate){
            system.debug('trigger on Opportunity isUpdate');
            CaseTriggerHelper.beforeUpdateHandler(trigger.new,trigger.oldMap);
        }
        
    }
}