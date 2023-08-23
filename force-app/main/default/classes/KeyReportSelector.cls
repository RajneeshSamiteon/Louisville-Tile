public class KeyReportSelector {

   public static List<Key_Report_Assignment__c> getKeyReportAssignmentByReportTypeAndLoginUser(String reportType){
		return [SELECT Name,Id,User__c,Key_Report__c,Key_Report__r.Id,Key_Report__r.Name__c,Key_Report__r.Report_Url__c
                FROM Key_Report_Assignment__c 
                where Key_Report__r.Type__c=:reportType AND User__c=:userInfo.getUserId() order by Key_Report__r.Name__c ];   
   }
    
    public static List<Key_Report__c> getAllMasterRecordByType(String reportType){
 		return [SELECT Name,Name__c,Id,report_Id__c,Report_Url__c FROM Key_Report__c where Type__c=:reportType order by Name__c];    
    }

    public static List<Key_Report_Assignment__c> getKeyReportsAssignmentsByKeyReportidsAndTypeAndLoginUser(Set<id> ids,String reportType){
 		return [SELECT Name,Id,User__c,Key_Report__c,Key_Report__r.Name__c FROM 
                Key_Report_Assignment__c where Key_Report__c IN:ids 
                AND Key_Report__r.Type__c=:reportType 
                AND User__c=:userInfo.getUserId()  order by Key_Report__r.Name__c ];    
    }
    public static List<Key_Report__c> getAllMasterRecordByName(Set<String> names){
 		return [Select Id,Name from Key_Report__c where Name__c IN:names];    
    }
    
}