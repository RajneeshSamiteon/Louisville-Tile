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
                component.set("v.homeBuilderTypePicklist", result.homeBuilderType);
                component.set("v.selectionMade", result.getSelectionMade);
                component.set("v.createdYear", result.createdYear);
                helper.getAllBuilerRecoderProfileRecords(component, event,helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
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
    saveRecord:function(component, event,helper){
        var builderRecord=component.get('v.builderRecord');
        var accountName=component.get("v.accountName");
        const accountNameSplit = accountName.split(" ");
        builderRecord.Name=accountNameSplit[0]+"-"+component.get("v.currentCategory")+" "+"Profile";
        builderRecord.category__c=component.get("v.currentCategory");
        builderRecord.Account__c=component.get("v.recordId");
        builderRecord.Builder_Floorings__r={};
        console.log(JSON.stringify(builderRecord));
        console.log(JSON.stringify(component.get('v.builderFlooringRecords')));
        var action = component.get("c.saveBuilderRecord");
        action.setParams({ 
            builderRecordsJSON : JSON.stringify(builderRecord),
            builderFlooringsJSON:JSON.stringify(component.get('v.builderFlooringRecords'))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log(JSON.stringify(result));
                component.set("v.isShowSpinner",false);
                helper.showSaveSuccessToast(component, event, helper,'');
                component.reloadMethod();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    component.set("v.isShowSpinner",false);
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
    getAllBuilerRecoderProfileRecords:function(component, event, helper){
        debugger;
        
        var action = component.get("c.getRecordsbyAccountAndCategory");
        action.setParams({
            accountId:component.get("v.recordId"),
            category:component.get("v.currentCategory")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var builderRecords=response.getReturnValue();
                console.log("JSON.stringify(builderRecords)");
                console.log(JSON.stringify(builderRecords));
                if(builderRecords.length>0){

                    component.set("v.builderRecord",builderRecords[0]);
                    component.set("v.buttonDisable",false);
                    component.set("v.isShowSpinner",false);
                    component.set("v.builderFlooringRecords",builderRecords[0].Builder_Floorings__r);
                }else{
                   
                    component.set("v.isShowSpinner",false);
                    component.set("v.buttonDisable",true);
                }
                // component.set("v.storeAllCreatedRecord",response.getReturnValue());
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
                            if(err[0].includes("You do not have access to the Apex class named")){
                                var msg="You don't have access to create or view dealer profiles. Please contact your Salesforce Administrator or submit a support ticket.";
                                helper.showSaveErrorToastWithmessage(component, event,helper,msg);
                            }else{
                                let errorObj = {'className' : "Dealer Profile - Aura",
                                                'apexTrace' : err[1],
                                                'exceptionMsg' :  err[0]};
                                helper.CreateExceptionLog(component,event,helper,errorObj);
                            }
                            
                        }
                    } 
                }
        });
        $A.enqueueAction(action);
    },
    
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
    
})