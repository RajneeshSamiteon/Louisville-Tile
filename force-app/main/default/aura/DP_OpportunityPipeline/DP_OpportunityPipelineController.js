({
    doInit : function(component, event, helper) {
        helper.getOpportunityPipeLine(component, event, helper,component.get("v.recordId"));
        helper.getRecords(component, event, helper);
    },
    submitDetails:function(component, event, helper){
        component.set('v.isShowSpinner',true);
        helper.saveRecord(component, event, helper);
    },
    
})