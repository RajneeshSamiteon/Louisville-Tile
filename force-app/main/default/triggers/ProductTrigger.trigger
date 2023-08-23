trigger ProductTrigger on Product2 (After Update,after insert,after delete,before insert, before update,before delete) {
    if(trigger.isAfter){
       if(trigger.isUpdate && FlagClass.isAfterUpdateTriggerCalled==false){
            ProductTriggerHelper.afterUpdateHandler(trigger.newMap,trigger.oldMap);
     
      }  
    }
 
}