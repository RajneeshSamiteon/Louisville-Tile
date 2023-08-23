({
    doInit : function(component, event, helper) {
        var flag = 0;
        try {
            window.setInterval(
                $A.getCallback(function() {
                    flag += 1;
                    helper.loadCreditApplicationFormCode(component, event, helper, flag);  
                }), 3000
            );   
        }
        catch(exception) {
            let errorReferemce = {'className' : "CreditApplicationCode - Aura Controller",
                                  'apexTrace' : "doInit",
                                  'exceptionMsg' : exception.getMessage()};
            helper.CreateExceptionLog(component, event, helper, errorReferemce);
        }
    },
    
    regenerateCode : function(component, event, helper) {
        component.set('v.isDisableRegenrateButton',true);
        helper.generateCreditFormCode(component, event, helper);
    },
    handleCodeChange:
     function(component, event, helper) {
         component.set("v.isCodeChange",true);
         component.set('v.isDisableRegenrateButton',true);
    },
    
})