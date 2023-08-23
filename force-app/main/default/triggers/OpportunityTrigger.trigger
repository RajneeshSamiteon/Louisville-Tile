trigger OpportunityTrigger on Opportunity (Before insert, Before update,Before delete,after insert,after update,after delete) {  
   
    if(trigger.isBefore){
        if(trigger.isInsert){
          OpportunityTriggerHelper.beforeInsertHandler(trigger.new);
        }
        
        if(trigger.isUpdate ){
           OpportunityTriggerHelper.beforeUpdateHandler(trigger.new,trigger.oldMap);
            
        }

    }
    if(trigger.isAfter){
       if(trigger.isInsert){
            OpportunityTriggerHelper.afterInsertHandler(trigger.newMap,trigger.oldMap);
        }
        if(trigger.isUpdate && FlagClass.isAfterUpdateTriggerCalled==false){
            FlagClass.isAfterUpdateTriggerCalled=true;
           
            OpportunityTriggerHelper.afterUpdateHandler(trigger.new,trigger.newMap,trigger.oldMap);
          
        } 
        if(trigger.isDelete){
            OpportunityTriggerHelper.afterDeleteHandler(trigger.oldMap);
        } 
    }
    
}