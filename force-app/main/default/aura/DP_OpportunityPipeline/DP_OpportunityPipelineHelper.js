({
    getOpportunityPipeLine : function(component, event, helper,recordId) {
        var action = component.get("c.getOpportunityPipeLine");
        action.setParams({
            accountId : component.get("v.recordId") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var sumofTotalOppsAmountsToBeRelatedAccount=0.0;
                var lstOfRecords=response.getReturnValue();
                console.log("soniya " + JSON.stringify(response.getReturnValue()));
                var lstOfForwardRollingRecords=lstOfRecords.forwardRolling;
                var lstOfBackwardRollingRecords=lstOfRecords.backwardRolling;
                for(var i = 0; i < lstOfForwardRollingRecords.length; i++)
                {
                    sumofTotalOppsAmountsToBeRelatedAccount += lstOfForwardRollingRecords[i].totalAmount
                    /*if(lstOfRecords[i].StageName=='Sold'){
                        component.set("v.totalSold",lstOfRecords[i].totalAmount);
                    }*/
                    if(lstOfForwardRollingRecords[i].StageName=='Design & Planning'){
                        component.set("v.totalDesignAndPlanning",lstOfForwardRollingRecords[i].totalAmount);
                    }
                    else if(lstOfForwardRollingRecords[i].StageName=='Contractor Submittals'){
                        component.set("v.totalContractorSubmittals",lstOfForwardRollingRecords[i].totalAmount);
                    }
                        else if(lstOfForwardRollingRecords[i].StageName=='Quoting'){
                            component.set("v.totalQuoting",lstOfForwardRollingRecords[i].totalAmount);
                        }
                            else if(lstOfForwardRollingRecords[i].StageName=='Post Bidding'){
                                component.set("v.totalPostBidding",lstOfForwardRollingRecords[i].totalAmount);
                            }
                                else if(lstOfForwardRollingRecords[i].StageName=='On Order'){
                                    component.set("v.totalOnOrder",lstOfForwardRollingRecords[i].totalAmount);
                                }
                    /*else if(lstOfRecords[i].StageName=='Closed Lost'){
                                            component.set("v.totalClosedLost",lstOfRecords[i].totalAmount);
                                        }*/
                    
                }
                for(var i = 0; i < lstOfBackwardRollingRecords.length; i++){
                    sumofTotalOppsAmountsToBeRelatedAccount += lstOfBackwardRollingRecords[i].totalAmount;
                    if(lstOfBackwardRollingRecords[i].StageName=='Sold'){
                        component.set("v.totalSold",lstOfBackwardRollingRecords[i].totalAmount);
                    }else if(lstOfBackwardRollingRecords[i].StageName=='Closed Lost'){
                        component.set("v.totalClosedLost",lstOfBackwardRollingRecords[i].totalAmount);
                        
                    }
                }
                helper.capturePercentage(component, event, helper,sumofTotalOppsAmountsToBeRelatedAccount); 
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
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    capturePercentage: function(component, event, helper,sumofTotalOppsAmountsToBeRelatedAccount){
        var getSoldAmount=component.get("v.totalSold");
        var getLostAmount=component.get("v.totalClosedLost");
        var percentageOfAmountSold=0.0;
        var percentageOfAmountLost=0.0;
        if(sumofTotalOppsAmountsToBeRelatedAccount>0){
            percentageOfAmountSold=((getSoldAmount/sumofTotalOppsAmountsToBeRelatedAccount)*100).toFixed(2);
            percentageOfAmountLost=((getLostAmount/sumofTotalOppsAmountsToBeRelatedAccount)*100).toFixed(2);
        }
        component.set("v.capturePercentageOfSoldAmount",percentageOfAmountSold);
        component.set("v.capturePercentageOfLostAmount",percentageOfAmountLost);
        component.set("v.isShowSpinner",false);
    }, 
    saveRecord:function(component, event, helper){
        var accountName=component.get("v.accountName");
        const accountNameSplit = accountName.split(" ");
        var dealerProfileName=accountNameSplit[0]+"-"+component.get("v.currentCategory")+"-"+"Profile";
        var dealerProfile=component.get("v.dealerProfile");
        var dealerCustomer=component.get("v.dealerCustomer");
        dealerProfile.createdYear='2023';
        dealerProfile.dealerName=dealerProfileName;
        dealerProfile.dealerCustomerDetails=dealerCustomer;
        console.log(JSON.stringify(dealerProfile));
        component.set("v.dealerProfile",dealerProfile);
        var dealerProfile=component.get("v.dealerProfile");
        var action = component.get("c.saveDealerProfileRecord");
        action.setParams({ 
            dealerProfileJSON : JSON.stringify(dealerProfile),
            accountId : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: " + response.getReturnValue());
                helper.showSaveSuccessToast(component, event, helper,'');
                component.callDoinitMethod();
                component.set('v.isShowSpinner',false);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    component.set('v.isShowSpinner',false);
                    var errors = response.getError();
                    if (errors) {
                        component.set('v.Spinner',false);
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
                    } else {
                        component.set('v.Spinner',false);
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    setdealerProfileData:function(component, event, helper){
        var dealerProfile=component.get("v.dealerProfile");
        var obj={};
        obj.dealerAnnualSalesTotal=0.0;	
        obj.dealerAnnualSalesTotalPercentage=0.0;	
        obj.dealerAnnualPurchase=0.0;	
        obj.dealerAnnualPurchasePercentage=0.0;
        obj.dealerAnnualTileSaleincludelabour=0.0;	
        obj.dealerAnnualTileSaleincludelabourPercentage=0.0;	
        obj.dealerAnnualTileandAnnualPurchase=0.0;	
        obj.dealerAnnualTileandAnnualPurchasePercentage=0.0;	
        obj.tilePurchase=0.0;	
        obj.tilePurchasePercentage=0.0;	
        obj.ancillaryPurchases=0.0;	
        obj.ancillaryPurchasesPercentage=0.0;	
        obj.ltdTileAndAncillarySales=0.0;
        obj.ltdTileAndAncillarySalesPercentage=0.0;	
        obj.ltdTileSale=0.0;	
        obj.ltdTileSalePercentage=0.0;	
        obj.ltdAncillarySales=0.0;
        obj.ltdAncillarySalesPercentage=0.0;
        obj.ltdAncillarySalesMarketShareTarget=0.0;
        obj.ltdTileSalesMarketShareTarget=0.0;
        obj.ltdTileAndAncillarySalesMarketShareTarget=0.0;
        obj.ltdAncillarySalesMS=0.0;
        obj.ltdTileAndAncillarySalesMS=0.0;
        obj.ltdTileSaleMS=0.0;
        obj.ltdTileAndAncillarySalesMarketShare=0.0;
        obj.ltdTileSalesMarketShare=0.0;
        obj.ltdAncillarySalesMarketShare=0.0;
        component.set("v.dealerProfile",obj);
        helper.setDealerCustomerData(component, event, helper);
    },
    setDealerCustomerData:function(component, event, helper){
        var dealecustomer= component.get("v.dealerCustomer");
        var obj={};
        obj.customerName='';
        obj.customerType='';
        obj.selections='';
        obj.inactive=false;
        obj.salesperson='';
        obj.supplier='';
        obj.notes='';
        obj.isDeleted=false;
        dealecustomer.push(obj);
        component.set("v.dealerCustomer", dealecustomer);
    },
    
    getRecords:function(component, event, helper){
        component.set('v.isShowSpinner',true);
        var action = component.get("c.getDealerProfileRecordforLastFourCategories");
        action.setParams({ 
            accountId : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server ---------->: " + JSON.stringify(response.getReturnValue()));
                var dealerProfileRecord=response.getReturnValue();
                if( dealerProfileRecord.recordId != undefined){
                    component.set('v.isButtonDisable',false);
                    component.set("v.dealerProfile",dealerProfileRecord);
                    component.set("v.dealerCustomer",dealerProfileRecord.dealerCustomerDetails);
                    component.set('v.isShowSpinner',false);
                }else{
                    component.set('v.isShowSpinner',false);
                    component.set('v.isButtonDisable',true);
                    helper.setdealerProfileData(component, event, helper);
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    component.set('v.isShowSpinner',false);
                    var errors = response.getError();
                    if (errors) {
                        component.set('v.Spinner',false);
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            // helper.showSaveErrorToastWithmessage(component, event, helper, errors[0].message);
                            let err = errors[0].message.split('Trace');
                            console.log(err);
                            let errorObj = {'className' : "Dealer Profile - Aura",
                                            'apexTrace' : err[1],
                                            'exceptionMsg' :  err[0]};
                            helper.CreateExceptionLog(component,event,helper,errorObj);
                            
                        }
                    } else {
                        component.set('v.Spinner',false);
                        console.log("Unknown error");
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