({
    loadCreditApplicationFormCode : function(component, event, helper, flag) {
        let contactId = component.get("v.recordId")
        if($A.util.isUndefinedOrNull(contactId)) {
            return;
        }
        
        var action = component.get("c.getCreditApplicationFormCode");
        action.setParams({
            contactId : contactId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnResponse = response.getReturnValue();
                component.set("v.generatedOtp", returnResponse.generatedOTP);
                if(returnResponse.finalMessage) {
                    component.set("v.codeGenerationAddedTime", returnResponse.finalMessage);
                }
                console.log(flag);
                if(flag === 1 || component.get("v.isCodeChange")==true) {
                    helper.startTimer(component, event, helper); 
                }
                component.set('v.isDisplaySpinner',false);
            }
            else if (state === "ERROR") {
                component.set('v.isDisplaySpinner',false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let err = errors[0].message.split('Trace');
                        let errorReferemce = {'className' : "CreditApplicationCode - Aura",
                                              'apexTrace' : 'helper.loadCreditApplicationFormCode',
                                              'exceptionMsg' : err[0]};
                        helper.CreateExceptionLog(component, event, helper, errorReferemce);
                    }
                } else {
                    console.log("\n--Unknown error--");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    generateCreditFormCode : function(component, event, helper) {
        let contactId = component.get("v.recordId")
        if($A.util.isUndefinedOrNull(contactId)) {
            return;
        }
        
        var action = component.get("c.generateCreditApplicationFormCode");
        action.setParams({
            contactId : contactId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                try {
                    var returnResponse = response.getReturnValue();
                    
                    if (returnResponse.generatedOTP === 'ERROR') {
                        helper.errorToast('Cannot generate OTP (wait '+ returnResponse.finalMessage +')');
                    }
                    else {
                        component.set("v.generatedOtp", returnResponse.generatedOTP);
                        component.set("v.codeGenerationAddedTime", returnResponse.finalMessage);
                        helper.startTimer(component, event, helper);
                        helper.successToast('OTP was successfully generated...');
                    }
                }
                catch(exception) {
                    let errorReferemce = {'className' : "CreditApplicationCode - Helper",
                                          'apexTrace' : "helper.generateCreditFormCode",
                                          'exceptionMsg' : exception.getMessage()};
                    helper.CreateExceptionLog(component, event, helper, errorReferemce);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let errorReferemce = {'className' : "CreditApplicationCode - Helper",
                                              'apexTrace' : "helper.generateCreditFormCode",
                                              'exceptionMsg' : errors[0].message};
                        helper.CreateExceptionLog(component, event, helper, errorReferemce);
                    }
                } else {
                    console.log("\n--Unknown error--");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    startTimer : function(component, event, helper) {
        // component.set('v.isDisableRegenrateButton',true);
        
        var date = new Date(component.get("v.codeGenerationAddedTime"));
        var formattedDate = date.toLocaleString('en-US', { month: 'short', day: '2-digit', year:'numeric', hour:'2-digit', minute:'2-digit', second:'2-digit' });
        var countDownDate = new Date(formattedDate).getTime();
        
        // Update the count down every 1 second
        var x = setInterval(function() {
            var now = new Date().getTime();
            var distance = countDownDate - now;
            
            // Time calculations for days, hours, minutes and seconds
            //var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            if(distance) {
                var minutes = parseInt(Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60)), 10);
                var seconds = parseInt(Math.floor((distance % (1000 * 60)) / 1000), 10);
                // var seconds = Math.floor((distance % (1000 * 60)) / 1000);
                
                // Output the result in an element with id="demo"
                var remainingTime =  (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                //alert(isNaN(remainingTime));
                
                component.set('v.remainingTime', remainingTime);
            }
            
            // If the count down is over, write some text 
            if (distance < 0) {
                clearInterval(x);
                component.set('v.remainingTime','--:--');
                component.set('v.isDisableRegenrateButton',false);
            }
        }, 1000);
    },
    
    successToast : function(message) {
        try {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":'Success',
                "message": message,
                "type":'success'
            });
            toastEvent.fire();
        }
        catch(e) {
            alert(message);
        }
    },
    
    errorToast : function(message) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":'Error',
                "message": message,
                "type":'error'
            });
            toastEvent.fire();
        }
        catch(e){
            alert("Error :: "+message);
        }
    }
    
})