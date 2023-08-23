({
    
    getAllReportByLoginUser:function(component, event,helper){
        var action = component.get('c.getAllReportByLoginUser');
        
        action.setParams({ reportType : component.get("v.type") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var setOfIds=[];
                var records = response.getReturnValue();
                if(records != null){
                    component.set('v.reportdata', records);
                    records.forEach(function(record) {
                        if(record.Key_Report__r.Id !=undefined){
                            setOfIds.push(record.Key_Report__r.Id); 
                        }
                        
                    });  
                    component.set('v.selectedIds',setOfIds); 
                }
                
            }else if (state === "ERROR") {
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
        
        $A.enqueueAction(action);
        
    },
    fetchAllMasterReports : function(component, event,helper) {
        
        var action = component.get('c.getAllMasterReports');
        action.setParams({ reportType : component.get("v.type") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                if(records != null){
                    records.forEach(function(record) {
                        record.linkName = '/' + record.Id;
                        record.checked=true;
                    });   
                    component.set('v.reportList', records);
                    var selectedIds=component.get('v.selectedIds');
                    component.set("v.selectedRows",selectedIds);
                }     
            }else if (state === "ERROR") {
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
        
        $A.enqueueAction(action);
        
    },
    getRecordType:function(component, event, helper){
        var action = component.get("c.getRecorTypes");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var value=response.getReturnValue();
                component.set("v.type",value.Kerridge_Links); 
                helper.getAllReportByLoginUser(component, event,helper);      
            }else if (state === "ERROR") {
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
        $A.enqueueAction(action);
    },
    
})