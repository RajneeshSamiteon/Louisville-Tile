trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert,before update,After Insert,After update,After Delete){

    if(trigger.isbefore){
         if(trigger.isInsert){
            //OpportunityLineItemTriggerHelper.beforeInserthandler(Trigger.new);
        }
        if(trigger.isUpdate){
            
            if(ProductCleanUp.isUpdateOpportunityLineItems == false){
                OpportunityLineItemTriggerHelper.beforeUpdatehandler(trigger.NewMap,trigger.OldMap);
            } 
        }
    }
    if(trigger.isAfter ){
        if(trigger.isInsert){
            OpportunityLineItemTriggerHelper.afterInserthandler(trigger.NewMap);
        }
        if(trigger.isUpdate && ProductCleanUp.isUpdateOpportunityLineItems==false){
            FlagClass.isAfterUpdateTriggerCalled = false;
             ProductCleanUp.isUpdateOpportunityLineItems=true;
            OpportunityLineItemTriggerHelper.afterUpdatehandler(trigger.NewMap,trigger.OldMap);
        }
        if(trigger.isDelete){
            //OpportunityLineItemTriggerHelper.afterUpdatehandler(trigger.OldMap);
        }
    }
}