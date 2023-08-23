({
    doInit:function(component, event, helper){
       var InstallerTypelabel=$A.get("$Label.c.InstallerType");
        const InstallerType = InstallerTypelabel.split(",");
       component.set("v.InstallerType",InstallerType);
    },
	updatefield:function(component, event, helper){
       
        var builderFlooring=component.get("v.builderFlooring");
        
        builderFlooring.isChange=true;
       
        component.set("v.builderFlooring",builderFlooring);
       
        //component.set("v.openModal",true);
    },
    updatefieldReason:function(component, event, helper){
        
       
        var builderFlooring=component.get("v.builderFlooring");
        
        builderFlooring.isChange=true;
         
       
        component.set("v.builderFlooring",builderFlooring);
       
        component.set("v.openModal",true);
    },
    setFieldValue:function(component, event, helper){
     
        var cmpName=component.get("v.textAreaValue");
        
        var builderFlooring=component.get("v.builderFlooring");
       
        builderFlooring.notes=cmpName;
        
        component.set("v.builderFlooring",builderFlooring);
        component.set("v.openModal",false);

    },
    closeModal:function(component, event, helper){
        component.set("v.openModal",false);

    },
    deleteRow:function(component, event, helper){
        //Get the event using registerEvent name. 
        var cmpEvent = component.getEvent("removeItem"); 
        //Set event attribute value
        cmpEvent.setParams({"index" : component.get("v.index")}); 
        cmpEvent.fire(); 
        
    },
    updateCheckboxes :function(component, event, helper) {
        var checkboxes = event.getSource();
        var checkBoxValue=checkboxes.get("v.checked");
        //for index
        var checkBoxName=checkboxes.get("v.name");
        
        var dealecustomer= component.get("v.builderFlooring");
        
        dealecustomer.isChange=true;
        
        component.set("v.builderFlooring",dealecustomer);
       alert(JSON.stringify(component.get("v.builderFlooring")));
    },
})