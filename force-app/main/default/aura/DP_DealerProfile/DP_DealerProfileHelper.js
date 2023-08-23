({
    
    showSaveSuccessToast : function(component, event, helper, Message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Profile Saved Successfully',
            message: 'Saved',  
            type: 'success'  
        });
        toastEvent.fire();
    },
    
    
    showSaveErrorToastWithmessage : function(component, event, helper, message) {
        console.log(message);
        //alert(message)
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:message,
            type: 'error'
        });
        toastEvent.fire();
    },
    
    
    
    getCurrentAccountCategoryValues: function(component, event,helper) {
        var action = component.get("c.getAccountsById");
        action.setParams({ 
            accountId : component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log(JSON.stringify(result));
                
                component.set("v.currentAccountCategary", result[0].Account_Category__c);
                component.set("v.accountName", result[0].Name);
                var accountCategories= component.get("v.accountCategories");
                var lastThreeCategory= component.get("v.lastThreeCategory");
                if (accountCategories.includes(result[0].Account_Category__c)) {
                    component.set("v.isShowSpinner",false);
                    component.set("v.isFirstFourCategoryFound",true);
                }else if(component.get("v.buildercategory")== result[0].Account_Category__c)
                {
                    component.set("v.isbuildercategoryFound",true);
                    component.set("v.isShowSpinner",false);   
                }
                    else if(lastThreeCategory.includes(result[0].Account_Category__c)){
                        component.set("v.isShowSpinner",false);   
                        component.set("v.isLastThreeCategoryFound",true);
                        
                    }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            let err = errors[0].message.split('Trace');
                            let errorObj = {'className' : "Dealer Profile - Aura",
                                            'apexTrace' : err[1],
                                            'exceptionMsg' :  err[0]};
                            helper.CreateExceptionLog(component,event,helper,errorObj); 
                        }
                        
                    }
                } 
            
        });
        $A.enqueueAction(action);
    }                   
})