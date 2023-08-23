public class SelectionSheetSelector {
    
    public static List<Selection_Sheet__c> getSelectionSheetByOpportunityIds(set<Id> opportunityIds){
     List<Selection_Sheet__c> selectionSheets=[select Id,Product__c,Opportunity__c,Status__c  from Selection_Sheet__c where Opportunity__c IN:opportunityIds];
        return selectionSheets;
    }
	public static List<Selection_Sheet__c> getSelectionSheetByOpportunityIdAndProductIds(set<Id> opportunityIds,Set<Id> productIds){
     List<Selection_Sheet__c> selectionSheets=[Select Id,Product__c,Selected_Product__c,Opportunity__c from Selection_Sheet__c where (Product__c IN: productIds OR Product__c=:null) AND Opportunity__c IN: opportunityIds];
        return selectionSheets;
    }
    public static List<Selection_Sheet__c> getselectionSheetByUniqueKey(set<String> setOfUniqueKeys ){
       List<Selection_Sheet__c> selectionSheetByUniqueKey=[SELECT id,Name,unique_key_selection__c,Selection_Sheet_ID__c,
                                                            SS_Line_Number__c,
                                                            Product__c from Selection_Sheet__c where unique_key_selection__c IN:setOfUniqueKeys]; 
    return selectionSheetByUniqueKey;
    }
    
    public static List<Selection_Sheet__c> getSelectionSheetById(set<Id> selectionSheetId){
     List<Selection_Sheet__c> selectionSheets=[select Id,Product__c,Opportunity__c,Status__c  from Selection_Sheet__c where Id IN:selectionSheetId];
        return selectionSheets;
    }
    
     public static List<Selection_Sheet__c> getSelectionSheetBySelectionsheetId(set<Id> selectionSheetIDs){
     List<Selection_Sheet__c> selectionSheets=[select Id,Product__c,Opportunity__c,Status__c  from Selection_Sheet__c where Id IN:selectionSheetIDs];
        return selectionSheets;
    }
     
}