({

    doInit : function( component, event, helper ) {
        
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        
    },
    
    // When a keyword is entered in search box
    searchRecords : function( component, event, helper ) {
        if(!$A.util.isEmpty(component.get('v.selectedCatagory')))
        {
            if( !$A.util.isEmpty(component.get('v.searchString')) ) {
                helper.searchRecordsHelper( component, event, helper, '' );
            } else {
                $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
            }
        }
      
    },
    
    // When an item is selected
    selectItem : function( component, event, helper ) {        
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            var recordsList = component.get('v.recordsList');
            var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if(index != -1) {
                var selectedRecord = recordsList[index];
            }
            component.set('v.selectedRecord',selectedRecord);
            component.set('v.value',selectedRecord.value);
            component.set('v.recordsList',[]);
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    
    showRecords : function( component, event, helper ) {
        
        if(!$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
        
    },
    
    // To remove the selected item.
    removeItem : function( component, event, helper ){
        component.set('v.selectedRecord','');
        component.set('v.value','');
        component.set('v.searchString','');
        component.set('v.description','');
        setTimeout( function() {
            component.find( 'inputLookup' ).focus();
        }, 250);
    },
    
    // To close the dropdown if clicked outside the dropdown.
    blurEvent : function( component, event, helper ){
        
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        var value=component.get('v.selectedRecord.selectedValue');
        var sobjectValue=component.get('v.objectName');
        var accountId=component.get('v.selectedRecord.value');
        // alert(accountId);
        var formName=component.get('v.componentName');
        
        if(formName == 'newInternalComponent'){
            // alert(formName);
            helper.getShippingAddress(component, event, helper, accountId );
        }
        else{
            if(sobjectValue == 'Account'){
                if(value != undefined){
                    //   alert(accountId); 
                    helper.searchBranch( component, event, helper, accountId );  
                }else{
                    var compEvent = component.getEvent("branchEvent");
                    compEvent.setParams({
                        "Branch" :" ",
                        "isBranch":false,
                        "ischeckAccountNull":false
                        
                    });
                    compEvent.fire();
                }
            }
        }
        
        
        
    },
    
    //validate 
    validateCustomLookup : function(component,event,helper){
        let allValid =false;
        var validity =component.find('inputLookup').get("v.validity");
        if(validity.valid){
            allValid=true; 
        }else{
            component.find('inputLookup').showHelpMessageIfInvalid()
        }
        
        return allValid;
        
    },
    
})