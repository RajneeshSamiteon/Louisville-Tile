trigger KerridgeQuoteLineItem on Kerridge_Quote_Line__c  (before insert,After insert,After Update,After Delete) {
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
        KerridgeQuoteLineItemHelper.kerridgeQuoteLineItemAfterInsertOrDelete(Trigger.NewMap);
        }
        if(Trigger.isDelete){
        KerridgeQuoteLineItemHelper.kerridgeQuoteLineItemAfterInsertOrDelete(Trigger.OldMap);
        }
       if(Trigger.isUpdate){
        KerridgeQuoteLineItemHelper.kerridgeQuoteLineItemAfterUpdate(Trigger.NewMap,Trigger.OldMap);
        } 
    }
    if(Trigger.isbefore){
        if(Trigger.isinsert){
            KerridgeQuoteLineItemHelper.isbeforeInsert(Trigger.new);
        }
    }
}