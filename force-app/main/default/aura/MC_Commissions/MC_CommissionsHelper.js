({
    /***************************************************
		=> This is our main method from where we will collect all 
       	   all requiered data.  
	****************************************************/
    getBreakDownData : function(component, event, helper) {
        //  console.log('entry getBreakDownData');
        var action = component.get("c.getMonthlyBreakDown");
        action.setParams({  
            userDetail : component.get("v.currentLoggedInUser")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                console.log('BreakDowns===>',response.getReturnValue().monthlyBreakDown);
                console.log(JSON.stringify(response.getReturnValue()));
                component.set('v.MastermonthlyCommissions' , response.getReturnValue().monthlyCommission);
                component.set('v.monthlyBreakDown' , response.getReturnValue().monthlyBreakDown); 
                component.set('v.MastermonthlyBreakDowns' , response.getReturnValue().monthlyBreakDown);
                component.set('v.masterEOYSalesCommission' , response.getReturnValue().EOYsalesCommission);
                /***************************************************
                => this try genrally protect the code in some situation's like when there is no avilable 
                   data for a specific user.  
                ****************************************************/
                try {
                    helper.setYearPickList(component,event,helper);
                    helper.updateRecordThroughYear(component,event,helper);    
                    helper.updateRecordThroughMonth(component,event,helper);
                } catch (error) {
                    console.log('error.message==>'+error.message);
                    component.set('v.isUserHasdata' ,false);
                }
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
                            let errorObj = {'className' : "MyCommissionController - Aura"};
                            if(errors[0].message.includes('Trace')){                            
                                let err = errors[0].message.split('Trace');
                                errorObj.apexTrace= err[1];
                                errorObj.exceptionMsg = err[0]
                            }
                            else{
                                errorObj.apexTrace= 'helper.getBreakDownData';
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
        //  console.log('Exit getBreakDownData');
    },
    
    /***************************************************
    => this method is use for creating the year pick least based on 
       EOY sales commission oldest record year.  
	****************************************************/
    
    setYearPickList : function(component, event, helper) {
        //  console.log('entry setYearPickList');
        let eoySales = component.get('v.masterEOYSalesCommission');
        let leastyear =9999;
        for(let i=0;i<eoySales.length;i++){
            console.log('name : ',eoySales[i].Name);
            let temp = Number(eoySales[i].Name.slice(eoySales[i].Name.length - 4, eoySales[i].Name.length));
            
            //console.log('year',temp);
            leastyear = Math.min(leastyear,temp);
        }
        console.log('leatyear',leastyear);
        let eoyYear = Number(eoySales[eoySales.length -1].CreatedDate.slice(0,4));
        console.log('Ayush Year',eoyYear);
        var currentDay = new Date();
        let yearList =[];
        //let temp={'label':2012,'value': 2012};
        //yearList.push(temp);
        while(leastyear <= currentDay.getFullYear()){
            let temp={'label':leastyear , 'value': leastyear};
            leastyear+=1;
            yearList.push(temp);
        }
        component.set('v.yearList',yearList);
        component.set('v.selectedYear',new Date().getFullYear());
        //  console.log('Exit setYearPickList');
    },
    
    /***************************************************
    => this method is call when some one change the month piclist value
       to filter the commission record based on current selected month.  
	****************************************************/
    
    updateRecordThroughMonth : function(component, event, helper) {
        //  console.log('entry updateRecordThroughMonth');
        component.set('v.spinner',true);
        var selectedOptionValue = component.get("v.selectedMonth");
        component.set('v.selectedMonth',selectedOptionValue);
        helper.updateBreakDownRecord(component, event, helper);
        //  console.log('exit updateRecordThroughMonth');
    },
    
    /***************************************************
    => this method is call when some one change the year piclist value
       to filter the commission record based on current selected year.  
	****************************************************/
    
    updateRecordThroughYear : function(component, event, helper) {
        //  console.log('entry updateRecordThroughYear');
        component.set('v.spinner',true);
        var selectedOptionValue = component.get("v.selectedYear");
        component.set('v.selectedYear',selectedOptionValue);
        helper.updateBreakDownRecord(component, event, helper);
        var currentDay = new Date();
        //console.log('selected ::==?',component.get('v.selectedYear'));
        if(component.get('v.selectedYear') <= currentDay.getFullYear()){
            if(component.get('v.selectedYear') == currentDay.getFullYear()){
                component.set('v.monthVeiwStatus',false);
                component.set('v.eoyCommissionStatus' , false);
            }
            else{
                component.set('v.monthVeiwStatus',true);
                component.set('v.eoyCommissionStatus' , true);
            }
            helper.updateMonthPickList(component, event, helper);
            
        }
        else{
            component.set('v.monthVeiwStatus',false);
            helper.updateMonthPickList(component, event, helper);
            component.set('v.eoyCommissionStatus' , false);
        }
        //  console.log('exit updateRecordThroughYear');
    },
    updateMonthPickList : function(component, event, helper){
        //  console.log('entry updateMonthPickList');
        var currentDay = new Date();
        var month = currentDay.getMonth() +1;
        let Tablemonths =[];
        var months = component.get('v.masterMonthList');
        //console.log('master month ===>', JSON.stringify(component.get('v.masterMonthList')));
        if(component.get('v.monthVeiwStatus')){
            component.set('v.monthList',months);    
        }
        else{
            for(let temp in months){
                if(months[temp].value ==months[month].value){
                    break;
                }
                else{
                    Tablemonths.push(months[temp])
                }
            }
            component.set('v.monthList',Tablemonths);
            //  console.log('exit updateMonthPickList');
        }
    },
    /***************************************************
    => this method is the common call when some one change the month or year piclist value
       to filter the monthly BreakDown record based on current selected month or year.  
	****************************************************/
    
    updateBreakDownRecord :  function(component, event, helper) {
        //  console.log('entry updateBreakDownRecord');
        component.set('v.SelectedMonthlyCommission','');
        helper.updateEoySalesCommissionData(component, event, helper);
        helper.updateMonthlyCommissionData(component, event, helper);
        helper.updateBreakDown(component, event, helper);
        setTimeout(() => {  component.set('v.spinner',false); }, 500);
        //  console.log('exit updateBreakDownRecord'); 
    },
    
    /***************************************************
    => this method is the common call when some one change the month or year piclist value
       to filter the monthly commission record based on current selected month or year.  
	****************************************************/
    
    updateMonthlyCommissionData : function(component, event, helper){ 
        //  console.log('entry updateMonthlyCommissionData'); 
        let monthlyCommissions = component.get('v.MastermonthlyCommissions');
        for(let monthlyCommission in monthlyCommissions){
            if(monthlyCommissions[monthlyCommission].Name.includes(component.get('v.selectedYear')) &&  monthlyCommissions[monthlyCommission].Name.includes(component.get('v.selectedMonth'))){
                component.set('v.SelectedMonthlyCommission',monthlyCommissions[monthlyCommission]);
                break;
            }
        }
        //  console.log('exit updateMonthlyCommissionData'); 
    },    
    
    /***************************************************
    => this method is the common call when some one change the month or year piclist value
       to filter the EOY sales Commission record based on current selected month or year.  
	****************************************************/
    
    updateEoySalesCommissionData : function(component, event, helper){    
        //  console.log('entry updateEoySalesCommissionData'); 
        let eoySalesCommissions =component.get('v.masterEOYSalesCommission');
        for(let eoySalesCommission in eoySalesCommissions){
            if(eoySalesCommissions[eoySalesCommission].Name.includes(component.get('v.selectedYear'))){
                component.set('v.EOYSalesCommission',eoySalesCommissions[eoySalesCommission]);
                break;
            }
            else{
                component.set('v.EOYSalesCommission','');
            }
        }  
        //  console.log('exit updateEoySalesCommissionData'); 
    },                       
    updateBreakDown : function(component, event, helper){
        //  console.log('entry updateBreakDown'); 
        let commissionId ='';
        let breakDowns = component.get('v.MastermonthlyBreakDowns');
        let monthlyCommissions = component.get('v.MastermonthlyCommissions');
        for(let monthlyCommission in monthlyCommissions){
            if(monthlyCommissions[monthlyCommission].Name.includes(component.get('v.selectedYear')) &&  monthlyCommissions[monthlyCommission].Name.includes(component.get('v.selectedMonth'))){
                commissionId = monthlyCommissions[monthlyCommission].Id;
                break;
            }
        }
        let filtredMonthlyBreakDownByYear=[];
        for(let breakDown in breakDowns){
            if(breakDowns[breakDown].Monthly_Commission__c == commissionId){
                let temp = {}
                temp=breakDowns[breakDown];
                filtredMonthlyBreakDownByYear.push(breakDowns[breakDown]);
            }
        }
        component.set('v.monthlyBreakDown',filtredMonthlyBreakDownByYear);
        //  console.log('exit updateBreakDown'); 
    }
})