@isTest
public class KeyReportHomePageControllerTest {
   @isTest static void getRecorTypesTest(){ 
        Test.startTest();         
        KeyReportHomePageController.getRecorTypes(); 
        Test.stopTest();
    }
    @isTest static void getKeyReportRecordsTest(){ 
        Test.startTest();         
        KeyReportHomePageController.getAllReportByLoginUser('Test'); 
        Test.stopTest();
    }
    
    @isTest static void getKerridgeLinkRecordTest(){
        Test.startTest();
        KeyReportHomePageController.getAllMasterReports('Test');
        Test.stopTest();
    }
    
    
  	  @isTest 
     public static void saveKerridgeReportsTest(){
          List<Key_Report__c> allkeyreports = new List<Key_Report__c>();
                  List<Key_Report__c> keyreportsForSelect = new List<Key_Report__c>();
                  List<Key_Report__c> keyreportsForUnSelect = new List<Key_Report__c>();
			Set<Id> selectIds=new Set<Id>();
        Set<Id> unselectIds=new Set<Id>();
         List<Key_Report__c> keyreportsForUpdate = new List<Key_Report__c>();
        List<Key_Report__c> keyreportsForInsert = new List<Key_Report__c>();
        List<Key_Report__c> kerridgeLinks = new List<Key_Report__c>();
        List<String> kRselectIds=new List<String>();
        List<String> kRUselectIds=new List<String>();
         for(Integer i=0; i<10;i++){
            Key_Report__c record=new Key_Report__c();
           
            record.Name__c='test'+i;
            record.Type__c='Kerridge Links';
            record.Active__c=true;
            keyreportsForSelect.add(record);
            }
         
          for(Integer j=0; j<10;j++){
            Key_Report__c record=new Key_Report__c();
            record.Name__c='test1'+j;
            record.Type__c='Kerridge Links';
            record.Active__c=true;
            keyreportsForUnSelect.add(record);
            }
         insert keyreportsForSelect;
    	 insert keyreportsForUnSelect;
        // insert allkeyreports;
        for(Key_Report__c k1:keyreportsForSelect){
            kRselectIds.add(k1.Id);   
            selectIds.add(k1.Id);
        }
        for(Key_Report__c k2:keyreportsForUnSelect){
            
            kRUselectIds.add(k2.Id);   
            unselectIds.add(k2.Id);
        }
        delete keyreportsForUnSelect;
        Test.startTest();
       
        KeyReportHomePageController.saveKerridgeReports(kRUselectIds,kRselectIds,'Test');
        Test.stopTest();
    } 
   
}