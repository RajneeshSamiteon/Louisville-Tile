trigger VendorEvaluationTrigger on VendorEvaluation__c (before insert,before update) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            VendorEvaluationTriggerHepler.isBeforehelper(Trigger.new);
        }
        if(Trigger.isUpdate){
            VendorEvaluationTriggerHepler.isBeforeUpdatehelper(Trigger.new,Trigger.oldMap);
        }
    }
}