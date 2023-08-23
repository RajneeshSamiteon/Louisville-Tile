({
    populateCurrentLoggedInUser : function(component, event, helper) {
        var action = component.get("c.getLoggedInUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                if((response.getReturnValue().Profile.Name).includes('Sales Representative')){
                    component.set("v.isUserIsSalesRep",true);
                    component.set("v.currentLoggedInUser",response.getReturnValue());
                    if((response.getReturnValue().Profile.Name).includes('A&D')){
                        component.set("v.isAnDRep",true);
                    }
                }
                else{
                    component.set('v.isUserIsSalesRep',false);
                    component.set("v.currentLoggedInUser",response.getReturnValue());
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
                            let errorObj = {'className' : "MyCommission - Aura",
                                            'apexTrace' : "Helper.populateCurrentLoggedInUser",
                                            'exceptionMsg' : errors[0].message};
                            helper.CreateExceptionLog(component,event,helper,errorObj);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    }
})