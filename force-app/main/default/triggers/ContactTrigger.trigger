trigger ContactTrigger on Contact (Before insert, Before update,after insert,after update,after delete) {

    
      if(trigger.isBefore){
        if(trigger.isInsert){
          ContactTriggerHelper.beforeInsertHandler(trigger.new);
        }
        
        if(trigger.isUpdate ){
           ContactTriggerHelper.beforeUpdateHandler(trigger.new,trigger.oldMap);
            
        }
        
    }
}