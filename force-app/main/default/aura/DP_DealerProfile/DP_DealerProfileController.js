({
    doInit : function(component, event, helper) {
        //  component.set("v.isShowSpinner",true);
       var accountcategoryLabel=$A.get("$Label.c.First_4_account_category");
        const accountCategory = accountcategoryLabel.split(",");
        component.set("v.accountCategories",accountCategory);
        var buildercategoryLabel=$A.get("$Label.c.builder_category");
        component.set("v.buildercategory",buildercategoryLabel);
         var lastThreeCategory=$A.get("$Label.c.Last_3_Account_category");
        const accountLastThreeCategory = lastThreeCategory.split(",");
         component.set("v.lastThreeCategory",accountLastThreeCategory);
        helper.getCurrentAccountCategoryValues(component, event,helper);
    },
    
    
})