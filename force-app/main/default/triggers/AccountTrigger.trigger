trigger AccountTrigger on Account (Before insert, Before update,After update) {
    
     if(trigger.isAfter){
        if(trigger.isUpdate){
            AccountTriggerHelper.isAfterUpdateHandler(trigger.newMap,trigger.oldMap);
        }
    }
}