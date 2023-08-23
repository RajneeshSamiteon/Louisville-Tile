trigger ProjectBidderTrigger on Project_Bidders__c ( before insert,after insert,after update,after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ProjectBidderTriggerHelper.isAfterInserthelper(Trigger.newMap);
        }
    if(Trigger.isUpdate){
            ProjectBidderTriggerHelper.isAfterUpdatehelper(Trigger.newMap,Trigger.oldMap);
        }
        if(Trigger.isdelete){
            ProjectBidderTriggerHelper.isAfterDeletehelper(Trigger.oldMap);
        }
    }
}