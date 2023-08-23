({
    doInit : function(component, event, helper) {
        //console.log('entry doInit');
        component.set('v.monthlyBreakDown',[]);
        var currentDay = new Date();
        let Tablemonths =[];
        let months =[{'label': 'January', 'value': '-Jan-'},
                     {'label': 'February', 'value': '-Feb-'},
                     {'label': 'March', 'value': '-Mar'},
                     {'label': 'April', 'value': '-Apr-'},
                     {'label': 'May', 'value': '-May-'},
                     {'label': 'June', 'value': '-Jun-'},
                     {'label': 'July', 'value': '-Jul-'},
                     {'label': 'August', 'value': '-Aug-'},
                     {'label': 'September', 'value': '-Sep-'},
                     {'label': 'October', 'value': '-Oct-'},
                     {'label': 'November', 'value': '-Nov-'},
                     {'label': 'December', 'value': '-Dec-'}];
        var month = currentDay.getMonth() +1;
        for(let temp in months){
            if(months[temp].value ==months[month].value){
                break;
            }
            else{
                Tablemonths.push(months[temp])
            }
        }
        component.set('v.monthList',Tablemonths);
        component.set('v.masterMonthList',months);
        component.set('v.selectedMonth',months[month-1].value);
        //console.log('exit doInit');
    },
    handleUserChanges : function(component, event, helper) {
        //  console.log('entry handleUserChanges');
        helper.getBreakDownData(component, event, helper);  
        //   console.log('Exit handleUserChanges');
    },
    updaterecordThroughMonth : function(component, event, helper) {      
        //  console.log('entry updaterecordThroughMonth');
        component.set('v.spinner',true);
        helper.updateRecordThroughMonth(component,event,helper);    
        //  console.log('exit updaterecordThroughMonth');
    },
    updaterecordThroughYear : function(component, event, helper) {
        //  console.log('entry updaterecordThroughYear');
        helper.updateRecordThroughYear(component,event,helper);    
        //  console.log('exit updaterecordThroughYear');
    },
})