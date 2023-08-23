trigger LeadTrigger on Lead (before insert, before update) {
   
if(trigger.isBefore){
        if(trigger.isInsert){
            LeadTriggerHelper.isBeforeInsertHandler(trigger.new,null);
          }
        
        if(trigger.isUpdate){
            LeadTriggerHelper.isBeforeUpdateHandler(trigger.new,trigger.oldMap);
        }
    }

}