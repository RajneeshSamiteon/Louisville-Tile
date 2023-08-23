trigger OpportunityTeamMemberTrigger on OpportunityTeamMember (before insert,before update,After Insert,After update) {
    if(trigger.isBefore){
        if(trigger.isInsert ) {
            System.debug('before trigger');
           OpportunityTeamMemberTriggerHelper.isbeforeinsert(trigger.new);

        } 
        if(trigger.isUpdate ) {
            System.debug('before update');
           OpportunityTeamMemberTriggerHelper.isbeforeUpdate(trigger.new);
        }
    }
     if(trigger.isAfter){
        if(trigger.isInsert ) {
            System.debug('After trigger');
         // OpportunityTeamMemberTriggerHelper.afterInsert(trigger.new);

        } 
        if(trigger.isUpdate ) {
            System.debug('After update');
          // OpportunityTeamMemberTriggerHelper.beforeUpdate(trigger.new);
        }
    }
}