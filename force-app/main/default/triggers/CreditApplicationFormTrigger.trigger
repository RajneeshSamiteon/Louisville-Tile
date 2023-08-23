trigger CreditApplicationFormTrigger on Credit_Application_Form__c (before insert, before update) {

    if(!CreditApplicationFormTriggerHelper.skipCreditTrigger){
        if(trigger.isBefore){
            if(trigger.isUpdate){
                system.debug('call trigger credit');
                CreditApplicationFormTriggerHelper.handleBeforeUpdate(trigger.new, trigger.newMap);
            }
        }
    }
}