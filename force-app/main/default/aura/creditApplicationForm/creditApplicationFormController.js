({
    doInit : function(component, event, helper) {
        // for getting Contact id form URL  
        let idFromUrl = URLSearchParams(window.location.search).get("contactid");
        component.set("v.contactid", idFromUrl);
        
        // check Credit Application Form is completed or not
        helper.checkCreditFormCompletedOrNot(component, event, helper);
        
        // helper send the OTP for verification before opening the link
        helper.sendOTPForVerification(component, event, helper);
        
        // update step for last page
        helper.getCreditAppData(component, event, helper);
    },
    
    verifyOTP : function(component, event, helper) {
        var userEnteredOtp = component.get("v.enteredOtp");
        
        if (!userEnteredOtp) {
            component.set("v.errorMessage", "Please enter OTP.");
        }
        else {
            component.set("v.errorMessage", "");
            helper.verifyUserOTP(component, event, helper);
        }
    },
    
    resendOTP : function(component, event, helper) {
        component.set("v.errorMessage","");
        helper.sendOTPForVerification(component, event, helper);
    },
    
    verfiyVerficationCode : function(component, event, helper) {
        let sysGeneratedVerficationCode = component.get("v.systemGeneratedVerificationCode");
        let userEnteredVerificationCode = component.get("v.verificationCode");
        if(sysGeneratedVerficationCode == userEnteredVerificationCode){
            //hide the modal & show the form
            component.set("v.isShowModal", false);
        }else{
            helper.showErrorMessage(component, event, helper,"Please enter the correct verfication code.");
        }
    },
    
    /*  
    updateStepTo1 : function(component, event, helper) {
        component.set("v.currentStep", "1");  
	},
    updateStepTo2 : function(component, event, helper) {
        component.set("v.currentStep", "2");  
	},
    updateStepTo3 : function(component, event, helper) {
        component.set("v.currentStep", "3");  
	},
    updateStepTo4 : function(component, event, helper) {
        component.set("v.currentStep", "4");  
	},
    */
    
    updateStep : function(component, event, helper){
        var stepval = event.getParam("stepVal");
        component.set("v.currentStep", stepval);
    },
    ifEnterKeyPressed : function(component, event, helper) {     
        debugger;
        
        if ( event.keyCode == 13 ){
            console.log(event.keyCode == 13);
            event.preventDefault();

            try{
                var action = component.get('c.verifyOTP'); 
                $A.enqueueAction(action);
            }
            catch (err){
                let errorObj = {'className' : "CreditAppForm - Aura",
                                'apexTrace' : "ifEnterKeyPressed",
                                'exceptionMsg' : err.message};
                helper.CreateExceptionLog(component,event,helper,errorObj);
            }
        } 
    } ,
    
})