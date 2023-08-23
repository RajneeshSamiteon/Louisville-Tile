trigger SampleRequestFormTrigger on Sample_Request_Form__c (before insert, before Update) {  
    
    if(trigger.isBefore){
        if(trigger.isUpdate){
            SampleRequestFormHelper.handleBeforeUpdate(trigger.oldMap,trigger.new);    
        }
        
        else if(trigger.isInsert){
            SampleRequestFormHelper.handleBeforeInsert(trigger.new);    
        }
    }
}