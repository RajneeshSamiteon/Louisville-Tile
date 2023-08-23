({
    doInit:function(component, event, helper){
          var dealecustomer= component.get("v.builderFlooringRecords");
        var builderFlooring= component.get("v.builderFlooringRecords");
        var obj={};
        builderFlooring.push(obj);
        component.set("v.builderFlooringRecords", builderFlooring);
    },
    addBuilderFlooring : function(component, event, helper) {
        var builderFlooring= component.get("v.builderFlooringRecords");
        var obj={};
        builderFlooring.push(obj);
        component.set("v.builderFlooringRecords", builderFlooring);
                var deleteRow=1;
         var builderFlooringRecords= component.get("v.builderFlooringRecords");
         for(var i=0;i<builderFlooringRecords.length;i++){
            if(builderFlooringRecords[i].isDeleted !=true){
                deleteRow++;
            }
        }
        component.set("v.deleteRow",deleteRow);
    },
    
    updateCheckboxes :function(component, event, helper) {
        var checkboxes = event.getSource();
        var checkBoxValue=checkboxes.get("v.checked");
        //for index
        var checkBoxName=checkboxes.get("v.name");
        var obj={};
        var dealecustomer= component.get("v.builderFlooringRecords");
       // obj=dealecustomer[checkBoxName];
       // obj.inactive=checkBoxValue;
        //obj.isChange=true;
        //dealecustomer[checkBoxName]=obj;
        //component.set("v.builderFlooringRecords",dealecustomer);
        //alert(JSON.stringify(component.get("v.builderFlooringRecords")));
    },
    updatefield :function(component, event, helper){
        var fieldValue = event.getSource();
         var indexvalue=fieldValue.get("v.name");
        var obj={};
        var dealecustomer= component.get("v.builderFlooringRecords");
       // obj=dealecustomer[indexvalue];
        //obj.isChange=true;
        //dealecustomer[indexvalue]=obj;
        //component.set("v.builderFlooringRecords",dealecustomer);
        console.log(JSON.stringify(component.get("v.builderFlooringRecords")));
        //helper.saveRecord(component, event, helper,component.get("v.builderFlooringRecords"));
        
    },
    handleValidation: function (component, event, helper) {
       // debugger;
        var allValid = component.find('DCField').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        return allValid;
    },
   /* 
    removeItems:function(component, event, helper){
       var index = event.getParam("index"); 
        var obj={};
        let builderFlooringRecords = component.get("v.builderFlooringRecords");
       obj=builderFlooringRecords[index];
        obj.isDeleted=true;
        builderFlooringRecords[index]=obj;
        //setting the value of component
        component.set("v.builderFlooringRecords", builderFlooringRecords);
    },*/
})