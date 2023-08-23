({
    doInit : function(component, event, helper) {
        component.set("v.isShowSpinner",true);
        //component.get("v.builderRecord")
        var builderRecord=component.get("v.builderRecord");
        var obj={};
        obj.LTD_Tile_Ancillary_Sales__c=0.0;
        obj.LTD_Tile_Sales__c=0.0;
        obj.LTD_Ancillary_Sales__c=0.0;
        obj.Avg_Home_value_Sell_Price__c=0.0;
        component.set("v.builderRecord",obj);
        helper.getAccountCategoryValues(component, event,helper);
        const currentdate = new Date();
        let year = currentdate.getFullYear();
        component.set('v.currentDate', currentdate);
        component.set("v.currentYear",year);
    },
    submitDetails:function(component, event, helper){
        component.set("v.isShowSpinner",true);
        helper.saveRecord(component, event, helper);
    },
    handleCurrentYear:function(component, event, helper){
        //      var selected = event.currentTarget;
        //        var indexVal = selected.dataset.recordId;
        var currentName = event.getSource().get('v.label');
        var currentName = currentName.split('-');
        var year = currentName[currentName.length -1];
        if(year.length==4){
            
            helper.getAllBuilerRecoderProfileRecordsByYear(component, event, helper,year);
        }
    },
    getAncilliarySales:function(component, event, helper){
        var ctarget = event.getSource().get("v.value");
        var builderRecord= component.get("v.builderRecord");
        builderRecord.LTD_Tile_Ancillary_Sales__c=(parseFloat(builderRecord.LTD_Tile_Sales__c)+parseFloat(ctarget)).toFixed(1);
        component.set("v.builderRecord",builderRecord);
    },
    getTileDetails:function(component, event, helper){
        var ctarget = event.getSource().get("v.value");
        var builderRecord= component.get("v.builderRecord");
        builderRecord.LTD_Tile_Ancillary_Sales__c=(parseFloat(builderRecord.LTD_Ancillary_Sales__c)+parseFloat(ctarget)).toFixed(1);
        component.set("v.builderRecord",builderRecord);
    },
})