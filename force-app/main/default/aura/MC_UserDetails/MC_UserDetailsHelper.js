({
    populateCommissionMasterSchema : function(component, event, helper){
        //debugger; 
        component.set("v.showSpinner",true);
        var action = component.get("c.getCommissionStructureByUserId");
        let profile = component.get("v.currentLoggedInUser").Profile.Name;
        action.setParams({ 
            userProfileName : profile
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.showSpinner",false);
            debugger;
            if (state === "SUCCESS") {
                if(profile == 'Sales Representative - A&D'){
                    component.set('v.isAnDRep', true);
                }
                else{
                    debugger;
                    helper.seperateDealerAndCommercialTiers(component,helper,response.getReturnValue().commissionTiers);
                }
                console.log(JSON.stringify(response.getReturnValue().commissionMaster));
                component.set("v.commissionStructure",response.getReturnValue());
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
                            let errorObj = {'className' : "MC_UserDetails - Aura"};
                            if(errors[0].message.includes('Trace')){                            
                                let err = errors[0].message.split('Trace');
                                errorObj.apexTrace= err[1];
                                errorObj.exceptionMsg = err[0]
                            }
                            else{
                                errorObj.apexTrace= 'helper.populateCommissionMaster';
                                errorObj.exceptionMsg = errors[0].message;
                            }
                            helper.CreateExceptionLog(component,event,helper,errorObj);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    seperateDealerAndCommercialTiers : function(component,helper,commissionTiers){
        let dealerTiers =[];
        let commercialTiers = [];
        try{
            for(let tier of commissionTiers){
                console.log('tier'+JSON.stringify(tier));
                if(tier.Tier_Type__c =='Dealer'){
                    dealerTiers.push(tier);
                }
                else{
                    commercialTiers.push(tier);
                }
            }
            component.set('v.dealerTiers',dealerTiers);
            component.set('v.commercialTiers',commercialTiers);
        }
        catch(err){
            let errorObj = {'className' : "MC_UserDetails - Aura",
                            'apexTrace' : 'helper.populateCommissionMaster',
                            'exceptionMsg' : err.message};
            helper.CreateExceptionLog(component,event,helper,errorObj);
        }
    }
})