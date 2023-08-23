({
	 getAccountCategoryValues: function(component, event,helper) {
        var action = component.get("c.fetchOnLoadConfigration");
         action.setParams({ 
            accountId : component.get('v.recordsId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log(JSON.stringify(result));
                component.set("v.accountCategory", result.accountCategory);
                component.set("v.selections", result.selections);
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
                        console.log(err);
                        let errorObj = {'className' : "Dealer Profile - Aura",
                            'apexTrace' : err[1],
                            'exceptionMsg' :  err[0]};
            				helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } 
                }
        });
        $A.enqueueAction(action);
    },
    getAccountCategoryType: function(component, event,helper) {
        var action = component.get("c.fetchOnLoadConfigrationbyAccountId");
         action.setParams({ 
            accountId : component.get('v.recordsId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var  result= response.getReturnValue();
                //console.log(JSON.stringify(result));
                //alert(result);
                component.set("v.accountCategoryType", result);
                helper.setSeletion(component, event,helper);
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
                        console.log(err);
                        let errorObj = {'className' : "Dealer Profile - Aura",
                            'apexTrace' : err[1],
                            'exceptionMsg' :  err[0]};
            				helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } 
                }
        });
        $A.enqueueAction(action);
    },
     setSeletion :function(component, event, helper) {
      var selections=$A.get("$Label.c.Selection_For_Dealer");
        const selectionsArray = selections.split(",");
         component.set("v.selectionsbycategory",selectionsArray);
        var selections=$A.get("$Label.c.Selection_Not_For_Dealer");
        const selectionsArrayOther = selections.split(",");
		component.set("v.selectionsbyOthercategory",selectionsArrayOther);
         
    },
})