public class KeyReportHomePageController {
    @AuraEnabled
    public static Map<String,String> getRecorTypes(){
        Map<String,String> metadataValueByMetadataName= new Map<String,String>();       
        for(LouisvilleConfiguration__mdt louisvilleConfigurationRecord : LouisvilleConfigurationSelector.getRecordsByCategory(new Set<String>{System.Label.Key_Report_Type})){
            metadataValueByMetadataName.put(louisvilleConfigurationRecord.Name__c,louisvilleConfigurationRecord.Value__c);
        }
        return metadataValueByMetadataName;      
    }
    @AuraEnabled
    // get all key report by login user
    // inspect the situation If the size of the get report is zero, return null; otherwise, return the return report list.
    public static  List<Key_Report_Assignment__c> getAllReportByLoginUser(String  reportType){
        List<Key_Report_Assignment__c> keyreports=KeyReportSelector.getKeyReportAssignmentByReportTypeAndLoginUser(reportType);
        try{
            if(!keyreports.isEmpty()){
                return KeyReportSelector.getKeyReportAssignmentByReportTypeAndLoginUser(reportType);
            }else{
                return null; 
            }  
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KeyReportHomePageController - getKerridgeLinkRecord',e.getMessage(),e.getStackTraceString());
            return null;
        }
        
    }
    // get all master report
    @AuraEnabled
    public static List<Key_Report__c> getAllMasterReports(String  reportType){
        return KeyReportSelector.getAllMasterRecordByType(reportType);
    }
    
    @AuraEnabled
    public static void saveKerridgeReports(List<String> unSelectedIds,List<String> selectedIds,String  reportType){
        //Store unique Record Id for insert
        Set<Id> keyReportIdsToBeInsert=new Set<Id>();
        //Store unique Record Id for Delete
        Set<Id> keyReportIdsToBeDelete=new Set<Id>();
        // This map stores exciting records based on the login user.
        Map<Id,Key_Report_Assignment__c> keyReportAssignmentsByKeyReportId=new Map<Id,Key_Report_Assignment__c>();
        //This list is used to store new records for inserts.
        List<Key_Report_Assignment__c> keyReportsAssignmentsToBeInsert=new List<Key_Report_Assignment__c>();
        //This list is used to store new records for delete.
        List<Key_Report_Assignment__c> keyReportsAssignmentsToBeDelete=new List<Key_Report_Assignment__c>();
        for(String ids:unSelectedIds){
            keyReportIdsToBeDelete.add(ids);
        }
        for(String ids:selectedIds){
            keyReportIdsToBeInsert.add(ids);
        }
        //Obtain all Key Report Assignments Based On Report Type And Login User
        for(Key_Report_Assignment__c keyRAssign:KeyReportSelector.getKeyReportAssignmentByReportTypeAndLoginUser(reportType)){
            keyReportAssignmentsByKeyReportId.put(keyRAssign.Key_Report__c,keyRAssign);
        }
        for(Id keyReportId:keyReportIdsToBeInsert){
            if(!keyReportAssignmentsByKeyReportId.containsKey(keyReportId)){
                Key_Report_Assignment__c kRAssignment=new Key_Report_Assignment__c ();
                kRAssignment.Key_Report__c=keyReportId;
                kRAssignment.User__c=userInfo.getUserId();
                keyReportsAssignmentsToBeInsert.add(kRAssignment);
            }
        }
        
        keyReportsAssignmentsToBeDelete=KeyReportSelector.getKeyReportsAssignmentsByKeyReportidsAndTypeAndLoginUser(keyReportIdsToBeDelete,reportType);
        try{
            if(!keyReportsAssignmentsToBeInsert.isEmpty()){
                insert keyReportsAssignmentsToBeInsert; 
            }
            system.debug('keyReportAssignments=============>'+keyReportsAssignmentsToBeDelete);
            if(!keyReportsAssignmentsToBeDelete.isEmpty()){
                delete keyReportsAssignmentsToBeDelete;
            }
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('KeyReportHomePageController - saveKerridgeReports',e.getMessage(),e.getStackTraceString());
            
        }
    }     
}