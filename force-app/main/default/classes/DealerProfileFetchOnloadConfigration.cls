public class DealerProfileFetchOnloadConfigration {
    
     //picklist values
	public Map<String,List<String>> getPickListValues(){
        Map<String, List<String>> picklistValuesByFieldName = new Map<String, list<String>>();
        List<String> getDealerCustomerTypeValue = new List<String>();
        List<String> getSelections= new List<String>();
        List<String> getCreatedYear= new List<String>();
        List<String> getHomeBuilderType= new List<String>();
        List<String> getSelectionMade= new List<String>();
        Schema.DescribeFieldResult dealerCustomerTypefieldResult = Dealer_Customer__c.Customer_Type__c.getDescribe();
        List<Schema.PicklistEntry> dealerCustomerTypeValues = dealerCustomerTypefieldResult.getPicklistValues();
        for (Schema.PicklistEntry ac: dealerCustomerTypeValues) {
            getDealerCustomerTypeValue.add(ac.getValue());
        }
        picklistValuesByFieldName.put('accountCategory',new list<string>(getDealerCustomerTypeValue));
        Schema.DescribeFieldResult selectionsfieldResult = Dealer_Customer__c.Selections__c.getDescribe();
        List<Schema.PicklistEntry> selectionsValues = selectionsfieldResult.getPicklistValues();
        for (Schema.PicklistEntry sel: selectionsValues) {
            getSelections.add(sel.getValue());
        }
         picklistValuesByFieldName.put('selections',new list<string>(getSelections));
        
        Schema.DescribeFieldResult selectionsfieldResultforYear = Sales_And_Market__c.Created_year__c.getDescribe();
        List<Schema.PicklistEntry> selectionsValuesforYear = selectionsfieldResultforYear.getPicklistValues();
        for (Schema.PicklistEntry sel: selectionsValuesforYear) {
            getCreatedYear.add(sel.getValue());
        }
        picklistValuesByFieldName.put('createdYear',new list<string>(getCreatedYear));
        
        Schema.DescribeFieldResult homeBuilderType = Sales_And_Market__c.Home_Builder_Type__c.getDescribe();
        List<Schema.PicklistEntry> builderTypeForHome = homeBuilderType.getPicklistValues();
        for (Schema.PicklistEntry sel: builderTypeForHome) {
            getHomeBuilderType.add(sel.getValue());
        }
        picklistValuesByFieldName.put('homeBuilderType',new list<string>(getHomeBuilderType));
         Schema.DescribeFieldResult selectionMade = Sales_And_Market__c.Selections_Made__c.getDescribe();
        List<Schema.PicklistEntry> typeOfSelection = selectionMade.getPicklistValues();
        for (Schema.PicklistEntry sel: typeOfSelection) {
            getSelectionMade.add(sel.getValue());
        }
        picklistValuesByFieldName.put('getSelectionMade',new list<string>(getSelectionMade));
         return picklistValuesByFieldName;
}
}