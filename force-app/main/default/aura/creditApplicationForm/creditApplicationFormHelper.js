({
    sendOTPForVerification : function(component, event, helper) {
        let contactId = component.get("v.contactid");
        if($A.util.isUndefinedOrNull(contactId)) {
            return;
        }
        
        var action = component.get("c.sendVerificationCodeEmail");
        action.setParams({
            contactId : contactId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                try {
                    var response = response.getReturnValue();
                    
                    var codeWithRemainingTime = response.split(':');
                    
                    if (codeWithRemainingTime.length == 3 && codeWithRemainingTime[1].length > 0) {
                        if(codeWithRemainingTime[0] === "--Error--") {
                            helper.showErrorMessage('Cannot generate OTP (wait '+ codeWithRemainingTime[1] +') Use this code - ' + codeWithRemainingTime[2]);
                        }
                    }
                    else {
                        component.set("v.generatedOTP", response);
                        helper.showSuccessMessage("Check your email.");
                    }
                }
                catch(exception) {
                    let errorReferemce = {'className' : "CreditApplicationForm - Aura",
                                          'apexTrace' : "helper.sendOTPForVerification",
                                          'exceptionMsg' : exception.getMessage()};
                    helper.CreateExceptionLog(component, event, helper, errorReferemce);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let err = errors[0].message.split('Trace');
                        let errorReferemce = {'className' : "CreditApplicationForm - Aura",
                                              'apexTrace' : err[1],
                                              'exceptionMsg' :  err[0]};
                        helper.CreateExceptionLog(component, event, helper, errorReferemce);
                    }
                } else {
                    console.log("\n--Unknown error--");
                }
            }
        });
        $A.enqueueAction(action);
	},
    
    verifyUserOTP : function(component, event, helper) {
        let contactId = component.get("v.contactid");
        if($A.util.isUndefinedOrNull(contactId)) {
            return;
        }
        
        var action = component.get("c.getVerificationCode");
        action.setParams({
            contactId : contactId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.generatedOTP", response.getReturnValue());
                var generatedOTP = component.get("v.generatedOTP");
                var enteredOtp = component.get("v.enteredOtp");
                
                if (generatedOTP === enteredOtp) {
                    helper.showSuccessMessage('OTP matched.');
                    component.set("v.isDisplayOTPPage",false);
                }
                else {
                    component.set("v.errorMessage", "Entered OTP is incorrect.");
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let err = errors[0].message.split('Trace');
                        let errorReferemce = {'className' : "CreditApplicationForm - Aura",
                                              'apexTrace' : err[1],
                                              'exceptionMsg' :  err[0]};
                        helper.CreateExceptionLog(component, event, helper, errorReferemce);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    showSuccessMessage : function(messsage) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "success",
                "title": "Success!",
                "message": messsage
            });
            toastEvent.fire();
        }
        catch(e) {
            alert(messsage);
        }
    },
    
    showErrorMessage : function(messsage) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": messsage
            });
            toastEvent.fire();
        }
        catch(e) {
            alert(messsage);
        }
    },
    
    checkCreditFormCompletedOrNot  :  function(component,event,helper){
        component.set("v.isShowSpinner", true);
        
        var action = component.get("c.getIsSubmittedValue");
        action.setParams({ 
            contactId : component.get("v.contactid") 
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let submittedValue = response.getReturnValue();
                component.set("v.isSubmittedForm", submittedValue);
                if(submittedValue) {
                    component.set("v.currentStep", '4');
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorReferemce = {'className' : "CreditApplicationForm - Aura",
                                              'apexTrace' : "helper.checkCreditFormCompletedOrNot",
                                              'exceptionMsg' : errors[0].message};
                        helper.CreateExceptionLog(component, event, helper, errorReferemce);
                        helper.showToastError(errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
            component.set("v.isShowSpinner", false);
        });
        
        $A.enqueueAction(action);
    },
    
    getCreditAppData  :  function(component,event,helper){
        component.set("v.isShowSpinner", true);
        
        var action = component.get("c.getCreditAppValue");
        action.setParams({ 
            contactId : component.get("v.contactid") 
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let submittedValue = response.getReturnValue();
                if(submittedValue.length > 0) {
                    component.set("v.creditAppsObjectName", submittedValue[0].Name);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                        helper.showToastError(errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
            component.set("v.isShowSpinner", false);
        });
        
        $A.enqueueAction(action);
    },
    
    updateStepForSubmit :  function(component,event,helper){
        component.set("v.currentStep", stepval);
        let isSubmit=component.get("v.isSubmittedForm");
        if(isSubmit){
            component.set("v.currentStep", '4');
        }
    },
    
    //To show  error Toast Message
    showToastError : function(message) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error",
                "message": message,
                "type": "Error",
            });
            toastEvent.fire();
        }catch(e){
            alert('error : '+message);
        }
        
    }
    
})