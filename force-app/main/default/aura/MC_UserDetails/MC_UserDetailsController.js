({
    doInit : function(component, event, helper) {
        component.set('v.activeSections',['CommissionTiers','EoYBonusTargets','TargetForEoYAdjustment']);
        component.set('v.detailsViewer','Closed');
    },
    
    handleUserChanges : function(component, event, helper) {
        helper.populateCommissionMasterSchema(component, event, helper);  
    },
    
    handleClick : function(component, event, helper) {
        const handler = component.get('v.detailsViewer');
        if(handler === 'Closed'){
            $A.util.removeClass(component.find("viewer"), "display-props");
            component.set('v.detailsViewer','Opened');
        }
        else{
            $A.util.addClass(component.find("viewer"), "display-props");
            component.set('v.detailsViewer','Closed');
        }
    }
})