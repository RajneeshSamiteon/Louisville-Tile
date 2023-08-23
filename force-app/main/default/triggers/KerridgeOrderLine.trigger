trigger KerridgeOrderLine on Kerridge_Order_Line__c (before insert,After insert,After Update,After Delete) {
     if(Trigger.isbefore){
        if(Trigger.isinsert){
            KerridgeOrderLineItemHelper.isbeforeInsert(Trigger.new);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
        KerridgeOrderLineItemHelper.kerridgeOrderLineItemAfterInsertOrDelete(Trigger.NewMap);
        }
        if(Trigger.isDelete){
        KerridgeOrderLineItemHelper.kerridgeOrderLineItemAfterInsertOrDelete(Trigger.OldMap);
        }
       if(Trigger.isUpdate){
        KerridgeOrderLineItemHelper.kerridgeOrderLineItemAfterUpdate(Trigger.NewMap,Trigger.OldMap);
        } 
    }
}