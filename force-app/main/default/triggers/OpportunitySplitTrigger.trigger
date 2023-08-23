trigger OpportunitySplitTrigger on OpportunitySplit (After delete) {
    if(Trigger.isAfter){
        if(Trigger.isDelete){
            OpportunitySplitTriggerHelper.isAfterDeleteHelper(Trigger.old);
        }
    }
}