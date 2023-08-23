({
    
    init : function(component, event, helper) {
        helper.getRecordType(component, event,helper);
        component.set('v.reportColumns', [
            {label: 'Report Name', fieldName: 'Report_Url__c', type: 'url',
             typeAttributes: {label: { fieldName: 'Name__c' }, target: '_blank'}},
            
        ]);
            },
            
            handleSelect : function(component, event, helper) {
            if(component.get("v.isbutton")==true){
            component.set("v.isbutton",false);
            }
            var selectedRows = event.getParam('selectedRows'); 
            var setRows = [];
                      for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]);
        }
        component.set('v.selectedReports', setRows);
        
    },
    
    addKerridgeLink : function(component, event, helper) {
        //this var use for store selected ids report Id
        var selectedReportId=[];
        //this var use for store all report Ids
        var allReportId=[];
        //this var use for store unselected ids report Id
        let differenceId=[];
        //get all selected reports 
        var records = component.get('v.selectedReports');
        console.log('records--S---'+JSON.stringify(records));
        records.forEach(function(record) {
            if(record.Id !=undefined){
                selectedReportId.push(record.Id); 
            }
            
        });  
        //get all reports 
        var allReports = component.get('v.reportList');
        allReports.forEach(function(record) {
            if(record.Id !=undefined){
                allReportId.push(record.Id); 
            }
        });
        //get all selected reports Ids
      var selectedId=component.get('v.selectedReportId');
       differenceId = allReportId.filter(x => !selectedReportId.includes(x));
        console.log('difference--------'+differenceId);
        console.log('difference--------'+differenceId);
        console.log('selectedReportId--------'+selectedReportId);
        var action = component.get('c.saveKerridgeReports');
        action.setParams({ 
            unSelectedIds:differenceId,
            selectedIds:selectedReportId,
            reportType:component.get("v.type")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        let err = errors[0].message.split('Trace');
                        console.log(err);
                        let errorObj = {'className' : "homePageKeyReport - Aura",
                                        'apexTrace' : err[1],
                                        'exceptionMsg' :  err[0]};
                        helper.CreateExceptionLog(component,event,helper,errorObj);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        component.set('v.isShowModel',false);
        
        $A.enqueueAction(action);
        
    },
    
    showModel: function(component, event, helper) {
        component.set('v.isShowModel',true);
        helper.fetchAllMasterReports(component, event,helper);    
    },
    hideModel: function(component, event, helper) {
        component.set("v.isbutton",true);
        component.set('v.isShowModel',false);
    },
    
})