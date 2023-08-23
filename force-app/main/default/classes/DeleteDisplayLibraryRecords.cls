global without sharing class DeleteDisplayLibraryRecords implements Database.Batchable<sObject>,Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        Integer closedDateLimit =Integer.valueOf([SELECT Outdated_Display_Library_Removed_Records__c,DeveloperName FROM Display_Library_Configuration__mdt WHERE developerName ='Years_Of' LIMIT 1].Outdated_Display_Library_Removed_Records__c);
        String query = 'SELECT Id,Name,Date_Removed__c FROM Display_Library__c WHERE Date_Removed__c  <= N_YEARS_AGO:'+String.valueOf(closedDateLimit);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Display_Library__c> displayLibrarires) {
        
        if(!displayLibrarires.isEmpty()){
            
            delete displayLibrarires;
            
        }
        
    }   
    
    global void finish(Database.BatchableContext BC){
        // execute any post-processing operations
    }
    
    global void execute(SchedulableContext sc){
        
        DeleteDisplayLibraryRecords DeleteDisplayLibraryRecords= new DeleteDisplayLibraryRecords(); 
        database.executeBatch(DeleteDisplayLibraryRecords);
        
    }
}