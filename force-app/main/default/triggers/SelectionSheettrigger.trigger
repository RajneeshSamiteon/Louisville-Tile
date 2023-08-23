trigger SelectionSheettrigger on Selection_Sheet__c (before insert,before update,after insert,after update,after delete) {
    try{
        if(Trigger.isbefore){
            if(Trigger.isinsert){
                SelectionSheetTriggerHelper.isbeforeInsert(Trigger.new);
                SelectionSheetTriggerHelper.updateSelectionSheetStatus(Trigger.new);
            }
        }
        
        if(Trigger.isbefore){
            if(Trigger.isupdate){
                SelectionSheetTriggerHelper.updateSelectionSheetStatus(Trigger.new);
            }
        }
        
        if(Trigger.isafter){
            if(Trigger.isinsert){
                SelectionSheetTriggerHelper.productInsertInOpportunityLineItem(Trigger.new);
                //SelectionSheetTriggerHelper.selectionSheetsAfterInsert(Trigger.new);            
            }
            if(Trigger.isupdate){
                //SelectionSheetTriggerHelper.selectionSheetsAfterInsert(Trigger.new);
                SelectionSheetTriggerHelper.productUpdateInOpportunityLineItem(Trigger.newMap,Trigger.OldMap);
            }
            if(Trigger.isdelete){
                //SelectionSheetTriggerHelper.selectionSheetsAfterInsert(Trigger.old);
            }
        }   
    }catch(Exception e) {
        System.debug('An exception occurred: ' + e.getMessage());
        ExceptionUtils.createExceptionLog('SelectionSheetTriggerHelper - selectionSheetsMethod',e.getMessage(),e.getStackTraceString());
    }
    
    
    
}